-- ----------------------------------------------------
-- ----------------------------------------------------
-- -- TABLES CREATION SCRIPT -- ASSIGNMENT SOLUTION ---
-- ----------------------------------------------------
-- ----------------------------------------------------
-- -- Course: File Structures and DataBases -----------
-- ----------------------------------------------------
-- -- (c) 2017 Dolores Cuadra & Javier Calle ----------
-- ------ Carlos III University of Madrid -------------
-- ----------------------------------------------------


-- ----------------------------------------------------
-- -- Part I: Destroy (in case) existent tables -------
-- ----------------------------------------------------

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
-- -- Part II: Create all tables ----------------------
-- ----------------------------------------------------

CREATE TABLE MOVIES(
movie_title       VARCHAR2(100),
title_year        NUMBER(4),
country           VARCHAR2(25),
color             VARCHAR2(1),
duration          NUMBER(3) NOT NULL,
gross             NUMBER(10),
budget            NUMBER(12),
director_name     VARCHAR2(50) DEFAULT 'Anonymous',
filming_language  VARCHAR2(20),
num_critic_for_reviews    NUMBER(6),
director_facebook_likes   NUMBER(6),
num_voted_users           NUMBER(7),
num_user_for_reviews      NUMBER(6),
cast_total_facebook_likes NUMBER(6),
facenumber_in_poster      NUMBER(6),
movie_imdb_link           VARCHAR2(60),
imdb_score                NUMBER(2,1),
content_rating            VARCHAR2(9),
aspect_ratio              NUMBER(4,2) ,
movie_facebook_likes      NUMBER(6),
CONSTRAINT MOVIES_PK PRIMARY KEY (movie_title),
CONSTRAINT MOVIES_CH CHECK (COLOR IN ('B','C', null))
);


CREATE TABLE GENRES_MOVIES (
title	VARCHAR2(100),
genre	VARCHAR2(70),
CONSTRAINT PK_GENRES_MOVIES PRIMARY KEY (title,genre),
CONSTRAINT FK_GENRES_MOVIES FOREIGN KEY (title) REFERENCES MOVIES ON DELETE CASCADE
);


CREATE TABLE keywords_movies (
title		VARCHAR2(100),
keyword		VARCHAR2(150),
CONSTRAINT PK_KEYWORDS_MOVIES PRIMARY KEY (title,keyword),
CONSTRAINT FK_KEYWORDS_MOVIES FOREIGN KEY (title) REFERENCES MOVIES ON DELETE CASCADE
);


CREATE TABLE PLAYERS (
actor_name      VARCHAR2(50),
facebook_likes  NUMBER(6,0),
CONSTRAINT ACTORS_PK PRIMARY KEY (actor_name));


CREATE TABLE CASTS (
actor   VARCHAR2(50),
title   VARCHAR2(100),
CONSTRAINT PK_CASTS PRIMARY KEY (actor, title),
CONSTRAINT FK1_CASTS FOREIGN KEY (actor) REFERENCES PLAYERS ON DELETE CASCADE,
CONSTRAINT FK2_CASTS FOREIGN KEY (title) REFERENCES MOVIES ON DELETE CASCADE);


CREATE TABLE SERIES(
title        	VARCHAR2(100),
total_seasons 	NUMBER(3) NOT NULL,
CONSTRAINT PK_SERIES PRIMARY KEY (title)
);


CREATE TABLE SEASONS(
title        	VARCHAR2(100),
season 		NUMBER(3),
avgduration	NUMBER(3) NOT NULL,
episodes 	NUMBER(3) NOT NULL,
CONSTRAINT PK_SEASONS PRIMARY KEY (title, season),
CONSTRAINT FK_SEASONS FOREIGN KEY (title) REFERENCES SERIES ON DELETE CASCADE
);


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


CREATE TABLE taps_movies(
contractId VARCHAR2(10),
view_datetime DATE,
pct	NUMBER(3) DEFAULT 0 NOT NULL,
title VARCHAR2(100) NOT NULL,
CONSTRAINT PK_tapsM PRIMARY KEY (contractId,title,view_datetime),
CONSTRAINT FK_tapsM1 FOREIGN KEY (contractId) REFERENCES contracts,
CONSTRAINT FK_tapsM2 FOREIGN KEY (title) REFERENCES movies
);


CREATE TABLE taps_series(
contractId VARCHAR2(10),
view_datetime DATE,
pct	NUMBER(3) DEFAULT 0 NOT NULL,
title VARCHAR2(100) NOT NULL,
season  NUMBER(3) NOT NULL,
episode NUMBER(3) NOT NULL,
CONSTRAINT PK_tapsS PRIMARY KEY (contractId,title,season,episode,view_datetime),
CONSTRAINT FK_tapsS1 FOREIGN KEY (contractId) REFERENCES contracts,
CONSTRAINT FK_tapsS2 FOREIGN KEY (title,season) REFERENCES seasons
);


CREATE TABLE lic_movies(
client VARCHAR2(15),
datetime DATE,
title VARCHAR2(100) NOT NULL,
CONSTRAINT PK_licsM PRIMARY KEY (client,title),
CONSTRAINT FK_licsM1 FOREIGN KEY (title) REFERENCES movies,
CONSTRAINT FK_licsM2 FOREIGN KEY (client) REFERENCES clients ON DELETE CASCADE
);


CREATE TABLE lic_series(
client VARCHAR2(15),
datetime DATE,
title VARCHAR2(100) NOT NULL,
season  NUMBER(3) NOT NULL,
episode NUMBER(3) NOT NULL,
CONSTRAINT PK_licsS PRIMARY KEY (client,title,season,episode),
CONSTRAINT FK_licsS1 FOREIGN KEY (title,season) REFERENCES seasons,
CONSTRAINT FK_licsS2 FOREIGN KEY (client) REFERENCES clients ON DELETE CASCADE
);


CREATE TABLE invoices(
contractId VARCHAR2(10),
month  NUMBER(2) ,
year  NUMBER(4) ,
inv_date DATE,
amount NUMBER(8,2) NOT NULL,
CONSTRAINT PK_invcs PRIMARY KEY (contractId,month,year),
CONSTRAINT FK_invcs FOREIGN KEY (contractId) REFERENCES contracts
);




-- ----------------------------------------------------
-- -- Annex: Create supplementary validation table ----
-- ----------------------------------------------------

-- DROP TABLE GENRES_MOVIES CASCADE CONSTRAINTS;
--
-- CREATE TABLE GENRES (
--   genre	VARCHAR2(70),
--   CONSTRAINT PK_GENRES PRIMARY KEY (genre)
-- );
--
-- ALTER TABLE GENRES_MOVIES ADD CONSTRAINT FK_GENRES_MOVIES_2 FOREIGN KEY (genre) REFERENCES GENRES ON DELETE CASCADE;
--
