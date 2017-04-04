SELECT name, surname, SEASONS.title, SEASONS.season
  FROM ((SELECT season, title, episode FROM SEASONS) 
        JOIN (SELECT season, title, episodes FROM lic_series) ON SEASONS.season=lic_series.season AND SEASONS.title=lic_series.title)
       JOIN clients ON clientId=client
  GROUP BY SEASONS.season HAVING MAX(episode)=episode;
  
--SELECT COUNT(*) FROM (..);  

  


