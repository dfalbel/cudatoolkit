#' Path to the CUDA runtime installation
#'
#' @return A character string with the path to the installed CUDA runtime files.
#' @export
cuda_runtime_path <- function() {
  system.file("nvidia/cuda_runtime", package = "cuda.runtime", mustWork = TRUE)
}

#' Path to the CUDA runtime shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_runtime_lib_path <- function() {
  file.path(cuda_runtime_path(), "lib")
}

#' Path to the CUDA runtime headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_runtime_include_path <- function() {
  file.path(cuda_runtime_path(), "include")
}
