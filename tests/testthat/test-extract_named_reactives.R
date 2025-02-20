test_that("extract_named_reactives correctly identifies named reactives", {
  server_code <- c("my_reactive <- reactive({ input$x + 10 })")

  result <- extract_named_reactives(server_code)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 1)
  expect_equal(result$outputId, "my_reactive")
})

test_that("extract_named_reactives returns empty dataframe if no named reactives exist", {
  server_code <- c("output$plot1 <- renderPlot({ plot(1:10) })")

  result <- extract_named_reactives(server_code)

  expect_equal(nrow(result), NULL)
})
