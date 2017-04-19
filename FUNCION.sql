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
