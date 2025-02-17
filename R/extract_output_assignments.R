#' Extract output assignments from Shiny server code
#'
#' Identifies `output$` assignments in a Shiny server file and extracts
#' their associated render function types.
#'
#' @param server_code A character vector representing lines of Shiny server code.
#' @importFrom stringr str_match
#' @return A list of lists, where each list contains an index, output ID, and render function type.
#' @export
extract_output_assignments <- function(server_code) {
  output_lines_indices <- grep("output\\$", server_code)
  results <- list()

  for (idx in output_lines_indices) {
    line <- server_code[idx]
    match <- str_match(line, "output\\$(\\w+)\\s*<-\\s*(render\\w+)")

    if (!is.na(match[1])) {
      output_id <- match[2]
      render_type <- match[3]
      results[[length(results) + 1]] <- list(index = idx, output_id = output_id, render_type = render_type)
    }
  }

  return(results)
}
