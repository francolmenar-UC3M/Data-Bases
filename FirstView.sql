DROP VIEW PredictTVseriesContract;
DROP VIEW PredictTVseriesTaps;
DROP VIEW PredictTVseriesTapsMax;



CREATE VIEW PredictTVseriesContract AS	
SELECT clientId, contractID 	
FROM  CLIENTS NATURAL JOIN  contracts;	


CREATE VIEW PredictTVseriesTaps AS
SELECT clientId, title, episode, season, view_datetime	
FROM  PredictTVseriesContract 
NATURAL JOIN  taps_series	
WHERE clientID='15/73766815/37T';


CREATE VIEW PredictTVseriesTapsMax AS	
SELECT title, max(view_datetime) AS mostRecent	
FROM  PredictTVseriesTaps 	
GROUP BY title;


	
SELECT * FROM PredictTVseriesContract;
	
SELECT * FROM PredictTVseriesTaps;
SELECT * FROM PredictTVseriesTapsMax;	
