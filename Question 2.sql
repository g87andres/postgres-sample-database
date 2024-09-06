/*
	Identify which MPAA rating had the most rentals in the first quarter of 2006.
	Also identify how many rentals this category had over the previous category.
*/
WITH rentals AS (
	SELECT 
		f.film_id,
		f.title,
		f.rating,
		r.rental_date,
		COUNT(r.rental_id) OVER(PARTITION BY f.rating) AS rating_rental_count
		
	FROM rental r
	
	JOIN inventory i
		ON i.inventory_id = r.inventory_id
	
	JOIN film f
		ON f.film_id = i.film_id
	
	WHERE r.rental_date >= '2006-01-01'
	AND r.rental_date < '2006-04-01'
)

SELECT 
	r.rating,
	r.rating_rental_count,
	r.rating_rental_count - (LAG(r.rating_rental_count) OVER(ORDER BY r.rating_rental_count ASC)) AS ahead_by_count

FROM (
	SELECT rating, 
		MAX(rating_rental_count) AS rating_rental_count
	FROM rentals
	GROUP BY rating
) r

ORDER BY r.rating_rental_count DESC
