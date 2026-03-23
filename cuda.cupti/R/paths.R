#' Path to the CUPTI installation
#'
#' @return A character string with the path to the installed CUPTI files.
#' @export
cuda_cupti_path <- function() {
  system.file("nvidia/cuda_cupti", package = "cuda.cupti", mustWork = TRUE)
}

#' Path to the CUPTI shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_cupti_lib_path <- function() {
  file.path(cuda_cupti_path(), "lib")
}

#' Path to the CUPTI headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_cupti_include_path <- function() {
  file.path(cuda_cupti_path(), "include")
}
