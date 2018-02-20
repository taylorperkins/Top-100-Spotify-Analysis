#############################
# 
# BARS FIELD FROM AUDIO-ANALYSIS API
# ______________
# id - spotify_id
# confidence
# start
# duration
# 
#############################
# 
# ADDED FIELDS
# bar_count - num of bars per song
# 
#############################
# READ IN BARS
#############################
bars <- read.csv('./data/full-analysis/bars/bars.csv')

#############################
# START CLEANING PROCESS
#############################
# TURNING ID FACTOR TO CHARACTER
i <- sapply(bars, is.factor)
bars[i] <- lapply(bars[i], as.character)

# ADD A COUNT FIELD PER ID 
bars <- bars %>% 
  group_by(id) %>% 
  mutate(
    bar_count = n()
  ) %>% 
  ungroup()

#############################
# SAVE OFF R-OBJECT
#############################
saveRDS(bars, 'data/r-objects/bars/bars.rds')
