SELECT to_char(view_datetime, 'MON-YYYY'), actor
       FROM (SELECT COUNT(*) 
             FROM CASTS JOIN taps_movies ON CASTS.title=taps_movies.title)
       GROUP BY view_datetime;

              

