#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(lubridate)

#approval_topline <- read_csv("approval_topline.csv")
#approval_topline$modeldate <- mdy(approval_topline$modeldate)

#tweets <- read_csv("tweets.csv")
#tweets$date <- date(mdy_hm(tweets$created_at))

# Define server logic required to draw a histogram
server <- function(input, output) {

# approval_summary <- approval_topline %>%
#    filter(subgroup == "Voters")
#  ylim <- c(min(approval_summary$approve_estimate),max(approval_summary$approve_estimate))

  output$approval_plot <- renderPlot({
   # plot1 <- ggplot(approval_summary, aes(y = approve_estimate, x = modeldate)) +
#      geom_point(alpha = 0.25) + geom_smooth(span = 0.25, se = TRUE, color = "orange") +
#      geom_hline(aes(yintercept = mean(approve_estimate, na.rm = TRUE)), color = "darkred", alpha = .33) +
#      scale_x_date(date_breaks = "3 months", date_labels = "%y-%m-%d") +
#      ylim(ylim) +
#      xlim(input$date) +
#      xlab("Date") +
#      ylab("FiveThirtyEight Approval Estimate") +
#      theme(axis.text.x = element_text(angle = 60, hjust = 1),
#            panel.grid = element_blank(),
#            panel.background = element_blank())
   # plot1
  })

  output$tweet_plot <- renderPlot({
    #tweet_summary <- tweets %>%
    #  group_by(date) %>%
    #  summarize(n = n())

    #plot2 <- ggplot(tweet_summary, aes(x = date, y = n)) +
#      geom_point(alpha = 0.25) + geom_smooth(span = 0.25, se = TRUE, color = "orange") +
#      geom_hline(aes(yintercept = mean(n, na.rm = TRUE)), color = "darkred", alpha = .33)+
#      scale_x_date(date_breaks = "3 months", date_labels = "%y-%m-%d") +
#      ylim(0,max(tweet_summary$n)) +
#      xlim(input$date) +
#      xlab("Date") +
#      ylab("Number of Tweets") +
#      theme(axis.text.x = element_text(angle = 60, hjust = 1),
#            panel.grid = element_blank(),
#            panel.background = element_blank())
   # plot2

  })
}
