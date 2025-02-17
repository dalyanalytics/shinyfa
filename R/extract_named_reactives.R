#' Extract named reactive expressions from a Shiny server file
#'
#' Identifies `reactive()` assignments that are stored in variables and returns a data frame.
#'
#' @param server_code A character vector representing lines of Shiny server code.
#' @importFrom stringr str_match
#' @return A data frame containing named reactive expressions with their corresponding attributes.
#' @export
extract_named_reactives <- function(server_code) {
  reactive_expressions <- grep("(\\w+)\\s*<-\\s*reactive\\(", server_code, value = TRUE)
  reactive_names <- str_match(reactive_expressions, "^(\\w+)\\s*<-\\s*reactive\\(")[,2]

  reactive_list <- list()
  if (!is.na(reactive_names[1])) {
    for (reactive_name in reactive_names) {
      reactive_list[[length(reactive_list) + 1]] <- data.frame(
        outputId = reactive_name,
        render_function = "reactive()",
        reactivity_type = "Named Reactive Expression",
        input_values = "N/A",
        stringsAsFactors = FALSE
      )
    }
  }

  return(do.call(rbind, reactive_list))
}
