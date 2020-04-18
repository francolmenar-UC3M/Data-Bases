CREATE OR REPLACE PROCEDURE bill (clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) IS
CURSOR bill_movie IS
SELECT clientId,contractId, product_name AS product_name1,(tap_cost*2) as tap_costMovies,month FROM(
SELECT clientId, contractId, contract_type, month FROM(
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month
FROM taps_movies)
NATURAL JOIN contracts);
CURSOR bill_serie IS
SELECT clientId as client1,contractId AS contracts, product_name,tap_cost,month1 FROM(
SELECT clientId, contractId, contract_type, month1 FROM(
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month1
FROM taps_series)
NATURAL JOIN contracts);

BEGIN






SELECT * FROM TopContentMovie;
SELECT * FROM TopContentSerie;
