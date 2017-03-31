
-- ----------------------------------------------------
-- -- Creation of the projection of name and surname --
-- -- from client order by surname,name ---------------
-- ----------------------------------------------------

DROP VIEW clientsByName;

CREATE VIEW clientsByName AS
	SELECT name, surname , clientId
	FROM clients
	ORDER BY surname, name;
--5000
	
SELECT * FROM clientsByName;

	
DROP VIEW contractView;

CREATE VIEW contractView AS
	SELECT startdate, enddate, contract_type, clientId
	FROM contracts
	WHERE sysdate < enddate;
--2157

SELECT * FROM contractView;

DROP VIEW query1;

CREATE VIEW query1 AS
	SELECT * 
	FROM clientsByName NATURAL JOIN contractView;
--2157
	
SELECT * FROM query1;

