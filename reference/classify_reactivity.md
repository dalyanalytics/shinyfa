# Classify the reactivity type of a render block

Determines whether a given block of Shiny code contains reactive
elements such as `reactive()`, `eventReactive()`, `observeEvent()`, etc.

## Usage

``` r
classify_reactivity(render_block)
```

## Arguments

- render_block:

  A character vector representing a block of Shiny server code.

## Value

A string indicating the type of reactivity detected.
