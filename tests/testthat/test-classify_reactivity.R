test_that("classify_reactivity detects correct reactivity types", {
  render_block1 <- c("output$plot1 <- renderPlot({ reactive({ x + y }) })")
  render_block2 <- c("output$plot1 <- renderPlot({ eventReactive(input$btn, { x + y }) })")
  render_block3 <- c("output$plot1 <- renderPlot({ isolate({ x + y }) })")

  expect_equal(classify_reactivity(render_block1), "Reactive Expression")
  expect_equal(classify_reactivity(render_block2), "Event-Triggered Reactive")
  expect_equal(classify_reactivity(render_block3), "Isolated Expression")
})

test_that("classify_reactivity defaults to 'Direct' when no reactivity is found", {
  render_block <- c("output$plot1 <- renderPlot({ plot(1:10) })")
  expect_equal(classify_reactivity(render_block), "Direct")
})
