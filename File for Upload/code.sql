/* THIS FILE IS ORGANIZED AS FOLLOWS:

 - SLIDE SHOW QUERIES
 - ONLINE CHURN RATE QUERIES
 
 SOME OF THE QUERIES MAY BE DUPLICATIVE. THEY ARE BROKEN DOWN THIS WAY FOR EASE OF REVIEW. */
      
      /* SLIDE SHOW PROJECT QUERIES */

 			/* SECTION 1 OF SLIDE SHOW */
 
 SELECT MIN(subscription_start), 
 MAX(subscription_start)
 FROM subscriptions;

/* Modification of minimum query in no. 1 
to examine end dates for subscriptions */

SELECT MIN(subscription_end), 
MAX(subscription_end)
FROM subscriptions;

 			/* SECTION 2 OF SLIDE SHOW */
 
/* Overall Churn Rates with total subscriptions and cancellations by month */

/* COLUMN HEADERS AND DATES IN POWERPOINT HAVE BEEN REWRITTEN FOR AESTHETIC PURPOSES */

WITH months AS ( 					
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 ),

cross_join AS (
	SELECT *
	FROM subscriptions
	CROSS JOIN months),

status AS (
	SELECT id, first_day AS month,
  CASE
  	WHEN ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end is null)))
  	THEN 1
  	ELSE 0
  END AS is_active,
  
  CASE
  	WHEN (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled
FROM cross_join),

status_aggregate AS (
  SELECT month,
			SUM(is_active) AS Active_Subscriptions,
			SUM(is_canceled) AS Canceled_Subscriptions
  FROM status
	GROUP BY month 
	)
  
/* To calculate overall churn rate, eliminate line with GROUP BY MONTH above */

SELECT month AS Month,
		Active_Subscriptions,
    Canceled_Subscriptions,
		1.0 * Canceled_Subscriptions/Active_Subscriptions AS Churn_Rate

FROM status_aggregate; 


 			/* SECTION 3 OF SLIDE SHOW */
 
/* Churn Rates with total subscriptions and cancellations by month, broken down by segment. This is the same as query 8 below, except it has been modified to show acquisition and cancellations. */

/* COLUMN HEADERS AND DATES IN POWERPOINT HAVE BEEN REWRITTEN FOR AESTHETIC PURPOSES */

WITH months AS ( 					
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 ),

cross_join AS (
	SELECT *
	FROM subscriptions
	CROSS JOIN months),

status AS (
	SELECT id, first_day AS month,
  CASE
  	WHEN (segment = 87)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end is null)))
  	THEN 1
  	ELSE 0
  END AS is_active_87,
  
 	CASE
  	WHEN (segment = 30)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end IS NULL)))
      
  	THEN 1
  	ELSE 0
  END AS is_active_30,
  
  CASE
  	WHEN (segment = 87)
  	AND (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled_87,  	
 
 CASE
  	WHEN (segment = 30)
  	AND (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled_30
FROM cross_join),

status_aggregate AS (
  SELECT month,
			SUM(is_active_87) AS Active_Segment_87,
			SUM(is_active_30) AS Active_Segment_30,
			SUM(is_canceled_87) AS Canceled_Segment_87,
			SUM(is_canceled_30) AS Canceled_Segment_30
  FROM status
  GROUP BY month)

/* To calculate overall churn rate, eliminate line with GROUP BY MONTH above */

SELECT month,
	Active_Segment_87, Canceled_Segment_87,
  1.0 * Canceled_Segment_87/Active_Segment_87 AS 'Churn Rate: Segment 87',
  Active_Segment_30, Canceled_Segment_30,
	1.0 * Canceled_Segment_30/Active_Segment_30 AS 'Churn Rate: Segment 30'

FROM status_aggregate
GROUP BY month;

/* Overall Churn Rates with total subscriptions and cancellations by month */

WITH months AS ( 					
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 ),

cross_join AS (
	SELECT *
	FROM subscriptions
	CROSS JOIN months),

status AS (
	SELECT id, first_day AS month,
  CASE
  	WHEN ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end is null)))
  	THEN 1
  	ELSE 0
  END AS is_active,
  
  CASE
  	WHEN (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled
FROM cross_join),

status_aggregate AS (
  SELECT month,
			SUM(is_active) AS sum_active,
			SUM(is_canceled) AS sum_canceled
  FROM status
	GROUP BY month)

SELECT month, sum_active, sum_canceled,
	1.0 * sum_canceled/sum_active AS churn_rate

FROM status_aggregate; 




		/* TASKS FROM CALCULATING CHURN RATES LESSON */

					/* no. 1 */
SELECT *
FROM subscriptions
LIMIT 100;

					/* no. 2 */
 
 SELECT MIN(subscription_start), 
 MAX(subscription_start)
 FROM subscriptions;


					/* no. 3 */ 

WITH months AS ( 
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 )
 SELECT *
 FROM months;
 
					 /* no. 4*/
WITH months AS ( 					
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 ),
cross_join AS (
	SELECT *
	FROM subscriptions
	CROSS JOIN months)
