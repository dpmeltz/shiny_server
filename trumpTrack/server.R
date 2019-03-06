#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(ggplot2)
library(dplyr)
library(lubridate)
library(readr)
library(stargazer)
library(httr)
library(jsonlite)

# Define server logic required to draw a histogram
server <- function(input, output) {

  approval_topline <- read_csv("https://projects.fivethirtyeight.com/trump-approval-data/approval_topline.csv")
  approval_topline$date <- mdy(approval_topline$modeldate)

  approval_summary <- approval_topline %>%
    filter(subgroup == "Voters")

    ylim <- c(min(approval_summary$approve_estimate),max(approval_summary$approve_estimate))

    #tmp <- tempfile()
    #download.file("https://github.com/bpb27/trump_tweet_data_archive/blob/master/condensed_2019.json.zip?raw=true", tmp)
    #unz(tmp, "condensed_2019.json")
    #unlink(tmp)

    tweets1 <- fromJSON("data/condensed_2019.json")
    tweets2 <- fromJSON("data/condensed_2018.json")
    tweets3 <- fromJSON("data/condensed_2017.json")

    tweets2 <- rbind(tweets2,tweets3)

    tweets <- tweets2 %>%
      select(-in_reply_to_user_id_str) %>%
      rbind(tweets1)

  tweets$date <- date(parse_date_time(tweets$created_at, "a b d HMS z Y"))

  tweet_summary <- tweets %>%
    mutate(len = nchar(text)) %>%
    group_by(date) %>%
    summarize(n = n(), avg_len = mean(len, na.rm = TRUE), sd_len = sd(len, na.rm=TRUE))

  data <- left_join(approval_summary, tweet_summary, by = "date")

  output$approval_plot <- renderPlot({

       useData <- data %>%
            filter(date >= dateSelect()[1] & date <= dateSelect()[2])

    plot1 <- ggplot(useData, aes(y = approve_estimate, x = date)) +
      geom_point(alpha = 0.25) + geom_smooth(span = 0.25, se = TRUE, color = "orange") +
      geom_hline(aes(yintercept = mean(approve_estimate, na.rm = TRUE)), color = "darkred", alpha = .33) +
      scale_x_date(date_breaks = "3 months", date_labels = "%y-%m-%d") +
      ylim(ylim) +
      xlab("Date") +
      ylab("FiveThirtyEight Approval Estimate") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1),
            panel.grid = element_blank(),
            panel.background = element_blank())
    plot1
  })

  output$tweet_plot <- renderPlot({

        useData <- data %>%
            filter(date >= dateSelect()[1] & date <= dateSelect()[2])

    plot2 <- ggplot(useData, aes(x = date, y = n)) +
      geom_point(alpha = 0.25) + geom_smooth(span = 0.25, se = TRUE, color = "orange") +
      geom_hline(aes(yintercept = mean(n, na.rm = TRUE)), color = "darkred", alpha = .33) +
      scale_x_date(date_breaks = "3 months", date_labels = "%y-%m-%d") +
      ylim(0,max(useData$n)) +
      xlab("Date") +
      ylab("Number of Tweets") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1),
            panel.grid = element_blank(),
            panel.background = element_blank())
    plot2

  })

  output$regTable <- renderPrint({
       useData <- data %>%
            filter(date >= dateSelect()[1] & date <= dateSelect()[2])

    regression <- lm(useData$approve_estimate ~ useData$n)
    stargazer(regression, type = "html")
  })
}
