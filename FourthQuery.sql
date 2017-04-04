SELECT actor, month, MAX
SELECT MAX(*) FROM (SELECT COUNT(*)
       FROM CASTS JOIN taps_movies ON CASTS.title=taps_movies.title
       (SELECT DATEPART(mm,view_datetime) AS month FROM taps_movies)
       GROUP BY (actor, month));



