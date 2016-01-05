CREATE	TABLE &&owner..el_history
	(
	reg_date	DATE PRIMARY KEY,
	amt_day		NUMBER NOT NULL,
	amt_night	NUMBER NOT NULL
)
/

CREATE	TABLE &&owner..el_rates
	(
	valid_from	DATE,
	rate_type	VARCHAR2(30) NOT NULL,
	threshold	NUMBER NOT NULL,
	rate		NUMBER NOT NULL,
PRIMARY	KEY (valid_from, rate_type, threshold))
ORGANIZATION INDEX
/
