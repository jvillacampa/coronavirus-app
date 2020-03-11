
#Server side

function(input, output) {
  
  plot_trend_chart <- function(min = 500, max = 1000) {

    trend_data <- data.frame(date_event = seq(as.Date('2020-01-01'), as.Date('2020-03-31'), by = 'day'),
                             value = runif(91, min, max)) %>% 
      filter(between(date_event, input$time_media[1], input$time_media[2]))
    
    xaxis_plots <- list(title = FALSE, tickfont = list(size=14), titlefont = list(size=14), 
                        showline = TRUE, tickangle = 270, fixedrange=TRUE)
    
    yaxis_plots <- list(title = FALSE, rangemode="tozero", fixedrange=TRUE, size = 4, 
                        tickfont = list(size=14), titlefont = list(size=14)) 
    
      #Creating time trend plot
      trend_plot <- plot_ly(data=trend_data, x=~date_event,  y = ~value) %>% 
        add_trace(type = 'scatter', mode = 'lines+markers', marker = list(size = 8)) %>% 
        #Layout 
        layout(margin = list(b = 160, t=5), #to avoid labels getting cut out
               yaxis = yaxis_plots, xaxis = xaxis_plots) %>%  
        config(displayModeBar = FALSE, displaylogo = F) # taking out plotly logo button
      
  }
  
  output$hits_media_plot <- renderPlotly(plot_trend_chart())
  output$sentiment_plot <- renderPlotly(plot_trend_chart(0, 1))
  output$word_cloud_plot <- renderPlotly(plot_trend_chart())
  output$nhs24_plot <- renderPlotly(plot_trend_chart())
  output$aye_plot <- renderPlotly(plot_trend_chart())
  output$coronacases_plot <- renderPlotly(plot_trend_chart())
  output$coronadeaths_plot <- renderPlotly(plot_trend_chart())
  output$hits_hps_plot <- renderPlotly(plot_trend_chart())
  output$retweets_plot <- renderPlotly(plot_trend_chart())
  
  
} # server end
