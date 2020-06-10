# 
# library(readxl)
# library(dplyr)
# tweet_data <- read_excel("C:/Users/jamiev01/Desktop/DeepMiner tables/tweet_data.xlsx")
# 
# tweet_data <- tweet_data %>% 
#   mutate(rt = case_when(substr(tweet_text,1,2) == "RT" ~ 1, TRUE ~ 0),
#          length_tweet = nchar(tweet_text))
# 
# table(tweet_data$rt)
# # 0     1 
# # 15283 61569 
# hist(tweet_data$length_tweet)
# plot(tweet_data$length_tweet, log(tweet_data$sentiment))
# 
# m1 <- glm(log(sentiment) ~ length_tweet, family = "gaussian", tweet_data)
# summary(m1)
# # length_tweet -8.109e-04  9.572e-05  -8.472   <2e-16 ***
# 
# min(tweet_data$date)
# # [1] "2020-03-01 UTC"
# max(tweet_data$date)
# # [1] "2020-05-04 UTC"
# summary(tweet_data$sentiment)
# # Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
# # 0.02036 0.43878 0.63606 0.60186 0.78762 0.98450 
# 
# table(tweet_data$search_term)
