library(shiny)
library(shinydashboard)

library(ggplot2)
library(dplyr)

# Handler over the general page
source('./server/components/general.R')


general <- function(input, output, session) {
  
  general_server(input, output, session)
}