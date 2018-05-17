library(shinydashboard)
library(highcharter)
library(DT)

years <- readRDS('../data/r-objects/shiny/utility/years.rds')
echo_columns <- readRDS('../data/r-objects/shiny/general/echo_columns.rds')


general <- fluidRow(

  box(
    width = 4,
    height = 650,
    class = 'general_infoBoxes',
    
    fluidRow( 
      box(
        width = 12,
        class = "general_echoLevels",

        uiOutput("general_high_echoLevels", width = 12),
        uiOutput("general_low_echoLevels", width = 12)  
      )
    ),
    fluidRow( uiOutput("general_popularArtist") ),
    fluidRow( uiOutput("general_highestRankedArtist") ),
    fluidRow( uiOutput("general_popularSong") ),
    fluidRow( uiOutput("general_highestRankedSong") )
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
        'Histogram', 

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