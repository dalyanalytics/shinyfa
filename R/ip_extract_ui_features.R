#' Extract Shiny UI input and output elements and their ids (including custom Output functions)
#'
#' This function identifies all Shiny input functions (e.g., selectInput, textInput, numericInput) and output functions
#' (e.g., plotOutput, tableOutput, or custom output functions) in a UI script, and extracts the corresponding ids. It skips over lines that are source() calls.
#'
#' @param ui_code A character vector representing lines of Shiny UI code.
#' @importFrom stringr str_match
#' @return A data frame containing the input/output functions and their associated ids.
#' @export
extract_ui_features <- function(ui_code) {
  # Remove lines with source() to skip them
  ui_code <- ui_code[!grepl("source\\(", ui_code)]

  # Define regex patterns for input functions
  input_patterns <- c(
    "selectInput\\(", "textInput\\(", "numericInput\\(", "checkboxInput\\(",
    "radioButtons\\(", "dateInput\\(", "fileInput\\(", "actionButton\\(",
    "downloadButton\\(", "passwordInput\\(", "sliderInput\\(", "actionLink\\("
  )

  # Define regex patterns for output functions
  output_patterns <- c(
    "plotOutput\\(", "tableOutput\\(", "textOutput\\(", "verbatimTextOutput\\(",
    "imageOutput\\(", "uiOutput\\(", "plotlyOutput\\(", "leafletOutput\\(",
    "dataTableOutput\\(", "reactableOutput\\(", "Output\\(" # Catch any Output() term
  )

  # Initialize lists to store the results
  input_list <- list()
  output_list <- list()

  # Extract input functions and their ids
  for (pattern in input_patterns) {
    matches <- grep(pattern, ui_code, value = TRUE)
    input_ids <- str_match(matches, paste0(pattern, "\\s*\\(([^,\\)]+)"))

    if (length(input_ids) > 0) {
      input_list[[length(input_list) + 1]] <- data.frame(
        input_function = rep(pattern, length(input_ids)),
        input_id = input_ids[, 2],
        stringsAsFactors = FALSE
      )
    }
  }

  # Extract output functions and their ids (including custom Output functions)
  for (pattern in output_patterns) {
    matches <- grep(pattern, ui_code, value = TRUE)
    output_ids <- str_match(matches, paste0(pattern, "\\s*\\(([^,\\)]+)"))

    if (length(output_ids) > 0) {
      output_list[[length(output_list) + 1]] <- data.frame(
        output_function = rep(pattern, length(output_ids)),
        output_id = output_ids[, 2],
        stringsAsFactors = FALSE
      )
    }
  }

  # Combine all the results into one data frame
  ui_df <- do.call(rbind, c(input_list, output_list))

  return(ui_df)
}
