 */
WITH categories AS (SELECT f.film_id FROM film f JOIN film_category fc USING (film_id) JOIN film_category ac ON ac.category_id = fc.category_id JOIN film af ON af.film_id = ac.film_id WHERE af.title = 'AMERICAN CIRCUS' GROUP BY f.film_id HAVING count(DISTINCT fc.category_id) >= 2),
actors AS (SELECT f.film_id FROM film f JOIN film_actor fa USING (film_id) JOIN film_actor aa USING (actor_id) JOIN film af ON af.film_id = aa.film_id WHERE af.title = 'AMERICAN CIRCUS' GROUP BY f.film_id HAVING count(DISTINCT fa.actor_id) >= 1)
SELECT f.title FROM film f JOIN categories c USING (film_id) JOIN actors a USING (film_id) WHERE f.title <> 'AMERICAN CIRCUS';
/* 
 * Finding movies with similar categories still gives you too many options.
 *
 * Write a SQL query that lists all movies that share 2 categories with AMERICAN CIRCUS and 1 actor.
 *
 * HINT:
 * It's possible to complete this problem both with and without set operations,
 * but I find the version using set operations much more intuitive.
 */
