CREATE OR REPLACE FUNCTION bill (clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) RETURN NUMBER
IS

--The month must be changed due to the language: DEC-2016 OR DIC-2016

		total_cost NUMBER;
		zapping NUMBER;
		costsMovies NUMBER;
		costsSeries NUMBER;
		i NUMBER;
		t_enddate contracts.enddate%TYPE;
		t_startdate contracts.startdate%TYPE;
		t_viewdate taps_movies.view_datetime%TYPE;

CURSOR bill_movie(clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) IS
		SELECT title1, clientId,contractId, duration, product_name,tap_costMovies,month,daytime, type, zapp, ppm, ppd, promo, pct FROM(
		SELECT clientId,contractId,title1, product_name,tap_cost as tap_costMovies,month,daytime, type, zapp, ppm, ppd, promo, pct FROM(
		SELECT clientId, contractId,title1, contract_type, month, pct, daytime FROM(
		SELECT title AS title1, contractId, to_char(view_datetime, 'MON-YYYY') AS month, view_datetime AS daytime, pct
		FROM taps_movies)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type WHERE (product_name= productInput AND month = monthInput 
		AND clientId = clientInput)) JOIN movies ON title1=movie_title;

CURSOR bill_serie(clientInput VARCHAR2, monthInput VARCHAR2, productInput VARCHAR2) IS
		SELECT title, clientId,contractId, product_name,tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season, episode, pct, avgduration FROM(
		SELECT title, clientId,contractId, product_name,tap_cost as tap_costSeries,month,daytime,type, zapp, ppm, ppd, promo, season, episode, pct FROM(
		SELECT title, clientId, contractId, contract_type, month,daytime, season, episode, pct FROM(
		SELECT title,  contractId, to_char(view_datetime, 'MON-YYYY') AS month, view_datetime AS daytime,season, episode, pct
		FROM taps_series)
		NATURAL JOIN contracts) JOIN products ON product_name=contract_type
		WHERE product_name= productInput AND month = monthInput AND clientId = clientInput) NATURAL JOIN SEASONS;

BEGIN 
		IF bill_movie %ISOPEN THEN
				CLOSE bill_movie;
			END IF;		
		CASE productInput 
				WHEN 'Free Rider' THEN  total_cost := 10;
				WHEN 'Premium Rider' THEN total_cost := 39;
				WHEN 'TVrider' THEN total_cost := 29;
				WHEN 'Flat Rate Lover' THEN total_cost := 39;
				WHEN 'Short Timer' THEN total_cost := 15;
				WHEN 'Content Master' THEN total_cost := 20;
				WHEN 'Boredom Fighter' THEN total_cost := 10;
				WHEN 'Low Cost Rate' THEN total_cost := 0;
		END CASE;
		
		costsMovies := 0;
		FOR clientId IN bill_movie(clientInput, monthInput, productInput)
		LOOP
			zapping := 1;
			IF clientId.zapp >= clientId.pct AND clientId.ppd <> 0 THEN zapping := 0; END IF;
					IF clientId.type = 'V' THEN
							clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*CEIL(clientId.duration*(clientId.pct/100)));						
					ELSIF clientId.type = 'C' AND (clientId.ppm = 0.01 OR clientId.ppm = 0.02) THEN	
									clientId.tap_costMovies := clientId.tap_costMovies+(clientId.ppm*clientId.duration);
									clientId.tap_costMovies := clientId.tap_costMovies*zapping;
					END IF;
			costsMovies := clientId.tap_costMovies + costsMovies;
			DBMS_OUTPUT.PUT_LINE(costsMovies || '$');
		END LOOP;
		costsMovies := costsMovies * 2;
	
		costsSeries := 0;	
		IF bill_serie %ISOPEN THEN
				CLOSE bill_serie;
			END IF;
		FOR clientId IN bill_serie(clientInput, monthInput, productInput)
		LOOP
			zapping := 1;
			IF clientId.zapp >= clientId.pct AND clientId.ppd <> 0 THEN zapping := 0; END IF;
					IF clientId.type = 'V' THEN
							clientId.tap_costSeries := clientId.tap_costSeries+(clientId.ppm*CEIL(clientId.avgduration*(clientId.pct/100)));					
					END IF;
					IF clientId.type = 'C' AND (clientId.ppm = 0.01 OR clientId.ppm = 0.02) THEN					
									clientId.tap_costSeries := clientId.tap_costSeries+(clientId.ppm*clientId.avgduration);
									clientId.tap_costSeries := clientId.tap_costSeries*zapping;
					END IF;
			costsSeries := clientId.tap_costSeries + costsSeries;
		END LOOP;
		
		i := 0;
		IF t_startdate = monthInput THEN 
			total_cost := costsSeries + costsMovies + total_cost;
			DBMS_OUTPUT.PUT_LINE(total_cost || '$');
			RETURN total_cost;
		ELSE 
		WHILE i<8 LOOP
				ADD_MONTH(t_viewdate,8);
				 i := i+1;
		END LOOP;
		DBMS_OUTPUT.PUT_LINE(t_viewdate);
		END IF;
		
END;
/	

declare
result number;
begin
result:=bill('86/83744772/18T','MAR-2016','Low Cost Rate');
end;
/
