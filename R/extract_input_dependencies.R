#' Extract input dependencies from a Shiny render block
#'
#' Identifies all `input$` dependencies within a render block, including cases like `input$var` and `input[['var']]`.
#'
#' @param render_block A character vector representing a block of Shiny server code.
#' @importFrom stringr str_extract_all
#' @return A string of unique input IDs used within the render block, or `"None"` if no inputs are found.
#' @export
extract_input_dependencies <- function(render_block) {
  input_regex <- "input\\$(\\w+)|input\\[['\"](\\w+)['\"]\\]"
  input_matches <- unlist(stringr::str_extract_all(render_block, input_regex))
  input_matches <- gsub("input\\$", "", input_matches)  # Remove 'input$'
  input_matches <- gsub("input\\[['\"]|['\"]\\]", "", input_matches)  # Remove quotes/brackets

  return(if (length(input_matches) > 0) paste(unique(input_matches), collapse = ", ") else "None")
}
