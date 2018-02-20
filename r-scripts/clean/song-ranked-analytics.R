library(dplyr)
library(foreach)
library(iterators)

#############################
# 
# This dataset is a pre-merged dataset of both billboards api, and spotify. 
# http://billboard.modulo.site/rank/song/<[1-100]>?from=2000-1-1&to=2017-12-31
# https://api.spotify.com/v1/audio-features/?ids=123,234,345,456,567
# 
# The billboards data was received first. This dataset included a spotify_id for every artist that was ranked. 
# Using that spotify_id, separate requests were made to receive the base audio analysis for thos songs.
# 
# BILLBOARDS API
# ______________
# date             date song was ranked
# song_id          unique song id for billboards api (not used by me)
# song_name        name of song
# artist_id        unique artist id for billboards api (not used by me)
# spotify_id      unique song id for spotify api
# rank             rank given
# 
# SPOTIFY API
# **field definitions can be found at https://developer.spotify.com/web-api/get-several-audio-features/ **
# ______________
# acousticness
# analysis_url
# danceability
# duration_ms
# energy
# instrumentalness
# key
# liveness
# loudness
# mode
# speechiness
# tempo
# time_signature
# track_href
# type
# uri
# valence
# 
#############################

#############################
# READ IN SONG RANKED ANALYTICS
#############################
# cols_to_exclude <- c('analysis_url', 'track_href', 'type', 'uri', 'X')
# sra <- read.csv('./data/ranks/song-ranked-analytics.csv')
# 
# sra <- sra[, !(names(sra) %in% cols_to_exclude)]


#############################
# START CLEANING PROCESS
#############################

# DONT RUN THESE VVV, READ IN THE FILE INSTEAD

# Find all of the rows where there is no spotify id. There are 416 unique artists where no spotify id is available. 
# Since there is no id tied to the record, I am not able to dive into the analysis as much as I would like. 
# I am going to save these off to dig into further at another time. 
# missing_spotify_id <- sra[(is.na(sra$spotify_id) | sra$spotify_id == ''),]
# missing_spotify_id %>% 
#   distinct(display_artist) %>% 
#   arrange(desc(display_artist))
# 
# missing_spotify_id %>% 
#   select(date, song_id, song_name, artist_id, spotify_id, rank) %>% 
#   write.csv('./data/ranks/song-ranked-analytics-missing-spotify-id.csv')
# 
# # CONVERTING FACTORS TO CHARACTERS
# i <- sapply(sra, is.factor)
# sra[i] <- lapply(sra[i], as.character)
# 
# sra <- sra[!(is.na(sra$spotify_id) | sra$spotify_id == ''), ] %>% 
#   arrange(date, rank)
# 
# sra$date <- as.POSIXlt(sra$date)
# 
# update_song_previously_ranked <- list()
# update_artist_previously_ranked <- list()
# 
# for (name in unique(sra$spotify_id)) update_song_previously_ranked[[ name ]] <- 0
# for (name in unique(sra$display_artist)) update_artist_previously_ranked[[ name ]] <- 0
# 
# sra$song_previously_ranked <- 0
# sra$artist_previously_ranked <- 0
# 
# for (ind in seq(from = 1, to = nrow(sra))) {
#   
#   print(ind)
#   
#   current_row <- sra[ind, c("spotify_id", "display_artist")]
#   
#   sra[ind, 'song_previously_ranked'] <- update_song_previously_ranked[[ current_row[[ "spotify_id" ]] ]]
#   sra[ind, 'artist_previously_ranked'] <- update_artist_previously_ranked[[ current_row[[ "display_artist" ]] ]]
#   
#   update_song_previously_ranked[[ current_row[[ "spotify_id" ]] ]] <- update_song_previously_ranked[[ current_row[[ "spotify_id" ]] ]] + 1
#   update_artist_previously_ranked[[ current_row[[ "display_artist" ]] ]] <- update_artist_previously_ranked[[ current_row[[ "display_artist" ]] ]] + 1
#   
# }

# saveRDS(sra, './data/r-objects/song-ranked-analytics/sra-cleanup-1.rds')
sra <- readRDS('./data/r-objects/song-ranked-analytics/sra-cleanup-1.rds')

# ADD IN YEAR AND MONTH
sra <- sra %>% 
  mutate(
    year = strftime(date, '%Y'),
    month = strftime(date, '%b')
  )

# ADD KEY NAMES PER KEY
key_num <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
key_names <- c('C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B')

key_map <- setNames(as.list(key_names), key_num)

sra <- sra %>% 
  mutate(
    key_name = key_names[match(key, key_num)]
  )

saveRDS(sra, './data/r-objects/song-ranked-analytics/song-ranked-analytics.rds')
