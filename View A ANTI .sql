
DROP VIEW PredictTVseriesContract;
DROP VIEW PredictTVseriesTaps;
DROP VIEW PredictTVseriesTapsMax;
DROP VIEW MaxTitle;
DROP VIEW SerieInfo;
DROP VIEW NextSerie;



CREATE OR REPLACE VIEW PredictTVseriesContract AS	
SELECT clientId, contractID 	
FROM  CLIENTS NATURAL JOIN  contracts;	


CREATE OR REPLACE VIEW PredictTVseriesTaps AS
SELECT clientId, title, episode, season, view_datetime	
FROM  PredictTVseriesContract 
NATURAL JOIN  taps_series;
--client with his views


CREATE OR REPLACE VIEW PredictTVseriesTapsMax AS	
SELECT clientId AS clientId1, title AS title1, max(view_datetime) AS mostRecent	
FROM  PredictTVseriesTaps
GROUP BY clientId,title;
--Last views of each client


CREATE OR REPLACE VIEW MaxTitle AS
SELECT clientId, title as title1, episode, season as season1, mostRecent	
FROM PredictTVseriesTapsMax 
JOIN PredictTVseriesTaps
ON (title=title1 
AND mostRecent= view_datetime
AND clientId = clientId1);
--Each client with the last views of each serie


CREATE OR REPLACE VIEW SerieInfo AS
SELECT title, season, episodes 
FROM SEASONS
ORDER BY title, season;
--The series with its max num of episodes per season


CREATE OR REPLACE VIEW premium AS
SELECT clientId, title1, episode, season1, mostRecent
from MaxTitle
ANTI JOIN SerieInfo
ON episode = episodes
where title1 = title
AND season1 = season
ORDER BY mostRecent desc;



CREATE OR REPLACE VIEW predictSerie AS
SELECT clientId, title1, (episode+1) AS nextEpisode, season1
from (SELECT * FROM(
SELECT clientId, title1, episode, season1, RANK() OVER 
(PARTITION BY clientId ORDER BY mostRecent desc) as ultimo
FROM premium)
WHERE ultimo = 1);
--4008

--3410


SELECT * FROM predictSerie;
SELECT * FROM NextSerie2;
SELECT * FROM NextSerie1;
SELECT * FROM NextSerie;
SELECT * FROM SerieInfo;
SELECT * FROM MaxTitle;	
SELECT * FROM PredictTVseriesContract;	
SELECT * FROM PredictTVseriesTaps;
SELECT * FROM PredictTVseriesTapsMax;




CREATE OR REPLACE VIEW predictSerie AS
 SELECT clientId, title1, (episode+1) AS nextEpisode, season1 from 
  (SELECT * FROM(
   SELECT clientId, title1, episode, season1, RANK() OVER 
   (PARTITION BY clientId ORDER BY mostRecent desc) as ultimo FROM (
     SELECT clientId, title1, episode, season1, mostRecent from (
       SELECT clientId, title as title1, episode, season as season1, mostRecent	FROM (
         SELECT clientId AS clientId1, title AS title1, max(view_datetime) AS mostRecent FROM  (
           SELECT clientId, title, episode, season, view_datetime	FROM (
             SELECT clientId, contractID 	FROM  CLIENTS NATURAL 
             JOIN  contracts)
           NATURAL JOIN  taps_series)
         GROUP BY clientId,title) 
       JOIN (
         SELECT clientId, title, episode, season, view_datetime	FROM  (
           SELECT clientId, contractID 	FROM 
           CLIENTS NATURAL JOIN  contracts)
         NATURAL JOIN  taps_series)
       ON (title=title1 AND mostRecent= view_datetime 
           AND clientId = clientId1))
     ANTI JOIN (
       SELECT title, season, episodes FROM 
       SEASONS ORDER BY title, season)
     ON episode = episodes
     where title1 = title
     AND season1 = season
     ORDER BY mostRecent desc))
   WHERE ultimo = 1);
