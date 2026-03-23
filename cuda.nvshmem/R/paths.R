#' Path to the NVSHMEM installation
#'
#' @return A character string with the path to the installed NVSHMEM files.
#' @export
cuda_nvshmem_path <- function() {
  system.file("nvidia/nvshmem", package = "cuda.nvshmem", mustWork = TRUE)
}

#' Path to the NVSHMEM shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_nvshmem_lib_path <- function() {
  file.path(cuda_nvshmem_path(), "lib")
}

#' Path to the NVSHMEM headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_nvshmem_include_path <- function() {
  file.path(cuda_nvshmem_path(), "include")
}
