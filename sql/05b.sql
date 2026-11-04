 */
SELECT f2.title
FROM film f1 JOIN film_actor fa1 USING (film_id) JOIN film_actor fa2 USING (actor_id) JOIN film f2 ON f2.film_id = fa2.film_id
WHERE f1.title = 'AMERICAN CIRCUS' AND f2.title <> f1.title GROUP BY f2.title HAVING count(DISTINCT fa1.actor_id) >= 2;
/*
 * Write a SQL query that lists the title of all movies where at least 2 actors were also in 'AMERICAN CIRCUS'.
 */
