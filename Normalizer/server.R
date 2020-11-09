library(shiny)
library(ggplot2)

# Define variables required to draw desired curve
shinyServer(function(input, output) {

  # Define inputs
  m <- reactive({as.numeric(input$Mean)})
  sigma <- reactive({as.numeric(input$SD)})
  # Run a normal sample of n = 250
  samp <- data.frame(rnorm(250))
  colnames(samp) <- "xval" #Clean sample column name
  # Transform sample according to inputs
  sample <- reactive({(samp*sigma()) + m()})

  # Render UI for one or two input scores
  output$inputValues <- renderUI({

    if (input$direction == "Between" | input$direction == "Outside")
      {tagList(numericInput("valmin",
                            "Lower Score:",
                            value = -1.96,
                            step = .5),
               numericInput("valmax",
                            "Higher Score:",
                            value = 1.96,
                            step = .5))}
    else {numericInput("valmin",
                       "Score:",
                       value = 1.96,
                       step = .5)}
  })

  #render curve plot
  output$distPlot <- renderPlot({
    # Define needed values using input from ui.R
    m <- m() #Mean
    sigma <- sigma() #SD
    sample <- sample() #Sample values
    height <- dnorm(median(sample$xval), m, sigma) #Determine curve height
    scoreMin <- as.numeric(input$valmin) #Define lower score or only score
    scoreMax <- as.numeric(input$valmax) #Define higher score

    # draw the density graph
    curve <- ggplot(aes(x = xval), data = sample) +
      stat_function(fun = dnorm, args = list(sd = sigma, mean = m),
                    size = 2, color = "#bbbbbb") + #Curve
      annotate('segment', x = m, xend = m + sigma,
               y = height*0.61, yend = height*0.61,
      geom_vline(aes(xintercept = scoreMin), size = 1.5, color = "blue") + #Lower/only score
               size = 2, color = "#bbbbbb") + #SD Line
      geom_vline(aes(xintercept = scoreMin), size = 1.5, color = "#172f79") + #Lower/only score
      annotate('segment', x = scoreMin,
                xend = if
                 (input$direction == "Less Than" | input$direction == "Outside") {
                  scoreMin - (.33*sigma)} else {
                  scoreMin + (.33*sigma)},
                y = height*1.05, yend = height*1.05, size = 1, color = "#172f79",
                arrow = arrow(length = unit(0.33,"cm"))) + #Directional arrow for lower/only score
      geom_vline(aes(xintercept = m), size = 2, color = "#bbbbbb") + #Mean line
      xlim(m - (4*sigma), m + (4*sigma)) + #Limit x to 4SD +/- from mean
      xlab("Scores") + ylab("") + #X Label
      guides(size = FALSE) + #No legend
      scale_y_continuous(limits = c(0, height*1.1)) + #Set y axis from 0 to 10% more than max of curve
      theme(axis.ticks = element_blank(),
            axis.text.y = element_blank(),
            plot.background = element_rect(fill = "#eeeeee", color = "#eeeeee"),
            panel.background = element_rect(fill = "#eeeeee"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            legend.position = "hidden")

if (input$direction == "Less Than" | input$direction == "Greater Than") {curve} #If multiple add higher score line
    else {curve +
        geom_vline(aes(xintercept = scoreMax), size = 1.5, color = "#172f79") +
        annotate('segment', x = scoreMax,
          xend = if
            (input$direction == "Outside") {scoreMax + (.33*sigma)} else {
            scoreMax - (.33*sigma)},
          y = height*1.05, yend = height*1.05, size = 1, color = "#172f79",
          arrow = arrow(length = unit(0.33,"cm")))}
  })

  #Render text description of area under curve selected
  output$areaText <- renderText({
    #Define needed values using input from ui.R
    m <- m()
    sigma <- sigma()
    scoreMin <- as.numeric(input$valmin)
    scoreMax <- as.numeric(input$valmax)

    #Calculate areas from lines
    minDown <- pnorm(scoreMin, m, sigma, lower.tail = TRUE) #Lower down
    minUp <- pnorm(scoreMin, m, sigma, lower.tail = FALSE) #Lower up
    maxDown <- pnorm(scoreMax, m, sigma, lower.tail = TRUE) #Higher down
    maxUp <- pnorm(scoreMax, m, sigma, lower.tail = FALSE) #Higher up

    #Determine correct area from input
    area <- if (input$direction == "Less Than") {minDown} else
    if (input$direction == "Greater Than") {minUp} else
    if (input$direction == "Between") {minUp + maxDown - 1} else
    {minDown + maxUp}

    #Generate text description
    paste("Roughly ",round(area*100,2),
          "% of the curve is within the selected area", sep = "")
  })
})
