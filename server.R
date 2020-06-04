
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
    plot_trend_chart(covid_stats %>% filter(variable == "Testing - Total number of COVID-19 tests carried out by NHS Labs - Daily" ),  
                     var_chosen="value")
  })
  
  ###############################################.
  ## Tables ----
  ###############################################.
  output$word_weekly <- renderTable({word_weekly %>% ungroup() %>% 
      mutate(week_ending = format(week_ending,'%Y-%m-%d'))})
  output$top_words <- renderTable({top_words })
  
  # output$hits_media_plot <- renderPlotly(plot_trend_chart())
  # output$sentiment_plot <- renderPlotly(plot_trend_chart(0, 1))
  # output$nhs24_plot <- renderPlotly(plot_trend_chart(color_chosen = "green"))
  # output$aye_plot <- renderPlotly(plot_trend_chart(color_chosen = "green"))
  # output$coronacases_plot <- renderPlotly(plot_trend_chart(color_chosen = "orange"))
  # output$coronadeaths_plot <- renderPlotly(plot_trend_chart(color_chosen = "orange"))
  # output$hits_hps_plot <- renderPlotly(plot_trend_chart(color_chosen = "green"))
  # output$retweets_plot <- renderPlotly(plot_trend_chart(color_chosen = "orange"))
  # output$word_cloud_plot <- renderPlotly({
  #   
  #   trend_data <- data.frame(word = c("Flu", "UK", "Crisis", "Outbreak", "Panic",
  #                                     "Calm", "Health", "Sneeze", "Caution", "Cases"),
  #                            value = exp(seq(1, 5.5, by = 0.5)))
  # 
  #   xaxis_plots <- list(title = FALSE, tickfont = list(size=14), titlefont = list(size=14), 
  #                       showline = TRUE, tickangle = 270, fixedrange=TRUE,
  #                       categoryorder = "array", categoryarray = sort(trend_data[,"value"]))
  #   
  #   yaxis_plots <- list(title = FALSE, rangemode="tozero", fixedrange=TRUE, size = 4, 
  #                       tickfont = list(size=14), titlefont = list(size=14)) 
  #   
  #   
  #   plot_ly(data=trend_data, x=~word, y=~value,
  #           type = "bar", marker = list(color = "blue")) %>% 
  #     #Layout 
  #     layout(margin = list(b = 160, t=5), #to avoid labels getting cut out
  #            yaxis = yaxis_plots, xaxis = xaxis_plots) %>%  
  #     config(displayModeBar = FALSE, displaylogo = F) # taking out plotly logo button
  # 
  # })
  # 
  # output$correlation_plot <- renderPlotly({
  #   
  #   trend_data <- data.frame(ind1 = runif(91, 500, 1000),
  #                            ind2 = runif(91, 400, 700),
  #                            date_event = seq(as.Date('2020-01-01'), as.Date('2020-03-31'), by = 'day'))
  #   
  #   xaxis_plots <- list(title = FALSE, tickfont = list(size=14), titlefont = list(size=14), 
  #                       showline = TRUE, tickangle = 270, fixedrange=TRUE)
  #   
  #   yaxis_plots <- list(title = FALSE, rangemode="tozero", fixedrange=TRUE, size = 4, 
  #                       tickfont = list(size=14), titlefont = list(size=14)) 
  #   
  #   fit <- lm(ind2 ~ ind1, data = trend_data)
  #   
  #   
  #   plot_ly(data=trend_data) %>% 
  #     add_markers(x=~ind1, y=~ind2,
  #                 type = "scatter", marker = list(color = "blue")) %>% 
  #     add_lines(x=~ind1, y = fitted(fit), mode = "lines") %>%
  #     #Layout 
  #     layout(margin = list(b = 160, t=5), #to avoid labels getting cut out
  #            yaxis = yaxis_plots, xaxis = xaxis_plots) %>%  
  #     config(displayModeBar = FALSE, displaylogo = F) # taking out plotly logo button
  #   
  # })
  # 
  # 
  # table_data <- data.frame(date_event = seq(as.Date('2020-01-02'), as.Date('2020-03-31'), by = 'day'),
  #                          value = runif(90, 500, 1000),
  #                          measure = rep(measure_list, 10)) %>% 
  #   mutate(value = round(value, 0))
  # 
  # output$table_filtered <- DT::renderDataTable({
  # 
  #   DT::datatable(table_data)
  # })
  # 
  # 
  # output$download_table_csv <- downloadHandler(
  #   filename ="data_extract.csv",
  #   content = function(file) {
  #     write.csv(table_data,
  #               file, row.names=FALSE) } 
  # )
  
} # server end
