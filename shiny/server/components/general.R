library(shiny)
library(shinydashboard)

library(ggplot2)
library(dplyr)
library(reshape2)


general_server <- function(reactive_input, output, session) {
  
  output$general_histPlot <- histPlot(reactive_input)
  output$general_boxPlot <- boxPlot(reactive_input)
  output$general_lineGraph <- lineGraph(reactive_input)
  
  output$general_popularArtist <- infoBox_popularArtist(reactive_input)
  output$general_highestRankedArtist <- infoBox_highestRankedArtist(reactive_input)
  output$general_popularSong <- infoBox_popularSong(reactive_input)
  output$general_highestRankedSong <- infoBox_highestRankedSong(reactive_input)
  
}


createInfoBoxPopularText <- function(row) {
  paste0(
    "<span class='info-box-number'>",
      "Song Count: <span class='pull-right'>", row$count, "</span></br>",
      "Highest Rank: <span class='pull-right'>", format(round(row$highest_rank, 2), nsmall = 2), "</span>",
    "</span>"
  )
}


createInfoBoxHighestText <- function(row) {
  paste0(
    "<span class='info-box-number'>",
      "Song Count: <span class='pull-right'>", row$count, "</span></br>",
      "Avg Ranking: <span class='pull-right'>", format(round(row$highest_rank, 2), nsmall = 2), "</span>",
    "</span>"
  )
}


infoBox_popularArtist <- function(reactive_input) {
  
  renderInfoBox({
    pop_artist <- reactive_input()$df %>% 
      select(display_artist, rank) %>% 
      rename(name = display_artist) %>% 
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
          "<span class='info-box-text'>Most Popular Artist</br>",
          "<strong><em>", pop_artist$name, "</em></strong></span>"
        )
      ),
      HTML(
        createInfoBoxPopularText(pop_artist)
      ),
      icon = icon("list"),
      color = "purple",
      width = 12
    )
  })
  
}

infoBox_highestRankedArtist <- function(reactive_input) {
  
  renderInfoBox({
    highest_artist <- reactive_input()$df %>% 
      select(display_artist, rank) %>% 
      rename(name = display_artist) %>% 
      group_by(name) %>% 
      mutate(
        count = n(),
        highest_rank = mean(rank)
      ) %>% 
      arrange(desc(highest_rank)) %>% 
      head(n = 1)
    
    infoBox(
      HTML(
        paste0(
          "<span class='info-box-text'>Highest Ranked Artist</br>",
          "<strong><em>", highest_artist$name, "</em></strong></span>"
        )
      ),
      HTML(
        createInfoBoxHighestText(highest_artist)
      ),
      icon = icon("list"),
      color = "purple",
      width = 12
    )
  })
  
}


infoBox_popularSong <- function(reactive_input) {
  
  renderInfoBox({
    popularSong <- reactive_input()$df %>% 
      select(song_name, display_artist, spotify_id, rank) %>% 
      rename(name = song_name) %>% 
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
          "<span class='info-box-text'>Most Popular Song</br>",
          "<strong><em>", popularSong$name, "</em></strong></span>"
        )
      ),
      HTML(
        createInfoBoxPopularText(popularSong)
      ),
      icon = icon("list"),
      color = "purple",
      width = 12
    )
  })
  
}


infoBox_highestRankedSong <- function(reactive_input) {
  
  renderInfoBox({
    highest_song <- reactive_input()$df %>% 
      select(song_name, display_artist, spotify_id, rank) %>% 
      rename(name = song_name) %>% 
      group_by(spotify_id) %>% 
      mutate(
        count = n(),
        highest_rank = mean(rank)
      ) %>% 
      arrange(desc(highest_rank)) %>% 
      head(n = 1)
    
    infoBox(
      HTML(
        paste0(
          "<span class='info-box-text'>Highest Ranked Song </br>",
          "<strong><em>", highest_song$name, "</em></strong></span>"
        )
      ),
      HTML(
        createInfoBoxHighestText(highest_song)
      ),
      icon = icon("list"),
      color = "purple",
      width = 12
    )
  })
  
}

histPlot <- function(reactive_input) {
  
  renderPlot({
    # draw the histogram with the specified number of bins
    hist(
      reactive_input()$df[[ reactive_input()$field ]],
      col = 'darkgray', 
      border = 'white'
    )
  })
  
}


boxPlot <- function(reactive_input) {
  # Create a boxplot to show the stats over the variable specified per year
  
  renderPlot({
    ggplot(
      data = reactive_input()$df,
      aes(
        x = year,
        y = reactive_input()$df[[ reactive_input()$field ]]
      )
    ) +
      geom_boxplot() +
      xlab( reactive_input()$field ) +
      coord_flip()
  })
  
}


lineGraph <- function(reactive_input) {
  
  renderPlot({
    reactive_input()$df %>% 
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
  })
  
}

  
  