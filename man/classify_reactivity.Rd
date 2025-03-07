% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/classify_reactivity.R
\name{classify_reactivity}
\alias{classify_reactivity}
\title{Classify the reactivity type of a render block}
\usage{
classify_reactivity(render_block)
}
\arguments{
\item{render_block}{A character vector representing a block of Shiny server code.}
}
\value{
A string indicating the type of reactivity detected.
}
\description{
Determines whether a given block of Shiny code contains reactive elements such as
\code{reactive()}, \code{eventReactive()}, \code{observeEvent()}, etc.
}
