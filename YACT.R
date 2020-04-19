library(RCurl)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
x <- getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv")
data <- read_csv(x)
data_family <- data %>%
  filter(Province_State %in% c("Wisconsin"))

data_plot <- data_family %>%
  pivot_longer(cols = ends_with("/20"), names_to = "Date", values_to = "Deaths") %>%
  mutate(Date = mdy(Date),
         Location = Admin2) %>%
  filter(Date > mdy("03/15/2020"),
         Location == "Milwaukee") %>%
  mutate(NewDeaths = Deaths - lag(Deaths, n = 1L),
         Election = ifelse(Date <= mdy("04/07/2020"), "Pre",
                           ifelse(Date <= mdy("04/12/2020"), "Delay", "Post")))

pre_data <- data_plot %>%
    filter(Election == "Pre")

post_data <- data_plot %>%
  filter(Election == "Post")

lm(NewDeaths ~ Date, pre_data)
lm(NewDeaths ~ Date, post_data)

data_plot %>%
  filter(Date > mdy("03/16/2020")) %>%
  ggplot(aes(x = Date, y = NewDeaths, group = Election, color = Location)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", formula = y ~ splines::bs(x, 2)) +
  #scale_y_log10() +
  theme_minimal() +
  theme(legend.position = "none")
