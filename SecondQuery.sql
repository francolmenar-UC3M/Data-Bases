-- ----------------------------------------------------
-- -- Creation of the Top 5 stars involved in more   --
-- -- movies from USA --------------------------------
-- ----------------------------------------------------
DROP TABLE topActors;

CREATE TABLE topActors(
  actor_name   VARCHAR2(50),
  ranking NUMBER(1),
  CONSTRAINT PK_topActors PRIMARY KEY (actor_name),
  CONSTRAINT FK1_topActors FOREIGN KEY (actor_name) REFERENCES PLAYERS ON DELETE CASCADE
);

INSERT INTO topActors
SELECT actor_name, top_movie
FROM (SELECT * FROM(
SELECT actor_name,  rank() OVER (
ORDER BY top desc)
AS top_movie
FROM(
SELECT actor_name, count(actor_name) top
FROM(
SELECT DISTINCT actor_name, title FROM
PLAYERS INNER JOIN(
CASTS INNER JOIN MOVIES
ON CASTS.title = MOVIES.movie_title)
ON PLAYERS.actor_name = CASTS.actor
WHERE country='USA')
GROUP BY actor_name))
where top_movie <= 5);


SELECT * FROM topActors;
