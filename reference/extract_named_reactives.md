# Extract named reactive expressions from a Shiny server file

Identifies `reactive()` assignments that are stored in variables and
returns a data frame. Additionally, it checks for any input dependencies
inside the `reactive()` function.

## Usage

``` r
extract_named_reactives(server_code)
```

## Arguments

- server_code:

  A character vector representing lines of Shiny server code.

## Value

A data frame containing named reactive expressions with their
corresponding input dependencies.
