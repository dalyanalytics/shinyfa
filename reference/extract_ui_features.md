# Extract Shiny UI input and output elements and their ids (including custom Output functions)

This function identifies all Shiny input functions (e.g., selectInput,
textInput, numericInput) and output functions (e.g., plotOutput,
tableOutput, or custom output functions) in a UI script, and extracts
the corresponding ids. It skips over lines that are source() calls.

## Usage

``` r
extract_ui_features(ui_code)
```

## Arguments

- ui_code:

  A character vector representing lines of Shiny UI code.

## Value

A data frame containing the input/output functions and their associated
ids.
