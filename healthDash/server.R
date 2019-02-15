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
library(ggplot2)

# Define server logic required to draw a histogram
server <- function(input, output) {
  approval_topline <- read_csv("approval_topline.csv")


  output$plot1 <- renderPlot({
    plot <- ggplot(approval_topline, aes(y = approve_estimate, x = as.Date(modeldate))) +
      geom_point() +
      scale_x_date(date_breaks = "6 months", date_labels = "%m/%d/%y") +
      ylim(25,75) +
      xlim(input$date) +
      theme(axis.text.x = element_text(angle = 60, hjust = 1),
            panel.grid = element_blank(),
            panel.background = element_blank())
    plot
  })
}
