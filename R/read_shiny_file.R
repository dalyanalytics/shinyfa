#' Read a Shiny file and determine if it should be skipped
#'
#' This function reads a Shiny server file and checks whether it only contains
#' `source()` calls or is empty. If so, it returns `NULL` to indicate the file should be skipped.
#'
#' @param file_path A string representing the path to the R file.
#' @return A character vector containing the file's lines if valid, otherwise `NULL`.
#' @export
read_shiny_file <- function(file_path) {
  server_code <- readLines(file_path, warn = FALSE)

  # Remove empty lines and comments
  non_empty_lines <- grep("^\\s*[^#]", server_code, value = TRUE)
  source_only <- all(grepl("^\\s*source\\(", non_empty_lines))

  if (length(non_empty_lines) == 0 || source_only) {
    message("Skipping file: ", basename(file_path), " (only contains source() calls or is empty)")
    return(NULL)
  }

  return(server_code)
}
