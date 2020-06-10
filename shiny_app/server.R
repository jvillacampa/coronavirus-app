
#Server side

function(input, output, session) {
  
  observeEvent(input$browser, browser()) #for debugging
  
  ###############################################.
  ## Functions ----
  ###############################################.
  
  plot_trend_chart <- function(dataset, color_chosen = "black", var_chosen,  moving_average = F,
                               aver_chosen = "week_aver") {

      #Creating time trend plot
      trend_plot <- plot_ly(data=dataset, x=~date) %>% 
        add_trace(y = ~get(var_chosen), type = 'scatter', mode = 'lines+markers', 
                  marker = list(size = 8, color = color_chosen), 
                  line = list(color = color_chosen),
                  name = "Value") %>% 
        #Layout 
        layout(margin = list(b = 160, t=5), #to avoid labels getting cut out
               yaxis = yaxis_plots, xaxis = xaxis_plots) %>%  
        config(displayModeBar = FALSE, displaylogo = F) # taking out plotly logo button
      
      if ( moving_average == T) {
        trend_plot %>% 
          add_lines(y = ~get(aver_chosen), name = "Prior 7 days average")
      } else if ( moving_average == F) {
        trend_plot %>%  layout(showlegend = FALSE)
      }
      
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
  
  output$boris_count <- renderPlotly(plot_trend_chart(boris_data %>% filter(person == "Boris") ,  
                                                      var_chosen="count", aver_chosen = "count_aver",  moving_average = T))
  output$boris_sentiment <- renderPlotly(plot_trend_chart(boris_data %>% filter(person == "Boris"),
                                                          var_chosen = "sentiment", aver_chosen = "sent_aver",  moving_average = T))
  
  output$dom_count <- renderPlotly(plot_trend_chart(boris_data %>% filter(person == "Dom"),  
                                                      var_chosen="count", aver_chosen = "count_aver",  moving_average = T) )
  output$dom_sentiment <- renderPlotly(plot_trend_chart(boris_data %>% filter(person == "Dom"),
                                                          var_chosen = "sentiment", aver_chosen = "sent_aver",  moving_average = T))
  
  output$search_term_count <- renderPlotly({plot_term_chart("proportion")})
  output$search_term_sentiment <-  renderPlotly({plot_term_chart("sentiment")})
  
  ###############################################.
  # Covid stats charts 
  output$daily_positives <- renderPlotly({
    plot_trend_chart(covid_stats %>% filter(variable == "Testing - Daily people found positive"),  
                     var_chosen="value",  moving_average = T)
    })
  output$corona_calls <- renderPlotly({
    plot_trend_chart(covid_stats %>% filter(variable == "Calls - Coronavirus helpline"),  
                     var_chosen="value",  moving_average = T)
  })
  output$deaths <- renderPlotly({
    plot_trend_chart(covid_stats %>% filter(variable == "Number of COVID-19 confirmed deaths registered to date" ) %>% 
                       mutate(value = value - lag(value) ) %>% 
                       group_by(variable, feature_code, area_name) %>% 
                       mutate(week_aver= round(rollmeanr(value, k = 7, fill = NA), 1)) %>% ungroup ,  
                     var_chosen="value", moving_average = T)
  })
  
  output$tests <- renderPlotly({
    plot_trend_chart(covid_stats %>% filter(variable == "Testing - Total number of COVID-19 tests carried out" ),  
                     var_chosen="value",  moving_average = T)
  })
  
  ###############################################.
  ## Tables ----
  ###############################################.
  # output$word_weekly <- renderTable({word_weekly %>% ungroup() %>% 
  #     mutate(week_ending = format(week_ending,'%Y-%m-%d'))})
  # output$top_words <- renderTable({top_words })
  
} # server end
