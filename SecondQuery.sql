-- ----------------------------------------------------
-- -- Creation of the Top 5 stars involved in more   --
-- -- movies from USA --------------------------------
-- ----------------------------------------------------
DROP VIEW join1;
DROP VIEW group1;
DROP VIEW mostUSA;
DROP TABLE topActors;


CREATE VIEW group1 AS(
SELECT actor_name, count(actor_name) top
FROM(
SELECT DISTINCT actor_name, title FROM
PLAYERS INNER JOIN(
CASTS INNER JOIN MOVIES
ON CASTS.title = MOVIES.movie_title)
ON PLAYERS.actor_name = CASTS.actor
WHERE country='USA'));
--11103


CREATE VIEW group1 AS
SELECT actor_name, count(actor_name) top
FROM join1
GROUP BY actor_name;
--4673


CREATE VIEW mostUSA AS
SELECT * FROM(
SELECT actor_name,  rank() OVER (
ORDER BY top desc)
AS top_movie
FROM group1)
where top_movie <= 5;



CREATE TABLE topActors(
  actor_name   VARCHAR2(50),
  ranking NUMBER(1),
  CONSTRAINT PK_topActors PRIMARY KEY (actor_name),
  CONSTRAINT FK1_topActors FOREIGN KEY (actor_name) REFERENCES PLAYERS ON DELETE CASCADE
);

INSERT INTO topActors
SELECT actor_name, top_movie
FROM mostUSA;


SELECT * FROM topActors;


SELECT * FROM mostUSA;
SELECT * FROM join1;
SELECT * FROM group1;
