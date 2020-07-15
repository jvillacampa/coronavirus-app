#UI
navbarPage(id = "intabset", # id used for jumping between tabs
           title = div(tags$a(img(src="phs-logo.png", height=40), href= "https://www.publichealthscotland.scot/"),
                       style = "position: relative; top: -5px;"), 
  windowTitle = "Reactions to coronavirus in Twitter", #title for browser tab
  header = tags$head(includeCSS("www/styles.css"),
                     tags$link(rel="shortcut icon", href="favicon_phs.ico")), #Icon for browser tab),
  tabPanel(
    title = "Twitter", icon = icon("twitter"),
    h2("Reactions to coronavirus in Twitter by Scottish residents"),
    wellPanel(column(6, "We could add filters to select area and period of time for example. ",
              "Another thing missing from this dashboard is the data for people self-reporting symptoms
              as I haven't got it."),
              # actionButton("browser", "Browser")), #for debggin
              column(6, pickerInput(inputId = "term_picker", 
                label = "Select/deselect terms of interest", 
                choices = unique(tweet_count_term_data$search_term), 
                options = list( `actions-box` = TRUE,  size = 10  ), 
                multiple = TRUE, selected = c("Testing", "Tracing", "Coronavirus/COVID-19")))
              ),
    mainPanel(width = 12,
              fluidRow(column(6,
                              plot_box("Number of tweets per day", "tweet_count", 
                                       source = "Deep Miner (strange trend caused by limits on how many tweets were extracted by day)"),
                              plot_box("Average sentiment per day", "tweet_sentiment", 
                                       source = "Deep Miner")),
                       column(6,
                              plot_box("% of all tweets for each topic", "search_term_count", 
                                       source = "Deep Miner (using their methodology to assign to one term, not sure how
                                       terms are assigned as multiple topics could be contained. This is something that could
                                       be developed better by us or by them.)"),
                              plot_box("Average sentiment per group", "search_term_sentiment", 
                                       source = "Deep Miner"))),
              fluidRow(column(6,
                              plot_box("Testing - Daily people found positive" , "daily_positives", 
                                       source = "SG open data"),
                              plot_box("Calls - Coronavirus helpline", "corona_calls", 
                                       source = "SG open data")),
                       column(6,
                              plot_box("Number of deaths by COVID-19" , "deaths", 
                                       source = "SG open data"),
                              plot_box("Testing - Total number of COVID-19 tests carried out" , "tests", 
                                       source = "SG open data"))),
              fluidRow(column(6,
                              plot_box("Number of tweets mentioning Boris Johnson" , "boris_count", 
                                       source = "Deep Miner"),
                              plot_box("Number of tweets mentioning Dominic Cummings" , "dom_count", 
                                       source = "Deep Miner")
                              ),
                       column(6,
                              plot_box("Average sentiment for tweets mentioning Boris Johnson", "boris_sentiment", 
                                       source = "Deep Miner"),
                              plot_box("Average sentiment for tweets mentioning Dominic Cummings", "dom_sentiment", 
                                       source = "Deep Miner")))
    ) 
  ) # tabpanel bracket
  ) # navbar bracket


#   wellPanel(
#     column(4, radioGroupButtons("media_type", 
#                       label= "Step 1 - Select what media you are interested in.", 
#                       choices = c("Public health communications", "General media", "Social media"), 
#                       status = "primary", justified = TRUE, direction = "vertical")),
#     column(4, selectInput("location_media", label = "Step 2 - Choose area of interest",
#                 choices =c("Scotland", "UK", "Global"))),
#            column(4, sliderInput("time_media", label = "Step 3 - Select the time period of interest",
#                 min = as.Date('2020-01-01'), max = as.Date('2020-03-31'),
#                 value = c(as.Date('2020-03-24'), as.Date('2020-03-31')),
#                           step = 1))
#   ), #wellPanel bracket
#   mainPanel(width = 12,
#   column(4, 
#          plot_box("Visits to selected media", "hits_media_plot"),
#          plot_box("Number of retweets/favourites of selected media", "retweets_plot"),
#          plot_box("Visits to coronavirus pages in HPS", "hits_hps_plot")),
#   column(4, 
#          plot_box("Sentiment analysis, 0 negative, 1 positive", "sentiment_plot"),
#          plot_box("Positive cases of coronavirus", "coronacases_plot"),
#          plot_box("Calls to NHS 24", "nhs24_plot")),
#   column(4, 
#          plot_box("Most used words", "word_cloud_plot"),
#          plot_box("Deaths attributed to coronavirus", "coronadeaths_plot"),
#          plot_box("A&E attendances", "aye_plot"))
#   )# mainPanel bracket
# ), # tabpanel bracket
# tabPanel(
#   title = "Correlations", icon = icon("chart-line"),
#   wellPanel(
#     column(6,
#            selectInput("measure1", label = "Step 1 - Select a measure",
#                        choices = measure_list, selected = "Visits to selected media")),
#     column(6,
#            selectInput("measure2", label = "Step 2 - Select another measure",
#                        choices = measure_list, selected = "Positive cases of coronavirus"))
#   ), #wellPanel bracket
#   mainPanel(width = 12,
#             p("This will show the relationship between some of the measures available."),
#             p("Here some results of the modelling between both measures could
#               be shown (ARIMA?)"),
#             plotlyOutput("correlation_plot")
#   )# mainPanel bracket
# ), # tabpanel bracket
# tabPanel(
#   title = "Data", icon = icon("table"),
#   p("This tab could include the data used in the app. And potentially could have
#     the reactions to individual articles and tweets"),
#   downloadButton('download_table_csv', 'Download data'),
#   mainPanel(width = 12,
#             DT::dataTableOutput("table_filtered"))

##END