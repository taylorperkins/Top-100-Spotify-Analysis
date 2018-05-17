library(shinydashboard)


coorelation_art <- fluidRow(
  
  # Control panel, Highs and Lows (Sidebar)
  box(
    width = 12,
    
    fluidRow(
      # Control panel
      box(
        width = 12,
        title = "Controls",
        box(
          width = 6,
          selectInput(
            "coorelation_art_years",
            "Years:",
            choices = years$year,
            multiple = FALSE,
            selected = 2016
          ) 
        ),
        box(
          width = 6,
          actionButton(
            inputId = "coorelation_art_submit",
            label = "Submit"
          ) 
        )
      )
    ),
    
   # Acousticness
    fluidRow(      
      box(
        width = 12,        
        title = 'Acousticness',
        highchartOutput(
          "coorelation_art_acousticness_heatMap", 
          width = "100%"          
        )
      )
    ),

    # Danceability
    fluidRow(      
      box(
        width = 12,        
        title = 'Danceability',
        highchartOutput(
          "coorelation_art_danceability_heatMap", 
          width = "100%"
        )
      )
    ),

    # Energy
    fluidRow(      
      box(
        width = 12,  
        title = 'Energy',
        highchartOutput(
          "coorelation_art_energy_heatMap", 
          width = "100%"  
        )
      )
    ),

    # Instrumentalness
    fluidRow(      
      box(
        width = 12,  
        title = 'Instrumentalness',
        highchartOutput(
          "coorelation_art_instrumentalness_heatMap", 
          width = "100%"  
        )
      )
    ),

    # Liveness
    fluidRow(      
      box(
        width = 12,  
        title = 'Liveness',
        highchartOutput(
          "coorelation_art_liveness_heatMap", 
          width = "100%"
        )
      )
    ),

    # Speechiness
    fluidRow(      
      box(
        width = 12,  
        title = 'Speechiness',
        highchartOutput(
          "coorelation_art_speechiness_heatMap", 
          width = "100%" 
        )
      )
    ),

    # Valence
    fluidRow(      
      box(
        width = 12,  
        title = 'Valence',
        highchartOutput(
          "coorelation_art_valence_heatMap", 
          width = "100%"
        )
      )
    )  

  )
)