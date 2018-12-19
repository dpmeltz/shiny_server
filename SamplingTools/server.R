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
    waffle <- waffle(boxes, rows=round(sqrt(sum(boxes)),0), size=0.25,
                     colors = c("#EBAC00", "#FFDF80", "#444249"), equal = FALSE
                     ) +
      theme(legend.position = "bottom",
            plot.background = element_rect(fill = "#444249", color = "#444249"),
            axis.line = element_line(color="#444249"),
            panel.grid = element_line(color="#444249"),
            legend.text = element_text(color="#D3D3D3")
            )
    waffle
  })

  output$factorNote <- renderText({
    # Process Numbers
    #Population Size
    popSize <- as.numeric(input$pop)
    #factor calc
    factor <- nchar(popSize)-3
    factor <- if(factor<0) {0} else{factor}

<<<<<<< HEAD
    factorNote <- c("NOTE: Each box represents ", 10^factor, " people")
=======
    factorNote <- c("NOTE: Each box represents ", 10^factor, if(factor <1) { " person"} else{" people"})
>>>>>>> 099fd5d28f7dccb63471ce3e88f722e75c4d5867

    print(factorNote)
  })
})
