CREATE OR REPLACE VIEW contentProductMovies AS
SELECT title, month, top FROM
 (SELECT  month, max(pay) as top FROM
  (SELECT title, month, (tap_costMovies * times) as pay FROM
   (SELECT title, month, (tap_cost*2) as tap_costMovies, COUNT(month) as times from
    (SELECT title, month, contract_type from
      (SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month FROM
      taps_movies)
      NATURAL JOIN contracts)
    JOIN products
    ON contract_type = product_name
  GROUP BY title, month, (tap_cost*2)))
 GROUP BY month)
NATURAL JOIN (SELECT title, month, (tap_costMovies * times) as pay1 FROM
 (SELECT title, month, (tap_cost*2) as tap_costMovies, COUNT(month) as times from
  (SELECT title, month, contract_type from
   (SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month FROM taps_movies)
  NATURAL JOIN contracts)
  JOIN products
  ON contract_type = product_name
 GROUP BY title, month, (tap_cost*2)))
WHERE top = pay1;


CREATE OR REPLACE VIEW contentProductSerie AS
SELECT title as title1,episode, season, month as month1, top as top1 FROM
 (SELECT  month, max(pay) as top FROM
  (SELECT title,episode, season, month, (tap_cost * times) as pay FROM
   (SELECT title,episode, season, month, tap_cost, COUNT(month) as times from
    (SELECT title,episode, season, month, contract_type from
      (SELECT title, episode, season, contractId, to_char(view_datetime, 'MON-YYYY') AS month FROM
      taps_series)
      NATURAL JOIN contracts)
    JOIN products
    ON contract_type = product_name
  GROUP BY title,episode, season, month, tap_cost))
 GROUP BY month)
NATURAL JOIN (SELECT title,episode, season, month, (tap_cost * times) as pay1 FROM
   (SELECT title,episode, season, month, tap_cost, COUNT(month) as times from
    (SELECT title,episode, season, month, contract_type from
      (SELECT title, episode, season, contractId, to_char(view_datetime, 'MON-YYYY') AS month FROM
      taps_series)
      NATURAL JOIN contracts)
    JOIN products
    ON contract_type = product_name
  GROUP BY title,episode, season, month, tap_cost))
WHERE top = pay1;

CREATE OR REPLACE VIEW junto AS
SELECT * FROM contentProductMovies
FULL OUTER JOIN contentProductSerie
ON month = month1;

CREATE OR REPLACE VIEW fuck AS 
SELECT MAX(top) as jd FROM(
SELECT top from junto
UNION
SELECT top1 FROM junto);


SELECT * FROM contentProductMovies;
SELECT * FROM contentProductSerie;

SELECT * FROM junto;

SELECT * FROM fuck;
