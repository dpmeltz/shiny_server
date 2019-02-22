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
      genderH <- input$gender

      dataH <- hchart %>%
        filter(Gender == genderH)

      valueH <- if(input$scaleH == 'Inches') {input$valueH * 2.54} else {input$valueH}

      plotH <- ggplot(dataH, aes(x = `Age (in months)`)) +
        geom_line(aes(y = `50th Percentile Stature (in centimeters)`), alpha = .9) +
        geom_line(aes(y = `75th Percentile Stature (in centimeters)`), color = "blue", alpha = .75) +
        geom_line(aes(y = `25th Percentile Stature (in centimeters)`), color = "blue", alpha = .75) +
        geom_hline(aes(yintercept = valueH), color = "red") +
        geom_vline(aes(xintercept = input$age), color = "red") +
        xlim(c(input$age - 6, input$age + 6)) +
        ylim(c(valueH * .9, valueH * 1.1))

   plotH

  })


    output$weightPlot <- renderPlot({
      # filter data to gender
      genderW <- input$gender

      dataW <- wchart %>%
        filter(Gender == genderW)

      valueW <- if (input$scaleW == 'Pounds') {input$valueW / 2.205} else {input$valueW}

      plotW <- ggplot(dataW, aes(x = `Age (in months)`)) +
        geom_line(aes(y = `50th Percentile Weight (in kilograms)`), alpha = .9) +
        geom_line(aes(y = `75th Percentile Weight (in kilograms)`), color = "blue", alpha = .75) +
        geom_line(aes(y = `25th Percentile Weight (in kilograms)`), color = "blue", alpha = .75) +
        geom_hline(aes(yintercept = valueW), color = "red") +
        geom_vline(aes(xintercept = input$age), color = "red") +
        xlim(c(input$age - 6, input$age + 6)) +
        ylim(c(valueW * .9, valueW * 1.1))

      plotW

    })
})
