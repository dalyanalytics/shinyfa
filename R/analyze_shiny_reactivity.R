#' Analyze Shiny server reactivity in a given file
#'
#' This function processes a Shiny server script, identifying render functions,
#' their reactivity types, and any input dependencies.
#'
#' @param file_path A string representing the path to the R file.
#' @return A data frame summarizing the reactivity structure of the file.
#' @export
analyze_shiny_reactivity <- function(file_path) {
  server_code <- read_shiny_file(file_path)
  if (is.null(server_code)) return(NULL)  # Skip files that should be ignored

  output_assignments <- extract_output_assignments(server_code)
  results <- list()

  for (assignment in output_assignments) {
    block_start <- assignment$index
    block_end <- which(grepl("^\\s*}\\s*$", server_code[block_start:length(server_code)]))[1] + block_start - 1
    if (is.na(block_end)) block_end <- min(block_start + 10, length(server_code))  # Fallback

    render_block <- server_code[block_start:block_end]

    results[[length(results) + 1]] <- data.frame(
      outputId = assignment$output_id,
      render_function = assignment$render_type,
      reactivity_type = classify_reactivity(render_block),
      input_values = extract_input_dependencies(render_block),
      stringsAsFactors = FALSE
    )
  }
  # Include named reactives
  reactive_results <- extract_named_reactives(server_code)

  return(do.call(rbind, c(results, list(reactive_results))))
}
