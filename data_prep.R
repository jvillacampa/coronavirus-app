#data preparation
library(dplyr)
library(readxl)
library(readr)
library(phsmethods)
library(lubridate)
library(tidyr)
library(zoo)

tweet_count_data <- read_csv("data/tweets.csv") %>%
  group_by(date) %>%
  summarise(count = n(), sentiment = mean(sentiment, na.rm = T)) %>% ungroup

saveRDS(tweet_count_data, "data/tweet_count_data.rds")

tweet_count_term_data <- read_csv("data/tweets.csv") %>%
  filter(as.Date(date) > as.Date("2020-04-26")) %>% #no other terms before
  mutate(search_term = recode(search_term, "coronavirus" = "Coronavirus/COVID-19",
                              "COVID-19" = "Coronavirus/COVID-19",
                              "distancing" = "Social distancing",  "distancing coronavirus"= "Social distancing",
                              "lockdown" = "Lockdown",  "lockdown coronavirus" = "Lockdown",
                              "PPE" = "PPE",
                              "tracing" = "Tracing", "tracing and privacy" = "Tracing", 
                              "tracing coronavirus" = "Tracing", "tracing privacy coronavirus" = "Tracing",
                              "isolation coronavirus" = "Isolation", "isolation" = "Isolation",
                              "masks coronavirus" = "Masks", "face covering" = "Masks", "masks" = "Masks",
                              "quarantine coronavirus"  = "Quarantine", "quarantine" = "Quarantine",
                              "shielding coronavirus" = "Shielding",  "shielding" = "Shielding",
                              "testing coronavirus" = "Testing", "testing" = "Testing"
  )) %>%
  group_by(date, search_term) %>%
  summarise(count = n(), sentiment = mean(sentiment, na.rm = T)) %>% ungroup

tweet_count_term_data <- left_join(tweet_count_term_data,
                                   tweet_count_data %>% select(total = count, date),
                                   by = c("date")) %>%
  mutate(proportion = round(count/total *100, 0))

saveRDS(tweet_count_term_data, "shiny_app/data/tweet_count_term_data.rds")


# Tweets by key word identified
word_data <- read_csv("data/tweet_words.csv") %>%
  mutate(date = as.Date(date, format="%d/%m/%Y"),
         week_ending = ceiling_date(date, "week", change_on_boundary = F))  # week ending

top_words <- word_data %>% group_by(tweet_word) %>% count %>% arrange(desc(n)) %>% ungroup %>%
  filter(n > 500) #this is arbitrary better in future with top_n

saveRDS(top_words, "shiny_app/data/topword_count.rds")

word_data <- word_data %>% filter(tweet_word %in% top_words$tweet_word) %>%
  group_by(week_ending, tweet_word) %>%
  count %>%
  pivot_wider(week_ending, names_from = tweet_word, values_from = n)

saveRDS(word_data, "shiny_app/data/worddata_weekly.rds")


# Data from open data platform
covid_stats <- read_csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fcoronavirus-covid-19-management-information") %>%
  janitor::clean_names() %>%
  mutate(area_name = match_area(feature_code)) %>%
  mutate(date = as.Date(date_code), value = as.numeric(value)) %>%
  arrange(date, variable) %>%
  filter(area_name == "Scotland") %>%  #scotland for now
  mutate(variable = recode(variable, "Testing - Total number of COVID-19 tests carried out by NHS Labs - Daily" =
                             "Testing - Total number of COVID-19 tests carried out", 
                           "Testing - Total number of COVID-19 tests carried out by Regional Testing Centres - Daily" =
                             "Testing - Total number of COVID-19 tests carried out")) %>% 
  group_by(variable, feature_code, date, area_name) %>% 
  summarise(value = sum(value, na.rm = T)) %>% ungroup %>% 
  group_by(variable, feature_code, area_name) %>% 
  mutate(week_aver= round(rollmeanr(value, k = 7, fill = NA), 1)) %>% ungroup

saveRDS(covid_stats, "shiny_app/data/covid_open_data.rds")

# deaths <- read_csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fdeaths-involving-coronavirus-covid-19") %>%
#   janitor::clean_names() %>%
#   mutate(area_name = match_area(feature_code)) %>%
#   filter(area_name == "Scotland") %>% #scotland for now
#   filter(sex == "All" & age == "All" & cause_of_death == "COVID-19 related" &
#            location_of_death == "All")

