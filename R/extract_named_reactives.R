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
  # Updated regex to capture reactive assignments, with flexibility for spaces
  reactive_expressions <- grep("\\w+\\s*<-\\s*\\s*reactive\\s*\\(", server_code, value = TRUE)

  # If no match found for reactive expressions
  if (length(reactive_expressions) == 0) {
    return(data.frame())
  }

  # Extract the names of the reactive expressions using str_match
  reactive_names <- str_match(reactive_expressions, "^(\\w+)\\s*<-\\s*\\s*reactive\\s*\\(")[,2]

  # Initialize a list to store results
  reactive_list <- list()

  # Check if we have any reactive names
  if (length(reactive_names) > 0) {
    for (reactive_name in reactive_names) {
      # Find the block of code corresponding to the reactive expression
      start_idx <- grep(paste0("^", reactive_name, "\\s*<-\\s*reactive\\("), server_code)
      reactive_block <- server_code[start_idx:length(server_code)]

      # Look for input dependencies within the reactive block using the same extract logic
      input_dependencies <- extract_input_dependencies(reactive_block)

      # Add to the list
      reactive_list[[length(reactive_list) + 1]] <- data.frame(
        outputId = reactive_name,
        render_function = "reactive()",
        reactivity_type = "Named Reactive Expression",
        input_values = input_dependencies,  # Add the input values detected
        stringsAsFactors = FALSE
      )
    }
  }

  # Return the final data frame of reactive expressions and their input dependencies
  return(do.call(rbind, reactive_list))
}
