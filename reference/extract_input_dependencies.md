# Extract input dependencies from a Shiny render block

Identifies all `input$` dependencies within a render block, including
cases like `input$var` and `input[['var']]`.

## Usage

``` r
extract_input_dependencies(render_block)
```

## Arguments

- render_block:

  A character vector representing a block of Shiny server code.

## Value

A string of unique input IDs used within the render block, or `"None"`
if no inputs are found.
