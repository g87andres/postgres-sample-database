/*
	Identify how many rentals had payments that exceeded the film's rental rate	
*/

WITH payment_count_per_rental AS (
	SELECT rental_id, COUNT(payment_id) AS payment_count
	FROM payment
	GROUP BY rental_id
)
SELECT 
	p.payment_id,
	p.rental_id,
	p.amount AS payment_amount,
	f.film_id,
	f.title AS film_title,
	f.rental_rate, 
	pcpr.payment_count

FROM payment p

INNER JOIN rental r
	ON r.rental_id = p.rental_id

INNER JOIN inventory i
	ON i.inventory_id = r.inventory_id

INNER JOIN film f
	ON f.film_id = i.film_id

LEFT JOIN payment_count_per_rental pcpr
	ON pcpr.rental_id = r.rental_id

WHERE p.amount > f.rental_rate
ORDER BY pcpr.payment_count DESc

