#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that estimates sample requirements
shinyUI(
  fluidPage(theme="sparkStyle.css",

  # Application title
  titlePanel("Sample Size Estimator"),

  # Sidebar
  sidebarLayout(
    sidebarPanel(
      #slider input
       sliderInput("conf",
                   "Confidence Level:",
                   min = 80,
                   max = 99.5,
                   value = 95,
                   step = .5),
       #numeric input
       numericInput("pop",
                   "Population Size:",
                   value = 5000,
                   step = 25),
       #slider input
       sliderInput("alpha",
                   "Margin of Error (+/-)",
                   min = 1,
                   max = 10,
                   value = 5,
                   step = .5),
       #slider input
       sliderInput("response",
                   "Expected response rate:",
                   min = 5,
                   max = 100,
                   value = 60,
                   step = 5)
    ),

    # Show the output
    mainPanel(
      #headline number output
      h1(textOutput("sampleSize")),
      #graph output
      plotOutput("wafflePlot"),
      textOutput("factorNote"),
      h2("Definitions"),
      p(strong("Confidence Level: ")," The degree of certainty that the true mean score would be represented within the Margin of Error given the sample."),
      p(strong("Population Size: ")," The total size of the group of people you intend to represent."),
      p(strong("Margin of Error: ")," The width for the range of scores (+/-) around the estimated mean that is likely to contain the true mean."),
      p(strong("Expected Response Rate: ")," The percent of invited people expected to respond.")
    )
  )
))
