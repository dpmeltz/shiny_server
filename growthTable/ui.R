library(shiny)
library(shinydashboard)

# Define UI for application that plots child growth
dashboardPage(
  dashboardHeader(title = "Growth Tables"),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Height", tabName = "height", icon = icon("arrow-circle-up")),
      menuItem("Weight", tabName = "weight", icon = icon("weight")),
      hr(),
      radioButtons("gender", "Gender:", c("M","F"), selected = "M", inline = TRUE),
      numericInput("age", "Age (in months):", min = 0, step = 1, value = 6)
      )
  ),

  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "height",
        fluidRow(
          box(
            radioButtons("scaleH", "Scale:", c("Inches", "CM"), selected = "Inches", inline = TRUE),
            numericInput("valueH", "Value:", min = 0, step = 0.5, value = 14),
            width = 3
            ),
        fluidRow(
          box(plotOutput("heightPlot", height = 250),
              width = 8)
          )
        )
      ),

      # Second tab content
      tabItem(tabName = "weight",
              fluidRow(
                box(
                  radioButtons("scaleW", "Scale:", c("Pounds", "KG"), selected = "Pounds", inline = TRUE),
                  numericInput("valueW", "Value:", min = 0, step = 0.5, value = 30),
                  width = 3
                ),
                fluidRow(
                  box(plotOutput("weightPlot", height = 250),
                      width = 8)
                )
              )
      )
    )
  )
)
