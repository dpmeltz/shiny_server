#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(twitteR)
library(ROAuth)
library(httr)
library(tidyverse)


#set twitter
api_key <- "bbmeTHKmB0yOp2tNxdi3N4yBe" # your api_key
api_secret <- "FZziVSsIqfwoWXyZg2lTror9rozOZCJYOCHlWsV8qYmInfRcdG" # your api_secret
access_token <- "500829754-O6wIL5kiyuhThm54Wy2qUTYJxGFX9yjI9ZALJKIH" # your access_token
access_token_secret <- "FwT0B8oVmuwwJz6aLUBM7ybJ1Vyvdnyk9UEreDFwsowPt" # your access_token_secret
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$wordcloud <- renderPlot({

    tweets <- userTimeline(isolate(input$search_phrase), n = isolate(input$n_count), maxID = NULL, sinceID = NULL, includeRts = TRUE)
    tweets_df <- twListToDF(tweets) #Convert to Data Frame
    text <- Corpus(VectorSource(tweets_df$text), readerControl = list(language = "eng"))
    tdm <- TermDocumentMatrix(text)
    m1 <- as.matrix(tdm)
    v1 <- sort(rowSums(m1),decreasing = TRUE)
    d1 <- data.frame(word = names(v1),freq = v1)

    #Remove Stop Words
    #Remove Punctuation

    wordcloud(d1$word,d1$freq, min.freq = 2,max.words = 200, random.order = FALSE, rot.per = 0.35, colors = brewer.pal(9, "Greys"), scale = c(5,.5))
  }, width = 650, height = 650)

  })
