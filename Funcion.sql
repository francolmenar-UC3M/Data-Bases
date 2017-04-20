CREATE OR REPLACE FUNCTION bill (clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) RETURN NUMBER
IS
--The month must be changed due to the language: DEC-2016 OR DIC-2016
		total_cost NUMBER;
		zapping NUMBER;
		costsMovies NUMBER;
		costsSeries NUMBER;
		newmonth DATE;
		licencias NUMBER;
		t_startdateaux VARCHAR2(9);
		t_enddate contracts.enddate%TYPE;
		t_startdate contracts.startdate%TYPE;
		t_viewdate taps_movies.view_datetime%TYPE;
		t_promo NUMBER;
		discount NUMBER;
		counter NUMBER;

CURSOR bill_movie(clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) IS
		SELECT title1, clientId,contractId, duration, product_name,tap_costMovies,month,daytime, type, zapp, ppm, ppd, promo, pct, startdate, enddate FROM(
		SELECT clientId,contractId,title1, product_name,tap_cost as tap_costMovies,month,daytime, type, zapp, ppm, ppd, promo, pct, startdate, enddate FROM(
		SELECT clientId, contractId,title1, contract_type, month, pct, daytime, startdate, enddate FROM(
		SELECT title AS title1, contractId, to_char(view_datetime, 'MON-YY') AS month, view_datetime AS daytime, pct
		FROM taps_movies)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type WHERE (product_name= productInput AND month = monthInput
		AND clientId = clientInput)) JOIN movies ON title1=movie_title;
		
CURSOR bill_serie(clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) IS		
		SELECT DISTINCT title2, clientId,contractId, product_name,tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season2, episode2, pct, startdate, enddate,avgduration FROM(
		SELECT title as title2, clientId,contractId, product_name,tap_cost as tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season  as season2, episode as episode2, pct, startdate, enddate FROM(
		SELECT title, clientId, contractId, contract_type, month,daytime, season, episode, pct, startdate, enddate FROM(
		SELECT title,  contractId, to_char(view_datetime, 'MON-YY') AS month, view_datetime AS daytime,season, episode, pct
		FROM taps_series)
		NATURAL JOIN contracts)
		JOIN products ON product_name=contract_type
		WHERE product_name= productInput AND month = monthInput AND clientId = clientInput)
		JOIN seasons
		ON (title2=seasons.title AND season2=seasons.season);
		
CURSOR licseries(clientInput VARCHAR2, monthInput VARCHAR2) IS
		SELECT client, datetime, views FROM (SELECT to_char(view_datetime, 'MON-YY') AS views, client, datetime FROM (lic_series NATURAL JOIN taps_series WHERE clientInput=client));

CURSOR licmovies(clientInput VARCHAR2, monthInput VARCHAR2) IS
		SELECT client, datetime, views FROM (SELECT to_char(view_datetime, 'MON-YY') AS views, client, datetime FROM (lic_movies NATURAL JOIN taps_movies WHERE clientInput=client));

BEGIN
		IF bill_movie %ISOPEN THEN
				CLOSE bill_movie;
			END IF;
		CASE productInput
				WHEN 'Free Rider' THEN
					total_cost := 10;
					t_promo := 0.05;
				WHEN 'Premium Rider' THEN
					total_cost := 39;
					t_promo := 0.03;
				WHEN 'TVrider' THEN
					total_cost := 29;
					t_promo := 0;
				WHEN 'Flat Rate Lover' THEN
					total_cost := 39;
					t_promo := 0.05;
				WHEN 'Short Timer' THEN
					total_cost := 15;
					t_promo := 0.03;
				WHEN 'Content Master' THEN
					total_cost := 20;
					t_promo := 0.03;
				WHEN 'Boredom Fighter' THEN
					total_cost := 10;
					t_promo := 0;
				WHEN 'Low Cost Rate' THEN
					total_cost := 0;
					t_promo := 0.03;
		END CASE;
		
		--licenses
		
		licencias := 0;
		FOR a IN licmovies(clientInput VARCHAR2, monthInput VARCHAR2) 
		LOOP 
			IF (a.views < a.datetime) THEN 
				
			END IF;
		END LOOP;
		
		FOR b IN licseries(clientInput VARCHAR2, monthInput VARCHAR2) 
		LOOP 
			IF (b.views < b.datetime) THEN 
				
			END IF;
		END LOOP;
			
		--PPC or PPV
		--Movies
		IF bill_movie %ISOPEN THEN
  			CLOSE bill_movie;
  		END IF;
		FOR clientId IN bill_movie(clientInput, monthInput, productInput)
  		LOOP
  			zapping := 1;
  			IF clientId.zapp >= clientId.pct AND clientId.ppd <> 0 THEN zapping := 0; END IF; 											
 					IF clientId.type = 'C' AND (clientId.ppm = 0.01 OR clientId.ppm = 0.02) THEN	
 							clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*CEIL(clientId.duration*(clientId.pct/100)));
							clientId.tap_costMovies := clientId.tap_costMovies*zapping;
					END IF;
					IF clientId.type = 'V' THEN
							licencias := 0;
 							clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*CEIL(clientId.avgduration*(clientId.pct/100)));
					END IF;
			costsMovies := clientId.tap_costMovies + costsMovies;
 		END LOOP;
		
		--Series
		IF bill_serie %ISOPEN THEN
  			CLOSE bill_serie;
  		END IF;
		FOR clientId IN bill_serie(clientInput, monthInput, productInput)
  		LOOP
  			zapping := 1;
  			IF clientId.zapp >= clientId.pct AND clientId.ppd <> 0 THEN zapping := 0; END IF; 	
					IF clientId.type = 'C' AND (clientId.ppm = 0.01 OR clientId.ppm = 0.02) THEN	
 							clientId.tap_costSeries := clientId.tap_costSeries+(clientId.ppm*CEIL(clientId.duration*(clientId.pct/100)));
							clientId.tap_costSeries := clientId.tap_costSeries*zapping;
					END IF;
 					IF clientId.type = 'V' THEN
							licencias := 0;
 							clientId.tap_costSeries := clientId.tap_costSeries+(clientId.ppm*CEIL(clientId.avgduration*(clientId.pct/100)));
					END IF;
					
			costsSeries := clientId.tap_costSeries + costsSeries;
 		END LOOP;
		total_cost := costsSeries + costsMovies + total_cost + licencias;
		
		--Promotion
		
		discount := 0;
		t_startdateaux := TO_CHAR(t_startdate, 'MON-YY');
		t_startdate := TO_DATE(t_startdateaux, 'MON-YY');
		newmonth := TO_DATE(monthInput, 'MON-YY');
		--If no movies or series were watched in the inputmonth t_startdate and t_enddate are not initialized
		WHILE t_startdate <= newmonth LOOP
				IF t_startdate = newmonth THEN
				discount := t_promo*total_cost;
				EXIT;
				END IF;
				newmonth := ADD_MONTHS(newmonth,-8);
		END LOOP;
		total_cost := total_cost-discount;
        total_cost := ROUND(total_cost, 2);
		DBMS_OUTPUT.PUT_LINE(total_cost|| '$');
		RETURN total_cost;
END;
/
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			