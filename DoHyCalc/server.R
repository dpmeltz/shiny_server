# Load Libraries
library(shiny)
library(shinydashboard)
library(ggplot2)

# Define server logic
shinyServer(function(input, output) {

  # Calculations
  # Load reactive values
  flour <- reactive(input$Flour)
  water <- reactive(input$Water)
  starter <- reactive(input$Starter)
  percent <- reactive(input$StarterHydration)

  output$hydrationText <- renderText({
    percent <- percent() / 100


    # Find flour/water values from starter weight/hydration
    starterFlour <- starter() * (1 / (percent + 1))
    starterWater <- starter() * (percent / (percent + 1))

    # Find total hydration (all water / all flour)
    totalWater <- water() + starterWater
    totalFlour <- flour() + starterFlour
    waterPercent <- round((totalWater / totalFlour) * 100, digits = 1)

    # Print hydration %
    print(c("Hydration Percent = ", waterPercent, "%"))
  })

  # Hydration graph
  output$hydrationPlot <- renderPlot({
    percent <- percent() / 100

    # Find flour/water values from starter weight/hydration
    starterFlour <- starter() * (1 / (percent + 1))
    starterWater <- starter() * (percent / (percent + 1))

    # Table source / weight
    col1 <- c("Flour", "Starter Flour", "Water", "Starter Water")
    col2 <- c(flour(), starterFlour, water(), starterWater)
    cpall <- c("#fee6ce", "#fdae6b", "#deebf7", "#9ecae1")
    hydration <- data.frame(Source = col1, Weight = col2)
    hydration$Source <- factor(hydration$Source, levels = col1)

    # Plot weight/total by source
    ggplot(hydration, aes(x = 1, y = Weight)) +
      geom_col(position = "fill", aes(fill = Source)) +
      scale_fill_manual(values = cpall) +
      # geom_text() add label for water% at top of water bar
      theme_minimal() +
      theme(
        axis.title = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_blank()
      )
  })
})
