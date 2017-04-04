SELECT actor_name, top_movie
  FROM (SELECT * FROM (SELECT actor_name,  rank() OVER (ORDER BY top desc)
    AS top_movie FROM (SELECT actor_name, count(actor_name) top
      FROM (SELECT DISTINCT actor_name, title FROM PLAYERS INNER JOIN (CASTS INNER JOIN MOVIES ON CASTS.title = MOVIES.movie_title)
        ON PLAYERS.actor_name = CASTS.actor
      WHERE country='USA')
    GROUP BY actor_name))
  WHERE top_movie <= 5);
  
  --5--


