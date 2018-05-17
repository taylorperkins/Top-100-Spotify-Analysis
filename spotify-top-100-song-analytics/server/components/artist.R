library(shiny)
library(shinydashboard)

library(ggplot2)
library(plotly)
library(fmsb)

library(dplyr)
library(reshape2)


artist_server <- function(reactive_input, output, session) {
  # Reactive input is an artist dataframe

  output$artist_radarPlot <- radarPlot(reactive_input, session)
  output$artist_lineGraph <- lineGraph(reactive_input)
  
  output$artist_top100SongCount <- valueBox_top100SongCount(reactive_input)
  output$artist_timesRanked <- valueBox_timesRanked(reactive_input)
  output$artist_avgRank <- valueBox_avgRank(reactive_input)
  output$artist_highestRank <- valueBox_highestRank(reactive_input)  
  
}

valueBox_top100SongCount <- function(reactive_input) {
  
  renderInfoBox({
    top100SongCount <- reactive_input() %>% 
      summarise(songCount = length(unique(song_name)))

    valueBox(
      top100SongCount$songCount,
      "Unique Song Count",
      icon = icon("list"),
      color = "purple",
      width = 12
    )
  })
  
}


valueBox_timesRanked <- function(reactive_input) {
  
  renderInfoBox({
    timesRanked <- reactive_input() %>% 
      summarise(timesRanked = n())

    valueBox(
      timesRanked$timesRanked,
      "Rank Frequency",
      icon = icon("list"),
      color = "purple",
      width = 12
    )
  })
  
}


valueBox_avgRank <- function(reactive_input) {
  
  renderInfoBox({
    avgRank <- reactive_input() %>% 
      summarise(avgRank = mean(rank))

    valueBox(
      avgRank$avgRank,
      "Avg Rank",
      icon = icon("list"),
      color = "purple",
      width = 12
    )
  })
  
}


valueBox_highestRank <- function(reactive_input) {
  
  renderInfoBox({
    highestRank <- reactive_input() %>% 
      summarise(highestRank = min(rank))

    valueBox(
      highestRank$highestRank,
      "Top Rank",
      icon = icon("list"),
      color = "purple",
      width = 12
    )
  })
  
}


radarPlot <- function(reactive_input, session) {
  
  shiny::renderImage({
    width  <- session$clientData$output_artist_radarPlot_width
    height <- session$clientData$output_artist_radarPlot_height  

    outfile <- tempfile(fileext = '.png')
    png(outfile, width = width, height = height)

    artistSummary <- reactive_input() %>%
      summarise(
        Acousticness = mean(acousticness), 
        Danceability = mean(danceability), 
        Energy = mean(energy), 
        Instrumentalness = mean(instrumentalness), 
        Liveness = mean(liveness), 
        Speechiness = mean(speechiness), 
        Valence = mean(valence)
      ) %>% 
      select(
        Acousticness, Danceability, Energy, Instrumentalness, Liveness, Speechiness, Valence
      )

    # Create two rows at beginning of df to represent min and max vals
    artistSummary = rbind(rep(1,10), rep(0,10), artistSummary)

    radarchart( artistSummary, axistype=1,
      #custom polygon
      pcol = rgb(0.2,0.5,0.5,0.9), 
      pfcol = rgb(0.2,0.5,0.5,0.5), 
      plwd = 4, 
      
      #custom the grid
      cglcol = "grey", 
      cglty = 1, 
      axislabcol = "grey", 
      caxislabels = seq(0, 1, 0.25), 
      cglwd = 0.8,
      
      #custom labels
      vlcex = 0.8 
    )
    dev.off()

    list(
      src = outfile,      
      width = width,
      height = height,
      alt = "This is alternate text"
    )
  }, deleteFile = TRUE)

}


lineGraph <- function(reactive_input) {
  
  plotly::renderPlotly({
    reactive_input() %>%
      select(
        date, 
        song_name,
        rank
      ) %>%       
      ggplot(
        aes(
          x = date,
          y = rank,
          colour = song_name
        )
      ) +
      geom_line() +
      scale_y_reverse()
  })
  
}

  
  