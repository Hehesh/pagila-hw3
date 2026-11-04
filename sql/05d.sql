 */
SELECT f.title
FROM film f JOIN film_actor fa USING (film_id) JOIN film_actor base USING (actor_id) JOIN film b ON b.film_id = base.film_id
WHERE b.title IN ('AMERICAN CIRCUS', 'ACADEMY DINOSAUR', 'AGENT TRUMAN') GROUP BY f.title HAVING count(*) FILTER (WHERE b.title = 'AMERICAN CIRCUS') > 0 AND count(*) FILTER (WHERE b.title = 'ACADEMY DINOSAUR') > 0 AND count(*) FILTER (WHERE b.title = 'AGENT TRUMAN') > 0;
/* 
 * In the previous query, the actors could come from any combination of movies.
 * Unfortunately, you've found that if the actors all come from only 1 or 2 of the movies,
 * then there is not enough diversity in the acting talent.
 *
 * Write a SQL query that lists all of the movies where:
 * at least 1 actor was also in AMERICAN CIRCUS,
 * at least 1 actor was also in ACADEMY DINOSAUR,
 * and at least 1 actor was also in AGENT TRUMAN.
 *
 * HINT:
 * There are many ways to solve this problem,
 * but I personally found the INTERSECT operator to make a convenient solution.
 */
