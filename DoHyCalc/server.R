library(shiny)
library(shinydashboard)
library(ggplot2)

# Define server logic
shinyServer(function(input, output) {

    output$hydrationPlot <- renderPlot({
        dough <- {}
        dough$flour <- input$Flour
        dough$water <- input$Water
        dough$starter <- input$Starter
        dough <- as.data.frame(dough)
        dough <- t(dough)
        colnames(dough) <- "weight"

        # draw the plot
        plot <- barplot(dough)
        plot
    })

})
