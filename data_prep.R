#data preparation
library(dplyr)
library(readxl)
library(readr)
library(phsmethods)

tweet_count_data <- read_excel("data/tweet_data.xlsx") %>% 
  group_by(date) %>% 
  summarise(count = n(), sentiment = mean(sentiment, na.rm = T)) %>% ungroup

saveRDS(tweet_count_data, "data/tweet_count_data.rds")

tweet_count_term_data <- read_excel("data/tweet_data.xlsx") %>% 
  filter(as.Date(date) > as.Date("2020-04-26")) %>% #no other terms before
  mutate(search_term = recode(search_term, "coronavirus" = "Coronavirus/COVID-19", 
                              "COVID-19" = "Coronavirus/COVID-19", 
                              "distancing" = "Social distancing",  "distancing coronavirus"= "Social distancing",
                              "lockdown" = "Lockdown",  "lockdown coronavirus" = "Lockdown", 
                              "PPE" = "PPE",  
                              "tracing" = "Tracing", "tracing and privacy" = "Tracing", "tracing coronavirus" = "Tracing",
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

saveRDS(tweet_count_term_data, "data/tweet_count_term_data.rds")

# Data from open data platform
covid_stats <- read_csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fcoronavirus-covid-19-management-information") %>%
  janitor::clean_names() %>% 
  mutate(area_name = match_area(feature_code)) %>% 
  mutate(date = as.Date(date_code), value = as.numeric(value)) %>% 
  arrange(date, variable) %>% 
  filter(area_name == "Scotland") #scotland for now

saveRDS(covid_stats, "data/covid_open_data.rds")

# deaths <- read_csv("https://statistics.gov.scot/downloads/cube-table?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fdeaths-involving-coronavirus-covid-19") %>%
#   janitor::clean_names() %>% 
#   mutate(area_name = match_area(feature_code)) %>% 
#   filter(area_name == "Scotland") %>% #scotland for now
#   filter(sex == "All" & age == "All" & cause_of_death == "COVID-19 related" &
#            location_of_death == "All")

