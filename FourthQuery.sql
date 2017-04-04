SELECT actor, month, max
       FROM (SELECT month, MAX(*) FROM
              (SELECT to_char(view_datetime, 'MON-YYYY'), COUNT(*) top FROM CASTS JOIN taps_movies ON CASTS.title=taps_movies.title  
               GROUP BY to_char(view_datetime, 'MON-YYYY')
               ORDER BY to_char(view_datetime, 'MON-YYYY'))
       GROUP BY CASTS.actor, to_char(view_datetime, 'MON-YYYY');
       
              
             
             
             
             
             
             SELECT to_char(view_datetime, 'MON-YYYY'), ACTOR, rank() OVER (ORDER BY top desc) as mejor
				FROM (SELECT COUNT(*) top
				FROM CASTS JOIN taps_movies ON 
				CASTS.title=taps_movies.title)  
				 WHERE mejor = 1
               GROUP BY ACTOR, to_char(view_datetime, 'MON-YYYY')
               ORDER BY to_char(view_datetime, 'MON-YYYY');
			   
			
