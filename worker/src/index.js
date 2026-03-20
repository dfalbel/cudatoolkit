// Cloudflare Worker that serves a cranlike R package repository.
//
// - PACKAGES index files are served from GitHub Pages
// - .tar.gz tarballs are served from GitHub Releases
//
// Release tag convention: {package}-{version}
// e.g. cuda.runtime-12.9.79 with asset cuda.runtime_12.9.79.tar.gz

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname;

    // Route PACKAGES index files to GitHub Pages
    if (/PACKAGES(\.gz|\.rds)?$/.test(path)) {
      return fetchFromGHPages(path, env);
    }

    // Route .tar.gz files to GitHub Releases
    if (path.endsWith(".tar.gz")) {
      return fetchFromGHRelease(path, env);
    }

    return new Response("Not found", { status: 404 });
  },
};

async function fetchFromGHPages(path, env) {
  const ghPagesUrl = `https://${env.GHPAGES_HOST}/${env.GITHUB_REPO}${path}`;
  const response = await fetch(ghPagesUrl);

  if (!response.ok) {
    return new Response(`Index not found: ${path}`, { status: response.status });
  }

  // Return with appropriate headers
  return new Response(response.body, {
    status: 200,
    headers: {
      "content-type": response.headers.get("content-type") || "text/plain",
      "cache-control": "public, max-age=60",
    },
  });
}

async function fetchFromGHRelease(path, env) {
  // Extract filename from path, e.g. /src/contrib/cuda.runtime_12.9.79.tar.gz
  const filename = path.split("/").pop();

  // Parse package name and version from filename: {package}_{version}.tar.gz
  // Also handles binary tarballs: {package}_{version}_R_*.tar.gz
  const match = filename.match(/^(.+?)_(\d+\.\d+\.\d+)/);
  if (!match) {
    return new Response(`Cannot parse package filename: ${filename}`, { status: 400 });
  }

  const [, packageName, version] = match;
  // Convert package name separator: cuda.runtime -> cuda.runtime (dots are fine in tags)
  const tag = `${packageName}-${version}`;

  const releaseUrl =
    `https://github.com/${env.GITHUB_OWNER}/${env.GITHUB_REPO}/releases/download/${tag}/${filename}`;

  const response = await fetch(releaseUrl, { redirect: "follow" });

  if (!response.ok) {
    return new Response(`Release asset not found: ${tag}/${filename}`, {
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
