#' Extract named reactive expressions from a Shiny server file
#'
#' Identifies `reactive()` assignments that are stored in variables and returns a data frame.
#' Additionally, it checks for any input dependencies inside the `reactive()` function.
#'
#' @param server_code A character vector representing lines of Shiny server code.
#' @importFrom stringr str_match str_detect
#' @return A data frame containing named reactive expressions with their corresponding input dependencies.
#' @export
extract_named_reactives <- function(server_code) {
  reactive_expressions <- grep("(\\w+)\\s*<-\\s*reactive\\(", server_code, value = TRUE)
  reactive_names <- str_match(reactive_expressions, "^(\\w+)\\s*<-\\s*reactive\\(")[,2]

  reactive_list <- list()
  if (!is.na(reactive_names[1])) {
    for (reactive_name in reactive_names) {
      # Extract the block of code for the reactive expression
      start_idx <- grep(paste0("^", reactive_name, "\\s*<-\\s*reactive\\("), server_code)
      block_end <- which(grepl("^\\s*}\\s*$", server_code[start_idx:length(server_code)]))[1] + start_idx - 1
      if (is.na(block_end)) block_end <- min(start_idx + 10, length(server_code))  # Fallback

      reactive_block <- server_code[start_idx:block_end]

      # Extract input dependencies
      input_regex <- "input\\$(\\w+)|input\\[['\"](\\w+)['\"]"
      input_matches <- unlist(str_extract_all(reactive_block, input_regex))
      input_matches <- gsub("input\\$", "", input_matches)  # Remove 'input$'
      input_matches <- gsub("input\\[['\"]|['\"]", "", input_matches)  # Remove quotes/brackets
      input_values <- if (length(input_matches) > 0) paste(unique(input_matches), collapse = ", ") else "None"

      reactive_list[[length(reactive_list) + 1]] <- data.frame(
        outputId = reactive_name,
        render_function = "reactive()",
        reactivity_type = "Named Reactive Expression",
        input_values = input_values,
        stringsAsFactors = FALSE
      )
    }
  }

  if (length(reactive_list) > 0) {
    return(do.call(rbind, reactive_list))
  } else {
    return(NULL)
  }
}
