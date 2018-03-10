library(shiny)
library(shinydashboard)

library(ggplot2)
library(dplyr)
library(reshape2)
library(xts)
library(highcharter)
library(Hmisc)
library(DT)


general_server <- function(input, output, session) {  
    
  output$general_histPlot <- general_histPlot(input)
  output$general_boxPlot <- general_boxPlot(input)
  output$general_lineGraph <- general_lineGraph(input)
  output$general_dataTab <- general_dataTab(input)
  
  output$general_high_echoLevels <- general_infoBox_echoLevels(input, 1)
  output$general_low_echoLevels <- general_infoBox_echoLevels(input, 2)
  output$general_popularArtist <- general_infoBox_popularArtist(input)
  output$general_highestRankedArtist <- general_infoBox_highestRankedArtist(input)
  output$general_popularSong <- general_infoBox_popularSong(input)
  output$general_highestRankedSong <- general_infoBox_highestRankedSong(input)  
  
}


filter_df <- function(input, cols) {
  startDate <- input$sidebar_dateRange[[1]]
  endDate <- input$sidebar_dateRange[[2]]

  sra[ 
    (sra$date >= startDate & sra$date <= endDate) &
    (sra[[ input$sidebar_inputField ]] >= input$sidebar_echoSlider[[1]] & sra[[ input$sidebar_inputField ]] <= input$sidebar_echoSlider[[2]]) , 
  ][ , cols ]

}

general_infoBox_echoLevels <- function(input, level) {
  renderUI({    
    df <- filter_df( input, c('spotify_id', input$sidebar_inputField) ) %>%
      dplyr::arrange_(input$sidebar_inputField)

    if (level == 1) {
      row <- df[nrow(df), ]
      header = h4(paste0('Highest ', capitalize(input$sidebar_inputField), ': ', format(round(row[[ input$sidebar_inputField ]], 2), nsmall = 2)))
      spotify_id <- row$spotify_id
    } else {
      row <- df[1, ]
      header = h4(paste0('Lowest ', capitalize(input$sidebar_inputField), ': ', format(round(row[[ input$sidebar_inputField ]], 2), nsmall = 2)))
      spotify_id <- row$spotify_id
    }

    HTML(
      paste0(
        header,
        '<iframe 
          src="https://open.spotify.com/embed?uri=spotify:track:', spotify_id, '"
          frameborder="0" 
          width="250" 
          height="80" 
          allow="encrypted-media" 
          allowtransparency="true">
        </iframe>'
      )
    )
  })  
}


reversed_scoring <- function(rank_col, highest_rank, df_len) {
  new_ranks = sapply(rank_col, function(val) { highest_rank - val })
  sum(new_ranks) / df_len
}


general_infoBox_popularArtist <- function(input) {
  renderUI({

    df <- filter_df( input, c('display_artist', 'rank') )

    pop_artist <- df %>%       
      dplyr::rename(name = display_artist) %>% 
      group_by(name) %>% 
      mutate(
        count = n(),
        highest_rank = min(rank)
      ) %>% 
      arrange(desc(count)) %>% 
      head(n = 1)

    tags$div( class="col-md-12",
      tags$div( class="info-box",
        tags$div( class="info-box-number",
          HTML(paste0('<span>Most Frequent Artist: <span class="pull-right"><strong><em>', pop_artist$name, '</em></strong></span></span>'))
        ),
        tags$div( class="info-box-body",
          tags$span( class="info-box-icon bg-black",
            HTML('<i class="fa fa-user"></i>')
          ),
          tags$div( class="info-box-content",
            tags$span( class="info-box-text",
              HTML(paste0('<span class="info-box-text">Song Count: <span class="pull-right">', pop_artist$count, '</span><br>Highest Rank: <span class="pull-right">', format(round(pop_artist$highest_rank, 2), nsmall = 2), '</span></span>'))
            )
          )
        )
      )  
    )
    
  })
}

