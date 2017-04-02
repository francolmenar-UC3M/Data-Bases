-- ----------------------------------------------------
-- -- Creation of the Top 5 stars involved in more   --
-- -- movies from USA --------------------------------
-- ----------------------------------------------------

DROP VIEW mostUSA;

CREATE VIEW mostUSA AS(
SELECT actor,
  rank() OVER (ORDER BY
(SELECT actor FROM
CASTS NATURAL JOIN MOVIES
GROUP BY actor) desc)
AS top_star
FROM CASTS
where top_star <= 5);

SELECT * FROM mostUSA;





DROP VIEW mostUSA2;

CREATE VIEW mostUSA2 AS(
SELECT actor FROM
CASTS NATURAL JOIN MOVIES
WHERE country='USA'
GROUP BY actor;

SELECT * FROM mostUSA2;
