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
# date                      - date song was ranked
# song_id                   - unique song id for billboards api (not used by me)
# song_name                 - name of song
# artist_id                 - unique artist id for billboards api (not used by me)
# spotify_id                - unique song id for spotify api
# rank                      - rank given
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
# ADDED FIELDS
# ______________
# song_previously_ranked    - since I have a date field, I wanted to create a new field to determine if a song has previously made the top 100.
#                             This is a count per row of the time before that the specific song has made the top 100
# artist_previously_ranked  - Very similar to song_previously_ranked, only grouping by artist
# year                      - year song was ranked
# month                     - month year was ranked
# key_name                  - chr representation of the key
# danceability_cat          - low, medium, high danceability category
# acousticness_cat          - low, medium, high acousticeness category
# energy_cat                - low, medium, high energy category
# instrumentalness_cat      - low, medium, high instrumentalness category
# liveness_cat              - low, medium, high liveness category
# speechiness_cat           - low, medium, high speechiness category
# valence_cat               - low, medium, high valence category
# is_top_ten                - 0 or 1 is ranked within top ten
# is_number_one             - 0 or 1 is ranked at 1
# 
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

# ADD CHR KEY VALUES PER KEY
key_num <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
key_names <- c('C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B')

key_map <- setNames(as.list(key_names), key_num)

# DEFINE METHOD TO DETERMINE A CATEGORY GIVEN A RANGE BETWEEN 0 AND 1 --> LOW, MEDIUM, AND HIGH
low_med_high <- function(val) {
  if (val < .3333) {
    cat <- 'low'
  } else if (val < .6667) {
    cat <- 'medium'
  } else {
    cat <- 'high'
  }
  
  cat
}

# METHODS TO DETERMINE RANK YES / NO
is_top_ten <- function(val) {
  if (val <= 10) {
    return(1)
  }
  return(0)
}

is_number_one <- function(val) {
  if (val == 1) {
    return(1)
  }
  return(0)
}

# ADD IN YEAR AND MONTH, KEY_NAME
sra <- sra %>% 
  mutate(
    year = strftime(date, '%Y'),
    month = strftime(date, '%b'),
    key_name = key_names[match(key, key_num)]
  )

sra$danceability_cat <- mapply(low_med_high, sra$danceability)
sra$acousticness_cat <- mapply(low_med_high, sra$acousticness)
sra$energy_cat <- mapply(low_med_high, sra$energy)
sra$instrumentalness_cat <- mapply(low_med_high, sra$instrumentalness)
sra$liveness_cat <- mapply(low_med_high, sra$liveness)
sra$speechiness_cat <- mapply(low_med_high, sra$speechiness)
sra$valence_cat <- mapply(low_med_high, sra$valence)

sra$is_top_ten <- mapply(is_top_ten, sra$rank)
sra$is_number_one <- mapply(is_number_one, sra$rank)

#############################
# SAVE OFF R-OBJECT
#############################
saveRDS(sra, './data/r-objects/song-ranked-analytics/song-ranked-analytics.rds')
