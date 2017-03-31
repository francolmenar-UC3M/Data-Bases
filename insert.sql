-- ----------------------------------------------------
-- -- Part III: Populate tables by querying old ones --
-- ----------------------------------------------------

INSERT INTO movies
(movie_title,title_year,country,color,duration,gross,budget,director_name,filming_language,num_critic_for_reviews,director_facebook_likes,num_voted_users,num_user_for_reviews, cast_total_facebook_likes,facenumber_in_poster,movie_imdb_link,imdb_score,content_rating,aspect_ratio,movie_facebook_likes)
SELECT movie_title,TO_NUMBER(title_year),country, CASE WHEN color='Black and White' THEN 'B' WHEN color='Color' THEN 'C' ELSE null END,
       duration,gross,budget,director_name,filming_language,num_critic_for_reviews,director_facebook_likes,
       num_voted_users,num_user_for_reviews, cast_total_facebook_likes,facenumber_in_poster,
       movie_imdb_link,TO_NUMBER(imdb_score,'9.9'),content_rating,TO_NUMBER(aspect_ratio,'99.99'),movie_facebook_likes
FROM fsdb.old_movies;
-- 4913 rows


INSERT INTO genres_movies SELECT DISTINCT movie_title, genres FROM fsdb.old_movies;
-- 4913 rows


INSERT INTO keywords_movies SELECT DISTINCT movie_title,plot_keywords FROM fsdb.old_movies WHERE plot_keywords is not null;
-- 4762 rows


INSERT INTO players
SELECT actor,MAX(likes) FROM
(SELECT actor_1_name actor, actor_1_facebook_likes likes FROM fsdb.old_movies WHERE actor_1_name IS NOT NULL
UNION
SELECT DISTINCT actor_2_name actor, actor_2_facebook_likes likes FROM fsdb.old_movies WHERE actor_2_name IS NOT NULL
UNION
SELECT DISTINCT actor_3_name actor, actor_3_facebook_likes likes FROM fsdb.old_movies WHERE actor_3_name IS NOT NULL
) GROUP BY actor;
-- 6249 rows


INSERT INTO casts
SELECT actor_1_name, movie_title FROM fsdb.old_movies WHERE actor_1_name IS NOT NULL
UNION
SELECT DISTINCT actor_2_name, movie_title FROM fsdb.old_movies WHERE actor_2_name IS NOT NULL
UNION
SELECT DISTINCT actor_3_name, movie_title FROM fsdb.old_movies WHERE actor_3_name IS NOT NULL ;
-- 14698 rows


INSERT INTO series SELECT DISTINCT title, total_seasons FROM fsdb.old_tvseries;
-- 80 rows


INSERT INTO seasons SELECT DISTINCT title, season, avgduration, episodes FROM fsdb.old_TVSERIES;
-- 748 rows


INSERT INTO clients (
   SELECT DISTINCT clientId, dni, name, surname, sec_surname, eMail, phoneN, to_date(birthdate,'YYYY-MM-DD') FROM fsdb.old_CONTRACTS);
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
SELECT contractId, clientId, TO_DATE(startdate,'YYYY-MM-DD'), TO_DATE(enddate,'YYYY-MM-DD'), contract_type, address, town, ZIPcode, country FROM fsdb.old_contracts);
-- 7013 rows


-- The following insert produces FK violation ERROR:
-- There is a missing movie ('Avatar'); feasible solutions:
-- (a) insert the movie;
INSERT INTO movies(movie_title,duration) VALUES ('Avatar',100);
-- (b) ignore it and document all taps on that movie


-- Besides, the two following ones produce errors due to contracts' enddate has been uploaded with time set to 00:00 h.
-- -> solution: use enddate+1 (taking time 0h. of the next day)

INSERT INTO taps_movies
SELECT distinct b.contractId , a.fecha, SUBSTR(a.viewPCT, 1, LENGTh(viewPCT)-1), a.title
FROM (SELECT client, TO_DATE (viewdate||' '|| viewhour, 'YYYY-MM-DD HH24:MI') fecha, viewhour, season, title, viewPCT FROM fsdb.old_taps WHERE season is null) a
     join (select clientId, contractId, startdate, NVL(enddate+1,sysdate) fecha from contracts) b
     ON (a.client=b.clientId and a.fecha>= b.startdate and a.fecha<=b.fecha);
-- 230886 rows (198 illegal rows skipped and documented)


-- Two seasons of M*A*S*H are missing (4th and 5th):
-- You can insert them (either from old_taps, or directly, taking the atributes of the next 6th season as implicit semantics)
INSERT INTO seasons VALUES('M*A*S*H',4,25,25);
INSERT INTO seasons VALUES('M*A*S*H',5,25,25);

INSERT INTO taps_series
SELECT distinct b.contractId , a.fecha, SUBSTR(a.viewPCT, 1, LENGTh(viewPCT)-1), a.title,a.season,a.episode
FROM (SELECT client, TO_DATE(viewdate||' '|| viewhour, 'YYYY-MM-DD HH24:MI') fecha, viewhour, episode, season, title, viewPCT FROM fsdb.old_taps WHERE season is NOT null) a join (select clientId, contractId, startdate, NVL(enddate,sysdate)+1 fecha from contracts) b
ON (a.client=b.clientId and a.fecha>= b.startdate and a.fecha<=b.fecha);
-- 313933 rows (437 illegal rows skipped and documented)


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
-- 179036 rows

COMMIT;
