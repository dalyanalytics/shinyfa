test_that("read_shiny_file returns file content correctly", {
  test_file <- tempfile()
  writeLines(c("output$plot1 <- renderPlot({ plot(1:10) })"), test_file)

  result <- read_shiny_file(test_file)
  expect_type(result, "character")
  expect_length(result, 1)

  unlink(test_file)
})

test_that("read_shiny_file skips files with only source() calls", {
  test_file <- tempfile()
  writeLines(c("source('other_file.R')", "source('more_code.R')"), test_file)

  result <- read_shiny_file(test_file)
  expect_null(result)  # Should return NULL

  unlink(test_file)
})

test_that("read_shiny_file skips empty files", {
  test_file <- tempfile()
  writeLines(character(0), test_file)

  result <- read_shiny_file(test_file)
  expect_null(result)  # Should return NULL

  unlink(test_file)
})
