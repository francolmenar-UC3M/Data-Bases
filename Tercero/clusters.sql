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

DROP CLUSTER titleM;
DROP CLUSTER cliente;
--DROP CLUSTER contract;

--DROP CLUSTER titleS;

DROP INDEX t_movie;
DROP INDEX t_cliente;
DROP INDEX i_sed; 
DROP INDEX cry; 
DROP INDEX dur; 
DROP INDEX series; 
DROP INDEX viewsM; 
DROP INDEX viewsS;
DROP INDEX lic_movie;
DROP INDEX lic_serie;

--DROP INDEX t_contract;
--DROP INDEX t_series;

-- ----------------------------------------------------
-- -- Part II: Create all tables ----------------------
-- ----------------------------------------------------

CREATE CLUSTER titleM (movie_title VARCHAR2(100)); 
CREATE CLUSTER cliente (clientId VARCHAR2(15));

--CREATE CLUSTER contract (contractId VARCHAR2(10));
--CREATE CLUSTER series (title VARCHAR2(100), season NUMBER(3), episodes NUMBER(3));
--CREATE CLUSTER titleS (title VARCHAR2(100)); 

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
)CLUSTER titleM (movie_title);


CREATE TABLE GENRES_MOVIES (
title	VARCHAR2(100),
genre	VARCHAR2(70),
CONSTRAINT PK_GENRES_MOVIES PRIMARY KEY (title,genre),
CONSTRAINT FK_GENRES_MOVIES FOREIGN KEY (title) REFERENCES MOVIES ON DELETE CASCADE
)CLUSTER titleM (title);


CREATE TABLE keywords_movies (
title		VARCHAR2(100),
keyword		VARCHAR2(150),
CONSTRAINT PK_KEYWORDS_MOVIES PRIMARY KEY (title,keyword),
CONSTRAINT FK_KEYWORDS_MOVIES FOREIGN KEY (title) REFERENCES MOVIES ON DELETE CASCADE
)CLUSTER titleM (title);


CREATE TABLE PLAYERS (
actor_name      VARCHAR2(50),
facebook_likes  NUMBER(6,0),
CONSTRAINT ACTORS_PK PRIMARY KEY (actor_name)
);


CREATE TABLE CASTS (
actor   VARCHAR2(50),
title   VARCHAR2(100),
CONSTRAINT PK_CASTS PRIMARY KEY (actor, title),
CONSTRAINT FK1_CASTS FOREIGN KEY (actor) REFERENCES PLAYERS ON DELETE CASCADE,
CONSTRAINT FK2_CASTS FOREIGN KEY (title) REFERENCES MOVIES ON DELETE CASCADE
)CLUSTER titleM (title);

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
)CLUSTER cliente (clientId);

CREATE TABLE products(
product_name 	VARCHAR2(50),
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
)CLUSTER cliente (clientId); 

CREATE TABLE taps_movies(
contractId VARCHAR2(10),
view_datetime DATE,
pct	NUMBER(3) DEFAULT 0 NOT NULL,
title VARCHAR2(100) NOT NULL,
CONSTRAINT PK_tapsM PRIMARY KEY (contractId,title,view_datetime),
CONSTRAINT FK_tapsM1 FOREIGN KEY (contractId) REFERENCES contracts,
CONSTRAINT FK_tapsM2 FOREIGN KEY (title) REFERENCES movies
)CLUSTER titleM (title);

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
)CLUSTER cliente (client); 

CREATE TABLE lic_series(
client VARCHAR2(15),
datetime DATE,
title VARCHAR2(100) NOT NULL,
season  NUMBER(3) NOT NULL,
episode NUMBER(3) NOT NULL,
CONSTRAINT PK_licsS PRIMARY KEY (client,title,season,episode),
CONSTRAINT FK_licsS1 FOREIGN KEY (title,season) REFERENCES seasons,
CONSTRAINT FK_licsS2 FOREIGN KEY (client) REFERENCES clients ON DELETE CASCADE
)CLUSTER cliente (client); 

