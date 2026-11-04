/*
 * Management wants to create a "best sellers" list for each actor.
 *
 * Write a SQL query that:
 * For each actor, reports the three films that the actor starred in that have brought in the most revenue for the company.
 * (The revenue is the sum of all payments associated with that film.)
 *
 * HINT:
 * For correct output, you will have to rank the films for each actor.
 * My solution uses the `rank` window function.
 */

WITH revenue AS (
  SELECT fa.actor_id, f.film_id, f.title, sum(p.amount) AS total
  FROM film_actor fa JOIN film f USING (film_id)
  JOIN inventory i USING (film_id) JOIN rental r USING (inventory_id)
  JOIN payment p USING (rental_id)
  GROUP BY fa.actor_id, f.film_id, f.title
), ranked AS (
  SELECT r.*, rank() OVER (PARTITION BY actor_id ORDER BY total DESC) AS rank
  FROM revenue r
)
SELECT a.first_name, a.last_name, ranked.title, ranked.total, ranked.rank
FROM ranked JOIN actor a USING (actor_id)
WHERE ranked.rank <= 3;
