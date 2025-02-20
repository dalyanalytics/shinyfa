test_that("extract_input_dependencies detects inputs in render blocks", {
  render_block <- c(
    "output$plot1 <- renderPlot({",
    "  plot(input$var1)",
    "})",
    "output$table1 <- renderTable({",
    "  data.frame(x = input$var2)",
    "})"
  )

  result <- extract_input_dependencies(render_block)
  expect_equal(result, "var1, var2")
})

test_that("extract_input_dependencies detects inputs in reactive expressions", {
  reactive_block <- c(
    "my_reactive <- reactive({",
    "  input$slider1 + input$var2",
    "})"
  )

  result <- extract_input_dependencies(reactive_block)
  expect_equal(result, "slider1, var2")
})

test_that("extract_input_dependencies handles code without inputs", {
  no_input_block <- c(
    "output$plot1 <- renderPlot({ plot(1:10) })",
    "some_variable <- reactive({ 42 })"
  )

  result <- extract_input_dependencies(no_input_block)
  expect_equal(result, "None")
})

test_that("extract_input_dependencies handles multi-line input references", {
  complex_block <- c(
    "output$plot1 <- renderPlot({",
    "  x <- input$varX",
    "  y <- input$varY",
    "  plot(x, y)",
    "})"
  )

  result <- extract_input_dependencies(complex_block)
  expect_equal(result, "varX, varY")
})

test_that("extract_input_dependencies handles multiple input styles in the same block", {
  mixed_input_block <- c(
    "observeEvent(input$button, {",
    "  showModal(modalDialog(input$text_input, input$checkbox))",
    "})"
  )

  result <- extract_input_dependencies(mixed_input_block)
  expect_equal(result, "button, text_input, checkbox")
})
