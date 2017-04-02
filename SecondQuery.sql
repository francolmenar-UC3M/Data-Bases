-- ----------------------------------------------------
-- -- Creation of the Top 5 stars involved in more   --
-- -- movies from USA --------------------------------
-- ----------------------------------------------------

DROP VIEW mostUSA;

CREATE VIEW mostUSA AS(
SELECT actor,
  rank() OVER (ORDER BY
mostUSA2) desc)
AS top_star
FROM CASTS
where top_star <= 5);

SELECT * FROM mostUSA;



DROP VIEW join1;

CREATE VIEW join1 AS
SELECT actor, movie_title FROM
CASTS NATURAL JOIN (MOVIES
WHERE country='USA');

SELECT * FROM join1;




DROP VIEW mostUSA2;

CREATE VIEW mostUSA2 AS(
SELECT actor, count('x') top FROM(
CASTS NATURAL JOIN (MOVIES
WHERE country='USA'))
GROUP BY actor);

SELECT * FROM mostUSA2;
