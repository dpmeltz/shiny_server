#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  # skin
  skin = "red",
  # Dashboard title
  dashboardHeader(title = "Basic dashboard"),
  # Define sidebar
  dashboardSidebar(
    # Use sidebar as menu
    sidebarMenu(
    # Menu1
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    # Menu2
    menuItem("Widgets", tabName = "widgets", icon = icon("th"))
  )
  ),
  dashboardBody(
    # Define tabs
    tabItems(
      # Menu1 tab content
      tabItem(tabName = "dashboard",
              # Boxes need to be put in a row (or column)
              fluidRow(
                # box1
                box(plotOutput("plot1", height = 250)),
                # box2
                box(
                  title = "Controls",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              )
      ),

      # Menu2 tab content
      tabItem(tabName = "widgets",
              h2("Widgets tab content")
      )
    )

  )
)
