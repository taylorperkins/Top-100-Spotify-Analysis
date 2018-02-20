#############################
# 
# SECTIONS FIELD FROM AUDIO-ANALYSIS API
# ______________
# id - spotify_id
# confidence
# start
# duration
# 
#############################
# 
# ADDED FIELDS
# section_count -> count per id
# key_name -> chr labeling for key 
# 
#############################
# READ IN SECTIONS
#############################
sections <- read.csv('./data/full-analysis/sections/sections.csv')

#############################
# START CLEANING PROCESS
#############################
# TURNING ID FACTOR TO CHARACTER
i <- sapply(sections, is.factor)
sections[i] <- lapply(sections[i], as.character)

# HASH FOR INT TO CHR FOR KEY FIELD
key_num <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
key_names <- c('C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B')

key_map <- setNames(as.list(key_names), key_num)

# ADD SECTION_COUNT, AND KEY_NAME FIELDS
sections <- sections %>% 
  mutate(
    key_name = key_names[match(key, key_num)]
  ) %>% 
  group_by(id) %>% 
  mutate(
    section_count = n()
  ) %>% 
  ungroup()

#############################
# SAVE OFF R-OBJECT
#############################
saveRDS(sections, './data/r-objects/sections/sections.rds')
