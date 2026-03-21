#' Path to the cuDNN installation
#'
#' @return A character string with the path to the installed cuDNN files.
#' @export
cuda_cudnn_path <- function() {
  system.file("nvidia/cudnn", package = "cuda.cudnn", mustWork = TRUE)
}

#' Path to the cuDNN shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_cudnn_lib_path <- function() {
  file.path(cuda_cudnn_path(), "lib")
}

#' Path to the cuDNN headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_cudnn_include_path <- function() {
  file.path(cuda_cudnn_path(), "include")
}
