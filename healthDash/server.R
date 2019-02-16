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
library(readr)
library(tidyverse)
library(lubridate)
# Define server logic required to draw a histogram
server <- function(input, output) {
  approval_topline <- read_csv("approval_topline.csv")
  approval_topline$modeldate <- mdy(approval_topline$modeldate)

  approval_summary <- approval_topline %>%
    filter(subgroup == "Voters")
  ylim <- c(min(approval_summary$approve_estimate),max(approval_summary$approve_estimate))


  output$plot1 <- renderPlot({
    plot <- ggplot(approval_summary, aes(y = approve_estimate, x = modeldate)) +
      geom_point() +
      scale_x_date(date_breaks = "3 months", date_labels = "%y-%m-%d") +
      ylim(ylim) +
      xlim(input$date) +
      theme(axis.text.x = element_text(angle = 60, hjust = 1),
            panel.grid = element_blank(),
            panel.background = element_blank())
    plot
  })
}
