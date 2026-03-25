#' Path to the cuFFT installation
#'
#' @return A character string with the path to the installed cuFFT files.
#' @export
cuda_cufft_path <- function() {
  system.file("nvidia/cufft", package = "cuda.cufft", mustWork = TRUE)
}

#' Path to the cuFFT shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_cufft_lib_path <- function() {
  file.path(cuda_cufft_path(), "lib")
}

#' Path to the cuFFT headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_cufft_include_path <- function() {
  file.path(cuda_cufft_path(), "include")
}
