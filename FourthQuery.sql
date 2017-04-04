SELECT actor 
FROM (CASTS JOIN taps_movies ON CASTS.title=taps_movies.title)
