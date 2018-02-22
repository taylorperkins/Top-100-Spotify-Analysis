#############################
# 
# PITCHES FIELD PER SEGMENT PER SONG FROM AUDIO-ANALYSIS API
# ______________
# song_id                   - spotify_id
# segment_id                - linking to song segment
# X[0-11]                   - pitch values. 12 pitches per segment. 0-11 represents index value
# 
#############################
# 
# ADDED FIELDS
# ______________
# X[0-11]_song_avg          - avg col x per song
# X_segment_avg             - avg x per segment
# 
#############################
# READ IN SEGMENTS-PITCHES
#############################
# 1 to 1 relationship with segments. segment_id is a bit unnecessary, but it's whatever.
segments_pitches <- read.csv('./data/full-analysis/segments/segment-pitches.csv')

#############################
# START CLEANING PROCESS
#############################

# ADD A COUNT FIELD PER ID 
segments_pitches <- segments_pitches %>% 
  group_by(song_id) %>% 
  mutate(
    X0_song_avg = mean(X0),
    X1_song_avg = mean(X1),
    X2_song_avg = mean(X2),
    X3_song_avg = mean(X3),
    X4_song_avg = mean(X4),
    X5_song_avg = mean(X5),
    X6_song_avg = mean(X6),
    X7_song_avg = mean(X7),
    X8_song_avg = mean(X8),
    X9_song_avg = mean(X9),
    X10_song_avg = mean(X10),
    X11_song_avg = mean(X11),
    X_song_avg = mean(c(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11))
  ) %>% 
  ungroup() %>% 
  rowwise() %>% 
  mutate(
    X_segment_avg = mean(c(X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11))
  )

#############################
# SAVE OFF R-OBJECT
#############################
saveRDS(segments_pitches, 'data/r-objects/segments-pitches/segments-pitches.rds')
