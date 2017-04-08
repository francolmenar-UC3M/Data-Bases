CREATE OR REPLACE VIEW TopContent AS
SELECT clientId, product_name, tap_costs,month, view_datetime FROM(
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month, view_datetime
FROM taps_movies)
NATURAL JOIN contracts;


SELECT * FROM TopContent;s
