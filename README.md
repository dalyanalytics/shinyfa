# shinyfa

<img src="https://media.githubusercontent.com/media/dalyanalytics/shinyfa/refs/heads/main/man/figures/shinyfa-logo.png" align="right" alt="shinyfa logo" width="200" />


<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/dalyanalytics/shinyfa/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/dalyanalytics/shinyfa/actions/workflows/pkgdown.yaml)
<!-- badges: end -->


The `{shinyfa}` package is designed to help Shiny developers analyze and understand the file contents of large Shiny app directories.  

Large Shiny applications often contain numerous files that define both dynamic UI and server components, sometimes linked together in complex sourcing chains (though this is less common in Shiny apps structured with modules). For new contributors—such as consultants joining a project—it can take considerable time to onboard, navigate the codebase, and identify areas for optimization.  

This package aims to streamline that process by extracting key information from a Shiny app directory. It identifies specific render functions, reactive functions, and their inputs, organizing them into a structured `data.frame` for easy reference.  

The *fa* in *shinyfa* stands for *file analysis*.

## 🎯 Why use shinyfa?

- **📊 Audit reactive dependencies**: Quickly understand which inputs affect which outputs across your entire app
- **🔍 Identify unused code**: Find reactive expressions and render functions that may no longer be used
- **🗺️ Map data flow**: Visualize how data flows through complex Shiny applications with multiple modules
- **📚 Generate documentation**: Create instant reference guides for new team members joining the project
- **⚡ Optimize performance**: Identify potential bottlenecks by understanding reactive chains

## 📦 Installation

Install from CRAN:

``` r
install.packages("shinyfa")
```

Or install the development version from GitHub:

``` r
# Install from GitHub
devtools::install_github("dalyanalytics/shinyfa")

# Or using pak
pak::pak("dalyanalytics/shinyfa")
```

## 🚀 Usage

### Basic Example

Analyze a typical Shiny app structure:

``` r
library(shinyfa)
library(dplyr)

# Analyze server files in your Shiny app
server_files <- list.files("my_shiny_app/server", 
                          pattern = "\\.R$", 
                          full.names = TRUE, 
                          recursive = TRUE)

file_analysis <- data.frame()

for (file in server_files) {
  shiny_analysis <- analyze_shiny_reactivity(file_path = file)
  
  if (is.null(shiny_analysis)) next
  
  shiny_analysis$file_name <- basename(file)
  file_analysis <- bind_rows(file_analysis, shiny_analysis)
}

# View the analysis results
print(file_analysis)
```

### Example Output

```
#>   type         name              inputs        output          file_name
#> 1 render       plotSales        c("dateRange", "product")  plotOutput     sales_module.R
#> 2 reactive     filteredData     c("selectedRegion")         NULL           data_processing.R  
#> 3 observe      updateFilters    c("input$reset")            NULL           ui_helpers.R
#> 4 render       tableSummary     c("filteredData")           tableOutput    summary_module.R
#> 5 observeEvent downloadHandler  c("input$download")         NULL           download_handlers.R
```

### Analyzing Specific Patterns

``` r
# Find all reactive expressions that depend on a specific input
file_analysis %>%
  filter(type == "reactive", 
         grepl("dateRange", inputs)) %>%
  select(name, file_name)

# Identify potentially unused render functions
file_analysis %>%
  filter(type == "render",
         is.na(output) | output == "")
```

## 🔍 Scope & Limitations

- **File types**: Supports `.R` files 
- **Module support**: Works with both traditional Shiny apps and modularized applications
- **Static analysis**: Performs static code analysis without running the app
- **Pattern detection**: May not catch all edge cases or dynamically generated reactives

## 🤝 Contributing

Contributions are welcomed! 

- Submit bug reports and feature requests via [GitHub Issues](https://github.com/dalyanalytics/shinyfa/issues)
- Fork the repository and submit pull requests for improvements
- Help us improve documentation and add more examples

## 📄 License

MIT © Jasmine Daly / shinyfa authors

