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
contract_type VARCHAR2(50),
CONSTRAINT PK_current_clients PRIMARY KEY (clientId),
CONSTRAINT FK_current_clients1 FOREIGN KEY (clientId) REFERENCES clients,
CONSTRAINT FK_current_clients6 FOREIGN KEY (contract_type) REFERENCES products
);


 INSERT INTO current_clients
	SELECT clientId, name, surname, startdate, enddate, contract_type
	FROM ((
	SELECT name, surname , clientId
	FROM clients
	ORDER BY surname, name) NATURAL JOIN (
		SELECT startdate, enddate, contract_type, clientId
	FROM contracts
	WHERE sysdate < enddate));
--2140--

SELECT * FROM current_clients;
