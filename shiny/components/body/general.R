library(shinydashboard)
library(highcharter)
library(DT)

years <- readRDS('../data/r-objects/shiny/utility/years.rds')
echo_columns <- readRDS('../data/r-objects/shiny/general/echo_columns.rds')


general <- fluidRow(

  box(
    width = 4,
    height = 650,
    
    fluidRow( infoBoxOutput("general_popularArtist", width = 12) ),
    fluidRow( infoBoxOutput("general_highestRankedArtist", width = 12) ),
    fluidRow( infoBoxOutput("general_popularSong", width = 12) ),
    fluidRow( infoBoxOutput("general_highestRankedSong", width = 12) )
  ),
  
  # Plots (Body)
  box(
    width = 8,
    height = 650,

    tabBox(
      id = "general_plot_tabset", 
      title = "Plots",
      height = "500px",
      width = 12,
      # The id lets us use input$tabset1 on the server to find the current tab

      tabPanel(
        'Hist Plot', 

        highchartOutput("general_histPlot",  width = "100%", height = "500")
      ),

      tabPanel(
        'Box Plot', 

        highchartOutput("general_boxPlot", width = "100%", height = "500")
      ),

      tabPanel(
        'Line Graph', 

        highchartOutput('general_lineGraph', width = "100%", height = "500")
      ),

      tabPanel(
        'Dataset', 

        DT::dataTableOutput("general_dataTab", width = "100%", height = "500")
      )
    )
  )

)