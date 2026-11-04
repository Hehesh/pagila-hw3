/* 
 * You've decided that you don't actually like ACADEMY DINOSAUR and AGENT TRUMAN,
 * and want to focus on more movies that are similar to AMERICAN CIRCUS.
 * This time, however, you don't want to focus only on movies with similar actors.
 * You want to consider instead movies that have similar categories.
 *
 * Write a SQL query that lists all of the movies that share 2 categories with AMERICAN CIRCUS.
 * Order the results alphabetically.
 *
 * NOTE:
 * Recall that the following query lists the categories for the movie AMERICAN CIRCUS:
 * ```
 * SELECT name
 * FROM category
 * JOIN film_category USING (category_id)
 * JOIN film USING (film_id)
 * WHERE title = 'AMERICAN CIRCUS';
 * ```
 * This problem should be solved by a self join on the "film_category" table.
 */

SELECT f.title
FROM film f
JOIN film_category fc USING (film_id)
JOIN film_category ac ON ac.category_id = fc.category_id
JOIN film af ON af.film_id = ac.film_id
WHERE af.title = 'AMERICAN CIRCUS'
  AND f.title <> 'AMERICAN CIRCUS'
GROUP BY f.film_id, f.title
HAVING count(DISTINCT fc.category_id) >= 2
ORDER BY f.title;
