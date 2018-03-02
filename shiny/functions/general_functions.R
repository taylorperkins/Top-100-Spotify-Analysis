
lows_highs_facet <- function(df, sortBy, echo_variable) {
  facet_plot <- df %>% 
    select_('spotify_id', 'rank', echo_variable)
  
  if (sortBy == 'low') {
    facet_plot <- facet_plot %>% 
      filter(rank <= 3)
  } else {
    facet_plot <- facet_plot %>% 
      filter(rank >= 98)
  }
  
  min_val <- paste0('min(', echo_variable, ')')
  max_val <- paste0('max(', echo_variable, ')')
  
  dots_filter <- paste0(echo_variable, ' == ', min_val, ' | ', echo_variable, ' == ', max_val)
  
  facet_plot %>% 
    group_by(rank) %>% 
    filter_(
      .dots = dots_filter
    ) %>% 
    mutate_(
      max = max_val,
      min = min_val
    ) %>% 
    ungroup() %>%
    
    group_by(rank, max) %>% 
    slice( c(1) ) %>% 
    ungroup() %>%
    
    group_by(rank, min) %>% 
    slice( c(n()) ) %>% 
    ungroup() %>% 
    
    select(spotify_id, rank, min, max) %>%
    distinct(spotify_id, rank, min, max) %>%
    melt(id = c("spotify_id", "rank")) %>%
    ggplot(
      aes(
        y = value, x = variable, color = variable, fill = variable
      )
    ) +
    geom_bar(stat = 'identity') +
    facet_wrap(~rank)
}

lows_highs_facet(sra, 'high', 'acousticness')



