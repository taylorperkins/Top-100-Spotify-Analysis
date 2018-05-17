library(shinydashboard)

library(plotly)

years <- readRDS('../data/r-objects/shiny/utility/years.rds')
artists <- readRDS('../data/r-objects/shiny/artist/unique_artists.rds')


artist <- fluidRow(
  
  # Control panel, Highs and Lows (Sidebar)
  box(
    width = 12,
    
    fluidRow(
      # Control panel
      box(
        width = 12,
        title = "Controls",
        box(
          title = 'Select Artist: ',
          width = 4,
          selectInput(
            "artist_artist",
            "Select Artist:",
            choices = artists$display_artist,            
            selected = 'Taylor Swift'
          ) 
        ),
        box(          
          width = 4,
          selectInput(
            "artist_years",
            "Years:",
            choices = years$year,
            multiple = TRUE,
            selected = years$year
          ) 
        ),
        box(
          width = 4,
          actionButton(
            inputId = "artist_submit",
            label = "Submit"
          ) 
        )
      )
    ),
    
    # Value boxes for:
    #     1. Most popular artist    
    #     3. Most popular song
    #     4. Highest ranked song
    fluidRow(      
      box(
        width = 4,
        height = 650,
        
        fluidRow(
          valueBoxOutput("artist_top100SongCount", width = 12)
        ),
        fluidRow(
          valueBoxOutput("artist_timesRanked", width = 12)          
        ),
        fluidRow(
          valueBoxOutput("artist_avgRank", width = 12)
        ),
        fluidRow(
          valueBoxOutput("artist_highestRank", width = 12)
        )
        
      ),
      
      # Plots (Body)
      box(
        width = 8,
        height = 650,
        
        # Hist and box plots
        fluidRow(
          # Hist
          box(
            width = 2,
            height = 300,
            title = 'Radar Plot',
            shiny::plotOutput(
              "artist_radarPlot",
              width = "250px",
              height = "250px"
            )
          )
        ),
        
        # Line graph
        fluidRow(
          # Line Graph
          box(
            width = 12,
            height = 300,
            title = 'Line Graph',
            plotly::plotlyOutput(
              "artist_lineGraph", 
              width = "100%",
              height = "200"
            )
          )
        )
      )   
    )
  )
)