SELECT *
FROM cross_join
LIMIT 100;

 							/* no. 5*/
WITH months AS ( 					
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 ),

cross_join AS (
	SELECT *
	FROM subscriptions
	CROSS JOIN months),

status AS (
	SELECT id, first_day AS month,
  CASE
  	WHEN (segment = 87)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end is null)))
  	THEN 1
  	ELSE 0
  END AS is_active_87,
  
 	CASE
  	WHEN (segment = 30)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end IS NULL)))
      
  	THEN 1
  	ELSE 0
  END AS is_active_30
  FROM cross_join)
  
SELECT *
FROM status
LIMIT 100;
  
  					/* no. 6 */

WITH months AS ( 					
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 ),

cross_join AS (
	SELECT *
	FROM subscriptions
	CROSS JOIN months),

status AS (
	SELECT id, first_day AS month,
  CASE
  	WHEN (segment = 87)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end is null)))
  	THEN 1
  	ELSE 0
  END AS is_active_87,
  
 	CASE
  	WHEN (segment = 30)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end IS NULL)))
      
  	THEN 1
  	ELSE 0
  END AS is_active_30,
  
  CASE
  	WHEN (segment = 87)
  	AND (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled_87,  	
 
 CASE
  	WHEN (segment = 30)
  	AND (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled_30
FROM cross_join)

SELECT *
FROM status
LIMIT 100;

  				/* no. 7 */

WITH months AS ( 					
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 ),

cross_join AS (
	SELECT *
	FROM subscriptions
	CROSS JOIN months),

status AS (
	SELECT id, first_day AS month,
  CASE
  	WHEN (segment = 87)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end is null)))
  	THEN 1
  	ELSE 0
  END AS is_active_87,
  
 	CASE
  	WHEN (segment = 30)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end IS NULL)))
      
  	THEN 1
  	ELSE 0
  END AS is_active_30,
  
  CASE
  	WHEN (segment = 87)
  	AND (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled_87,  	
 
 CASE
  	WHEN (segment = 30)
  	AND (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled_30
FROM cross_join),

status_aggregate AS (
  SELECT month,
			SUM(is_active_87) AS sum_active_87,
			SUM(is_active_30) AS sum_active_30,
			SUM(is_canceled_87) AS sum_canceled_87,
			SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  GROUP BY month)

SELECT *
FROM status_aggregate; 

		/* no. 8 -- churn rates*/

WITH months AS ( 					
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 ),

cross_join AS (
	SELECT *
	FROM subscriptions
	CROSS JOIN months),

status AS (
	SELECT id, first_day AS month,
  CASE
  	WHEN (segment = 87)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end is null)))
  	THEN 1
  	ELSE 0
  END AS is_active_87,
  
 	CASE
  	WHEN (segment = 30)
  	AND ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end IS NULL)))
      
  	THEN 1
  	ELSE 0
  END AS is_active_30,
  
  CASE
  	WHEN (segment = 87)
  	AND (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled_87,  	
 
 CASE
  	WHEN (segment = 30)
  	AND (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled_30
FROM cross_join),

status_aggregate AS (
  SELECT month,
			SUM(is_active_87) AS sum_active_87,
			SUM(is_active_30) AS sum_active_30,
			SUM(is_canceled_87) AS sum_canceled_87,
			SUM(is_canceled_30) AS sum_canceled_30
  FROM status
  GROUP BY month)

SELECT month,
	1.0 * sum_canceled_87/sum_active_87 AS churn_87,
	1.0 * sum_canceled_30/sum_active_30 AS churn_30

FROM status_aggregate
GROUP BY month;

/* Overall Churn Rates with total subscriptions and cancellations by month */

WITH months AS ( 					
   SELECT 
	   '2017-01-01' AS first_day,
  	 '2017-01-31' AS last_day
   UNION
	 SELECT
   		'2017-02-01' AS first_day,
   		'2017-02-28' AS last_day
   UNION
   SELECT
   		'2017-03-01' AS first_day,
   		'2017-03-31' AS last_day
 ),

cross_join AS (
	SELECT *
	FROM subscriptions
	CROSS JOIN months),

status AS (
	SELECT id, first_day AS month,
  CASE
  	WHEN ((subscription_start < first_day)
			AND ((subscription_end > first_day)
    		OR (subscription_end is null)))
  	THEN 1
  	ELSE 0
  END AS is_active,
  
  CASE
  	WHEN (subscription_end BETWEEN first_day AND last_day)
	  THEN 1
  	ELSE 0
  END AS is_canceled
FROM cross_join),

status_aggregate AS (
  SELECT month,
			SUM(is_active) AS sum_active,
			SUM(is_canceled) AS sum_canceled
  FROM status
	GROUP BY MONTH)

SELECT month, sum_active, sum_canceled,
	1.0 * sum_canceled/sum_active AS churn_rate

FROM status_aggregate; 

					/* no. 9 */
          
/* If there were more segments, the queries could be grouped using the GROUP BY command, which should eliminate the need to hard code using the WHEN function and "=" operator. */          
