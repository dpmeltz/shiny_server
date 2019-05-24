library(shiny)
library(shinydashboard)
library(ggplot2)

# Define server logic
shinyServer(function(input, output) {

  flour <- reactive(input$Flour)
  water <- reactive(input$Water)
  starter <- reactive(input$Starter)
  percent <- reactive(input$StarterHydration)

    output$hydrationText <- renderText({
      percent <- percent() / 100


        starterFlour <- starter() * (1 / (percent + 1))
        starterWater <- starter() * (percent / (percent + 1))

        totalWater <- water() + starterWater
        totalFlour <- flour() + starterFlour
        waterPercent <- round((totalWater / totalFlour) * 100, digits = 1)
print(c("Hydration Percent = ", waterPercent, "%"))
    })

    output$hydrationPlot <- renderPlot({
      percent <- percent() / 100

      starterFlour <- starter() * (1 / (percent + 1))
      starterWater <- starter() * (percent / (percent + 1))


      col1 <- c("Flour", "Starter Flour", "Water", "Starter Water")
      col2 <- c(flour(), starterFlour, water(), starterWater)
      cpall <- c("Tan", "Brown", "Light Blue", "Blue")
      hydration <- data.frame(Source = col1, Weight = col2)

      ggplot(hydration, aes(x = 1, y = Weight)) + geom_col(position = 'fill', aes(fill = Source)) + scale_fill_manual(values = cpall)
    })


})


