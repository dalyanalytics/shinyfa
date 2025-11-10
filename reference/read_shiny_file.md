# Read a Shiny file and determine if it should be skipped

This function reads a Shiny server file and checks whether it only
contains [`source()`](https://rdrr.io/r/base/source.html) calls or is
empty. If so, it returns `NULL` to indicate the file should be skipped.

## Usage

``` r
read_shiny_file(file_path)
```

## Arguments

- file_path:

  A string representing the path to the R file.

## Value

A character vector containing the file's lines if valid, otherwise
`NULL`.
