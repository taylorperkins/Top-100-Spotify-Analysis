library(shinydashboard)

years <- readRDS('../data/r-objects/shiny/ui/general/years.rds')
echo_columns <- readRDS('../data/r-objects/shiny/ui/general/echo_columns.rds')


general <- fluidRow(
  
  # Control panel, Highs and Lows (Sidebar)
  box(
    width = 12,
    
    fluidRow(
      # Control panel
      box(
        width = 12,
        title = "Controls",
        box(
          width = 4,
          selectInput(
            "years",
            "Years:",
            choices = years$year,
            multiple = TRUE,
            selected = years$year
          ) 
        ),
        box(
          width = 4,
          selectInput(
            "inputField",
            "Echoprint fields:",
            choices = echo_columns
          ) 
        ),
        box(
          width = 4,
          actionButton(
            inputId = "submit",
            label = "Submit"
          ) 
        )
      )
    ),
    
    fluidRow(
      # Info boxes for:
      #     1. Most popular artist
      #     2. Highest ranked artist (mean)
      #     3. Most popular song
      #     4. Highest ranked song (mean)
      box(
        width = 4,
        height = 650,
        
        fluidRow(
          infoBoxOutput("general_popularArtist", width = 12)
        ),
        fluidRow(
          infoBoxOutput("general_highestRankedArtist", width = 12)
        ),
        fluidRow(
          infoBoxOutput("general_popularSong", width = 12)
        ),
        fluidRow(
          infoBoxOutput("general_highestRankedSong", width = 12)
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
            width = 6,
            height = 300,
            title = 'Hist Plot',
            plotOutput(
              "general_histPlot", 
              width = "100%",
              height = "200"
            )
          ),
          
          # Boxplot
          box(
            width = 6,
            height = 300,
            title = 'Boxplot',
            plotOutput(
              "general_boxPlot", 
              width = "100%",
              height = "200"
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
            plotOutput(
              'general_lineGraph',
              width = "100%",
              height = "200"
            )
          )
        )
      )   
    )
  )
)