-- ----------------------------------------------------
-- -- Creation of the Top 5 stars involved in more   --
-- -- movies from USA --------------------------------
-- ----------------------------------------------------
DROP VIEW join1;

CREATE VIEW join1 AS
SELECT DISTINCT actor, movie_title FROM
CASTS NATURAL JOIN MOVIES
WHERE country='USA';

SELECT * FROM join1;


DROP VIEW group1;

CREATE VIEW group1 AS
SELECT actor, count('x') top
FROM join1
GROUP BY actor;

SELECT * FROM group1;



DROP VIEW mostUSA;

CREATE VIEW mostUSA AS
SELECT actor,  rank() OVER (
ORDER BY top) desc)
AS top_star
FROM group1
where top_star <= 5);

SELECT * FROM mostUSA;
