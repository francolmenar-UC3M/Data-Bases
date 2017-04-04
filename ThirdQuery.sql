SELECT name, surname, SEASONS.title, SEASONS.season
  FROM (SELECT COUNT(episode) FROM (SEASONS NATURAL JOIN lic_series))
  GROUP BY SEASONS.season, name, surname HAVING MAX(episode)=episode;
  
--SELECT COUNT(*) FROM (..);  

  


