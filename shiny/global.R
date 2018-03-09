library(RColorBrewer)

sra <- readRDS('../data/r-objects/song-ranked-analytics/song-ranked-analytics.rds')
sra$date <- as.Date(sra$date)

# tracks <- readRDS('../data/r-objects/track/track.rds')

years <- readRDS('../data/r-objects/shiny/utility/years.rds')

color_brewer_set <- 'Set1'
echonest_color_palette <- list(
  'acousticness' = brewer.pal(7, color_brewer_set)[[ 7 ]],
  'danceability' = brewer.pal(7, color_brewer_set)[[ 6 ]],
  'energy' = brewer.pal(7, color_brewer_set)[[ 2 ]],
  'instrumentalness' = brewer.pal(7, color_brewer_set)[[ 5 ]],
  'liveness' = brewer.pal(7, color_brewer_set)[[ 1 ]],
  'speechiness' = brewer.pal(7, color_brewer_set)[[ 3 ]],
  'valence' = brewer.pal(7, color_brewer_set)[[ 4 ]]
)


echonest_value_description <- list(
	'acousticness' = '* A confidence measure from <em>0.0 to 1.0</em> of whether the track is <strong>acoustic</strong>. <strong>1.0</strong> represents <em><strong>high</strong> confidence the track is acoustic</em>.',
	'danceability' = '* <strong>Danceability</strong> describes how <em>suitable a track is for dancing</em> based on a combination of musical elements including <em>tempo, rhythm stability, beat strength, and overall regularity</em>. A value of <strong>0.0</strong> is <em><strong>least</strong> danceable</em> and <strong>1.0</strong> is <em><strong>most</strong> danceable</em>.',
	'energy' = '* <strong>Energy</strong> is a measure from <em>0.0 to 1.0</em> and represents a perceptual measure of <em>intensity and activity</em>. Typically, energetic tracks feel <em>fast, loud, and noisy</em>. For example, <strong>death metal</strong> has <strong><em>high</em></strong> energy, while a <strong>Bach prelude</strong> scores <strong><em>low</em></strong> on the scale. Perceptual features contributing to this attribute include <em>dynamic range, perceived loudness, timbre, onset rate, and general entropy</em>.',
	'instrumentalness' = '* Predicts whether a track <em>contains no vocals</em>. <em>"Ooh"</em> and <em>"aah"</em> sounds are treated as instrumental in this context. Rap or spoken word tracks are clearly "vocal". The <em>closer the instrumentalness value is to <strong>1.0</strong></em>, the greater likelihood the track <em><strong>contains no vocal content</strong></em>. Values <em>above <strong>0.5</strong></em> are intended to <em>represent instrumental tracks</em>, but confidence is higher as the value approaches 1.0.',
	'liveness' = '* Detects the <em>presence of an audience</em> in the recording. <em>Higher liveness</em> values represent an increased probability that the <em>track was performed live</em>. A value <strong>above 0.8</strong> provides <strong>strong</strong> likelihood that the <em>track <strong>is</strong> live</em>.',
	'speechiness' = '* <em>Speechiness</em> detects the <em>presence of spoken words</em> in a track. The more exclusively speech-like the recording <em>(e.g. talk show, audio book, poetry)</em>, the <em>closer to <strong>1.0</strong></em> the attribute value. Values <strong>above 0.66</strong> describe tracks that are <em>probably made entirely of spoken words</em>. Values <strong>between 0.33 and 0.66</strong> describe tracks that <em>may contain both music and speech</em>, either in sections or layered, including such cases as rap music. Values <strong>below 0.33</strong> most likely represent music and other <em>non-speech-like tracks.</em>',
	'valence' = '* A measure from 0.0 to 1.0 describing the <em>musical positiveness</em> conveyed by a track. Tracks with <em><strong>high</strong> valence</em> sound more <em>positive (e.g. happy, cheerful, euphoric)</em>, while tracks with <em><strong>low</strong> valence</em> sound more <em>negative (e.g. sad, depressed, angry)</em>.'
)

# First index is high, second is low
echonest_value_examples <- data.frame(
	'acousticness' = c(
		'3wriDAN59yRNx8FqynZnnb', # Soko -- We Might Be Dead By Tomorrow
		'6RfDLynqmspMOKA57mXyQI' # Godsmack -- Speak
	),
	'danceability' = c(
		'3kUkjtNjWG7jFEMIEPnVJq', # Glee -- Ice, Ice, Baby
		'6nnacTL5on2aVsRhVDNUSo' # Dragonforce -- Through the Fire and Flames
	),
	'energy' = c(
		'6nTiIhLmQ3FWhvrGafw2zj', # Green Day -- American Idiot
		'4h0zU3O9R5xzuTmNO7dNDU' # Ruth B. -- Lost Boy
	),
	'instrumentalness' = c(
		'3XWZ7PNB3ei50bTPzHhqA6', # Darude -- Sandstorm (EDM)
		'3QV7NYkrmV0Q0IHdFJw9hO' # Kenny Chesney -- She Thinks My Tractor's Sexy
	),
	'liveness' = c(
		'1J3UaZHMc5FooGjz2JUWzs', # Paul McCartney -- Freedom
		'1j8z4TTjJ1YOdoFEDwJTQa' # Paramore -- Ain't It Fun
	),
	'speechiness' = c(
		'3bOoByGO6dgf3EYY8pSDaV', # Drake -- Charged Up
		'4gs07VlJST4bdxGbBsXVue' # John Maher -- Heartbreak Warfare
	),
	'valence' = c(
		'1EzaEQ1hUWj7NWphY5Allw', # Pitbull -- MM Yeah
		'4S7YHmlWwfwArgd8LfSPud' # A$AP Rocky -- L$D
	),
	stringsAsFactors = FALSE
)


# test <- sra %>% 
#   select(spotify_id, acousticness) %>% 
#   arrange(desc(acousticness))
# 
# test[1, 'spotify_id']
# test[nrow(test), 'spotify_id']