CREATE TABLE invoices(
clientId VARCHAR2(15),  
month  VARCHAR2(2) ,
year  VARCHAR2(4) ,
amount NUMBER(8,2) NOT NULL,
CONSTRAINT PK_invcs PRIMARY KEY (clientId,month,year),
CONSTRAINT FK_invcs FOREIGN KEY (clientId) REFERENCES clients
)CLUSTER cliente (clientId);  

------------------------------ INDEXES ------------------------------

CREATE INDEX t_movie ON CLUSTER titleM;
CREATE INDEX t_cliente ON CLUSTER cliente;
CREATE INDEX i_sed ON contracts(startdate, enddate);
CREATE INDEX cry ON movies (country, duration);
CREATE INDEX series ON seasons(title, episodes, season); 
CREATE INDEX viewsM ON taps_movies(view_datetime, pct); 
CREATE INDEX viewsS ON taps_series(view_datetime, pct); 
CREATE INDEX dur ON seasons (avgduration); 
--CREATE INDEX lic_movie ON lic_movies(client, title, datetime); 
--CREATE INDEX lic_serie ON lic_series(client, title, season, episode, datetime); 

--CREATE INDEX t_contract ON CLUSTER contract;
--CREATE INDEX i_sed ON contracts(startdate, enddate) TABLESPACE tabsp_2k;
--CREATE INDEX t_series ON CLUSTER titleS;

------------------------------ INSERTS -------------------------------

INSERT INTO movies 
(movie_title, 
title_year,  
country,
color,
duration,
gross,
budget,
director_name,
filming_language,
num_critic_for_reviews,director_facebook_likes,
num_voted_users,num_user_for_reviews, cast_total_facebook_likes,facenumber_in_poster,
movie_imdb_link,imdb_score,content_rating,aspect_ratio,movie_facebook_likes)
SELECT movie_title,
TO_NUMBER(title_year),
country,
CASE WHEN color='Black and White' THEN 'B' WHEN color='Color' THEN 'C' ELSE null END,
 duration,
	gross,
	budget,
	director_name,
	filming_language	,
	num_critic_for_reviews,director_facebook_likes,
 num_voted_users,num_user_for_reviews, cast_total_facebook_likes,facenumber_in_poster,
 movie_imdb_link,TO_NUMBER(imdb_score,'9.9'),content_rating,TO_NUMBER(aspect_ratio,'99.99'),movie_facebook_likes
FROM FSDB.old_movies;
-- 4913 rows


INSERT INTO genres_movies
SELECT DISTINCT movie_title, genres FROM FSDB.old_movies;
-- 4913 rows


INSERT INTO keywords_movies
SELECT DISTINCT movie_title,plot_keywords FROM FSDB.old_movies WHERE plot_keywords is not null;
-- 4762 rows


INSERT INTO players
SELECT actor,MAX(likes) FROM
(SELECT actor_1_name actor, actor_1_facebook_likes likes FROM FSDB.old_movies WHERE actor_1_name IS NOT NULL
UNION
SELECT DISTINCT actor_2_name actor, actor_2_facebook_likes likes FROM FSDB.old_movies WHERE actor_2_name IS NOT NULL
UNION
SELECT DISTINCT actor_3_name actor, actor_3_facebook_likes likes FROM FSDB.old_movies WHERE actor_3_name IS NOT NULL
) GROUP BY actor;
-- 6249 rows


INSERT INTO casts
SELECT actor_1_name, movie_title FROM FSDB.old_movies WHERE actor_1_name IS NOT NULL
UNION
SELECT DISTINCT actor_2_name, movie_title FROM FSDB.old_movies WHERE actor_2_name IS NOT NULL
UNION
SELECT DISTINCT actor_3_name, movie_title FROM FSDB.old_movies WHERE actor_3_name IS NOT NULL ;
-- 14698 rows


INSERT INTO series
SELECT DISTINCT title, total_seasons FROM FSDB.old_tvseries;
-- 80 rows


INSERT INTO seasons
SELECT DISTINCT title, season, avgduration, episodes FROM FSDB.old_TVSERIES;
-- 748 rows


