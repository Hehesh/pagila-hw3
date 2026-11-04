 */
SELECT DISTINCT a.first_name, a.last_name
FROM actor a JOIN film_actor fa USING (actor_id) JOIN film_actor rb USING (film_id) JOIN actor r ON r.actor_id = rb.actor_id
WHERE r.first_name = 'RUSSELL' AND r.last_name = 'BACALL' AND a.actor_id <> r.actor_id;
/*
 * This question and the next one are inspired by the Bacon Number:
 * https://en.wikipedia.org/wiki/Six_Degrees_of_Kevin_Bacon#Bacon_numbers
 *
 * List all actors with Bacall Number 1.
 * That is, list all actors that have appeared in a film with 'RUSSELL BACALL'.
 * Do not list 'RUSSELL BACALL', since he has a Bacall Number of 0.
 */
