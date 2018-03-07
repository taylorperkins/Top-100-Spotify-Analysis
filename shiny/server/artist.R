library(shiny)
library(shinydashboard)

library(ggplot2)
library(dplyr)

# Data
artists_df <- readRDS('../data/r-objects/shiny/artist/grouped_artist.rds')

# Handler over the general page
source('./server/components/artist.R')


artist <- function(input, output, session) {
  
  observeEvent(
    input$artist_submit,
    {
      print('Clicking artist submit')
    }
  )
  
  reactive_artists_df <- eventReactive(
    input$artist_submit, 
    { 
      df <- artists_df %>%         
        filter( 
          year %in% as.integer(input$artist_years),
          display_artist == input$artist_artist
        )
      
      df
    }
  )
  
  artist_server(reactive_artists_df, output, session)
    
}