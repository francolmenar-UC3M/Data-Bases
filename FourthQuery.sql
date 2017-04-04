SELECT actor, month, maxT
  select count(*)
  FROM CASTS JOIN taps_movies ON CASTS.title=taps_movies.title
  GROUP BY (actor, month)


to_char()
