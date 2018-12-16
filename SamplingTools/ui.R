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
  fluidPage(theme="ColgateStyle.css",

  # Application title
  titlePanel("Sample Size Estimator"),

  # Sidebar
  sidebarLayout(
    sidebarPanel(
      #slider input
       sliderInput("conf",
                   "Confidence Level:",
                   min = 80,
                   max = 99.9,
                   value = 95,
                   step = .1),
       #numeric input
       numericInput("pop",
                   "Population Size:",
                   value = 1000,
                   step = 50),
       #slider input
       sliderInput("alpha",
                   "Margin of Error (+/-)",
                   min = 1,
                   max = 10,
                   value = 5,
                   step = 1)
    ),

    # Show the output
    mainPanel(
      #headline number output
      h1(textOutput("sampleSize")),
      #graph output
       plotOutput("wafflePlot"),
      p(textOutput("factorNote"))
    )
  )
))
