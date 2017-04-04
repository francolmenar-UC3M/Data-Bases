
		SELECT max, month, actor FROM (
		SELECT max(top) AS max, month FROM (
			SELECT to_char(view_datetime, 'MON-YYYY') AS month, actor, COUNT(CASTS.actor) top
				   FROM CASTS JOIN taps_movies ON CASTS.title=taps_movies.title  
				   GROUP BY to_char(view_datetime, 'MON-YYYY'), actor 		   
				   ORDER BY to_char(view_datetime, 'MON-YYYY'))
					GROUP BY month)
		NATURAL JOIN (
			SELECT to_char(view_datetime, 'MON-YYYY') AS month, actor, COUNT(CASTS.actor) top1
				   FROM CASTS JOIN taps_movies ON CASTS.title=taps_movies.title  
				   GROUP BY to_char(view_datetime, 'MON-YYYY'), actor 		   
				   ORDER BY to_char(view_datetime, 'MON-YYYY'))
		WHERE top1=max;
	
	
	--diciembre Morgan Freeman el resto DeNiro
			  
			  
			  
             
          
