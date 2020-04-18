SELECT CLIENTS.name, CLIENTS.surname, SEASONS.title, SEASONS.season
  FROM (SEASONS JOIN lic_series ON SEASONS.title=lic_series.title AND SEASONS.season=lic_series.season 
        JOIN CLIENTS ON clientId=client)
  GROUP BY CLIENTS.name, CLIENTS.surname, SEASONS.title, SEASONS.season, SEASONS.episodes 
  HAVING COUNT(lic_series.episode)=SEASONS.episodes;
  
--2103--
  


