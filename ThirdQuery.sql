SELECT name, surname, SEASONS.title, SEASONS.season
  FROM (SEASONS JOIN lic_series ON SEASONS.season=lic_series.season)
       JOIN clients ON clientId=client)
  GROUP BY SEASONS.title HAVING COUNT(lic_series.episode)=max(SEASONS.episode);
  
--SELECT COUNT(*) FROM (..);  

  


