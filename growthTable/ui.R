library(shiny)
library(shinydashboard)

# Define UI for application that plots child growth
dashboardPage(
  dashboardHeader(title = "Growth Tables"),

  dashboardSidebar(
    sidebarMenu(
      menuItem("Size", tabName = "Size", icon = icon("arrow-circle-up")),
      menuItem("Other", tabName = "other", icon = icon("weight")),
      hr(),
      radioButtons("gender", "Gender:", c("M","F"), selected = "M", inline = TRUE),
      numericInput("age", "Age (in months):", min = 0, step = 1, value = 6)
      )
  ),

  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "Size",
        fluidRow(
          box(
            radioButtons("scaleH", "Scale:", c("Inches", "CM"), selected = "Inches", inline = TRUE),
            numericInput("valueH", "Value:", min = 0, step = 0.5, value = 14),
            width = 3
            ),
          box(plotOutput("heightPlot", height = 250),
              width = 8)

      ),

              fluidRow(
                box(
                  radioButtons("scaleW", "Scale:", c("Pounds", "KG"), selected = "Pounds", inline = TRUE),
                  numericInput("valueW", "Value:", min = 0, step = 0.5, value = 30),
                  width = 3
                ),
                  box(plotOutput("weightPlot", height = 250),
                      width = 8)
                )
      ),
      tabItem(tabName = "other",
              fluidRow(
                box("Data for this tool is extracted from CDC.gov. The tool pulls the 25th, 50th, and 75th percentiles from the guidelines and plots them to the grids.",br(), br(),"No data entered is stored in any way.")
              ))
    )
  )
)