general_infoBox_highestRankedArtist <- function(input) {
  renderUI({

    df <- filter_df( input, c('display_artist', 'rank') )

    highest_artist <- df %>%       
      dplyr::rename(name = display_artist) %>% 
      group_by(name) %>% 
      mutate(
        count = n(),
        score = reversed_scoring(rank, max(df$rank), nrow(df)),
        avg_rank = mean(rank)
      ) %>% 
      arrange(desc(score)) %>% 
      head(n = 1)

    tags$div( class="col-md-12",
      tags$div( class="info-box",
        tags$div( class="info-box-number",
          HTML(paste0('<span>Highest Scored Artist: <span class="pull-right"><strong><em>', highest_artist$name, '</em></strong></span></span>'))
        ),
        tags$div( class="info-box-body",
          tags$span( class="info-box-icon bg-black",
            HTML('<i class="fa fa-user"></i>')
          ),
          tags$div( class="info-box-content",
            tags$span( class="info-box-text",
              HTML(paste0('
                <span class="info-box-text">Song Count: <span class="pull-right">', highest_artist$count, '</span><br>
                Avg Ranking: <span class="pull-right">', format(round(highest_artist$avg_rank, 2), nsmall = 2), '</span><br>
                Score: <span class="pull-right">', format(round(highest_artist$score, 2), nsmall = 2), '</span>
                </span>'
              ))
            )
          )
        )
      )
    )

  })
}


general_infoBox_popularSong <- function(input) {
  renderUI({

    df <- filter_df( input, c('song_name', 'display_artist', 'spotify_id', 'rank') )

    popularSong <- df %>%       
      dplyr::rename(name = song_name) %>% 
      group_by(name) %>% 
      mutate(
        count = n(),
        highest_rank = min(rank)
      ) %>% 
      arrange(desc(count)) %>% 
      head(n = 1)
  
    tags$div( class="col-md-12",
      tags$div( class="info-box",
        tags$div( class="info-box-number",
          HTML(paste0('<span>Most Frequent Song: <span class="pull-right"><strong><em>', popularSong$name, '</em></strong></span></span>'))
        ),
        tags$div( class="info-box-body",
          tags$span( class="info-box-icon bg-black",
            HTML('<i class="fa fa-headphones"></i>')
          ),
          tags$div( class="info-box-content",
            tags$span( class="info-box-text",
              HTML(paste0('
                <span class="info-box-text">Song Count: <span class="pull-right">', popularSong$count, '</span><br>
                Highest Rank: <span class="pull-right">', format(round(popularSong$highest_rank, 2), nsmall = 2), '</span>                
                </span>'
              ))
            )
          )
        )
      )
    )
        
  })
}


general_infoBox_highestRankedSong <- function(input) {
  renderUI({

    df <- filter_df( input, c('song_name', 'display_artist', 'spotify_id', 'rank') )
    names(df)[names(df) == 'song_name'] <- 'name'

    highest_song <- df %>%
      group_by(name) %>% 
      mutate(
        count = n(),
        score = reversed_scoring(rank, max(df$rank), nrow(df)),
        avg_rank = mean(rank)
      ) %>% 
      arrange(desc(score)) %>% 
      head(n = 1)
    
    tags$div( class="col-md-12",
      tags$div( class="info-box",
        tags$div( class="info-box-number",
          HTML(paste0('<span>Highest Scored Song: <span class="pull-right"><strong><em>', highest_song$name, '</em></strong></span></span>'))
        ),
        tags$div( class="info-box-body",
          tags$span( class="info-box-icon bg-black",
            HTML('<i class="fa fa-headphones"></i>')
          ),
          tags$div( class="info-box-content",
            tags$span( class="info-box-text",
              HTML(paste0('
                <span class="info-box-text">Song Count: <span class="pull-right">', highest_song$count, '</span><br>
                Avg Ranking: <span class="pull-right">', format(round(highest_song$avg_rank, 2), nsmall = 2), '</span><br>
                Score: <span class="pull-right">', format(round(highest_song$score, 2), nsmall = 2), '</span>
                </span>'
              ))
            )
          )
        )
      )
    )

  })
}

