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
library(waffle)

# Define server logic required to draw output
shinyServer(function(input, output) {

  output$sampleSize <- renderText({
    # Process Numbers
    #Population Size
    popSize <- as.numeric(input$pop)
    #Alpha level
    alpha <- input$alpha/100
    #Confidence level
    Z <- qnorm(((100-input$conf)/2)/100)
    #Estimate Sample (round up to whole person)
    sampSize <- round(((Z^2)*(.25)/(alpha^2)) / (1+((Z^2)*(.25)/(alpha^2*popSize))) + .49, 0)

    sample <- c(sampSize, " people required")
      print(sample)
  })

  output$wafflePlot <- renderPlot({
    # Process Numbers
    #Population Size
    popSize <- as.numeric(input$pop)
    #Alpha level
    alpha <- input$alpha/100
    #Confidence level
    Z <- qnorm(((100-input$conf)/2)/100)
    #Estimate Sample (round up to whole person)
    sampSize <- round(((Z^2)*(.25)/(alpha^2)) / (1+((Z^2)*(.25)/(alpha^2*popSize))) + .49, 0)
    #Pop vs Samp
    boxes <- c("Sampled" = sampSize, "Not Sampled" = (popSize-sampSize))
    factor <- nchar(popSize)-3
    factor <- if(factor<0) {0} else{factor}
    boxes <- round(boxes/10^factor,0)

        # generate waffle plot based on Pop vs Samp
    waffle <- waffle(boxes, rows=round(sqrt(sum(boxes)),0), size=.5,
                     colors = c("#D2010D", "#535353", "#FFFFFF")) +
      theme(legend.position = "bottom")
    waffle
  })

  output$factorNote <- renderText({
    # Process Numbers
    #Population Size
    popSize <- as.numeric(input$pop)
    #factor calc
    factor <- nchar(popSize)-3
    factor <- if(factor<0) {0} else{factor}

    factorNote <- c("NOTE: Each box represents ", 10^factor, if(factor <1) { " person"} else{" people"})

    print(factorNote)
  })
})
