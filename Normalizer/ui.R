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
                   value = 0),
       numericInput("SD",
                    "Standard Deviation:",
                    value = 1),
       radioButtons("direction",
                    "Direction",
                    choices = c("Less Than", "Greater Than", "Between", "Outside"),
                    selected = "Less Than"),

       uiOutput("inputValues")

    ),

    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
<<<<<<< HEAD
       textOutput("dataReadout")
=======
       textOutput("areaText")
>>>>>>> 680f4e201a0ed6116eb7695d5724dff8ada63ec7
    )
  )
))