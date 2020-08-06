--Identify favorite movies for a group of customers - all customers born in 1980s
SELECT m.title,  COUNT(*) AS no_of_rents, AVG(r.rating) 
FROM renting AS r 
LEFT JOIN customers AS c 
ON c.customer_id = r.customer_id 
LEFT JOIN movies AS m 
ON m.movie_id = r.movie_id 
WHERE c.date_of_birth BETWEEN '1980-01-01' AND '1989-12-31' 
GROUP BY m.title 
HAVING COUNT(*) > 1 -- Remove movies with only one rental 
ORDER BY no_of_rents DESC;

/*A query combined with LEFT JOIN, WEHRE,GROUP BY, HAVING AND ORDER BY. 
The "World Trade Center" is the most popular movie among the 1980s customrs*/

-- Found the youngest and oldest actress in each country
SELECT af.nationality, 
	MIN(af.year_of_birth),
	MAX(af.year_of_birth)
FROM
(SELECT *
FROM actors
WHERE gender = 'female') AS af
GROUP BY af.nationality;

--How much money did each customer spend?
SELECT customer_id, SUM(rm.renting_price) AS total_spent
FROM(SELECT r.customer_id,
	m.renting_price
	FROM renting AS r
	LEFT JOIN movies AS m
	ON r.movie_id = m.movie_id) AS rm
GROUP BY customer_id 
ORDER BY SUM(rm.renting_price) DESC;

--Count registrations by month

SELECT
DATE_TRUNC('month', date_account_start) :: DATE AS start_month,
COUNT (DISTINCT customer_id) AS regs
FROM customers
GROUP BY start_month;

/* Nov 2018 has the highest number of registration since the company launched in Jan 2017. */

-----------------------------------------------------------------------------------
-- NEW REGISTRATIONS. 
-- Built a monitor that compares the registrations of the previous and current month, 
-- raising a red flag to the team 
-- if the current month's active users are less than those of the previous month.

WITH regs AS (
	SELECT
	DATE_TRUNC('month', date_account_start) :: DATE AS start_month,
	COUNT (DISTINCT customer_id) AS regs
	FROM customers
	GROUP BY start_month),
	
	regs_lag AS (
	SELECT start_month,
		regs,
	COALESCE (
	LAG(regs)OVER (ORDER BY start_month)) AS last_regs
	FROM regs)
	
SELECT start_month, 
		regs, 
		regs - last_regs AS difference
FROM regs_lag
ORDER BY start_month;


-- Create a monitor for a month-to-month growth in percentage-- 
WITH regs AS (
	SELECT
	DATE_TRUNC('month', date_account_start) :: DATE AS start_month,
	COUNT (DISTINCT customer_id) AS regs
	FROM customers
	GROUP BY start_month),
	
	regs_lag AS (
	SELECT start_month,
		regs,
	COALESCE (
	LAG(regs)OVER (ORDER BY start_month)) AS last_regs
	FROM regs)
	
SELECT start_month,  
		ROUND((regs - last_regs) :: NUMERIC / last_regs, 2)AS growth
FROM regs_lag
ORDER BY start_month;