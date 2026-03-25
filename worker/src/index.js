// Cloudflare Worker that serves a cranlike R package repository.
//
// Platform-specific repos at /{platform}/src/contrib/
// e.g. /linux-x64/src/contrib/PACKAGES, /windows-x64/src/contrib/cuda.runtime_12.9.79.tar.gz
//
// - PACKAGES index files are served from GitHub Pages
// - .tar.gz tarballs are served from GitHub Releases
//
// Release tag convention: {package}-{version}
// Asset naming: {package}_{version}_{platform}.tar.gz

const VALID_PLATFORMS = ["linux-x64", "linux-arm64", "windows-x64"];

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    // Parse platform from path: /{platform}/src/contrib/...
    const platformMatch = path.match(/^\/(linux-x64|linux-arm64|windows-x64)\//);
    if (!platformMatch) {
      return new Response(
        "Use /{platform}/src/contrib/ where platform is: " + VALID_PLATFORMS.join(", "),
        { status: 404 },
      );
    }
    const platform = platformMatch[1];
    const subPath = path.slice(platform.length + 1); // strip /{platform}

    // Route PACKAGES index files to GitHub Pages
    if (/PACKAGES(\.gz|\.rds)?$/.test(subPath)) {
      return fetchFromGHPages(path, env);
    }

    // Route .tar.gz files to GitHub Releases
    if (subPath.endsWith(".tar.gz")) {
      return fetchFromGHRelease(subPath, platform, env);
    }

    return new Response("Not found", { status: 404 });
  },
};

async function fetchFromGHPages(path, env) {
  // path includes the platform prefix, which matches gh-pages structure
  const ghPagesUrl = `https://${env.GHPAGES_HOST}/${env.GITHUB_REPO}${path}`;
  const response = await fetch(ghPagesUrl);

  if (!response.ok) {
    return new Response(`Index not found: ${path}`, { status: response.status });
  }

  return new Response(response.body, {
    status: 200,
    headers: {
      "content-type": response.headers.get("content-type") || "text/plain",
      "cache-control": "public, max-age=60",
    },
  });
}

async function fetchFromGHRelease(subPath, platform, env) {
  // R requests: /src/contrib/cuda12.8_1.0.0.tar.gz
  // Release asset: cuda12.8_1.0.0_linux-x64.tar.gz
  const filename = subPath.split("/").pop();

  // Greedy match so "cuda12.8_1.0.0" gives package="cuda12.8", version="1.0.0"
  const match = filename.match(/^(.+)_(\d+(?:\.\d+)+)\.tar\.gz$/);
  if (!match) {
    return new Response(`Cannot parse package filename: ${filename}`, { status: 400 });
  }

  const [, packageName, version] = match;
  const tag = `${packageName}-${version}`;
  const assetName = `${packageName}_${version}_${platform}.tar.gz`;

  const releaseUrl =
    `https://github.com/${env.GITHUB_OWNER}/${env.GITHUB_REPO}/releases/download/${tag}/${assetName}`;

  const response = await fetch(releaseUrl, { redirect: "follow" });

  if (!response.ok) {
    return new Response(`Release asset not found: ${tag}/${assetName}`, {
      status: response.status,
    });
  }

  return new Response(response.body, {
    status: 200,
    headers: {
      "content-type": "application/gzip",
      "cache-control": "public, max-age=3600",
    },
  });
}
