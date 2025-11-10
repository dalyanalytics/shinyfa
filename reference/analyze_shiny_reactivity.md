# Analyze Shiny server reactivity in a given file

This function processes a Shiny server script, identifying render
functions, their reactivity types, and any input dependencies.

## Usage

``` r
analyze_shiny_reactivity(file_path)
```

## Arguments

- file_path:

  A string representing the path to the R file.

## Value

A data frame summarizing the reactivity structure of the file.
