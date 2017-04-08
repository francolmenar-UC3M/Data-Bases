CREATE OR REPLACE VIEW TopContentMovie AS
SELECT clientId, product_name1, tap_costMovies, tap_cost, month FROM(
SELECT contractId, product_name AS product_name1,(tap_cost*2) as tap_costMovies,month FROM(
SELECT clientId, contractId, contract_type, month FROM(
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month
FROM taps_movies)
NATURAL JOIN contracts)
JOIN products ON
contract_type = product_name)
JOIN (
SELECT contractId AS contracts, product_name,tap_cost,month1 FROM(
SELECT clientId, contractId, contract_type, month1 FROM(
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month1
FROM taps_series)
NATURAL JOIN contracts)
JOIN products ON
contract_type = product_name)
ON contractId = contracts;




SELECT * FROM TopContentMovie;
SELECT * FROM TopContentSerie;
