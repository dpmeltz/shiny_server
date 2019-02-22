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
library(readxl)
library(ggplot2)
library(dplyr)

# Define server logic
shinyServer(function(input, output) {

  wchart <- read_excel("./growthCharts.xlsx", sheet = "weight")
  hchart <- read_excel("./growthCharts.xlsx", sheet = "height")

    output$heightPlot <- renderPlot({
    # filter data to gender
      gender <- input$gender

      data <- hchart %>%
        filter(Gender == gender)

      value <- if(input$scale == 'Inches') {input$value * 2.54} else {input$value}

      plotH <- ggplot(data, aes(x = `Age (in months)`)) +
        geom_point(aes(y = `50th Percentile Stature (in centimeters)`), alpha = .50) +
        geom_point(aes(y = `75th Percentile Stature (in centimeters)`), color = "light blue", alpha = .25) +
        geom_point(aes(y = `25th Percentile Stature (in centimeters)`), color = "light blue", alpha = .25) +
        geom_hline(aes(yintercept = value), color = "red") +
        geom_vline(aes(xintercept = input$age), color = "red") +
        xlim(c(input$age-6, input$age+6)) +
        ylim(c(value*.75, value*1.25))

   plotH

  })

})
