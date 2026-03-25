# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Monorepo of R packages that distribute CUDA toolkit binaries by downloading pre-built wheels from PyPI. Each package bundles **all** CUDA components for a specific CUDA minor version (e.g., `cuda12.8` = runtime, cuBLAS, cuDNN, cuFFT, cuSOLVER, cuSPARSE, CUPTI, NVRTC, NvJitLink, NCCL, NVSHMEM, NVCC). The R package version (e.g., `1.0.0`) is decoupled from the CUDA version.

## Architecture

### Package structure (e.g., `cuda12.8/`)
- **`inst/components.tsv`** — manifest listing each component's PyPI package name, version, wheel subdirectory, and platform constraints. This is the single source of truth for what gets downloaded.
- **`configure`** — shell script that runs during `R CMD INSTALL`. Reads `inst/components.tsv`, downloads each component's PyPI wheel for the detected platform, and extracts shared libraries + headers into `inst/`.
- **`R/paths.R`** — exports generic path helpers: `lib_path("runtime")`, `include_path("cublas")`, `bin_path("nvcc")`, `all_lib_paths()`. Uses `packageName()` so the same source works across all cuda packages.

### R API
```r
cuda12.8::lib_path("runtime")      # path to libcudart.so.12 etc.
cuda12.8::lib_path("cublas")       # path to libcublas.so.12 etc.
cuda12.8::include_path("cudnn")    # path to cudnn headers
cuda12.8::bin_path("nvcc")         # path to ptxas binary
cuda12.8::all_lib_paths()          # all lib dirs for LD_LIBRARY_PATH
```

### Distribution
- **GitHub Releases** store source + binary tarballs. Tag convention: `{package}-{version}` (e.g., `cuda12.8-1.0.0`).
- **GitHub Pages** hosts only the PACKAGES index (no tarballs) for a cranlike repo.
- A Cloudflare Worker sits in front and routes `PACKAGES*` requests to gh-pages and `*.tar.gz` requests to the matching GitHub Release asset.

### CI workflow (`.github/workflows/publish.yml`)
- Matrix over platforms × packages.
- Runs `configure` to download all component wheels.
- Removes `configure`, runs `R CMD build` to create a fat source tarball with pre-downloaded libs.
- Uploads to a GitHub Release.
- Generates PACKAGES index and deploys to gh-pages.

## Supported platforms

Matches what PyPI provides: Linux x86_64, Linux aarch64, Windows (win_amd64). macOS is not supported (no CUDA). Linux-only components (NCCL, NVSHMEM) are skipped on Windows by the configure script.

## Adding a new CUDA minor version

1. Create a new directory (e.g., `cuda12.9/`) — copy from an existing package.
2. Update `inst/components.tsv` with the correct PyPI versions for that CUDA minor version.
3. Add the package to the `matrix.package` list in `.github/workflows/publish.yml`.

## Updating component versions

Edit `inst/components.tsv` in the relevant package directory and bump the `Version:` in `DESCRIPTION`.
