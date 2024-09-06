WITH rental_payment_counts AS (
	SELECT 
		i.film_id,
		COUNT(DISTINCT r.rental_id) AS rental_count,
		SUM(p.amount) AS payment_amount
	
	FROM rental r
	
	INNER JOIN inventory i
		ON i.inventory_id = r.inventory_id
	
	INNER JOIN payment p
		ON p.rental_id = r.rental_id
	
	GROUP BY 
		i.film_id
)

SELECT 
	a.category_name,
	a.film_title,
	a.rental_count,
	a.film_payments_total

FROM (

	SELECT 
		c.category_id,
		c.name AS category_name,
		f.film_id,
		f.title AS film_title,
		rc.rental_count,
		rc.payment_amount AS film_payments_total,
		ROW_NUMBER() OVER(PARTITION BY c.category_id ORDER BY rc.rental_count DESC) AS row_num
	
	FROM film f
	
	LEFT JOIN film_category fc
		ON fc.film_id = f.film_id
	
	LEFT JOIN category c
		ON c.category_id = fc.category_id
	
	LEFT JOIN rental_payment_counts rc
		ON rc.film_id = f.film_id
	
	WHERE rc.rental_count IS NOT NULL
) a

WHERE a.row_num = 1


