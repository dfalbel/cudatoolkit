// Cloudflare Worker that serves a cranlike R package repository.
//
// Source-only repo at /src/contrib/
// e.g. /src/contrib/PACKAGES, /src/contrib/cuda12.8_1.0.0.tar.gz
//
// - PACKAGES index files are served from GitHub Pages
// - .tar.gz tarballs are served from GitHub Releases
//
// Release tag convention: {package}-{version}
// Asset naming: {package}_{version}.tar.gz

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

    return new Response("Use /src/contrib/ for the R package repository.", {
      status: 404,
    });
  },
};

async function fetchFromGHPages(path, env) {
  const ghPagesUrl = `https://${env.GHPAGES_HOST}/${env.GITHUB_REPO}${path}`;
  const response = await fetch(ghPagesUrl);

  if (!response.ok) {
    return new Response(`Index not found: ${path}`, {
      status: response.status,
    });
  }

  return new Response(response.body, {
    status: 200,
    headers: {
      "content-type": response.headers.get("content-type") || "text/plain",
      "cache-control": "public, max-age=60",
    },
  });
}

async function fetchFromGHRelease(path, env) {
  // R requests: /src/contrib/cuda12.8_1.0.0.tar.gz
  const filename = path.split("/").pop();

  // Greedy match so "cuda12.8_1.0.0" gives package="cuda12.8", version="1.0.0"
  const match = filename.match(/^(.+)_(\d+(?:\.\d+)+)\.tar\.gz$/);
  if (!match) {
    return new Response(`Cannot parse package filename: ${filename}`, {
      status: 400,
    });
  }

  const [, packageName, version] = match;
  const tag = `${packageName}-${version}`;

  const releaseUrl = `https://github.com/${env.GITHUB_OWNER}/${env.GITHUB_REPO}/releases/download/${tag}/${filename}`;

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
