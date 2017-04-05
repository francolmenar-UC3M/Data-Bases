DROP VIEW PredictTVseriesContract;
DROP VIEW PredictTVseriesTaps;

CREATE VIEW PredictTVseriesContract AS
	SELECT clientId, contractID 
	FROM  CLIENTS NATURAL JOIN  contracts;	



CREATE VIEW PredictTVseriesTaps AS
	SELECT clientId, title, episode, season
	FROM  PredictTVseriesContract NATURAL JOIN  taps_series
	WHERE clientID='15/73766815/37T';
	
CREATE VIEW PredictTVseriesTapsMax AS
	SELECT clientId, title, episode, season
	FROM  PredictTVseriesTaps 
	WHERE view_datetime= (SELECT max(view_datetime)
		from taps_series
		WHERE clientID='15/73766815/37T');
	
	
	SELECT max(view_datetime)
		from taps_series
		WHERE clientID='15/73766815/37T';
	
	SELECT * FROM PredictTVseriesContract;
	SELECT * FROM PredictTVseriesTaps;