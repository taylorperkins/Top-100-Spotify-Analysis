# Body UI
library(shinydashboard)

source('./components/body/general.R')
source('./components/body/artist.R')
source('./components/body/coorelation_art.R')


body <- dashboardBody(  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),  
  
  tabItems(
    
    ########################
    # General View
    ########################
    tabItem(
      general,
      tabName = "dashboard"
    ),

    # ########################
    # # Artist View
    # ########################
    # tabItem(
    #   artist,
    #   tabName = "artist"
    # ),

    ########################
    # Coorelation Art View
    ########################
    tabItem(
      coorelation_art,
      tabName = "coorelation_art"
    )
  )
)