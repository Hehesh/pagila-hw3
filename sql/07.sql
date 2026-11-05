/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */

SELECT DISTINCT a.first_name, a.last_name
FROM actor a JOIN film_actor fa USING (actor_id)
WHERE fa.film_id IN (
  SELECT fa2.film_id
  FROM film_actor fa2
  WHERE fa2.actor_id IN (
    SELECT fa3.actor_id
    FROM film_actor fa3
    WHERE fa3.film_id IN (
      SELECT fa4.film_id FROM film_actor fa4
      JOIN actor r USING (actor_id)
      WHERE r.first_name = 'RUSSELL' AND r.last_name = 'BACALL'
    )
  )
)
AND NOT EXISTS (
  SELECT 1
  FROM film_actor direct
  JOIN film_actor bacall ON bacall.film_id = direct.film_id
  JOIN actor r ON r.actor_id = bacall.actor_id
  WHERE direct.actor_id = a.actor_id
    AND r.first_name = 'RUSSELL'
    AND r.last_name = 'BACALL'
);
