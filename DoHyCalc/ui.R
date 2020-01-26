# Load libraries
library(shiny)
library(shinydashboard)

# Define UI for application that plots child growth
dashboardPage(
  dashboardHeader(title = "Dough Hydration"),

  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      # Settings
      menuItem("Hydration", tabName = "hydration", icon = icon("tint")),
      menuItem("Other", tabName = "other", icon = icon("info-circle")),
      hr(),
      numericInput("Flour", "Flour (in gr):", min = 0, step = 5, value = 600),
      numericInput("Water", "Water (in gr):", min = 0, step = 5, value = 400),
      numericInput("Starter", "Starter (in gr):", min = 0, step = 5, value = 250),
      sliderInput("StarterHydration", "Starter Hydration %", min = 50, max = 200, step = 5, value = 100)
    )
  ),

  dashboardBody(
    tabItems(
      # Outputs
      tabItem(
        tabName = "hydration",
        # Print hydration percentage
        fluidRow(
          box(textOutput("hydrationText"))
        ),
        # Graph of hydration
        fluidRow(
          box(plotOutput(("hydrationPlot")))
        )
      ),
      tabItem(
        tabName = "other",
        # Description of bakers math
        fluidRow(
          box("This hydration tool is designed to help estimate the hydration percentage of a sourdough loaf. Hydration is calculated as the weight of water over the weight of flour (not water/total). ")
        )
      )
    )
  )
)