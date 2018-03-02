library(ggplot2)
library(reshape2)
library(plyr)
library(dplyr)

#############################
# READ IN SRA
#############################
sra <- readRDS('./data/r-objects/song-ranked-analytics/song-ranked-analytics.rds')
track <- readRDS('./data/r-objects/track/track.rds') %>% 
  rename(c("id"="spotify_id"))

full <- merge(sra, track, by = 'spotify_id')

#############################
# START EXPLORATION
#############################
# See on average how many new songs / artists are entering the music scene
sra %>% 
  group_by(date) %>% 
  summarise(
    avg_song_ranked = mean(song_previously_ranked),
    avg_artist_ranked = mean(artist_previously_ranked)
  ) %>% 
  ggplot(
    aes(
      x = date,
      y = avg_song_ranked
    )
  ) +
  geom_line() +
  geom_line(
    aes(
      x = date,
      y = avg_artist_ranked
    )
  )
  
# Get averages of specified fields, melt them, and display 
# lines plot over each date instance
sra %>% 
  group_by(date) %>% 
  dplyr::mutate(
    avg_acousticness = mean(acousticness),
    avg_danceability = mean(danceability),
    avg_energy = mean(energy),
    avg_instrumentalness = mean(instrumentalness),
    avg_liveness = mean(liveness),
    avg_speechiness = mean(speechiness),
    avg_valence = mean(valence)
  ) %>% 
  ungroup() %>% 
  select(
    date, 
    avg_acousticness, 
    avg_danceability, 
    avg_energy, 
    avg_instrumentalness, 
    avg_liveness, 
    avg_speechiness, 
    avg_valence
  ) %>% 
  melt(id='date') %>% 
  ggplot() +
  geom_line(
    aes(
      x = date,
      y = value,
      colour = variable
    )
  )

create_box_vs_year = function(df, variable) {
  ggplot(
    df, 
    aes(
      x = year,
      y = df[[variable]]
    )
  ) +
  geom_boxplot() +
  xlab(variable) +
  coord_flip()
}

cols <- c(
  'acousticness',
  'danceability',
  'energy',
  'instrumentalness',
  'liveness',
  'speechiness',
  'valence'
)


#############################
# PLOT SRA SPOTIFY KEYS AVG PER YEAR
# 

# Acousticness (1 == is acoustic)         - Generally super low. Don't know what to make of it yet
# Danceability                            - Pretty flatlined
# Energy (metal = high, bach = low)       - Generally high energy, but trailing off in the later years
# Instrumentalness (All instrument)       - Makes sens for there to be vocals in just about every song,
#                                           but the outliers are interesting. Would be good to figure out
#                                           what those instances are
# Liveness (presence of audience)         - Not much to notice here
# Speechiness (Presence of spoken word)   - More noticeable between 2002 and 2006, and started 
#                                           to spike again in 2016. A lot of outliers. Avg hangs 
#                                           around 0.5 range overall
# Valence (Positivity)                    - Going down. In 2000, the average was almost 0.6, 
#                                           and by 2016 it avgs at around .42
#
#############################
for (var in seq_along(cols)) {
  print(create_box_vs_year(sra, cols[[var]]))
  hist(sra[[cols[[var]]]], xlab = cols[[var]])
}


