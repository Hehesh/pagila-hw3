 */
WITH one AS (SELECT DISTINCT fa.actor_id FROM film_actor fa JOIN film_actor rb USING (film_id) JOIN actor r USING (actor_id) WHERE r.first_name = 'RUSSELL' AND r.last_name = 'BACALL'), two AS (SELECT DISTINCT fa.actor_id FROM film_actor fa JOIN one o USING (actor_id) JOIN film_actor fb USING (film_id))
SELECT DISTINCT a.first_name, a.last_name FROM actor a JOIN two USING (actor_id) WHERE a.actor_id NOT IN (SELECT actor_id FROM one) AND NOT (a.first_name = 'RUSSELL' AND a.last_name = 'BACALL');
/*
 * List all actors with Bacall Number 2;
 * That is, list all actors that have appeared in a film with an actor that has appeared in a film with 'RUSSELL BACALL',
 * but do not include actors that have Bacall Number < 2.
 */
