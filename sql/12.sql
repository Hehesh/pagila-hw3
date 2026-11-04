 */
WITH recent AS (SELECT r.customer_id, f.film_id, row_number() OVER (PARTITION BY r.customer_id ORDER BY r.rental_date DESC) AS n FROM rental r JOIN inventory i USING (inventory_id) JOIN film f USING (film_id))
SELECT c.first_name, c.last_name FROM customer c JOIN recent r USING (customer_id) LEFT JOIN film_category fc USING (film_id) LEFT JOIN category ca USING (category_id) WHERE r.n <= 5 GROUP BY c.customer_id, c.first_name, c.last_name HAVING count(*) FILTER (WHERE ca.name = 'Action') >= 4;
/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */
