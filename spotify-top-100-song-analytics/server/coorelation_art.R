library(shiny)
library(shinydashboard)

library(dplyr)

# Data
coorelation_art_df <- readRDS('../data/r-objects/shiny/coorelation_art/coorelation_art.rds')

# Handler over the general page
source('./server/components/coorelation_art.R')


coorelation_art <- function(input, output, session) {
  
  observeEvent(
    input$coorelation_art_submit,
    {
      print('Clicking coorelation_art submit')
    }
  )

  observeEvent(
    input$coorelation_art_acousticness_heatMap,
    {
      print('Observing event around coorelation_art_acousticness_heatMap')
    }
  )
  
  reactive_coorelation_art_df <- eventReactive(
    input$coorelation_art_submit, 
    { 
      df <- coorelation_art_df %>%         
        filter( year == as.integer(input$coorelation_art_years) )

      df
    }
  )
  
  coorelation_art_server(reactive_coorelation_art_df, output, session)
    
}