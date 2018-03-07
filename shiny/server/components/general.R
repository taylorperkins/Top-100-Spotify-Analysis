library(shiny)
library(shinydashboard)

library(ggplot2)
library(dplyr)
library(reshape2)
library(xts)
library(highcharter)
library(Hmisc)
library(DT)


general_server <- function(input, output, session) {
  
  output$general_histPlot <- general_histPlot(input)
  output$general_boxPlot <- general_boxPlot(input)
  output$general_lineGraph <- general_lineGraph(input)
  output$general_dataTab <- general_dataTab(input)
  
  output$general_popularArtist <- general_infoBox_popularArtist(input)
  output$general_highestRankedArtist <- general_infoBox_highestRankedArtist(input)
  output$general_popularSong <- general_infoBox_popularSong(input)
  output$general_highestRankedSong <- general_infoBox_highestRankedSong(input)  
  
}


filter_df <- function(input, cols) {
  startDate <- input$sidebar_dateRange[[1]]
  endDate <- input$sidebar_dateRange[[2]]

  sra[ 
    sra$date >= startDate & sra$date <= endDate, 
  ][ , cols ]
}


general_createInfoBoxPopularText <- function(row) {
  paste0(
    "<span class='info-box-number'>",
      "Song Count: <span class='pull-right'>", row$count, "</span></br>",
      "Highest Rank: <span class='pull-right'>", format(round(row$highest_rank, 2), nsmall = 2), "</span>",
    "</span>"
  )
}


general_createInfoBoxHighestText <- function(row) {
  paste0(
    "<span class='info-box-number'>",
      "Song Count: <span class='pull-right'>", row$count, "</span></br>",
      "Avg Ranking: <span class='pull-right'>", format(round(row$avg_rank, 2), nsmall = 2), "</span>",
      "Score: <span class='pull-right'>", format(round(row$score, 2), nsmall = 2), "</span>",
    "</span>"
  )
}


reversed_scoring <- function(rank_col, highest_rank, df_len) {
  new_ranks = sapply(rank_col, function(val) { highest_rank - val })
  sum(new_ranks) / df_len
}


general_infoBox_popularArtist <- function(input) {
  
  renderInfoBox({
    df <- filter_df( input, c('display_artist', 'rank') )

    pop_artist <- df %>% 
      select(display_artist, rank) %>% 
      dplyr::rename(name = display_artist) %>% 
      group_by(name) %>% 
      mutate(
        count = n(),
        highest_rank = min(rank)
      ) %>% 
      arrange(desc(count)) %>% 
      head(n = 1)
    
    infoBox(
      HTML(
        paste0(
          "<span class='info-box-text'>Most Frequent Artist</br>",
          "<strong><em>", pop_artist$name, "</em></strong></span>"
        )
      ),
      HTML(
        general_createInfoBoxPopularText(pop_artist)
      ),
      icon = icon("user"),
      color = "black",
      width = 12
    )
  })
  
}

general_infoBox_highestRankedArtist <- function(input) {
  renderInfoBox({

    df <- filter_df( input, c('display_artist', 'rank') )

    highest_artist <- df %>% 
      select(display_artist, rank) %>% 
      dplyr::rename(name = display_artist) %>% 
      group_by(name) %>% 
      mutate(
        count = n(),
        score = reversed_scoring(rank, max(df$rank), nrow(df)),
        avg_rank = mean(rank)
      ) %>% 
      arrange(desc(score)) %>% 
      head(n = 1)
    
    infoBox(
      HTML(
        paste0(
          "<span class='info-box-text'>Highest Scored Artist</br>",
          "<strong><em>", highest_artist$name, "</em></strong></span>"
        )
      ),
      HTML(
        general_createInfoBoxHighestText(highest_artist)
      ),
      icon = icon("user"),
      color = "black",
      width = 12
    )

  })
}


general_infoBox_popularSong <- function(input) {
  renderInfoBox({

    df <- filter_df( input, c('song_name', 'display_artist', 'spotify_id', 'rank') )

    popularSong <- df %>% 
      select(song_name, display_artist, spotify_id, rank) %>% 
      dplyr::rename(name = song_name) %>% 
      group_by(spotify_id) %>% 
      mutate(
        count = n(),
        highest_rank = min(rank)
      ) %>% 
      arrange(desc(count)) %>% 
      head(n = 1)
    
    infoBox(
      HTML(
        paste0(
          "<span class='info-box-text'>Most Frequent Song</br>",
          "<strong><em>", popularSong$name, "</em></strong></span>"
        )
      ),
      HTML(
        general_createInfoBoxPopularText(popularSong)
      ),
      icon = icon("headphones"),
      color = "black",
      width = 12
    )

  })
}


