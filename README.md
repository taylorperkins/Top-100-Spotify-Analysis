# SHINY / Top Ranked Billboards Trends

The purpose of this app is to spot trends within the top ranked songs (based on the **unofficial** billboards api)
from every week over the span of 2000 - 2017 using Spotify's audio analysis api, as well as potentially
spotting trends in **what will be** the following top 100 songs.

I do this by first obtaining songs, dates, and their ranks through the billboards api. Second, I gather a base
audio analysis of every song, as well as an in depth anaysis using Spotify's api. 
Some key features I would like to focus on would be: 

* Energy of the song
* Amount of vocals
* Song duration
* Key
* Modality
* Repetition in structure (beats, segments like chorus/verses, or pitches)


## Data
I use data from a few different places. I gather data from 3 separate api endpoints, and merge them together or split
them apart based on the spotify_id associated with them.
The first dataset I use is from the billboards api. `http://billboard.modulo.site/rank/song/<[1-100]>?from=2000-1-1&to=2017-12-31`

>* **date**             date song was ranked
* **song_id**          unique song id for billboards api (not used by me)
* **song_name**        name of song
* **artist_id**        unique artist id for billboards api (not used by me)
* **spotify_api**      unique song id for spotify api
* **rank**             rank given

The second being `https://api.spotify.com/v1/audio-features/?ids=123,234,345,456,567`
*field definitions can be found in the [spotify docs](https://developer.spotify.com/web-api/get-several-audio-features/)*

>* acousticness, analysis_url, danceability, duration_ms, energy, instrumentalness, key, liveness, loudness, mode, speechiness, tempo, time_signature, track_href, type, uri, valence