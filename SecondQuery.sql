-- ----------------------------------------------------
-- -- Creation of the Top 5 stars involved in more   --
-- -- movies from USA --------------------------------
-- ----------------------------------------------------
DROP VIEW join1;

CREATE VIEW join1 AS
SELECT DISTINCT actor, movie_title FROM
CASTS NATURAL JOIN MOVIES
WHERE country='USA';
--4424

DROP VIEW group1;

CREATE VIEW group1 AS
SELECT actor, count('x') top
FROM join1
GROUP BY actor;
--6249

DROP VIEW mostUSA;

CREATE VIEW mostUSA AS
SELECT * FROM(
SELECT actor,  rank() OVER (
ORDER BY top desc)
AS top_movie
FROM group1)
where top_movie <= 5);

SELECT * FROM mostUSA;


SELECT * FROM join1;
SELECT * FROM group1;
