# Component name -> wheel subdirectory mapping
.component_subdir <- c(
  runtime = "cuda_runtime",
  cublas = "cublas",
  cudnn = "cudnn",
  cupti = "cuda_cupti",
  nvrtc = "cuda_nvrtc",
  cufft = "cufft",
  cusolver = "cusolver",
  cusparse = "cusparse",
  nvjitlink = "nvjitlink",
  nccl = "nccl",
  nvshmem = "nvshmem",
  nvcc = "cuda_nvcc"
)

#' Path to a CUDA component installation
#'
#' @param component Component name (e.g., "runtime", "cublas", "cudnn").
#' @return A character string with the path to the installed component files.
#' @export
cuda_path <- function(component) {
  subdir <- .component_subdir[[component]]
  if (is.null(subdir)) {
    stop(sprintf("Unknown component: '%s'. Available: %s",
                 component, paste(names(.component_subdir), collapse = ", ")))
  }
  system.file(file.path("nvidia", subdir), package = packageName(),
              mustWork = TRUE)
}

#' Path to a CUDA component's shared libraries
#'
#' @param component Component name (e.g., "runtime", "cublas", "cudnn").
#' @return A character string with the path to the lib directory.
#' @export
lib_path <- function(component) {
  file.path(cuda_path(component), "lib")
}

#' Path to a CUDA component's headers
#'
#' @param component Component name (e.g., "runtime", "cublas", "cudnn").
#' @return A character string with the path to the include directory.
#' @export
include_path <- function(component) {
  file.path(cuda_path(component), "include")
}

#' Path to a CUDA component's binaries
#'
#' @param component Component name (e.g., "nvcc").
#' @return A character string with the path to the bin directory.
#' @export
bin_path <- function(component) {
  file.path(cuda_path(component), "bin")
}

#' List all library paths for all installed components
#'
#' Returns a character vector of all lib directories. Useful for setting
#' LD_LIBRARY_PATH or registering with ldconfig.
#'
#' @return A character vector of library paths.
#' @export
all_lib_paths <- function() {
  pkg <- packageName()
  paths <- vapply(.component_subdir, function(subdir) {
    p <- system.file(file.path("nvidia", subdir, "lib"), package = pkg)
    if (nzchar(p)) p else NA_character_
  }, character(1))
  paths[!is.na(paths)]
}
