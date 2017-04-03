SELECT clientId, name, surname, startdate, enddate, type
	FROM 
	(SELECT name, surname , clientId
	FROM clients
	ORDER BY surname, name) 
	NATURAL JOIN 
	(SELECT startdate, enddate, contract_type, clientId
	FROM contracts
	WHERE (sysdate BETWEEN enddate AND startdate) OR (sysdate >= startdate AND enddate IS NULL))
	       JOIN products ON product_name=contract_type;
--2258--
