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
                      value=-1,
                      step=.5),
        numericInput("valmax",
                   "Higher Score:",
                   value = 1,
                   step=.5))}
    else {numericInput("valmin",
                       "Score:",
                       value=-1,
                       step=.5)}
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
      stat_function(fun=dnorm, args=list(sd=sigma, mean=m), size=2, color="#979797") +
      annotate('segment', x=m, xend=m+sigma, y=height*0.61, yend=height*0.61,
               size = 2, alpha=0.33) +
      geom_vline(aes(xintercept=scoreMin), size = 1.5, color="blue") +
      annotate('segment', x=scoreMin,
                       xend = if
                       (input$direction == "Less Than" | input$direction == "Outside") {
                        scoreMin-(.33*sigma)} else {
                        scoreMin+(.33*sigma)},
               y=height*1.05, yend=height*1.05, size = 1, color="blue",
               arrow = arrow(length = unit(0.33,"cm"))) +
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

if (input$direction == "Less Than" | input$direction == "Greater Than") {curve} else {curve + geom_vline(aes(xintercept=scoreMax), size = 1.5, color="red") +
    annotate('segment', x=scoreMax,
             xend = if
             (input$direction == "Outside") {
               scoreMax+(.33*sigma)} else {
                 scoreMax-(.33*sigma)},
             y=height*1.05, yend=height*1.05, size = 1, color="red",
             arrow = arrow(length = unit(0.33,"cm")))}


  })


  output$areaText <- renderText({
    # generate curve based on input from ui.R
    m <- as.numeric(input$Mean)
    sigma <- as.numeric(input$SD)
    scoreMin <- as.numeric(input$valmin)
    scoreMax <- as.numeric(input$valmax)

    minDown <- pnorm(scoreMin, m, sigma, lower.tail = TRUE)
    minUp <- pnorm(scoreMin, m, sigma, lower.tail = FALSE)
    maxDown <- pnorm(scoreMax, m, sigma, lower.tail = TRUE)
    maxUp <- pnorm(scoreMax, m, sigma, lower.tail = FALSE)

    area <- if (input$direction == "Less Than") {minDown} else
    if (input$direction == "Greater Than") {minUp} else
    if (input$direction == "Between") {minUp+maxDown-1} else
    {minDown+maxUp}

    paste("Roughly ",round(area*100,2),"% of the curve is within the selected area", sep="")
  })

})
