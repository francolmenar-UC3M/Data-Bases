SELECT name, surname, title, season
  FROM ((SELECT title, season FROM SEASONS) NATURAL JOIN 
       (SELECT title, season, client FROM lic_series) JOIN 
       clients ON clientId=client)
       GROUP BY name HAVING episodes=(SELECT max(episodes) FROM lic_series);
       
--178857--
  


