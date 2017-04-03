SELECT name, surname, title, season
  FROM (SEASONS JOIN lic_series ON (episodes=COUNT(episode) AND seasons=season)
       JOIN clients ON clientId=client)
  GROUP BY title;
       
--178857--
  


