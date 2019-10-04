library(shiny)
library(shinydashboard)

# Define UI for application that plots child growth
dashboardPage(
    dashboardHeader(title = "Dough Hydration"),

    dashboardSidebar(
        sidebarMenu(
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
            # First tab content
            tabItem(tabName = "hydration",
                    fluidRow(
                        box(textOutput("hydrationText"))),
                    fluidRow(
                        box(plotOutput(("hydrationPlot")))
                    )
            ),
            tabItem(tabName = "other",
                    fluidRow(
                        box("This hydration tool is designed to help estimate the hydration percentage of a sourdough loaf. Hydration is calculated as the weight of water over the weight of flour (not water/total). "))
        )
    )
)
)