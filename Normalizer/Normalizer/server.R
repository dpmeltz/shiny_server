#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$distPlot <- renderPlot({

    # generate curve based on input from ui.R
    m <- as.numeric(input$Mean)
    sd <- as.numeric(input$SD)

    sample <- data.frame(rnorm(10000,m, sd))
    colnames(sample) <- "value"

    # draw the density graph
    ggplot(data=sample, aes(x=value)) + stat_function(fun = dnorm, arg = list(mean = m, sd = sd))

  })

})
