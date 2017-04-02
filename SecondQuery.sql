-- ----------------------------------------------------
-- -- Creation of the Top 5 stars involved in more   --
-- -- movies from USA --------------------------------
-- ----------------------------------------------------

DROP VIEW mostUSA;

CREATE VIEW mostUSA AS
	SELECT * FROM(
	SELECT actor,
  rank() OVER (ORDER BY
    (SELECT actor_name FROM
    CASTS NATURAL JOIN MOVIES
    GROUP BY actor_name) desc)
  AS top_star
	FROM CAST)
	where top_star <= 5;

SELECT * FROM mostUSA;
