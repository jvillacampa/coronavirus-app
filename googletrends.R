# # code to extract google trends data on coronavirus terms
# library(gtrendsR)
# library(ggplot2)
# 
# # Scotland council codes
# scot_ca_codes <- as.character(countries$sub_code[1454:1485])
# 
# corona_web <-  gtrends(c("coronavirus"), geo = c("GB-SCT"), 
#                         gprop = "web", time = "today 3-m")
# corona_news <-  gtrends(c("coronavirus", "COVID-19", "covid-19"), geo = c("GB-SCT"), 
#                        gprop = "news", time = "today 3-m")
# 
# comparison <-  gtrends(c("money problems", "anxiety", "mental health", "face masks"), geo = c("GB-SCT"), 
#                         gprop = "web", time = "today 3-m")
# 
# ggplot(data=corona_web[["interest_over_time"]], aes(x=date, y=hits,group=keyword,col=keyword))+
#   geom_line()+xlab('Time')+ylab('Relative Interest')+ theme_bw()+
#   theme(legend.title = element_blank(),legend.position="bottom",legend.text=element_text(size=12))+
#   ggtitle("Google Search Volume in Scotland")
# 
# ggplot(data=comparison[["interest_over_time"]], aes(x=date, y=hits,group=keyword,col=keyword))+
#   geom_line()+xlab('Time')+ylab('Relative Interest')+ theme_bw()+
#   theme(legend.title = element_blank(),legend.position="bottom",legend.text=element_text(size=12))+
#   ggtitle("Google Search Volume in Scotland")
