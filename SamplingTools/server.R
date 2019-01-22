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

  #Population Size
  popSize <- reactive({as.numeric(input$pop)})
  #Alpha level
  alpha <- reactive({input$alpha/100})
  #Confidence level
  Z <- reactive({qnorm(((100 - input$conf)/2)/100)})
  #response rate
  respRate <- reactive({input$response/100})

  output$sampleSize <- renderText({
    #Process Numbers
    #Population Size
    popSize <- popSize()
    #Alpha level
    alpha <- alpha()
    #Confidence level
    Z <- Z()
    #Estimate Sample (round up to whole person)
    respSize <- round(((Z^2)*(.25)/(alpha^2)) / (1 + ((Z^2)*(.25)/(alpha^2*popSize))) + .49, 0)
    sampSize <- respSize/respRate()
    sampSizePrint <- if (sampSize > popSize) {popSize} else {sampSize}

    sample <- paste(respSize, " responses required (invite ", round(sampSizePrint,0),
                " people", if (sampSize > popSize) {" and cross your fingers)"} else {")"}, sep = "")
      print(sample)
  })

  output$wafflePlot <- renderPlot({
    #Process Numbers
    #Population Size
    popSize <- popSize()
    #Alpha level
    alpha <- alpha()
    #Confidence level
    Z <- Z()
    #Estimate Sample (round up to whole person)
    respSize <- round(((Z^2)*(.25)/(alpha^2)) / (1 + ((Z^2)*(.25)/(alpha^2*popSize))), 0)
    sampSize <- respSize/respRate()
    sampSizeVis <- round(if (sampSize > popSize) {popSize - respSize} else {
      sampSize - respSize}, 0)

    #Pop vs Samp
    boxes <- c("Required Responses" = respSize,
               "Sampled" = sampSizeVis,
               "Not Sampled" = if (sampSize > popSize) {0}
               else {(popSize - sampSizeVis - respSize)})
    factor <- nchar(format(popSize, scientific = F)) - 3
    factor <- if (factor < 0) {0} else {factor}
    boxes <- round(boxes/10^factor,0)

        # generate waffle plot based on Pop vs Samp
    waffle <- waffle(boxes,
                     rows = round(sqrt(sum(boxes))*.75,0),
                     size = .5,
                     equal = TRUE,
                     colors = c("#EBAC00", "#FFDF80", "#979797", "#FFFFFF")) +
      theme(legend.position = "bottom"
            )
    waffle
  })

  output$factorNote <- renderText({
    # Process Numbers
    #Population Size
    popSize <- popSize()
    #factor calc
    factor <- nchar(format(popSize, scientific = F)) - 3
    factor <- if (factor < 0) {0} else {factor}

    factorNote <- c("NOTE: Each box represents ", 10^factor, if (factor < 1) {
      " person"} else {" people"})

    print(factorNote)
  })
})
