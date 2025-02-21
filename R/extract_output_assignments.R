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

  # Return empty list if no output assignments exist
  if (length(output_lines_indices) == 0) {
    return(list())
  }

  results <- list()

  for (idx in output_lines_indices) {
    line <- server_code[idx]

    # Extract outputId and render function
    match <- stringr::str_match(line, "output\\$(\\w+)\\s*<-\\s*(render\\w+)")

    if (!is.na(match[1])) {
      results[[length(results) + 1]] <- list(
        index = idx,
        output_id = match[2],
        render_type = match[3]
      )
    }
  }

  return(results)
}
