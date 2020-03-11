# Global


library(shiny)
library(plotly)
library(shinyWidgets)
library(dplyr)

plot_box <- function(title_plot, plot_output) {
  div(h4(title_plot),
  plotlyOutput(plot_output))
}


