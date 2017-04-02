-- ----------------------------------------------------
-- -- Creation of the Top 5 stars involved in more   --
-- -- movies from USA --------------------------------
-- ----------------------------------------------------
DROP VIEW mostUSA;

CREATE VIEW mostUSA AS
	SELECT * FROM(
	SELECT movie_title,imdb_score,
  rank() OVER (ORDER BY imdb_score desc)
  AS top_star
	FROM movies)
	where top_star <= 5;

SELECT * FROM mostUSA;
