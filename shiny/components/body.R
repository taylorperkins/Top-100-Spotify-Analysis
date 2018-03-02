# Body UI
library(shinydashboard)

source('./components/body/general.R')


body <- dashboardBody(
  tabItems(
    
    ########################
    # General View
    ########################
    tabItem(
      general,
      tabName = "dashboard"
    ),
    
    ########################
    # Second tab content
    ########################
    tabItem(
      tabName = "Artist",
      h2("Widgets tab content")
    )
  )
)