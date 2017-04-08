CREATE OR REPLACE VIEW TopContentMovies AS
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month, view_datetime
FROM taps_movies;
--taps with its views

CREATE OR REPLACE VIEW contentContractMovies AS
SELECT title, month, view_datetime, contract_type
from TopContent
NATURAL JOIN contracts;


CREATE OR REPLACE VIEW contentProduct AS
SELECT title, month, view_datetime, (tap_cost*2) as tap_costMovies
from contentContract
JOIN products
ON contract_type = product_name;


CREATE OR REPLACE VIEW TopContentSerie AS
SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month, view_datetime
FROM taps_movies;
--taps with its views

CREATE OR REPLACE VIEW contentContractSerie AS
SELECT title, month, view_datetime, contract_type
from TopContent
NATURAL JOIN contracts;


COMO EN LA 4 QUERY

SELECT * FROM TopContentMovies;
SELECT * FROM contentContractMovies;
SELECT * FROM contentProduct;
SELECT * FROM amount;
