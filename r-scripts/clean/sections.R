#############################
# 
# SECTIONS FIELD FROM AUDIO-ANALYSIS API
# ______________
# id                        - spotify_id
# confidence                - confidence level for section 0-1
# start                     - start or section in ms
# duration                  - length of section in ms
# 
#############################
# 
# ADDED FIELDS
# ______________
# section_count             - count per id
# key_name                  - chr labeling for key 
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


#############################
# Loudness Categories
# 
# I've determined that I cannot quite compare loudness levels amongst different songs.
# The section count between songs varies too much, so to try and determine
# any sort of aggregation of trend in the loudness in that way would be difficult.
# Could probably be done.. But not enough gain for the work.
# Instead, I decided to tokenize the loudness trends. Question I ask is: 
# 
#   Are loud sections more likely to follow soft sections? Vice versa. Are there trends in 
#   patterns of loudness levels, vs loudness itself?
# 
# The following methods assign pre / post loudness category values to determine if the 
# section pre or post is considered loud by the songs standard.
# Also, categorize the current row.
#############################
assign_pre_song_loudness <- function(group_loudness, loudness_range) {
  pre_loudness <- character(length = 0)
  
  for(ind in seq_along(group_loudness)) {
    if (ind == 1) {
      pre_loudness[ind] <- 'start'
    } else {
      pre_level <- abs(group_loudness[[ind - 1]])
      
      if (pre_level < (loudness_range * .33)) {
        pre_loudness[ind] <- 'low'
      } else if (pre_level < (loudness_range * .67)) {
        pre_loudness[ind] <- 'mid'
      } else {
        pre_loudness[ind] <- 'high'
      }
    } 
  }
  
  return(pre_loudness)
}

assign_post_loudness <- function(group_loudness, loudness_range) {
  post_loudness <- character(length = 0)
  
  for(ind in seq_along(group_loudness)) {
    if (ind == length(group_loudness)) {
      post_loudness[ind] <- 'end'
    } else {
      post_level <- abs(group_loudness[[ind + 1]])
      
      if (post_level < (loudness_range * .33)) {
        post_loudness[ind] <- 'low'
      } else if (post_level < (loudness_range * .67)) {
        post_loudness[ind] <- 'mid'
      } else {
        post_loudness[ind] <- 'high'
      }
    } 
  }
  
  return(post_loudness)
}

assign_song_loudness_category <- function(group_loudness, loudness_range) {
  loudness_categories <- character()
  
  for(ind in seq_along(group_loudness)) {
    level_loudness <- abs(group_loudness[[ind]])
    
    if (level_loudness < (loudness_range * .33)) {
      loudness_categories[ind] <- 'low'
    } else if (level_loudness < (loudness_range * .67)) {
      loudness_categories[ind] <- 'mid'
    } else {
      loudness_categories[ind] <- 'high'
    }
  }
  
  return(loudness_categories)
}

pop_loudness_range <- abs(max(sections$loudness) + min(sections$loudness))

# ADD SECTION_COUNT, AND KEY_NAME FIELDS
sections <- sections %>% 
  mutate(
    key_name = key_names[match(key, key_num)]
  ) %>% 
  group_by(id) %>% 
  arrange(desc(start), .by_group = TRUE) %>% 
  mutate(
    section_count = n(),
    norm_index = row_number() / (n() + 1),
    
    ind_loudness_cat = assign_song_loudness_category(
      loudness, loudness_range = (abs(max(loudness) + min(loudness)))),
    
    ind_pre_loudness_cat = assign_pre_song_loudness(
      loudness, loudness_range = (abs(max(loudness) + min(loudness)))),

    ind_post_loudness_cat = assign_post_loudness(
      loudness, loudness_range = (abs(max(loudness) + min(loudness)))),
    
    pop_loudness_cat = assign_song_loudness_category(loudness, loudness_range = pop_loudness_range),
    pop_pre_loudness_cat = assign_pre_song_loudness(loudness, loudness_range = pop_loudness_range),
    pop_post_loudness_cat = assign_post_loudness(loudness, loudness_range = pop_loudness_range)

  ) %>% 
  ungroup()

#############################
# SAVE OFF R-OBJECT
#############################
saveRDS(sections, './data/r-objects/sections/sections.rds')
