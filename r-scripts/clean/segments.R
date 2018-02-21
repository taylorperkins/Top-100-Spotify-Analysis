#############################
# 
# SEGMENTS FIELD FROM AUDIO-ANALYSIS API
# ______________
# id - unique segment id
# song_id - spotify_id
# duration - length of segment in ms
# loudness_max
# loudness_max_time
# loudness_start
# loudness_end
# 
#############################
# 
# ADDED FIELDS
# avg_song_segment_duration - avg segment duration per song
# 
#############################
# READ IN SEGMENTS
#############################
segments <- read.csv('./data/full-analysis/segments/segments.csv')

#############################
# START CLEANING PROCESS
#############################

# ADD A COUNT FIELD PER ID 
segments <- segments %>% 
  group_by(song_id) %>% 
  mutate(
    avg_song_segment_duration = mean(duration)
  ) %>% 
  ungroup()

#############################
# SAVE OFF R-OBJECT
#############################
saveRDS(segments, 'data/r-objects/segments/segments.rds')
