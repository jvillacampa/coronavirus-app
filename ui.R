#UI
navbarPage(
  title = "Media response to coronavirus",
  windowTitle = "Media response to coronavirus", #title for browser tab
  header = tags$head(includeCSS("www/styles.css")),
  tabPanel(
    title = "Public health communications", icon = icon("newspaper"),
    wellPanel(
      column(4, radioGroupButtons("media_type", 
                        label= "Step 1 - Select what media you are interested in.", 
                        choices = c("Public health communications", "General media", "Social media"), 
                        status = "primary", justified = TRUE, direction = "vertical")),
      column(4, selectInput("location_media", label = "Step 2 - Choose area of interest",
                  choices =c("Scotland", "UK", "Global"))),
             column(4, sliderInput("time_media", label = "Step 3 - Select the time period of interest",
                  min = as.Date('2020-01-01'), max = as.Date('2020-03-31'),
                  value = c(as.Date('2020-03-24'), as.Date('2020-03-31')),
                            step = 1))
    ), #wellPanel bracket
    mainPanel(width = 12,
    column(4, 
           plot_box("Visits to selected media", "hits_media_plot"),
           plot_box("Sentiment analysis, 0 negative, 1 positive", "sentiment_plot"),
           plot_box("Most used words", "word_cloud_plot")),
    column(4, 
           plot_box("Calls to NHS 24", "nhs24_plot"),
           plot_box("A&E attendances", "aye_plot"),
           plot_box("Positive cases of coronavirus", "coronacases_plot")),
    column(4, 
           plot_box("Visits to coronavirus pages in HPS", "hits_hps_plot"),
           plot_box("Retweets/favourites of", "retweets_plot"),
           plot_box("Deaths attributed to Coronavirus", "coronadeaths_plot"))
    )# mainPanel bracket
  ), # tabpanel bracket
  tabPanel(
    title = "Correlations", icon = icon("chart-line")

  ), # tabpanel bracket
  tabPanel(
    title = "Data", icon = icon("table")

  ) # tabpanel bracket
) # navbar bracket