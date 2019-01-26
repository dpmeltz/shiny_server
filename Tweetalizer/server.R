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
library(tidytext)
library(ggwordcloud)

#set twitter
api_key <- "bbmeTHKmB0yOp2tNxdi3N4yBe" # your api_key
api_secret <- "FZziVSsIqfwoWXyZg2lTror9rozOZCJYOCHlWsV8qYmInfRcdG" # your api_secret
access_token <- "500829754-O6wIL5kiyuhThm54Wy2qUTYJxGFX9yjI9ZALJKIH" # your access_token
access_token_secret <- "FwT0B8oVmuwwJz6aLUBM7ybJ1Vyvdnyk9UEreDFwsowPt" # your access_token_secret
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  tweets <- reactive(userTimeline(input$search_phrase, n = input$n_count, maxID = NULL, sinceID = NULL, includeRts = TRUE))

  output$wordcloud <- renderPlot({
    #Import tweets and create data frame
    #tweets <- userTimeline(input$search_phrase, n = input$n_count, maxID = NULL, sinceID = NULL, includeRts = TRUE)
    tweets_df <- twListToDF(tweets())

      #Symbols to remove
      remove_reg <- "&amp;|&lt;|&gt;"
      #Clean tweets
      tidy_tweets <- tweets_df %>%
      filter(!str_detect(text, "^RT")) %>%
      mutate(text = str_remove_all(text, remove_reg)) %>%
      unnest_tokens(word, text, token = "tweets") %>%
      filter(!word %in% stop_words$word,
             !word %in% str_remove_all(stop_words$word, "'"),
             str_detect(word, "[a-z]"))

      #Take top 50 words
      tweet_sort <- tidy_tweets %>%
      count(word, sort = TRUE) %>%
       head(50)


     #Plot
     wordcloud <- ggplot(tweet_sort, aes(
       label = word, size = n)) +
       geom_text_wordcloud_area(shape = 'circle', eccentricity = 1.5) +
       scale_size_area(max_size = 20) +
       theme_minimal()

     wordcloud
  })

  output$sparkline <- renderPlot({
    #tweets <- userTimeline(input$search_phrase, n = input$n_count, maxID = NULL, sinceID = NULL, includeRts = TRUE)
    tweets_df <- twListToDF(tweets())

    tweets_df$date <- format(as.POSIXct(
      tweets_df$created, format = '%Y-%m-/%d %H:%M:%S'), format = '%Y/%m/%d')

    date_count <- tweets_df %>%
      count(date, sort = FALSE)

    date_count$date <- as.Date(date_count$date)

    ggplot(date_count, aes(x = date, y = n, group = 1)) +
      geom_point() +
      geom_line() +
      scale_x_date(date_breaks = "1 day", date_labels = "%m/%d") +
      ylim(0,max(date_count$n)) +
      theme(axis.text.x = element_text(angle=60, hjust=1),
            panel.grid = element_blank(),
            panel.background = element_blank())

  })

})
