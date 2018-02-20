#############################
# 
# BEATS FIELD FROM AUDIO-ANALYSIS API
# ______________
# id - spotify_id
# confidence
# start
# duration
# 
#############################
# 
# ADDED FIELDS
# beat_count - num of bars per song
# 
#############################
# READ IN BEATS
#############################
beats <- read.csv('./data/full-analysis/beats/beats.csv')

#############################
# START CLEANING PROCESS
#############################
# TURNING ID FACTOR TO CHARACTER
i <- sapply(beats, is.factor)
beats[i] <- lapply(beats[i], as.character)

# ADD A COUNT FIELD PER ID 
beats <- beats %>% 
  group_by(id) %>% 
  mutate(
    beat_count = n()
  ) %>% 
  ungroup()

#############################
# SAVE OFF R-OBJECT
#############################
saveRDS(beats, 'data/r-objects/beats/beats.rds')
