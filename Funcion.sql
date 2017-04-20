CREATE OR REPLACE FUNCTION bill (clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) RETURN NUMBER
IS
--The month must be changed due to the language: DEC-2016 OR DIC-2016
		total_cost NUMBER;
		zapping NUMBER;
		costsMovies NUMBER;
		costsSeries NUMBER;
		newmonth DATE;
		t_startdateaux VARCHAR2(9);
		t_enddate contracts.enddate%TYPE;
		t_startdate contracts.startdate%TYPE;
		t_viewdate taps_movies.view_datetime%TYPE;
		t_promo NUMBER;
		discount NUMBER;

CURSOR bill_movie(clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) IS
		SELECT title1, clientId,contractId, duration, product_name,tap_costMovies,month,daytime, type, zapp, ppm, ppd, promo, pct, startdate, enddate, datetime FROM(
		SELECT title1, clientId,contractId, duration, product_name,tap_costMovies,month,daytime, type, zapp, ppm, ppd, promo, pct, startdate, enddate FROM(
		SELECT clientId,contractId,title1, product_name,tap_cost as tap_costMovies,month,daytime, type, zapp, ppm, ppd, promo, pct, startdate, enddate FROM(
		SELECT clientId, contractId,title1, contract_type, month, pct, daytime, startdate, enddate FROM(
		SELECT title AS title1, contractId, to_char(view_datetime, 'MON-YY') AS month, view_datetime AS daytime, pct
		FROM taps_movies)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type WHERE (product_name= productInput AND month = monthInput
		AND clientId = clientInput)) JOIN movies ON title1=movie_title)LEFT OUTER JOIN lic_movies ON clientId=client AND title1 = title; 

CURSOR bill_serie(clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) IS
		SELECT title2, clientId,contractId, product_name,tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season2, episode2, pct, avgduration, startdate, enddate, datetime FROM(		
		SELECT DISTINCT title2, clientId,contractId, product_name,tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season2, episode2, pct, startdate, enddate,avgduration FROM(
		SELECT title as title2, clientId,contractId, product_name,tap_cost as tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season  as season2, episode as episode2, pct, startdate, enddate FROM(
		SELECT title, clientId, contractId, contract_type, month,daytime, season, episode, pct, startdate, enddate FROM(
		SELECT title,  contractId, to_char(view_datetime, 'MON-YY') AS month, view_datetime AS daytime,season, episode, pct
		FROM taps_series)
		NATURAL JOIN contracts)
		JOIN products ON product_name=contract_type
		WHERE product_name= productInput AND month = monthInput AND clientId = clientInput)
		JOIN seasons
		ON (title2=seasons.title AND season2=seasons.season))		
		LEFT OUTER JOIN lic_series 
		ON clientId=client where (title2 = title AND season2 = season AND episode2 = episode);
		
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
			
		--PPC or PPV
		--Movies (ppm)
		costsMovies := 0;
		IF bill_movie %ISOPEN THEN
  			CLOSE bill_movie;
  		END IF;
		FOR clientId IN bill_movie(clientInput, monthInput, productInput)
  		LOOP
			IF t_startdate IS NULL THEN
					t_startdate := clientId.startdate;
					t_enddate := clientId.enddate;
				END IF;
  			zapping := 1;
  			IF clientId.zapp >= clientId.pct AND clientId.ppd <> 0 THEN zapping := 0; END IF; 											
 					IF clientId.type = 'C' AND (clientId.ppm = 0.01 OR clientId.ppm = 0.02) AND (clientId.datetime > clientId.daytime OR clientId.datetime IS NULL) THEN	
 							clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*CEIL(clientId.duration*(clientId.pct/100)));
							clientId.tap_costMovies := clientId.tap_costMovies*zapping;
					END IF;
					IF clientId.type = 'V' THEN
 							clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*CEIL(clientId.duration*(clientId.pct/100)));
					END IF;
			costsMovies := clientId.tap_costMovies + costsMovies;
 		END LOOP;
		costsMovies := costsMovies * 2;
		DBMS_OUTPUT.PUT_LINE(costsMovies|| ' movies $');
		
		--Series(ppm)
		costsSeries := 0;
		IF bill_serie %ISOPEN THEN
  			CLOSE bill_serie;
  		END IF;
		FOR clientId IN bill_serie(clientInput, monthInput, productInput)
  		LOOP
			IF t_startdate IS NULL THEN
					t_startdate := clientId.startdate;
					t_enddate := clientId.enddate;
				END IF;
  			zapping := 1;
  			IF clientId.zapp >= clientId.pct AND clientId.ppd <> 0 THEN zapping := 0; END IF; 	
					IF clientId.type = 'C' AND (clientId.ppm = 0.01 OR clientId.ppm = 0.02) AND (clientId.datetime > clientId.daytime OR clientId.datetime IS NULL) THEN	
 							clientId.tap_costSeries := clientId.tap_costSeries+(clientId.ppm*CEIL(clientId.avgduration*(clientId.pct/100)));
							clientId.tap_costSeries := clientId.tap_costSeries*zapping;
					END IF;
 					IF clientId.type = 'V' THEN
 							clientId.tap_costSeries := clientId.tap_costSeries+(clientId.ppm*CEIL(clientId.avgduration*(clientId.pct/100)));
					END IF;
					
			costsSeries := clientId.tap_costSeries + costsSeries;
 		END LOOP;
		DBMS_OUTPUT.PUT_LINE(costsSeries|| ' series $');
		total_cost := costsSeries + costsMovies + total_cost;
		DBMS_OUTPUT.PUT_LINE(total_cost|| ' total $');
		
		--Promotion
		
		discount := 0;
		DBMS_OUTPUT.PUT_LINE(t_startdate|| ' t_startdate $');
		t_startdateaux := TO_CHAR(t_startdate, 'MON-YY');
		t_startdate := TO_DATE(t_startdateaux, 'MON-YY');
		newmonth := TO_DATE(monthInput, 'MON-YY');
		DBMS_OUTPUT.PUT_LINE(t_startdateaux|| ' t_startdateaux $');
		DBMS_OUTPUT.PUT_LINE(newmonth|| ' newmonth $');
		DBMS_OUTPUT.PUT_LINE(t_startdate|| ' t_startdate $');
		--If no movies or series were watched in the inputmonth t_startdate and t_enddate are not initialized
		WHILE t_startdate <= newmonth LOOP
				IF t_startdate = newmonth THEN
				DBMS_OUTPUT.PUT_LINE(t_promo|| ' promo $');
				discount := t_promo*total_cost;
				DBMS_OUTPUT.PUT_LINE(discount|| ' discount $');
				EXIT;
				END IF;
				newmonth := ADD_MONTHS(newmonth,-8);
		END LOOP;
		total_cost := total_cost-discount;
        total_cost := ROUND(total_cost, 2);
		DBMS_OUTPUT.PUT_LINE(total_cost|| ' total final $');
		RETURN total_cost;
END;
/

declare
result number;
begin
result:=bill('Timmi','NOV-10','Short Timer');
end;
/

DELETE FROM Clients WHERE clientId='Timmi';
		DELETE FROM CONTRACTS WHERE contractId='Timmi';
		
		INSERT INTO CLIENTS VALUES('Timmi','Timmi','Timmi','Timmi','Timmi','tuputamadre@hotmail.com',1,TO_DATE('10-OCT-13', 'YYYY-MM-DD'));
		insert into contracts VALUES('Timmi','Timmi',TO_DATE('13-03-2010', 'DD-MM-YYYY'),TO_DATE('19-03-2013', 'DD-MM-YYYY'),'Short Timer','payo','tonto','matame','ya');
		
		insert into taps_movies VALUES('Timmi',TO_DATE('13-11-2010', 'DD-MM-YYYY'),1, 'Titanic');
		
