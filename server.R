
#Server side

function(input, output, session) {
  
  ###############################################.
  ## Functions ----
  ###############################################.
  
  plot_trend_chart <- function(dataset, color_chosen = "black", var_chosen) {

      #Creating time trend plot
      trend_plot <- plot_ly(data=dataset, x=~date,  y = ~get(var_chosen)) %>% 
        add_trace(type = 'scatter', mode = 'lines+markers', 
                  marker = list(size = 8, color = color_chosen), 
                  line = list(color = color_chosen)) %>% 
        #Layout 
        layout(margin = list(b = 160, t=5), #to avoid labels getting cut out
               yaxis = yaxis_plots, xaxis = xaxis_plots) %>%  
        config(displayModeBar = FALSE, displaylogo = F) # taking out plotly logo button
      
  }
  
  plot_term_chart  <- function(var_chosen) {
    
    plot_data <- tweet_count_term_data %>% filter(search_term %in% input$term_picker)
    
    #Creating time trend plot
    plot_ly(data=plot_data, x=~date,  y =  ~get(var_chosen)) %>% 
      add_trace(type = 'scatter', mode = 'lines+markers', 
                color = ~search_term, colors = term_palette,
                marker = list(size = 8)) %>% 
      #Layout 
      layout(margin = list(b = 160, t=5), #to avoid labels getting cut out
             yaxis = yaxis_plots, xaxis = xaxis_plots) %>%  
      config(displayModeBar = FALSE, displaylogo = F) # taking out plotly logo button
    
  }
  
  ###############################################.
  ## Charts ----
  ###############################################.
  output$tweet_count <- renderPlotly(plot_trend_chart(tweet_count_data,  var_chosen="count"))
  output$tweet_sentiment <- renderPlotly(plot_trend_chart(tweet_count_data, var_chosen = "sentiment"))
  
  output$search_term_count <- renderPlotly({plot_term_chart("proportion")})
  output$search_term_sentiment <-  renderPlotly({plot_term_chart("sentiment")})
  
  ###############################################.
  # Covid stats charts 
  output$daily_positives <- renderPlotly({
    plot_trend_chart(covid_stats %>% filter(variable == "Testing - Daily people found positive"),  
                     var_chosen="value")
    })
  output$corona_calls <- renderPlotly({
    plot_trend_chart(covid_stats %>% filter(variable == "Calls - Coronavirus helpline"),  
                     var_chosen="value")
  })
  output$deaths <- renderPlotly({
    plot_trend_chart(covid_stats %>% filter(variable == "Number of COVID-19 confirmed deaths registered to date" ) %>% 
                       mutate(value = value - lag(value) ),  
                     var_chosen="value")
  })
  
  output$tests <- renderPlotly({
    plot_trend_chart(covid_stats %>% filter(variable == "Testing - Total number of COVID-19 tests carried out" ),  
                     var_chosen="value")
  })
  
  ###############################################.
  ## Tables ----
  ###############################################.
  # output$word_weekly <- renderTable({word_weekly %>% ungroup() %>% 
  #     mutate(week_ending = format(week_ending,'%Y-%m-%d'))})
  # output$top_words <- renderTable({top_words })
  
} # server end
