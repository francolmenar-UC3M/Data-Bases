DROP TABLE products_pay CASCADE CONSTRAINTS;
DROP TABLE client CASCADE CONSTRAINTS;
DROP TABLE allTimeContracts CASCADE CONSTRAINTS;
DROP VIEW effectiveContracts;
DROP TABLE movies CASCADE CONSTRAINTS;
DROP TABLE TVseries CASCADE CONSTRAINTS;
DROP TABLE purchasesSeries CASCADE CONSTRAINTS;
DROP TABLE purchasesMovies CASCADE CONSTRAINTS;
DROP TABLE movies_taps CASCADE CONSTRAINTS;
DROP TABLE TVseries_taps CASCADE CONSTRAINTS;

DROP TABLE MOVIES CASCADE CONSTRAINTS;
DROP TABLE GENRES_MOVIES CASCADE CONSTRAINTS;
DROP TABLE keywords_movies CASCADE CONSTRAINTS;
DROP TABLE PLAYERS CASCADE CONSTRAINTS;
DROP TABLE CASTS CASCADE CONSTRAINTS;
DROP TABLE SERIES CASCADE CONSTRAINTS;
DROP TABLE SEASONS CASCADE CONSTRAINTS;
DROP TABLE CLIENTS CASCADE CONSTRAINTS;
DROP TABLE PRODUCTS CASCADE CONSTRAINTS;
DROP TABLE CONTRACTS CASCADE CONSTRAINTS;
DROP TABLE TAPS_MOVIES CASCADE CONSTRAINTS;
DROP TABLE TAPS_SERIES CASCADE CONSTRAINTS;
DROP TABLE LIC_MOVIES CASCADE CONSTRAINTS;
DROP TABLE LIC_SERIES CASCADE CONSTRAINTS;
DROP TABLE INVOICES CASCADE CONSTRAINTS;


-- ----------------------------------------------------
-- -- Creation of the projection of name and surname --
-- -- from client order by surname,name ---------------
-- ----------------------------------------------------
	CREATE TABLE CLIENTS (
clientId	VARCHAR2(15),
DNI		VARCHAR2(9),
name		VARCHAR2(100) NOT NULL,
surname		VARCHAR2(100) NOT NULL,
sec_surname	VARCHAR2(100),
eMail		VARCHAR2(100) NOT NULL,
phoneN		NUMBER(12),
birthdate	DATE,
CONSTRAINT PK_CLIENTS PRIMARY KEY (clientId),
CONSTRAINT UK1_CLIENTS UNIQUE (DNI),
CONSTRAINT UK2_CLIENTS UNIQUE (eMail),
CONSTRAINT UK3_CLIENTS UNIQUE (phoneN),
CONSTRAINT CH_CLIENTS CHECK (eMail LIKE '%@%.%')
);
	
	
	INSERT INTO clients (
   SELECT DISTINCT clientId, dni, name, surname, sec_surname, eMail, phoneN,
   to_date(birthdate,'YYYY-MM-DD')
   FROM fsdb.old_CONTRACTS);
   
-- 5000 rows


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


	CREATE TABLE products(
product_name 	VARCHAR2(25),
fee		NUMBER(3) NOT NULL,
type		VARCHAR2(1) NOT NULL,
tap_cost	NUMBER(4,2) NOT NULL,
zapp		NUMBER(2) DEFAULT 0 NOT NULL,
ppm		NUMBER(4,2) DEFAULT 0 NOT NULL,
ppd		NUMBER(4,2) DEFAULT 0 NOT NULL,
promo		NUMBER(3) DEFAULT 0 NOT NULL,
CONSTRAINT PK_products PRIMARY KEY (product_name),
CONSTRAINT CK_products1 CHECK (type IN ('C','V')),
CONSTRAINT CK_products2 CHECK (PROMO <= 100)
);
	
	INSERT INTO products VALUES('Free Rider',10,'C',2.5,5,0,0.95,5);
INSERT INTO products VALUES('Premium Rider',39,'V',0.5,0,0.01,0,3);
INSERT INTO products VALUES('TVrider',29,'C',2,8,0,0.5,0);
INSERT INTO products VALUES('Flat Rate Lover',39,'C',2.5,0,0,0,5);
INSERT INTO products VALUES('Short Timer',15,'C',2.5,5,0.01,0,3);
INSERT INTO products VALUES('Content Master',20,'C',1.75,4,1.02,0,3);
INSERT INTO products VALUES('Boredom Fighter',10,'V',1,1,0,0.95,0);
INSERT INTO products VALUES('Low Cost Rate',0,'V',0.95,4,0,1.45,3);
-- 1x8 rows



	CREATE TABLE contracts(
contractId VARCHAR2(10),
clientId  VARCHAR2(15),
startdate DATE NOT NULL,
enddate DATE,
contract_type VARCHAR2(50),
address		VARCHAR2(100) NOT NULL,
town		VARCHAR2(100) NOT NULL,
ZIPcode		VARCHAR2(8) NOT NULL,
country		VARCHAR2(100) NOT NULL,
CONSTRAINT PK_contracts PRIMARY KEY (contractId),
CONSTRAINT FK_contracts1 FOREIGN KEY (clientId) REFERENCES clientS ON DELETE SET NULL,
CONSTRAINT FK_contracts2 FOREIGN KEY (contract_type) REFERENCES products,
CONSTRAINT CK_contracts CHECK (startdate<=enddate)
);
	
	
INSERT INTO contracts (
SELECT contractId, clientId, TO_DATE(startdate,'YYYY-MM-DD'), TO_DATE(enddate,'YYYY-MM-DD'), contract_type, address, town, ZIPcode, country FROM fsdb.old_contracts);
-- 7013 rows
	
