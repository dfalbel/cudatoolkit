# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Monorepo of R packages that distribute CUDA toolkit binaries by downloading pre-built wheels from PyPI. Each package corresponds to a CUDA component (runtime, cuDNN, etc.) and the R package version matches the CUDA version (e.g., `cuda.runtime` 12.9.79 = CUDA 12.9.79).

## Architecture

### Package structure (e.g., `cuda.runtime/`)
- **`configure`** — shell script that runs during `R CMD INSTALL`. Reads the CUDA version from `DESCRIPTION`, downloads the matching PyPI wheel for the detected platform (Linux x86_64/aarch64, Windows), and extracts shared libraries + headers into `inst/`.
- **`R/paths.R`** — exports path helpers (`cuda_runtime_path()`, `cuda_runtime_lib_path()`, `cuda_runtime_include_path()`) that downstream packages use to locate installed CUDA files via `system.file()`.
- The CUDA version is defined solely in `DESCRIPTION`'s `Version:` field. The configure script derives everything from it (PyPI package name, wheel filename).

### Distribution
- **GitHub Releases** store source + binary tarballs. Tag convention: `{package}-{version}` (e.g., `cuda.runtime-12.9.79`).
- **GitHub Pages** hosts only the PACKAGES index (no tarballs) for a cranlike repo.
- A CDN (CloudFront/Cloudflare Worker) sits in front and routes `PACKAGES*` requests to gh-pages and `*.tar.gz` requests to the matching GitHub Release asset.
- Binary packages are built via `R CMD INSTALL --build` on Linux runners, which runs `configure` and bundles the result.

### CI workflow (`.github/workflows/publish.yml`)
- Matrix over CUDA versions × packages.
- `sed` updates `DESCRIPTION` version per matrix entry before building.
- Source tarball: `R CMD build {package}`
- Binary tarball: `R CMD INSTALL --build`
- Uploads both to a GitHub Release tagged `{package}-{version}`.
- Generates PACKAGES index from source tarballs and deploys to gh-pages.

## Supported platforms

Matches what PyPI provides: Linux x86_64, Linux aarch64, Windows (win_amd64). macOS is not supported (no CUDA).

## Adding a new CUDA component package

1. Create a new directory (e.g., `cuda.cudnn/`) with `DESCRIPTION`, `configure`, `NAMESPACE`, `R/paths.R`.
2. Adapt the configure script for the corresponding PyPI package name (e.g., `nvidia_cudnn_cu12`).
3. Add the package to the `matrix.package` list in `.github/workflows/publish.yml`.