general_histPlot <- function(input) {
  renderHighchart({
      
    series <- filter_df( input, c(input$sidebar_inputField) )

    h <- hist(series, breaks = 25, plot = FALSE)

    hchart(
      h,
      type = "area",
      color = echonest_color_palette[[ input$sidebar_inputField ]],
      name = capitalize( input$sidebar_inputField )
    ) %>%
    hc_title(text = paste0(capitalize(input$sidebar_inputField), " Frequency ", input$sidebar_dateRange[[1]], " and ", input$sidebar_dateRange[[2]])) %>% 
    hc_subtitle(text = paste0("All ", input$sidebar_inputField, " values fall anywhere between 0 and 1.")) %>%
    hc_add_theme(hc_theme_538()) %>%
    hc_tooltip(crosshairs = TRUE)

  })
}


general_boxPlot <- function(input) {
  renderHighchart({

    df <- filter_df( input, c('year', 'display_artist', 'song_name', input$sidebar_inputField) )    

    # Create a boxplot to show the stats over the variable specified per year
    hcboxplot(
      x = df[[ input$sidebar_inputField ]], 
      var = df$year,
      color = echonest_color_palette[[ input$sidebar_inputField ]]
    ) %>% 
    hc_yAxis(title = list(text = paste0(capitalize(input$sidebar_inputField), " (0-1)"))) %>%
    hc_xAxis(title = list(text = "Years")) %>%
    hc_add_theme(hc_theme_538()) %>%
    hc_title(text = paste0( "Boxplot For ", capitalize(input$sidebar_inputField), " Per Year (", min(df$year), "-", max(df$year), ")")) %>%
    hc_subtitle(text = paste0("All ", input$sidebar_inputField, " values fall anywhere between 0 and 1."))
  })
}


general_lineGraph <- function(input) {
  renderHighchart({

    df <- sra[ 
      (sra$date >= input$sidebar_dateRange[[1]] & sra$date <= input$sidebar_dateRange[[2]]),
    ][ , c('date', 'acousticness', 'danceability', 'energy', 'instrumentalness', 'liveness', 'speechiness', 'valence') ]

    avgs <- df %>% 
      dplyr::group_by(date) %>% 
      dplyr::summarise(
        avg_acousticness = mean(acousticness),
        avg_danceability = mean(danceability),
        avg_energy = mean(energy),
        avg_instrumentalness = mean(instrumentalness),
        avg_liveness = mean(liveness),
        avg_speechiness = mean(speechiness),
        avg_valence = mean(valence)
      )

    rownames(avgs) <- avgs$date
    avgs$date <- NULL

    avgs_xts <- as.xts(avgs)

    highchart(type = "stock") %>% 
      hc_title(text = "Avg Echo Values Over Time") %>% 
      hc_subtitle(text = "Data generated through gathering average field per week.") %>%
      hc_add_theme(hc_theme_538()) %>%
      hc_add_series(avgs_xts$avg_acousticness, name = "Acousticness", color = echonest_color_palette$acousticness) %>% 
      hc_add_series(avgs_xts$avg_danceability, name = "Danceability", color = echonest_color_palette$danceability) %>%
      hc_add_series(avgs_xts$avg_energy, name = "Energy", color = echonest_color_palette$energy) %>% 
      hc_add_series(avgs_xts$avg_instrumentalness, name = "Instrumentalness", color = echonest_color_palette$instrumentalness) %>% 
      hc_add_series(avgs_xts$avg_liveness, name = "Liveness", color = echonest_color_palette$liveness) %>% 
      hc_add_series(avgs_xts$avg_speechiness, name = "Speechiness", color = echonest_color_palette$speechiness) %>% 
      hc_add_series(avgs_xts$avg_valence, name = "Valence", color = echonest_color_palette$valence)

  })
}


general_dataTab <- function(input) {
  DT::renderDataTable({

    sra[, c('spotify_play', 'date', 'display_artist', 'song_name', 'rank', 'acousticness', 'danceability', 'energy', 'instrumentalness', 'liveness', 'speechiness', 'valence')]

  }, 
  escape = FALSE,  
  colnames = c('Play', 'Date', 'Artist', 'Song', 'Rank', 'Acousticness', 'Danceability', 'Energy', 'Instrumentalness', 'Liveness', 'Speechiness', 'Valence'),
  options = list(
    scrollX = TRUE,
    scrollY = 400,
    autoWidth = TRUE,
    columnDefs = list(list(width = '90px', targets = 1:12))
  ))
}
