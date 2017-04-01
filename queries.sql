
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

DROP TABLE current_clients;

CREATE TABLE current_clients(
clientId	VARCHAR2(15),
name		VARCHAR2(100) NOT NULL,
surname		VARCHAR2(100) NOT NULL,
startdate DATE,
enddate DATE,
contract_type VARCHAR2(50),
CONSTRAINT PK_current_clients PRIMARY KEY (clientId),
CONSTRAINT FK_current_clients1 FOREIGN KEY (clientId) REFERENCES clients,
CONSTRAINT FK_current_clients2 FOREIGN KEY (name) REFERENCES clients,
CONSTRAINT FK_current_clients3 FOREIGN KEY (surname) REFERENCES clients,
CONSTRAINT FK_current_clients4 FOREIGN KEY (startdate) REFERENCES contracts,
CONSTRAINT FK_current_clients5 FOREIGN KEY (enddate) REFERENCES contracts,
CONSTRAINT FK_current_clients6 FOREIGN KEY (contract_type) REFERENCES contracts
);
 INSERT INTO current_clients
	SELECT *
	FROM clientsByName NATURAL JOIN contractView;

DROP VIEW query1;

CREATE VIEW query1 AS
	SELECT *
	FROM clientsByName NATURAL JOIN contractView;
--2157

SELECT * FROM query1;
