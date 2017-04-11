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


mini triger ara sabe como va la vaina
CREATE OR REPLACE TRIGGER triggerD BEFORE INSERT ON contracts FOR EACH ROW 		
DECLARE
	t_enddate contracts.enddate%TYPE;
	t_startdate contracts.startdate%TYPE;
BEGIN
	select enddate into t_enddate from contracts;
	select startdate into t_startdate from contracts;
	IF t_enddate > :new.startdate AND t_startdate <= sysdate THEN
				DBMS_OUTPUT.PUT_LINE('joder');				
	END IF;
END triggerD;
/
show errors;


