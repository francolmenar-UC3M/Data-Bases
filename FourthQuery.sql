SELECT actor, month, max
       FROM (SELECT month, MAX(*) FROM
              (SELECT actor, to_char(view_datetime, 'MON-YYYY') AS month, COUNT(*) FROM CASTS JOIN taps_movies ON CASTS.title=taps_movies.title  
               GROUP BY actor, month))
       GROUP BY month;
       
              

