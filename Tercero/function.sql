CREATE OR REPLACE FUNCTION bill (month IN NUMBER, year IN NUMBER, 
          cust IN CLIENTS.clientId%TYPE, product IN products.product_name%TYPE)  
          RETURN NUMBER IS

tariff products%ROWTYPE;
low_date DATE; top_date DATE;
ppcs NUMBER; ppvs NUMBER;
mins NUMBER; days NUMBER; 
promoends DATE;
total NUMBER;
aux NUMBER;

BEGIN
   SELECT * INTO tariff FROM products WHERE product_name=product;
   low_date := TO_DATE(month||'/'||year,'MM/YYYY'); 
	top_date  := ADD_MONTHS(low_date,1) -1;
    
   If tariff.type='V' THEN ppcs:=0;
      ELSE
           SELECT count('x')*2 INTO ppcs FROM lic_movies 
              WHERE client=cust AND datetime>=low_date AND datetime<top_date;
           SELECT ppcs+count('x') INTO ppcs FROM lic_series 
              WHERE client=cust AND datetime>=low_date AND datetime<top_date;
   END IF;


   If tariff.type='C' THEN ppvs:=0;
      ELSE
 -- We will count all views and then substract views with a licence
 -- Count movie_views with licence
         SELECT count('x') INTO aux 
            FROM (SELECT * FROM taps_movies
                    WHERE view_datetime>=low_date AND view_datetime<top_date 
                          AND pct>tariff.zapp) A 
                 NATURAL JOIN 
                 (SELECT contractId FROM contracts WHERE clientId=cust) B
               JOIN 
                 (SELECT title,datetime FROM lic_movies WHERE client=cust) C
                 ON (A.title=C.title AND A.view_datetime>=C.datetime);
      
 -- Count movie_views without licence
         SELECT (count('x')-aux)*2 INTO ppvs
            FROM (SELECT contractId FROM contracts WHERE clientId=cust) 
                 NATURAL JOIN taps_movies
            WHERE view_datetime>=low_date AND view_datetime<top_date 
                  AND pct>tariff.zapp;

 -- Count series_views with licence
         SELECT count('x') INTO aux 
            FROM (SELECT * FROM taps_series
                    WHERE view_datetime>=low_date AND view_datetime<top_date 
                          AND pct>tariff.zapp) A 
                 NATURAL JOIN 
                 (SELECT contractId FROM contracts WHERE clientId=cust) B
                 JOIN 
                 (SELECT title,datetime,season,episode FROM lic_series 
                     WHERE client=cust) C
                 ON (A.title=C.title AND A.season=C.season AND A.episode=C.episode 
                     AND A.view_datetime>=C.datetime);
 -- count series_views without licence minus the latter
      SELECT ppvs+(count('x')-aux) INTO ppvs
           FROM (SELECT contractId FROM contracts WHERE clientId=cust) 
                NATURAL JOIN taps_series
           WHERE view_datetime>=low_date AND view_datetime<top_date 
                   AND pct>tariff.zapp;
             
   END IF;
  

-- Count days
   SELECT count('x') INTO days
      FROM ((SELECT DISTINCT TO_CHAR(view_datetime,'DD')
               FROM (SELECT contractId FROM contracts WHERE clientId=cust) 
                    NATURAL JOIN taps_movies
               WHERE view_datetime>=low_date AND view_datetime<top_date 
                     AND pct>tariff.zapp)
            UNION
            (SELECT DISTINCT TO_CHAR(view_datetime,'DD')
               FROM (SELECT contractId FROM contracts WHERE clientId=cust) 
                    NATURAL JOIN taps_series
               WHERE view_datetime>=low_date AND view_datetime<top_date 
                     AND pct>tariff.zapp));

-- Count minutes regarding movies
   SELECT sum(B.duration*A.pct/100) INTO mins
      FROM ((SELECT title,pct
            FROM (SELECT contractId FROM contracts WHERE clientId=cust) 
                 NATURAL JOIN taps_movies
                 WHERE view_datetime>=low_date AND view_datetime<top_date) A
            NATURAL JOIN (SELECT movie_title title, duration FROM movies) B);

   SELECT NVL(mins,0)+sum(B.avgduration*A.pct/100) INTO mins
      FROM (SELECT title,season,pct
            FROM (SELECT contractId FROM contracts WHERE clientId=cust) 
                 NATURAL JOIN taps_series
                 WHERE view_datetime>=low_date AND view_datetime<top_date) A
            NATURAL JOIN (SELECT title,season,avgduration FROM seasons) B;


-- Calculates total
total := tariff.fee + tariff.tap_cost*(ppcs+ppvs)+ tariff.ppm*nvl(mins,0) + tariff.ppd*days;  

-- We calculate when the promotion ends
SELECT MAX((nvl(enddate,sysdate)-startdate)/8+startdate) INTO promoends 
   FROM contracts 
   WHERE (clientId=cust) AND 
         ( (low_date BETWEEN startdate AND nvl(enddate,sysdate))
           OR ((top_date-1) BETWEEN startdate AND nvl(enddate,sysdate))
         );

-- And we substract the discount in case
 IF top_date<promoends THEN total:=total*((100-tariff.promo)/100); END IF;


RETURN trunc(nvl(total,0),2);

END;
