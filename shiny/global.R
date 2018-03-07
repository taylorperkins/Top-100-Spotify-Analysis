library(RColorBrewer)

sra <- readRDS('../data/r-objects/song-ranked-analytics/song-ranked-analytics.rds')
sra$date <- as.Date(sra$date)

# tracks <- readRDS('../data/r-objects/track/track.rds')

years <- readRDS('../data/r-objects/shiny/utility/years.rds')

color_brewer_set <- 'Set1'
echonest_color_palette <- list(
  'acousticness' = brewer.pal(7, color_brewer_set)[[ 7 ]],
  'danceability' = brewer.pal(7, color_brewer_set)[[ 6 ]],
  'energy' = brewer.pal(7, color_brewer_set)[[ 2 ]],
  'instrumentalness' = brewer.pal(7, color_brewer_set)[[ 5 ]],
  'liveness' = brewer.pal(7, color_brewer_set)[[ 1 ]],
  'speechiness' = brewer.pal(7, color_brewer_set)[[ 3 ]],
  'valence' = brewer.pal(7, color_brewer_set)[[ 4 ]]
)

# 
# 
# library(highcharter)
# library(tidyr)
# library(dplyr)

# hchart.cor <- function(object, ...) {
#   
#   df <- as.data.frame(object)
#   is.num <- sapply(df, is.numeric)
#   df[is.num] <- lapply(df[is.num], round, 2)
#   dist <- NULL
#   
#   x <- y <- names(df)
#   
#   df <- tbl_df(cbind(x = y, df)) %>% 
#     gather(y, dist, -x) %>% 
#     mutate(x = as.character(x),
#            y = as.character(y)) %>% 
#     left_join(data_frame(x = y,
#                          xid = seq(length(y)) - 1), by = "x") %>% 
#     left_join(data_frame(y = y,
#                          yid = seq(length(y)) - 1), by = "y")
#   
#   ds <- df %>% 
#     select_("xid", "yid", "dist") %>% 
#     list.parse2()
#   
#   fntltp <- JS("function(){
#                return this.series.xAxis.categories[this.point.x] + ' ~ ' +
#                this.series.yAxis.categories[this.point.y] + ': <b>' +
#                Highcharts.numberFormat(this.point.value, 2)+'</b>';
#                ; }")
#   cor_colr <- list( list(0, '#FF5733'),
#                     list(0.5, '#F8F5F5'),
#                     list(1, '#2E86C1')
#   )
#   
#   browser()
#   
#   highchart() %>% 
#     hc_chart(type = "heatmap") %>% 
#     hc_xAxis(categories = y, title = NULL) %>% 
#     hc_yAxis(categories = y, title = NULL) %>% 
#     hc_add_series(data = ds) %>% 
#     hc_plotOptions(
#       series = list(
#         boderWidth = 0,
#         dataLabels = list(enabled = TRUE)
#       )) %>% 
#     hc_tooltip(formatter = fntltp) %>% 
#     hc_legend(align = "right", layout = "vertical",
#               margin = 0, verticalAlign = "top",
#               y = 25, symbolHeight = 280) %>% 
#     hc_colorAxis(  stops= cor_colr,min=-1,max=1)
#   }
# 
# mtcars2 <- mtcars[1:20, ]
# x <- cor(mtcars2)
# hchart.cor(x)


# reversed_scoring <- function(rank_col, highest_rank, df_len) {
#   new_ranks = sapply(rank_col, function(val) { highest_rank - val })
#   sum(new_ranks) / df_len
# }
# 
# reversed_scoring(c(1, 2, 1), 5, 5)
