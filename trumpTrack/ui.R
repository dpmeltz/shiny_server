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
  skin = "yellow",
  # Dashboard title
  dashboardHeader(title = "Trump Tracker"),
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
                box(plotOutput("approval_plot", height = 250),
                    width = 6),
                #box3
                box(plotOutput("tweet_plot", height = 250),
                    width = 6)
                # box2
              ),
              fluidRow(
                box(htmlOutput("regTable", inline = FALSE)),
                box(
                  title = "Date Range:",
                  dateRangeInput("date", "Date Range:",
                                 start = as.Date("2017-01-23"),
                                 end = as.Date("2019-02-12"),
                                 format = "M-d-yy")
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
