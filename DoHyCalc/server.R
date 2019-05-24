library(shiny)
library(shinydashboard)
library(ggplot2)

# Define server logic
shinyServer(function(input, output) {

    output$hydrationText <- renderText({
        flour <- input$Flour
        water <- input$Water
        starter <- input$Starter
        percent <- (input$StarterHydration)/100

        starterFlour <- starter * (1 / (percent + 1))
        starterWater <- starter * (percent / (percent + 1))

        totalWater <- water + starterWater
        totalFlour <- flour + starterFlour
        waterPercent <- round((totalWater / totalFlour) * 100, digits = 1)
print(c("Hydration Percent = ", waterPercent, "%"))

    })

})


