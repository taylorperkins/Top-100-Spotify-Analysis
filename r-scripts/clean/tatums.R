#############################
# 
# SEGMENTS FIELD FROM AUDIO-ANALYSIS API
# ______________
# id                        - unique segment id
# confidence                - confidence level for tatum 0-1
# start                     - start of tatum in ms
# duration                  - length of segment in ms
# 
#############################
# 
# ADDED FIELDS
# ______________
# avg_song_segment_duration - avg segment duration per song
# 
#############################
# READ IN SEGMENTS
#############################
tatums <- read.csv('./data/full-analysis/tatums/tatums.csv')

#############################
# START CLEANING PROCESS
#############################

#############################
# SAVE OFF R-OBJECT
#############################
saveRDS(tatums, 'data/r-objects/tatums/tatums.rds')
