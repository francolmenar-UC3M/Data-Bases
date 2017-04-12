CREATE OR REPLACE TRIGGER triggerD 
BEFORE INSERT ON contracts FOR EACH ROW 		
BEGIN
		IF (enddate > :new.startdate) AND (startdate <= sysdate) THEN
					UPDATE contracts
					SET enddate := :new.startdate-1
		ELSE
				DBMS_OUTPUT.PUT_LINE('Normal');
		END IF;
END triggerD;


mini triger ara sabe como va la vainaDELETE FROM CONTRACTS WHERE clientId='Timmi';
DELETE FROM Clients WHERE clientId='Timmi';
DELETE FROM CONTRACTS WHERE contractId='Timmi';
DELETE FROM CONTRACTS WHERE contractId='Timmi1';
DROP trigger triggerD;

INSERT INTO CLIENTS VALUES('Timmi','Timmi','Timmi','Timmi','Timmi','tuputamadre@hotmail.com',1,TO_DATE('10-OCT-13', 'YYYY-MM-DD'));

insert into contracts VALUES('Timmi','Timmi',TO_DATE('10-OCT-13', 'YYYY-MM-DD'),TO_DATE('10-OCT-19', 'YYYY-MM-DD'),'Short Timer','payo','tonto','matame','ya');


CREATE OR REPLACE TRIGGER triggerD BEFORE INSERT ON contracts FOR EACH ROW 		
DECLARE
	t_enddate contracts.enddate%TYPE;
	t_startdate contracts.startdate%TYPE;
	noHayEnd number(1);
	noHayStart number(1);
	cnt number;

	
BEGIN
	
	SELECT COUNT(*) INTO noHayEnd FROM (select enddate From contracts 
	where contracts.clientId = :new.clientId);
	
	IF(noHayEnd = 0) THEN
	DBMS_OUTPUT.PUT_LINE('No hay end date');	
	else
	DBMS_OUTPUT.PUT_LINE('hay end date');	
	END IF;

	SELECT COUNT (*) INTO noHayStart FROM (select startdate from contracts 	
	where contracts.clientId = :new.clientId);

	IF(noHayStart = 0) THEN
	DBMS_OUTPUT.PUT_LINE('No hay noHayStart');	
	else
	DBMS_OUTPUT.PUT_LINE('hay noHayStart');	
	END IF;

	
	IF(noHayStart = 1 AND noHayEnd = 1) then
	select enddate into t_enddate 
	from contracts 
	where contracts.clientId = :new.clientId;

	select startdate into t_startdate 
	from contracts 
	where contracts.clientId = :new.clientId;

		IF t_enddate > :new.startdate AND t_startdate <= sysdate THEN
				DBMS_OUTPUT.PUT_LINE('DIA MENOS UNO');	
					t_enddate := :new.startdate-1;	
		END IF;
	ELSIF 	(noHayStart = 0) then
		DBMS_OUTPUT.PUT_LINE('INSERT NORMAL PAYO TONTO');	
		
	ELSE
		DBMS_OUTPUT.PUT_LINE('PAYO CON CONTRATO PERO SIN ENDDATE');	
		
		select startdate into t_startdate 
		from contracts 
		where contracts.clientId = :new.clientId;

			IF t_startdate <= sysdate THEN
			DBMS_OUTPUT.PUT_LINE('DIA MENOS UNO(sin end');	
					t_enddate := :new.startdate-1;
			end if;
	
	END IF;
END triggerD;
/
show errors;


insert into contracts VALUES('Timmi1','Timmi',TO_DATE('10-OCT-14', 'YYYY-MM-DD'),TO_DATE('10-OCT-18', 'YYYY-MM-DD'),'Short Timer','payo','tonto','matame','ya');


SELECT * FROM CONTRACTS WHERE contractId='Timmi1';
SELECT * FROM CONTRACTS WHERE clientId='Timmi';
