DROP VIEW PredictTVseriesContract;
DROP VIEW PredictTVseriesTaps;
DROP VIEW PredictTVseriesTapsMax;
DROP VIEW MaxTitle;
DROP VIEW SerieInfo;
DROP VIEW NextSerie;



CREATE VIEW PredictTVseriesContract AS	
SELECT clientId, contractID 	
FROM  CLIENTS NATURAL JOIN  contracts;	


CREATE VIEW PredictTVseriesTaps AS
SELECT clientId, title, episode, season, view_datetime	
FROM  PredictTVseriesContract 
NATURAL JOIN  taps_series	
WHERE clientID='15/73766815/37T';


CREATE VIEW PredictTVseriesTapsMax AS	
SELECT title AS title1, max(view_datetime) AS mostRecent	
FROM  PredictTVseriesTaps 	
GROUP BY title;


CREATE VIEW MaxTitle AS
SELECT clientId, title, episode, season, mostRecent	
FROM PredictTVseriesTapsMax 
JOIN PredictTVseriesTaps
ON (title=title1 
AND mostRecent= view_datetime);



SELECT title, episode, season
FROM lic_series
where clietID = '15/73766815/37T'
ORDER BY title, seaon, episode;



CREATE VIEW NextSerie AS
SELECT clientId, title, episode, season
from MaxTitle
FOR UPDATE MaxTitle
OF episode = episode+1;




CREATE VIEW SerieInfo AS
SELECT title as title, season, total_seasons, episodes
FROM SERIES NATURAL JOIN 
(SELECT title, season, episodes 
FROM SEASONS
GROUP BY title,season)
ORDER BY title, season;



SELECT * FROM NextSerie;
SELECT * FROM SerieInfo;
SELECT * FROM MaxTitle;	
SELECT * FROM PredictTVseriesContract;	
SELECT * FROM PredictTVseriesTaps;
SELECT * FROM PredictTVseriesTapsMax;



Modern Family
         3          6 27-DEC-16

Breaking Bad
        13          3 09-JUL-16


15/73766815/37T
Cheers
        25          3 14-OCT-16
