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

  output$inputValues <- renderUI({
    if (input$direction == "Between" | input$direction == "Outside")
      {tagList(numericInput("valmin",
                      "Lower Score:",
                      value=-1.645),
        numericInput("valmax",
                   "Higher Score:",
                   value = 1.645))}
    else {numericInput("valmin",
                       "Score:",
                       value=-1.645)}
  })
  output$distPlot <- renderPlot({

    # generate curve based on input from ui.R
    m <- as.numeric(input$Mean)
    sigma <- as.numeric(input$SD)

    sample <- data.frame(rnorm(250, m, sigma))
    colnames(sample) <- "xval"
    scoreMin <- as.numeric(input$valmin)
    scoreMax <- as.numeric(input$valmax)
    height <- dnorm(median(sample$xval), m, sigma)


    # draw the density graph
    curve <- ggplot(aes(x=xval), data=sample) +
      stat_function(fun=dnorm, args=list(sd=sigma, mean=m)) +
      geom_segment(aes(x=m, xend=m+sigma, y=height*0.61, yend=height*0.61), alpha=0.33) +
      geom_vline(aes(xintercept=scoreMin), size = 2, color="blue", alpha=0.5) +
      geom_vline(aes(xintercept=m), size=2, alpha=0.33) +
      xlim(m-(4*sigma), m+(4*sigma)) +
      xlab("Scores") + ylab("") +
      guides(size=FALSE) +
      scale_y_continuous(limits=c(0, height*1.1)) +
      theme(axis.ticks=element_blank(),
            axis.text.y = element_blank(),
            panel.background = element_rect(fill=FALSE),
            panel.grid.major = element_blank(),
            legend.position="hidden")

if (input$direction == "Less Than" | input$direction == "Greater Than") {curve} else {curve + geom_vline(aes(xintercept=scoreMax), size = 2, color="red", alpha=0.5)}


  })

})
