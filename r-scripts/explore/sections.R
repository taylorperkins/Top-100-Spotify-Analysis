library(ggplot2)
library(reshape2)
library(plyr)
library(dplyr)

#############################
# READ IN SRA
#############################
sections <- readRDS('./data/r-objects/sections/sections.rds')

print(paste('Sections dataset. \nLength: ', length(sections)))
# Dominantly 4/4
hist(sections$time_signature)

unique_time_sig <- unique(sections$time_signature)
for (ind in seq_along(unique_time_sig)) {
  time_sig_count <- nrow(subset(sections, time_signature == unique_time_sig[[ind]]))
  print(paste(time_sig_count / nrow(sections), unique_time_sig[[ind]]))
}

# Major is basically double minor
hist(sections$mode)

uniq_mode <- unique(sections$mode)
for (ind in seq_along(uniq_mode)) {
  mode_count <- nrow(subset(sections, mode == uniq_mode[[ind]]))
  print(paste(mode_count / nrow(sections), uniq_mode[[ind]]))
}
