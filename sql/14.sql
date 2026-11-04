/*
 * Management also wants to create a "best sellers" list for each category.
 *
 * Write a SQL query that:
 * For each category, reports the five films that have been rented the most for each category.
 *
 * Note that in the last query, we were ranking films by the total amount of payments made,
 * but in this query, you are ranking by the total number of times the movie has been rented (and ignoring the price).
 */

WITH rentals AS (
  SELECT fc.category_id, f.film_id, f.title, count(*) AS rented
  FROM film_category fc JOIN film f USING (film_id)
  JOIN inventory i USING (film_id) JOIN rental r USING (inventory_id)
  GROUP BY fc.category_id, f.film_id, f.title
), ranked AS (
  SELECT r.*, rank() OVER (PARTITION BY category_id ORDER BY rented DESC) AS rank
  FROM rentals r
)
SELECT c.name AS category, ranked.title, ranked.rented, ranked.rank
FROM ranked JOIN category c USING (category_id)
WHERE ranked.rank <= 5;
