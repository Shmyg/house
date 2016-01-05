CREATE	OR REPLACE
FUNCTION &&owner..calc_amt
RETURN	NUMBER
AS

	diff_day	NUMBER;
	diff_night	NUMBER;
	amt_day		NUMBER;
	amt_night	NUMBER;
BEGIN

SELECT	*
INTO	diff_day,
	diff_night
FROM	(
	SELECT	amt_day - LEAD( amt_day, 1 ) OVER (ORDER BY reg_date DESC),
		amt_night - LEAD( amt_night, 1 ) OVER (ORDER BY reg_date DESC)
	FROM	el_history
	ORDER	BY reg_date DESC
	)
WHERE	rownum = 1;

SELECT  SUM (amt)
INTO	amt_day
FROM    (   
SELECT  threshold,
        NVL( LEAD (threshold, 1) OVER (ORDER BY threshold), diff_day) - threshold AS diff,
        rate,
        (NVL( LEAD (threshold, 1) OVER (ORDER BY threshold), diff_day ) - threshold) * rate AS amt 
FROM    el_rates
WHERE   rate_type = 'Day'
AND     threshold < diff_day
	);

DBMS_OUTPUT.PUT_LINE( amt_day);

SELECT  SUM (amt)
INTO	amt_night
FROM    (   
SELECT  threshold,
        NVL( LEAD (threshold, 1) OVER (ORDER BY threshold), diff_night) - threshold AS diff,
        rate,
        (NVL( LEAD (threshold, 1) OVER (ORDER BY threshold), diff_night ) - threshold) * rate AS amt 
FROM    el_rates
WHERE   rate_type = 'Night'
AND     threshold < diff_night
	);

DBMS_OUTPUT.PUT_LINE( amt_night);
RETURN	1.2 * ROUND( amt_day + amt_night, 2);
END	calc_amt;
/
