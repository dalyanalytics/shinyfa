# Extract output assignments from Shiny server code

Identifies `output$` assignments in a Shiny server file and extracts
their associated render function types.

## Usage

``` r
extract_output_assignments(server_code)
```

## Arguments

- server_code:

  A character vector representing lines of Shiny server code.

## Value

A list of lists, where each list contains an index, output ID, and
render function type.
