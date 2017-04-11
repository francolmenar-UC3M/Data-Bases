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
	select enddate into t_enddate 
	from contracts 
	where contracts.contractId = :new.contractId;
	select startdate into t_startdate 
	from contracts 
	where contracts.contractId = :new.contractId;
	IF t_enddate IS NULL AND t_startdate IS NULL THEN
		DBMS_OUTPUT.PUT_LINE('Puto Timmi');
	ELSIF t_enddate > :new.startdate AND t_startdate <= sysdate THEN
				DBMS_OUTPUT.PUT_LINE('joder');			
	END IF;
END triggerD;
/
show errors;

insert into contracts VALUES('Timmi','00/98607278/50T',TO_DATE('10-OCT-13', 'YYYY-MM-DD'),TO_DATE('10-OCT-19', 'YYYY-MM-DD'),'Short Timer','payo','tonto','matame','ya');

insert into contracts VALUES('Timmi1','00/98607278/50T',TO_DATE('10-OCT-14', 'YYYY-MM-DD'),TO_DATE('10-OCT-18', 'YYYY-MM-DD'),'Short Timer','payo','tonto','matame','ya');

SELECT * FROM CONTRACTS WHERE contractId='Timmi';
DELETE FROM CONTRACTS WHERE contractId='Timmi';

DROP trigger triggerD;
