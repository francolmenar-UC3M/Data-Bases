-- ----------------------------------------------------
-- -- Creation of the projection of name and surname --
-- -- from client order by surname,name ---------------
-- ----------------------------------------------------
DROP TABLE current_clients;

CREATE TABLE current_clients(
clientId	VARCHAR2(15),
name		VARCHAR2(100) NOT NULL,
surname		VARCHAR2(100) NOT NULL,
startdate DATE NOT NULL,
enddate DATE,
type VARCHAR2(1),
CONSTRAINT PK_current_clients PRIMARY KEY (clientId),
CONSTRAINT FK_current_clients1 FOREIGN KEY (clientId) REFERENCES clients,
CONSTRAINT CK_current_clients6 CHECK (type IN ('C','V'))
);


 INSERT INTO current_clients
	SELECT clientId, name, surname, startdate, enddate, type
	FROM 
	(SELECT name, surname , clientId
	FROM clients
	ORDER BY surname, name) 
	NATURAL JOIN 
	(SELECT startdate, enddate, contract_type, clientId
	FROM contracts
	WHERE (sysdate BETWEEN enddate AND startdate) OR (sysdate => startdate AND enddate IS NULL))
	       JOIN products ON product_name=contract_type;
--2258--

SELECT * FROM current_clients;
