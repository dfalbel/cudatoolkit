#' Path to the cuBLAS installation
#'
#' @return A character string with the path to the installed cuBLAS files.
#' @export
cuda_cublas_path <- function() {
  system.file("nvidia/cublas", package = "cuda.cublas", mustWork = TRUE)
}

#' Path to the cuBLAS shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_cublas_lib_path <- function() {
  file.path(cuda_cublas_path(), "lib")
}

#' Path to the cuBLAS headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_cublas_include_path <- function() {
  file.path(cuda_cublas_path(), "include")
}