general_infoBox_highestRankedSong <- function(input) {
  renderInfoBox({

    df <- filter_df( input, c('song_name', 'display_artist', 'spotify_id', 'rank') )
    names(df)[names(df) == 'song_name'] <- 'name'

    highest_song <- df %>%
      group_by(spotify_id) %>% 
      mutate(
        count = n(),
        score = reversed_scoring(rank, max(df$rank), nrow(df)),
        avg_rank = mean(rank)
      ) %>% 
      arrange(desc(score)) %>% 
      head(n = 1)
    
    infoBox(
      HTML(
        paste0(
          "<span class='info-box-text'>Highest Scored Song </br>",
          "<strong><em>", highest_song$name, "</em></strong></span>"
        )
      ),
      HTML(
        general_createInfoBoxHighestText(highest_song)
      ),
      icon = icon("headphones"),
      color = "black",
      width = 12
    )

  })
}

general_histPlot <- function(input) {
  renderHighchart({

    df <- filter_df( input, c(input$sidebar_inputField) )

    hchart(
      df[[ input$sidebar_inputField ]],
      type = "area",
      color = echonest_color_palette[[ input$sidebar_inputField ]],
      name = capitalize( input$sidebar_inputField )
    ) %>%
    hc_title(text = paste0("Histogram For ", capitalize(input$sidebar_inputField), " Within Date Range")) %>% 
    hc_add_theme(hc_theme_538()) %>%
    hc_tooltip(crosshairs = TRUE)

  })
}


general_boxPlot <- function(input) {
  renderHighchart({

    df <- filter_df( input, c('year', 'display_artist', 'song_name', input$sidebar_inputField) )    

    # Create a boxplot to show the stats over the variable specified per year
    hcboxplot(
      x = df[[ input$sidebar_inputField ]], 
      var = df$year,
      color = echonest_color_palette[[ input$sidebar_inputField ]]
    ) %>% 
    hc_add_theme(hc_theme_538()) %>%
    hc_title(
      text = paste0( "Boxplot For ", capitalize(input$sidebar_inputField), " Per Year (", min(df$year), "-", max(df$year), ")") 
    )

  })
}


general_lineGraph <- function(input) {
  renderHighchart({

    df <- filter_df( 
      input, 
      c('date', 'acousticness', 'danceability', 'energy', 'instrumentalness', 'liveness', 'speechiness', 'valence')
    )

    avgs <- df %>% 
      dplyr::group_by(date) %>% 
      dplyr::summarise(
        avg_acousticness = mean(acousticness),
        avg_danceability = mean(danceability),
        avg_energy = mean(energy),
        avg_instrumentalness = mean(instrumentalness),
        avg_liveness = mean(liveness),
        avg_speechiness = mean(speechiness),
        avg_valence = mean(valence)
      )

    rownames(avgs) <- avgs$date
    avgs$date <- NULL

    avgs_xts <- as.xts(avgs)

    highchart(type = "stock") %>% 
      hc_title(text = "Avg Echo Values Over Time") %>% 
      hc_subtitle(text = "Data generated through gathering average field per week.") %>%
      hc_add_theme(hc_theme_538()) %>%
      hc_add_series(avgs_xts$avg_acousticness, name = "Acousticness", color = echonest_color_palette$acousticness) %>% 
      hc_add_series(avgs_xts$avg_danceability, name = "Danceability", color = echonest_color_palette$danceability) %>%
      hc_add_series(avgs_xts$avg_energy, name = "Energy", color = echonest_color_palette$energy) %>% 
      hc_add_series(avgs_xts$avg_instrumentalness, name = "Instrumentalness", color = echonest_color_palette$instrumentalness) %>% 
      hc_add_series(avgs_xts$avg_liveness, name = "Liveness", color = echonest_color_palette$liveness) %>% 
      hc_add_series(avgs_xts$avg_speechiness, name = "Speechiness", color = echonest_color_palette$speechiness) %>% 
      hc_add_series(avgs_xts$avg_valence, name = "Valence", color = echonest_color_palette$valence)

  })
}


general_dataTab <- function(input) {
  DT::renderDataTable({

    sra[, c('date', 'display_artist', 'song_name', 'rank', 'acousticness', 'danceability', 'energy', 'instrumentalness', 'liveness', 'speechiness', 'valence')]

  }, options = list(
    scrollX = TRUE
  ))
}
