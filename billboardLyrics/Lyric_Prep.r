# Add Libs
library(dplyr)
library(genius)
library(tidytext)

# import data
billboardList <- read.csv("/cloud/project/billboardLyrics/chart2000-songyear-0-3-0057.csv")
billboardList <- billboardList %>%
  select(year, position, artist, song)

lyricCorpus <- billboardList %>%
  select(year, position, artist, song) %>%
  mutate(track = song) %>%
  add_genius(artist, track, type = "lyrics")

lyricCorpus <- lyricCorpus %>%
  unnest_tokens(word, lyric)

write.csv(lyricCorpus,'/cloud/project/billboardLyrics/lyric_corpus.csv')
