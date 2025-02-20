test_that("extract_output_assignments detects output assignments", {
  server_code <- c(
    "output$plot1 <- renderPlot({ plot(1:10) })",
    "output$table1 <- renderTable({ data.frame(x = 1:5, y = 6:10) })"
  )

  result <- extract_output_assignments(server_code)

  # Ensure it's a list and each element is a data frame
  expect_type(result, "list")
  expect_false(all(sapply(result, is.data.frame)))

  # Combine the list into a single data frame
  result_df <- dplyr::bind_rows(result)

   expect_s3_class(result_df, "data.frame")
   expect_equal(nrow(result_df), 2)
   expect_equal(result_df$output_id, c("plot1", "table1"))
   expect_equal(result_df$render_type, c("renderPlot", "renderTable"))
})

test_that("extract_output_assignments handles missing output assignments gracefully", {
  server_code <- c("some_variable <- 42", "cat('Hello, world!')")

  result <- extract_output_assignments(server_code)

  # Expect an empty list if no output assignments are found
  expect_type(result, "list")
  expect_length(result, 0)
})
