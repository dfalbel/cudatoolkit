#' Path to the NVRTC installation
#'
#' @return A character string with the path to the installed NVRTC files.
#' @export
cuda_nvrtc_path <- function() {
  system.file("nvidia/cuda_nvrtc", package = "cuda.nvrtc", mustWork = TRUE)
}

#' Path to the NVRTC shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_nvrtc_lib_path <- function() {
  file.path(cuda_nvrtc_path(), "lib")
}

#' Path to the NVRTC headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_nvrtc_include_path <- function() {
  file.path(cuda_nvrtc_path(), "include")
}
