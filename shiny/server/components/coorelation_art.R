library(shiny)
library(shinydashboard)

library(ggplot2)
library(dplyr)
library(reshape)
library(highcharter)


coorelation_art_server <- function(reactive_input, output, session) {
  
  output$coorelation_art_acousticness_heatMap <- coorelation_art_heatMap(reactive_input, 'acousticness')
  output$coorelation_art_danceability_heatMap <- coorelation_art_heatMap(reactive_input, 'danceability')
  output$coorelation_art_energy_heatMap <- coorelation_art_heatMap(reactive_input, 'energy')
  output$coorelation_art_instrumentalness_heatMap <- coorelation_art_heatMap(reactive_input, 'instrumentalness')
  output$coorelation_art_liveness_heatMap <- coorelation_art_heatMap(reactive_input, 'liveness')
  output$coorelation_art_speechiness_heatMap <- coorelation_art_heatMap(reactive_input, 'speechiness')
  output$coorelation_art_valence_heatMap <- coorelation_art_heatMap(reactive_input, 'valence')
  
}


coorelation_art_heatMap <- function(reactive_input, field) {
  renderHighchart({

      print(paste('Plotting for', field))      

      reactive_input() %>% 
        dplyr::select_(field, "date", "rank") %>%        
        reshape::melt(id=c("rank", "date")) %>%
        reshape::cast(
          rank ~ date, mean
        ) %>%
        select(-rank) %>%
        mutate_all(funs(replace(., is.na(.), -1))) %>%
        data.matrix() %>%
        hchart() %>%
        hc_colorAxis(
          minColor = '#FFFFFF',
          maxColor = echonest_color_palette[[ field ]]
        ) %>%
        hc_plotOptions(
          heatmap = list(
            events = list(
              click = JS("function(event) {
                console.log(this);
                alert('Hello')
              }")
            )
          )
        )

  })
}
