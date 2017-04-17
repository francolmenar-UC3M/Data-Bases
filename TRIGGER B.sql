
	CREATE OR REPLACE TRIGGER B
BEFORE INSERT ON taps_movies
FOR EACH ROW
DECLARE
	t_enddate contracts.enddate%TYPE;
	t_startdate contracts.startdate%TYPE;
	noHayEnd number(1);
	noHayStart number(1);
	valido number(1);
	cnt number;
BEGIN 
SELECT COUNT(*) INTO valido FROM 
contracts WHERE contractId = :new.contractId;
IF valido = 0 THEN
	RAISE_APPLICATION_ERROR(-20001,'error');
END IF;
SELECT COUNT(*) INTO noHayEnd FROM (select enddate From contracts 
	where contracts.contractId = :new.contractId);
	
	IF(noHayEnd = 0) THEN
	DBMS_OUTPUT.PUT_LINE('No hay end date');	
	else
	DBMS_OUTPUT.PUT_LINE('hay end date');	
	END IF;

	SELECT COUNT (*) INTO noHayStart FROM (select startdate from contracts 	
	where contracts.contractId = :new.contractId);

	IF(noHayStart = 0) THEN
	DBMS_OUTPUT.PUT_LINE('No hay Start date');	
	else
	DBMS_OUTPUT.PUT_LINE('hay Start date');	
	END IF;
	
		IF(noHayStart = 1 AND noHayEnd = 1) then
		select enddate into t_enddate 
		from contracts 
		where contracts.contractId = :new.contractId;

		select startdate into t_startdate 
		from contracts 
		where contracts.contractId = :new.contractId;
		
			IF :new.view_datetime NOT BETWEEN t_startdate AND t_enddate THEN 
				RAISE_APPLICATION_ERROR(-20001, 'View date is out of the scope of contracts');
			END IF;
	END IF;
END B; 
/
