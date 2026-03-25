#' Path to the cuSPARSE installation
#'
#' @return A character string with the path to the installed cuSPARSE files.
#' @export
cuda_cusparse_path <- function() {
  system.file("nvidia/cusparse", package = "cuda.cusparse", mustWork = TRUE)
}

#' Path to the cuSPARSE shared libraries
#'
#' @return A character string with the path to the lib directory.
#' @export
cuda_cusparse_lib_path <- function() {
  file.path(cuda_cusparse_path(), "lib")
}

#' Path to the cuSPARSE headers
#'
#' @return A character string with the path to the include directory.
#' @export
cuda_cusparse_include_path <- function() {
  file.path(cuda_cusparse_path(), "include")
}
