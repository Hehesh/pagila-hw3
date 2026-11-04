/*
 * You love the acting in the movie 'AMERICAN CIRCUS' and want to watch other movies with the same actors.
 *
 * Write a SQL query that lists the title of all movies that share at least 1 actor with 'AMERICAN CIRCUS'.
 *
 * HINT:
 * This can be solved with a self join on the film_actor table.
 */

SELECT DISTINCT f.title
FROM film f
JOIN film_actor fa USING (film_id)
JOIN film_actor circus ON circus.actor_id = fa.actor_id
JOIN film cf ON cf.film_id = circus.film_id
WHERE cf.title = 'AMERICAN CIRCUS'
  AND f.title <> 'AMERICAN CIRCUS';
