SELECT clientId, name, surname, startdate, enddate, type
	FROM 
	(SELECT name, surname , clientId
	FROM clients
	ORDER BY surname, name) 
	NATURAL JOIN 
	(SELECT startdate, enddate, type, clientId
	FROM contracts JOIN products ON product_name=contract_type)
	WHERE ((sysdate<enddate AND sysdate>startdate) OR (sysdate >= startdate AND enddate IS NULL));
