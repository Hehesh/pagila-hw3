 */
WITH actors AS (SELECT fa.actor_id FROM film_actor fa JOIN film f USING (film_id) WHERE f.title IN ('ACADEMY DINOSAUR', 'AGENT TRUMAN', 'AMERICAN CIRCUS'))
SELECT f.title FROM film f JOIN film_actor fa USING (film_id) JOIN actors a USING (actor_id) GROUP BY f.title HAVING count(DISTINCT a.actor_id) >= 3;
/* 
 * You also like the acting in the movies ACADEMY DINOSAUR and AGENT TRUMAN,
 * and so you'd like to see movies with actors that were in either of these movies or AMERICAN CIRCUS.
 *
 * Write a SQL query that lists all movies where at least 3 actors were in one of the above three movies.
 * (The actors do not necessarily have to all be in the same movie, and you do not necessarily need one actor from each movie.)
 */
