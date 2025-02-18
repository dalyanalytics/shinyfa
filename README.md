
# shinyfa

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of {shinyfa} is to provide Shiny developers analysis tools understand file contents of particularly large Shiny app directories.

## Installation

You can install the development version of {shinyfa} from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("dalyanalytics/shinyfa")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(shinyfa)
library(dplyr)  # Load dplyr for bind_rows()

file_path_df <- list.files("SHINY-SERVER-DIRECTORY", 
                           pattern = "\\.R$", full.names = TRUE)

file_analysis <- data.frame()  # Initialize an empty dataframe

for (file in file_path_df) {
  # Analyze the Shiny file
  shiny_analysis <- analyze_shiny_reactivity2(file_path = file)
  
  # Skip if NULL (i.e., file was empty or only had source() calls)
  if (is.null(shiny_analysis)) next
  
  # Ensure it's a data frame
  shiny_analysis <- as.data.frame(shiny_analysis)
  
  # Add filename column
  shiny_analysis$file_name <- basename(file)  
  
  # Bind results
  file_analysis <- bind_rows(file_analysis, shiny_analysis)
}

```

