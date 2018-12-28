#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Area Under Normal Curve Finder"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
       numericInput("Mean",
                   "Population Mean:",
                   value = 30),
       numericInput("SD",
                    "Standard Deviation:",
                    value = 10),
       radioButtons("direction",
                    "Direction",
                    choices = c("Less Than", "Greater Than", "Between", "Outside"),
                    selected = "Less Than"),
       numericInput("valmin",
                    "Score (if between/outside, the lower)",
                    value = 35),
       numericInput("valmax",
                    "Score (if between/outside, the higher)",
                    value = 55)
    ),

    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
