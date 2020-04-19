#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
lyricCorpus <- read_csv("lyric_corpus.csv")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Lyric Word Search"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("word",
                      "Word(s)",
                      choices = unique(lyricCorpus$word),
                      selected = c("Manhattan", "Brooklyn", "Queens", "Bronx", "Staten"),
                      selectize = TRUE,
                      multiple = TRUE),
            submitButton("Apply Changes")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            fluidRow((plotOutput("timePlot"))),
            fluidRow(tableOutput("artistList"))
        )
    )
))
