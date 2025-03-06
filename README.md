
# shinyfa 

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/dalyanalytics/shinyfa/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/dalyanalytics/shinyfa/actions/workflows/pkgdown.yaml)
<!-- badges: end -->

The `{shinyfa}` package is designed to help Shiny developers analyze and understand the file contents of large Shiny app directories.  

Large Shiny applications often contain numerous files that define both dynamic UI and server components, sometimes linked together in complex sourcing chains (though this is less common in Shiny apps structured with modules). For new contributors—such as consultants joining a project—it can take considerable time to onboard, navigate the codebase, and identify areas for optimization.  

This in-progress package aims to streamline that process by extracting key information from a Shiny app directory. It identifies specific render functions, reactive functions, and their inputs, organizing them into a structured `data.frame` for easy reference.  

The *fa* in *shinyfa* stands for *file analysis*.

## Installation

You can install the development version of {shinyfa} from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("dalyanalytics/shinyfa")
```

## Example

This is a basic example which shows you how to solve a common problem for looping through a directory that contains server files:

``` r
library(shinyfa)
library(dplyr)  

file_path_df <- list.files("SHINY-SERVER-DIRECTORY", 
                           pattern = "\\.R$", full.names = TRUE)

file_analysis <- data.frame()  # Initialize an empty dataframe

for (file in file_path_df) {
  shiny_analysis <- analyze_shiny_reactivity(file_path = file)
  
  # Skip if NULL (empty file or only `source()` calls)
  if (is.null(shiny_analysis)) next
  
  # Add filename column
  shiny_analysis$file_name <- basename(file)
  
  # Bind results
  file_analysis <- bind_rows(file_analysis, shiny_analysis)
}

print(file_analysis)
```

