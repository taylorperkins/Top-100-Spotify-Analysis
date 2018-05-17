# Server
library(shiny)
library(shinydashboard)

source('./components/sidebar/pages.R')

source('./server/general.R')
source('./server/coorelation_art.R')
# source('./server/artist.R')


server <- function(input, output, session) { 
  
  sidebar_pages(input, output, session)

  general(input, output, session)
  # artist(input, output, session)
  coorelation_art(input, output, session)
  
}
