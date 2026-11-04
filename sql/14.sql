 */
WITH rentals AS (SELECT fc.category_id, f.film_id, f.title, count(*) AS rental_count FROM film_category fc JOIN film f USING (film_id) JOIN inventory i USING (film_id) JOIN rental r USING (inventory_id) GROUP BY fc.category_id, f.film_id, f.title),
ranked AS (SELECT *, rank() OVER (PARTITION BY category_id ORDER BY rental_count DESC) AS ranking FROM rentals)
SELECT c.name AS category, title, rental_count FROM ranked r JOIN category c USING (category_id) WHERE ranking <= 5;
/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */
