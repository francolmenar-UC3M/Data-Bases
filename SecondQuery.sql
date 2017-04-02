-- ----------------------------------------------------
-- -- Creation of the Top 5 stars involved in more   --
-- -- movies from USA --------------------------------
-- ----------------------------------------------------

DROP VIEW mostUSA;

CREATE VIEW mostUSA AS
	SELECT movie_title,
  rank() OVER (ORDER BY imdb_score desc)
  AS top_star
	FROM movies;

SELECT * FROM mostUSA;
