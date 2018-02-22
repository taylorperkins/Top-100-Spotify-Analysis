#############################
# 
# TRACK FIELD FROM AUDIO-ANALYSIS API
# ______________
# id                        - unique segment id
# num_samples
# analysis_channels
# start_of_fade_out
# end_of_fade_in
# sample_md5
# analysis_sample_rate
# tempo
# tempo_confidence
# key
# key_confidence
# mode
# duration                  - length of segment in ms
# time_signature
# time_siganture_confidence
# window_seconds
# 
#############################
# 
# ADDED FIELDS
# key_name                  - chr representation of the field key
# duration_no_fade          - duration of the song without the fade-in or fade-out
# normalized_num_samples    - The num_samples field ranges between 817,000 and 15,180,000. This field is to
#                             normalize that range, and give each index a 0-1 representation.
# 
#############################
# READ IN TRACK
#############################
track <- read.csv('./data/full-analysis/track/track.csv')

#############################
# START CLEANING PROCESS
#############################

# It is NA in every case
track$sample_md5 <- NULL
# Both of these values are 0 100% of the time
track$offset_seconds <- NULL
track$window_seconds <- NULL
# Always 22050
track$analysis_sample_rate <- NULL

key_num <- c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
key_names <- c('C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B')

key_map <- setNames(as.list(key_names), key_num)

track <- track %>% 
  mutate(
    key_name = key_names[match(key, key_num)],
    duration_no_fade = duration - ((duration - start_of_fade_out) + end_of_fade_in),
    normalized_num_samples = (num_samples - min(num_samples)) / (max(num_samples) - min(num_samples))
  )

#############################
# SAVE OFF R-OBJECT
#############################
saveRDS(track, 'data/r-objects/track/track.rds')
