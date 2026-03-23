#' Path to the NCCL installation
#'
#' @return A character string with the path to the installed NCCL files.
#' @export
cuda_nccl_path <- function() {
  system.file("nvidia/nccl", package = "cuda.nccl", mustWork = TRUE)
}

#' Path to the NCCL shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_nccl_lib_path <- function() {
  file.path(cuda_nccl_path(), "lib")
}

#' Path to the NCCL headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_nccl_include_path <- function() {
  file.path(cuda_nccl_path(), "include")
}
