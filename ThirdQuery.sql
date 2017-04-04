SELECT name, surname, SEASONS.title, SEASONS.season, max(episode)
  FROM (SEASONS JOIN lic_series ON SEASONS.season=lic_series.season)
       JOIN clients ON clientId=client
  GROUP BY SEASONS.season HAVING MAX(episode)=episode;
  
--SELECT COUNT(*) FROM (..);  

  


