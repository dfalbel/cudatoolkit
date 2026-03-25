#' Path to the NVCC installation
#'
#' @return A character string with the path to the installed NVCC files.
#' @export
cuda_nvcc_path <- function() {
  system.file("nvidia/cuda_nvcc", package = "cuda.nvcc", mustWork = TRUE)
}

#' Path to the NVCC binaries (ptxas)
#'
#' @return A character string with the path to the bin directory.
#' @export
cuda_nvcc_bin_path <- function() {
  file.path(cuda_nvcc_path(), "bin")
}

#' Path to the NVCC headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_nvcc_include_path <- function() {
  file.path(cuda_nvcc_path(), "include")
}
