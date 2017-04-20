 CREATE OR REPLACE VIEW predictSerie AS(
  SELECT clientId, title, (episode+1) AS nextEpisode, season FROM(
   SELECT clientId, title, episode, season, validation, RANK() OVER (PARTITION BY clientId ORDER BY mostRecent desc) as ultimo FROM (
   SELECT clientId, title, episode, season, validation, mostRecent from (
   SELECT clientId, title, episode, episodes, season, mostRecent,
   CASE WHEN episode = episodes THEN 'invalid' 
   ELSE 'valid'
   END AS Validation FROM (
    SELECT clientId, title, episode, episodes, season, mostRecenT from (
     SELECT clientId, title, episode, season, mostRecent  FROM (
      SELECT clientId AS clientId1, title AS title1, max(view_datetime) AS mostRecent FROM (
       SELECT clientId, title, episode, season, view_datetime	FROM(
        SELECT clientId, contractID FROM 
		CLIENTS 
		NATURAL JOIN  contracts) 
	   NATURAL JOIN  taps_series)
	  GROUP BY clientId,title) 
	 JOIN (
	  SELECT clientId, title, episode, season, view_datetime FROM( 
	   SELECT clientId, contractID FROM 
	   CLIENTS 
	 NATURAL JOIN  contracts) 
    NATURAL JOIN  taps_series)
   ON (title=title1  AND mostRecent= view_datetime
   AND clientId = clientId1))
  NATURAL JOIN (SELECT title, season, episodes  FROM SEASONS
  ORDER BY title, season)))
  WHERE Validation = 'valid'))
 WHERE ultimo = 1);
