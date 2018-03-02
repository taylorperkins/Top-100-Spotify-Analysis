# Server
library(shiny)
library(shinydashboard)

source('./server/general.R')


server <- function(input, output, session) { 
  
  general(input, output, session)
    
}
