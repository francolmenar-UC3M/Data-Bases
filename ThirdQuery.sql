SELECT name, surname, SEASONS.title, SEASONS.season
  FROM ((SEASONS JOIN lic_series ON SEASONS.episodes=lic_series.episode)
  JOIN CLIENTS ON clientId=client)
  GROUP BY SEASONS.season HAVING max(episodes)=episode;
  


  


