library(shiny)
library(shinydashboard)

library(ggplot2)
library(dplyr)

# Handler over the general page
source('./server/components/general.R')


general <- function(input, output, session) {
  
  observeEvent(
    input$submit,
    {
      print('Clicking')
    }
  )
  
  reactive_inputSubmitVals <- eventReactive(
    input$submit, 
    { 
      df <- sra %>% 
        select(date, year, spotify_id, display_artist, song_name, rank, 
               acousticness, danceability, energy, instrumentalness, liveness, loudness, speechiness, valence) %>% 
        filter(year %in% as.integer(input$years) )
      
      input_submit_vals <- list(
        df = df,
        field = input$inputField
      )
      
      input_submit_vals
    }
  )
  
  general_server(reactive_inputSubmitVals, output, session)
    
}