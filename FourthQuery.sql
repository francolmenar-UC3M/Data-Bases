
	SELECT max(top), month FROM (
		SELECT to_char(view_datetime, 'MON-YYYY') AS month, actor, COUNT(CASTS.actor) top
		       FROM CASTS JOIN taps_movies ON CASTS.title=taps_movies.title  
		       GROUP BY to_char(view_datetime, 'MON-YYYY'), actor 		   
		       ORDER BY to_char(view_datetime, 'MON-YYYY'))
	GROUP BY month HAVING max(top)=188;
			  
			  
			  
             
          
