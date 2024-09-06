WITH films AS (
	SELECT 
		f.film_id,
		f.title AS film_title,
		fa.actor_id,
		CONCAT(a.first_name, ' ', a.last_name) AS actor_full_name		
		
	FROM film AS f
	
	JOIN film_actor AS fa
		ON fa.film_id = f.film_id
	
	JOIN actor a
		ON a.actor_id = fa.actor_id
	
	WHERE f.release_year = 2006
)

SELECT 
	films.actor_id,
	films.actor_full_name,
	COUNT(films.actor_id) AS actor_film_count
	
FROM films

GROUP BY 
	films.actor_id,
	films.actor_full_name

ORDER BY COUNT(films.actor_id) DESC

LIMIT 10
