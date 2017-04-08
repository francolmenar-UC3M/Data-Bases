CREATE OR REPLACE VIEW TopContentMovie AS
SELECT clientId, product_name, tap_costMovies, tap_cost, month FROM(
SELECT contractId, product_name,(tap_cost*2) as tap_costMovies,month FROM(
SELECT clientId, contractId, contract_type, month FROM(
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month
FROM taps_movies)
NATURAL JOIN contracts)
JOIN products ON
contract_type = product_name)
JOIN (
SELECT contractId, product_name,tap_cost as tap_costMovies,month FROM(
SELECT clientId, contractId, contract_type, month FROM(
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month
FROM taps_series)
NATURAL JOIN contracts)
JOIN products ON
contract_type = product_name)
ON clientId = clientId;




SELECT * FROM TopContentMovie;
SELECT * FROM TopContentSerie;
