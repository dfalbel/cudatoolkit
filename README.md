# cudatoolkit

R packages that provide CUDA toolkit libraries by downloading pre-built binaries from PyPI at install time. Each package bundles all components for a specific CUDA minor version.

## Installation

```r
install.packages("cuda12.8", repos = "https://cudatoolkit-repo.dfalbel.workers.dev")
```

Available packages: `cuda12.6`, `cuda12.8`, `cuda13.2`.

Multiple versions can be installed simultaneously (e.g., `cuda12.6` and `cuda12.8` coexist).

## Selecting components

By default, all components are downloaded. To install only specific components, set the `CUDA_COMPONENTS` environment variable before installing:

```r
Sys.setenv(CUDA_COMPONENTS = "runtime,cublas,cudnn")
install.packages("cuda12.8", repos = "https://cudatoolkit-repo.dfalbel.workers.dev")
```

Available components: `runtime`, `cublas`, `cudnn`, `cupti`, `nvrtc`, `cufft`, `cusolver`, `cusparse`, `nvjitlink`, `nccl`, `nvshmem`, `nvcc`.

### Overriding component versions

Use `component@version` syntax to override specific component versions:

```r
# Override cuDNN version while keeping everything else at the pinned versions
Sys.setenv(CUDA_COMPONENTS = "runtime,cublas,cudnn@9.10.0.56")
install.packages("cuda12.8", repos = "https://cudatoolkit-repo.dfalbel.workers.dev")
```

Components without `@version` use the version pinned at build time.

## Usage

```r
# Get library paths
cuda12.8::lib_path("runtime")      # path to libcudart.so etc.
cuda12.8::lib_path("cublas")       # path to libcublas.so etc.
cuda12.8::include_path("cudnn")    # path to cuDNN headers
cuda12.8::bin_path("nvcc")         # path to ptxas binary

# Get all library paths (useful for LD_LIBRARY_PATH)
cuda12.8::all_lib_paths()
```

## Requirements

- Linux x86_64, Linux aarch64, or Windows (no macOS — CUDA doesn't support it)
- NVIDIA GPU drivers must be installed on the host
- `curl` or `wget` (for downloading wheels from PyPI during installation)
- `unzip` (for extracting wheel contents)
