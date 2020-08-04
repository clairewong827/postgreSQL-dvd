-- Reporting KPIs: revenue, no.of movie rentals, no.of active customers
-- Calculate the revenue, no. of movie rentals & no. of active customers in 2018
SELECT SUM(m.renting_price),  COUNT(*),  COUNT(DISTINCT r.customer_id) 
FROM renting AS r 
LEFT JOIN movies AS m 
ON r.movie_id = m.movie_id 
-- Only look at movie rentals in 2018 
WHERE date_renting BETWEEN '2018-01-01' AND '2018-12-31' ; 