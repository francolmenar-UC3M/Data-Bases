SELECT name, surname, SEASONS.title, SEASONS.season
  FROM (SEASONS JOIN lic_series ON SEASONS.season=lic_series.season)
       JOIN clients ON clientId=client
  GROUP BY SEASONS.episode HAVING COUNT(lic_series.episode)=(SELECT max(episode) FROM SEASONS);
  
--SELECT COUNT(*) FROM (..);  

  


