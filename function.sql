CREATE OR REPLACE VIEW TopContent AS
SELECT contractId, product_name,(tap_cost*2) as tap_costMovies,month FROM(
SELECT clientId, contractId, contract_type, month FROM(
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month
FROM taps_movies)
NATURAL JOIN contracts)
JOIN products ON
contract_type = product_name;


SELECT * FROM TopContent;
