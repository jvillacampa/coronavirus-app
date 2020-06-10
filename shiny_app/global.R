# Global

library(shiny)
library(plotly)
library(shinyWidgets)
library(shinycssloaders)
library(dplyr)
library(DT)

tweet_count_term_data <- readRDS("data/tweet_count_term_data.rds")
tweet_count_data <- readRDS("data/tweet_count_data.rds")
top_words <- readRDS("data/topword_count.rds")
word_weekly <- readRDS("data/worddata_weekly.rds")

covid_stats <- readRDS("data/covid_open_data.rds")

plot_box <- function(title_plot, plot_output, source = "Blablabla") {
  div(h4(title_plot),
      p(paste0("Source: ", source)),
      withSpinner(plotlyOutput(plot_output)))
}

term_palette <- c("#b35806", "#f1a340",  "#fee0b6", "#d8daeb", "#998ec3", "#542788")

xaxis_plots <- list(title = FALSE, tickfont = list(size=14), titlefont = list(size=14), 
                    showline = TRUE, tickangle = 270, fixedrange=TRUE)

yaxis_plots <- list(title = FALSE, rangemode="tozero", fixedrange=TRUE, size = 4, 
                    tickfont = list(size=14), titlefont = list(size=14)) 

##END