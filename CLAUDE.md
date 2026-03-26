# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Monorepo that produces R packages distributing CUDA toolkit binaries from PyPI. A single template (`cuda/`) is used to generate packages per CUDA minor version (e.g., `cuda12.6`, `cuda12.8`). Each package bundles all CUDA components (runtime, cuBLAS, cuDNN, cuFFT, cuSOLVER, cuSPARSE, CUPTI, NVRTC, NvJitLink, NCCL, NVSHMEM, NVCC). Libraries are downloaded from PyPI at install time — source tarballs are tiny.

## Architecture

### Package template (`cuda/`)
- **`configure`** — shell script that runs during `R CMD INSTALL`. Reads `inst/cuda-toolkit-version`, fetches the `cuda-toolkit` meta-package metadata from PyPI to resolve component versions, then downloads each component wheel and extracts libs/headers/bins into `inst/`.
- **`R/paths.R`** — exports generic path helpers using `packageName()` so the same code works for any `cuda{X.Y}` package.
- **`DESCRIPTION.template`** — template with `{{CUDA_MINOR}}` and `{{PKG_VERSION}}` placeholders, filled in by CI.
- **`NAMESPACE`**, **`LICENSE`** — shared across all generated packages.

### Generated files (by CI, not in repo)
- **`inst/components.tsv`** — fully pinned component versions (resolved from cuda-toolkit on PyPI at build time).

### R API
```r
cuda12.8::lib_path()               # path to all shared libraries
cuda12.8::include_path("cudnn")    # path to cudnn headers
cuda12.8::bin_path("nvcc")         # path to ptxas binary
```

### Environment variables
- **`CUDA_COMPONENTS`** — comma-separated list of components to install. Default: all. Use `@version` to override pinned versions. Example: `CUDA_COMPONENTS=runtime,cublas,cudnn@9.10.0.56`. Available components: `runtime`, `cublas`, `cudnn`, `cupti`, `nvrtc`, `cufft`, `cusolver`, `cusparse`, `nvjitlink`, `nccl`, `nvshmem`, `nvcc`.
- **`CUDA_PLATFORM`** — override platform detection. Values: `linux-x64`, `linux-arm64`, `windows-x64`.

### Version resolution
Component versions are pinned at build time from the `cuda-toolkit` PyPI meta-package and stored in `inst/components.tsv`. Only cudnn, nccl, and nvshmem (not part of cuda-toolkit) have versions specified separately in the CI matrix.

### Distribution
- **GitHub Releases** store source tarballs. Tag convention: `cuda{X.Y}-{version}` (e.g., `cuda12.8-1.0.0`).
- **GitHub Pages** hosts the PACKAGES index for a cranlike repo.
- A Cloudflare Worker routes requests to gh-pages (PACKAGES) and GitHub Releases (tarballs).

### CI workflow (`.github/workflows/publish.yml`)
- Matrix defines CUDA minor versions with toolkit version, package version, and extra component versions.
- For each entry: copies `cuda/` template, fills in DESCRIPTION and inst/ files, runs `R CMD build`.
- Uploads source tarball to GitHub Release.
- Generates PACKAGES index and deploys to gh-pages.

## Adding a new CUDA minor version

Add a new entry to the matrix in `.github/workflows/publish.yml`:
```yaml
- cuda_minor: "12.9"
  toolkit_version: "12.9.1"
  pkg_version: "1.0.0"
  cudnn_version: "..."
  nccl_version: "..."
  nvshmem_version: "..."
```

## Updating component versions

- **Toolkit components**: bump `toolkit_version` in the matrix (versions resolve automatically from PyPI).
- **Extra components** (cudnn, nccl, nvshmem): update the version in the matrix.
- **R package version**: bump `pkg_version` in the matrix.

## Supported platforms

Matches what PyPI provides: Linux x86_64, Linux aarch64, Windows (win_amd64). macOS is not supported (no CUDA). Linux-only components (NCCL, NVSHMEM) are skipped on Windows by the configure script.
