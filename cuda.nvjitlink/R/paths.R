#' Path to the nvJitLink installation
#'
#' @return A character string with the path to the installed nvJitLink files.
#' @export
cuda_nvjitlink_path <- function() {
  system.file("nvidia/nvjitlink", package = "cuda.nvjitlink", mustWork = TRUE)
}

#' Path to the nvJitLink shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_nvjitlink_lib_path <- function() {
  file.path(cuda_nvjitlink_path(), "lib")
}

#' Path to the nvJitLink headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_nvjitlink_include_path <- function() {
  file.path(cuda_nvjitlink_path(), "include")
}
