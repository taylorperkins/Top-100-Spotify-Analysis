library(shiny)
library(shinydashboard)


########################
# Sidebar Page Menu Options
########################
sidebar_pages <- function(input, output, session) {
  output$sidebar_dashboard <- renderMenu({
	menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"))
  })

  output$sidebar_artists <- renderMenu({
	menuItem("Artists", tabName = "artist", icon = icon("th"))
  })

  output$sidebar_coorelation_art <- renderMenu({
  	menuItem("Coorelation Art", tabName = "coorelation_art", icon = icon("th"))
  })

  output$sidebar_echoDescription <- renderUI({
    HTML(paste0(      
        '<pre id="summary" class="shiny-text-output">',
          echonest_value_description[[ input$sidebar_inputField ]],
        '</pre>'
    ))  	
  })
}
