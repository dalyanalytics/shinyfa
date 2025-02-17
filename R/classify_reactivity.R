#' Classify the reactivity type of a render block
#'
#' Determines whether a given block of Shiny code contains reactive elements such as
#' `reactive()`, `eventReactive()`, `observeEvent()`, etc.
#'
#' @param render_block A character vector representing a block of Shiny server code.
#' @importFrom stringr str_detect
#' @return A string indicating the type of reactivity detected.
#' @export
classify_reactivity <- function(render_block) {
  if (any(str_detect(render_block, "eventReactive\\("))) return("Event-Triggered Reactive")
  if (any(str_detect(render_block, "observeEvent\\("))) return("Observer")
  if (any(str_detect(render_block, "reactiveValues\\("))) return("Reactive Values")
  if (any(str_detect(render_block, "reactive\\("))) return("Reactive Expression")
  if (any(str_detect(render_block, "isolate\\("))) return("Isolated Expression")
  return("Direct")
}
