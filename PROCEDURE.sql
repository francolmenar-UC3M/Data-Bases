CREATE OR REPLACE PROCEDURE billTotal (monthInput VARCHAR2) 
IS
		counter NUMBER(8,2);
		month NUMBER(2);
		year NUMBER(4);

CURSOR rigthContracts(monthInput VARCHAR2) IS 
 SELECT clientId,contractId, name, surname, startdate, enddate, product_name FROM (
  SELECT name, surname , clientId FROM 
 clients ORDER BY surname, name) 
 NATURAL JOIN(
  SELECT startdate, enddate,product_name,contractId , type, clientId	FROM 
   contracts JOIN products 
   ON product_name=contract_type)
  WHERE ((sysdate<enddate AND sysdate>startdate) OR
  (sysdate >= startdate AND enddate IS NULL));
	
BEGIN
		IF rigthContracts %ISOPEN THEN
				CLOSE rigthContracts;
			END IF;
		month := extract(month from (TO_DATE(monthInput,'MM-YYYY')));
		year := extract(year from (TO_DATE(monthInput,'MM-YYYY')));
		FOR aux_user IN rigthContracts(monthInput)
		LOOP
			counter := bill(aux_user.clientId,monthInput,aux_user.product_name);
			INSERT INTO invoices VALUES(aux_user.contractId,month,year,SYSDATE,counter);
		END LOOP;
END;
/
show errors;

'NOV-10'
begin
billTotal('NOV-10');
end;
/


TEST
IF aux_user.clientId = 'Timmi' THEN 
			counter := bill(aux_user.clientId,monthInput,aux_user.product_name);
			DBMS_OUTPUT.PUT_LINE('The client  '|| aux_user.clientId || ' has a bill of ' || counter || ' of ' || monthInput);
			END IF;