INSERT INTO clients (
SELECT DISTINCT clientId, dni, name, surname, sec_surname, eMail, phoneN, to_date(birthdate,'YYYY-MM-DD') FROM FSDB.old_CONTRACTS);
-- 5000 rows


INSERT INTO products VALUES('Free Rider',10,'C',2.5,5,0,0.95,5);
INSERT INTO products VALUES('Premium Rider',39,'V',0.5,0,0.01,0,3);
INSERT INTO products VALUES('TVrider',29,'C',2,8,0,0.5,0);
INSERT INTO products VALUES('Flat Rate Lover',39,'C',2.5,0,0,0,5);
INSERT INTO products VALUES('Short Timer',15,'C',2.5,5,0.01,0,3);
INSERT INTO products VALUES('Content Master',20,'C',1.75,4,1.02,0,3);
INSERT INTO products VALUES('Boredom Fighter',10,'V',1,1,0,0.95,0);
INSERT INTO products VALUES('Low Cost Rate',0,'V',0.95,4,0,1.45,3);
-- 1x8 rows


INSERT INTO contracts (
SELECT contractId, clientId, TO_DATE(startdate,'YYYY-MM-DD'), TO_DATE(enddate,'YYYY-MM-DD'), contract_type, address, town, ZIPcode, country
FROM FSDB.old_contracts);
-- 7013 rows


INSERT INTO movies(movie_title,duration) VALUES ('Avatar',100);




insert into taps_movies
SELECT distinct c.CONTRACTID,
TO_DATE (t.viewdate||' '|| t.viewhour, 'YYYY-MM-DD HH24:MI'),
SUBSTR(t.viewPCT, 1, LENGTh(t.viewPCT)-1),
t.title
FROM (FSDB.old_taps t join movies s on t.title=s.movie_title)
join FSDB.old_contracts c
ON t.CLIENT= c.CLIENTID
AND to_date(t.VIEWDATE,'YYYY-MM-DD') BETWEEN to_date(c.STARTDATE,'YYYY-MM-DD') AND nvl(to_date(c.ENDDATE,'YYYY-MM-DD'),sysdate)
WHERE t.season is null;

-- 230645 rows


INSERT INTO seasons VALUES('M*A*S*H',4,25,25);
INSERT INTO seasons VALUES('M*A*S*H',5,25,25);


insert into taps_series
SELECT distinct c.CONTRACTID,
TO_DATE (t.viewdate||' '|| t.viewhour, 'YYYY-MM-DD HH24:MI'),
SUBSTR(t.viewPCT, 1, LENGTh(t.viewPCT)-1),
t.title,
t.season,
t.episode
FROM (FSDB.old_taps t join FSDB.old_tvseries s
on t.title=s.title and t.season=s.season)
join FSDB.old_contracts c
ON t.CLIENT= c.CLIENTID
AND to_date(t.VIEWDATE,'YYYY-MM-DD') BETWEEN to_date(c.STARTDATE,'YYYY-MM-DD') AND nvl(to_date(c.ENDDATE,'YYYY-MM-DD'),sysdate)
WHERE t.season is not null;

-- 313038 rows

-- The two next are not required (will be furtherly done by a trigger)

INSERT INTO lic_movies (
SELECT A.clientId,MIN(B.view_datetime),B.title
 FROM (SELECT clientId,contractID FROM contracts JOIN (SELECT product_name FROM products WHERE type='C') ON (contract_type=product_name)) A
 JOIN taps_movies B ON (A.contractId=B.contractId)
 GROUP BY A.clientId, B.title);
-- 132906 rows

INSERT INTO lic_series(
SELECT A.clientId,MIN(B.view_datetime),B.title,B.season,B.episode
 FROM (SELECT clientId, contractID FROM contracts JOIN (SELECT product_name FROM products WHERE type='C') ON (contract_type=product_name)) A
 JOIN taps_series B ON (A.contractId=B.contractId)
 GROUP BY A.clientId, B.title,B.season,B.episode);
