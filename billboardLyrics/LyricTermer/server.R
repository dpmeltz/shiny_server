#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(stringr)
setwd("/cloud/project/billboardLyrics/LyricTermer")

lyricCorpus <- read_csv("lyric_corpus.csv")



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$timePlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        lyricCorpus %>%
        filter(word %in% str_to_lower(input$word)) %>%
            group_by(word, year) %>%
            dplyr::summarize(freq = n()) %>%
            ggplot(aes(x = year, y = freq, fill = word, color = word)) + geom_path() +
            geom_point() +
            expand_limits(y = 0) +
            theme_minimal() +
            coord_cartesian(xlim = c(2000,2020)) +
            scale_y_continuous(breaks = 10)

    })

   output$artistList <- renderTable({

    lyricCorpus %>%
        filter(word %in% str_to_lower(input$word)) %>%
        group_by(as.character(year), artist, word) %>%
        dplyr::summarize(freq = n()) %>%
        arrange(desc(freq)) %>%
        head()
    })

})
