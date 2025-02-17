#' Extract input dependencies from a render block
#'
#' Identifies all `input$` dependencies within a render block, extracting them as a comma-separated string.
#'
#' @param render_block A character vector representing a block of Shiny server code.
#' @return A string of unique input IDs used within the render block, or `"None"` if no inputs are found.
#' @export
extract_input_dependencies <- function(render_block) {
  input_regex <- "input\\$(\\w+)|input\\[['\"](\\w+)['\"]\\]"
  input_matches <- unlist(str_extract_all(render_block, input_regex))
  input_matches <- gsub("input\\$", "", input_matches)  # Remove 'input$'
  input_matches <- gsub("input\\[['\"]|['\"]\\]", "", input_matches)  # Remove quotes/brackets
  return(if (length(input_matches) > 0) paste(unique(input_matches), collapse = ", ") else "None")
}
