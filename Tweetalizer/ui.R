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
fluidPage(
      selectInput("n_count", label = "Number of tweets", choices = c(25, 50, 100, 200, 500), selected = 100),
      textInput("search_phrase", label = "Username:", value = "WashingtonPost"),
      checkboxInput("filter_handles", label = "Filter handles", value = FALSE),
      submitButton("Refresh"),

    # Show a plot of the generated distribution
    plotOutput("wordcloud"),
    plotOutput("sparkline")
)

