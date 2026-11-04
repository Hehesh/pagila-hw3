/* 
 * You also like the acting in the movies ACADEMY DINOSAUR and AGENT TRUMAN,
 * and so you'd like to see movies with actors that were in either of these movies or AMERICAN CIRCUS.
 *
 * Write a SQL query that lists all movies where at least 3 actors were in one of the above three movies.
 * (The actors do not necessarily have to all be in the same movie, and you do not necessarily need one actor from each movie.)
 */

SELECT f.title
FROM film f JOIN film_actor fa USING (film_id)
WHERE fa.actor_id IN (
  SELECT fa2.actor_id FROM film_actor fa2 JOIN film f2 USING (film_id)
  WHERE f2.title IN ('AMERICAN CIRCUS', 'ACADEMY DINOSAUR', 'AGENT TRUMAN')
)
GROUP BY f.film_id, f.title
HAVING count(DISTINCT fa.actor_id) >= 3;
