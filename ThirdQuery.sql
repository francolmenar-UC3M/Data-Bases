SELECT name, surname, SEASONS.title, SEASONS.season
  FROM (SEASONS JOIN lic_series ON (SEASONS.episodes=lic_series.episode AND SEASONS.season=lic_series.season)
       JOIN clients ON clientId=client)
  GROUP BY SEASONS.title HAVING COUNT(lic_series.season)=max(SEASONS.episode);
  
--SELECT COUNT(*) FROM (..);  
--279446--
  


