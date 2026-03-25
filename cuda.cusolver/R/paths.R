#' Path to the cuSOLVER installation
#'
#' @return A character string with the path to the installed cuSOLVER files.
#' @export
cuda_cusolver_path <- function() {
  system.file("nvidia/cusolver", package = "cuda.cusolver", mustWork = TRUE)
}

#' Path to the cuSOLVER shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_cusolver_lib_path <- function() {
  file.path(cuda_cusolver_path(), "lib")
}

#' Path to the cuSOLVER headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_cusolver_include_path <- function() {
  file.path(cuda_cusolver_path(), "include")
}
