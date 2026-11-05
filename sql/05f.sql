/* 
 * Finding movies with similar categories still gives you too many options.
 *
 * Write a SQL query that lists all movies that share 2 categories with AMERICAN CIRCUS and 1 actor.
 *
 * HINT:
 * It's possible to complete this problem both with and without set operations,
 * but I find the version using set operations much more intuitive.
 */

SELECT f.title
FROM film f
JOIN film_category fc USING (film_id)
JOIN film_category ac ON ac.category_id = fc.category_id
JOIN film af ON af.film_id = ac.film_id
JOIN film_actor fa ON fa.film_id = f.film_id
WHERE af.title = 'AMERICAN CIRCUS'
  AND fa.actor_id IN (
    SELECT fa2.actor_id
    FROM film_actor fa2 JOIN film af2 USING (film_id)
    WHERE af2.title = 'AMERICAN CIRCUS'
  )
GROUP BY f.film_id, f.title
HAVING count(DISTINCT fc.category_id) >= 2;
