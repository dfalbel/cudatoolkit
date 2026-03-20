# Cloudflare Worker — cranlike repo proxy

Routes R package requests to the right backend:
- `PACKAGES*` → GitHub Pages (index only)
- `*.tar.gz` → GitHub Releases (tarballs)

## Setup

```bash
npm install -g wrangler
wrangler login
```

## Deploy

```bash
cd worker
npx wrangler deploy
```

This deploys to `https://cudatoolkit-repo.<account>.workers.dev`.

## Configuration

Edit `wrangler.toml` to change:
- `GITHUB_OWNER` / `GITHUB_REPO` — the GitHub repository
- `GHPAGES_HOST` — the GitHub Pages hostname

To use a custom domain, add to `wrangler.toml`:

```toml
routes = [{ pattern = "cuda.example.com/*", zone_name = "example.com" }]
```

## Testing locally

```bash
cd worker
npx wrangler dev
```
