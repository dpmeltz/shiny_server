library(shiny)

# Define UI for application that illustrates area under a normal curve
shinyUI(
  fluidPage(theme="sparkStyle.css",
  # Application title
  titlePanel("Area Under Normal Curve Finder"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
       numericInput("Mean",
                   "Population Mean:",
                   value = 0),
       numericInput("SD",
                    "Standard Deviation:",
                    value = 1,
                    min = 0),
       radioButtons("direction",
                    "Direction",
                    choices = c("Less Than", "Greater Than", "Between", "Outside"),
                    selected = "Less Than"),

       uiOutput("inputValues")

    ),

    # Show a plot of the generated distribution and find the area described
    mainPanel(
       plotOutput("distPlot"),
       em(textOutput("areaText"))

    )
)
))
