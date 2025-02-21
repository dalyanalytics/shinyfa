#' Analyze Shiny server reactivity in a given file
#'
#' This function processes a Shiny server script, identifying render functions,
#' their reactivity types, and any input dependencies.
#'
#' @param file_path A string representing the path to the R file.
#' @importFrom stringr str_match
#' @importFrom stringr str_detect
#' @return A data frame summarizing the reactivity structure of the file.
#' @export
analyze_shiny_reactivity <- function(file_path) {
  # Read the file
  server_code <- readLines(file_path, warn = FALSE)

  # **Skip files that only contain `source()` calls**
  non_empty_lines <- grep("^\\s*[^#]", server_code, value = TRUE)  # Remove empty lines and comments
  source_only <- all(grepl("^\\s*source\\(", non_empty_lines))  # Check if all remaining lines are `source()`

  if (length(non_empty_lines) == 0 || source_only) {
    message("Skipping file: ", basename(file_path), " (only contains source() calls or is empty)")
    return(NULL)
  }

  # Extract output assignments
  output_assignments <- extract_output_assignments(server_code)

  results <- list()

  for (assignment in output_assignments) {
    block_start <- assignment$index

    # Find the nearest closing bracket `}`
    block_end_candidates <- which(grepl("^\\s*}\\s*$", server_code[block_start:length(server_code)]))
    if (length(block_end_candidates) == 0) {
      block_end <- min(block_start + 10, length(server_code))  # Fallback to 10 lines ahead
    } else {
      block_end <- block_end_candidates[1] + block_start - 1
    }

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
