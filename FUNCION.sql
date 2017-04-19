SELECT title, clientId,contractId, product_name,tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season, episode, pct, avgduration, startdate, enddate, datetime FROM(
		SELECT title as title2, clientId,contractId, product_name,tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season, episode, pct, avgduration, startdate, enddate FROM(
		SELECT title, clientId,contractId, product_name,tap_cost as tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season, episode, pct, startdate, enddate FROM(
		SELECT title, clientId, contractId, contract_type, month,daytime, season, episode, pct, startdate, enddate FROM(
		SELECT title,  contractId, to_char(view_datetime, 'MON-YY') AS month, view_datetime AS daytime,season, episode, pct
		FROM taps_series)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type
		WHERE product_name= '49/47300099/48T' AND month = 'MAR-16' AND clientId = 'Short Timer')  NATURAL JOIN seasons) JOIN lic_movies ON clientId=client;




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
		counter NUMBER;

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
		SELECT title, clientId,contractId, product_name,tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season, episode2, pct, avgduration, startdate, enddate, datetime FROM(
		SELECT title2, clientId,contractId, product_name,tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season2, episode2, pct, avgduration, startdate, enddate, datetime FROM(
		SELECT title as title2, clientId,contractId, product_name,tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season as season2, episode as episode2, pct, startdate, enddate FROM(
		SELECT title, clientId,contractId, product_name,tap_cost as tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season, episode, pct, startdate, enddate FROM(
		SELECT title, clientId, contractId, contract_type, month,daytime, season, episode, pct, startdate, enddate FROM(
		SELECT title,  contractId, to_char(view_datetime, 'MON-YY') AS month, view_datetime AS daytime,season, episode, pct
		FROM taps_series)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type
		WHERE product_name= productInput AND month = monthInput AND clientId = clientInput)  JOIN seasons
		ON title2=title AND season2=season)
		LEFT OUTER JOIN lic_series ON (clientId=client AND title2 = title AND season2 = season AND episode2 = episode));

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

		costsMovies := 0;
		counter := 0;
		FOR clientId IN bill_movie(clientInput, monthInput, productInput)
		LOOP
			IF t_startdate IS NULL THEN
				t_startdate := clientId.startdate;
				t_enddate := clientId.enddate;
			END IF;
			zapping := 1;
			IF clientId.zapp >= clientId.pct AND clientId.ppd <> 0 THEN zapping := 0; END IF;
					IF clientId.type = 'V' THEN
							clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*CEIL(clientId.duration*(clientId.pct/100)));
					END IF;
					IF clientId.type = 'C' AND (clientId.ppm = 0.01 OR clientId.ppm = 0.02) AND ((clientId.datetime > clientId.daytime) OR (clientId.datetime < clientId.daytime AND counter = 0)) THEN
									IF (clientId.datetime < clientId.daytime AND counter = 0) THEN
										counter := 1;

									ELSE

									clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*clientId.duration);
									clientId.tap_costMovies := clientId.tap_costMovies*zapping;
									END IF;
					END IF;
			costsMovies := clientId.tap_costMovies + costsMovies;
		END LOOP;
		costsMovies := costsMovies * 2;
		DBMS_OUTPUT.PUT_LINE(costsMovies  || '$');

		costsSeries := 0;
		IF bill_serie %ISOPEN THEN
				CLOSE bill_serie;
			END IF;
		counter := 0;
		FOR clientId IN bill_serie(clientInput, monthInput, productInput)
		LOOP
			IF t_startdate IS NULL THEN
				t_startdate := clientId.startdate;
				t_enddate := clientId.enddate;
			END IF;
			zapping := 1;
			IF clientId.zapp >= clientId.pct AND clientId.ppd <> 0 THEN zapping := 0; END IF;
					IF clientId.type = 'V' THEN
							clientId.tap_costSeries := clientId.tap_costSeries+(clientId.ppm*CEIL(clientId.avgduration*(clientId.pct/100)));
					END IF;
					IF clientId.type = 'C' AND (clientId.ppm = 0.01 OR clientId.ppm = 0.02) AND ((clientId.datetime > clientId.daytime) OR (clientId.datetime < clientId.daytime AND counter = 0)) THEN
									IF (clientId.datetime < clientId.daytime AND counter = 0) THEN
										counter := counter + 1;

									ELSE

									clientId.tap_costSeries := clientId.tap_costSeries+(clientId.ppm*clientId.avgduration);
									clientId.tap_costSeries := clientId.tap_costSeries*zapping;
									END IF;
				END IF;
			costsSeries := clientId.tap_costSeries + costsSeries;
		END LOOP;
		total_cost := costsSeries + costsMovies + total_cost;

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

declare
result number;
begin
result:=bill('49/47300099/48T','MAR-16','Short Timer');
end;
/
