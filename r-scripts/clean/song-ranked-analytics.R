library("dplyr")

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
# spotify_api      unique song id for spotify api
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
sra <- read.csv('./data/ranks/song-ranked-analytics.csv')

