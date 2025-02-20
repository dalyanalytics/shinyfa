test_that("analyze_shiny_reactivity processes a full file correctly", {
  test_file <- tempfile()
  writeLines(c(
    "output$plot1 <- renderPlot({ plot(input$x) })",
    "my_reactive <- reactive({ input$y + 10 })"
  ), test_file)

  result <- analyze_shiny_reactivity(test_file)
  expect_s3_class(result, "data.frame")
  expect_gte(nrow(result), 2)

  unlink(test_file)
})
