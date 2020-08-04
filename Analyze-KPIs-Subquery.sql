-- Reporting KPIs: revenue, no.of movie rentals, no.of active customers
-- Calculate the revenue, no. of movie rentals & no. of active customers in 2018

SELECT SUM(m.renting_price) AS total_revenue,  
		COUNT(*) AS number_of_rental,  
		COUNT(DISTINCT r.customer_id) AS active_customers
FROM renting AS r 
LEFT JOIN movies AS m 
ON r.movie_id = m.movie_id 
-- Only look at movie rentals in 2018 
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' ; 

/* Result is: 
Total_revenue: $658.02, 
no.of rental: 298, 
no.of active customers: 93*/

----------------------------------------------------------
-- Report the total income for each movie using subquery:

SELECT rm.title, 
		SUM(renting_price) AS income_movie 
FROM 
	(SELECT m.title,  m.renting_price 
	 FROM renting AS r 
	 LEFT JOIN movies AS m 
	 ON r.movie_id=m.movie_id) AS rm 
GROUP BY rm.title 

ORDER BY income_movie DESC;

/*We found that Bridge Jones - The Edge of Reason generated the highest income: $37.57*/

