 */
SELECT a.first_name, a.last_name
FROM actor a JOIN film_actor fa USING (actor_id) JOIN film_category fc USING (film_id) JOIN category c USING (category_id)
WHERE c.name = 'Children' EXCEPT SELECT a.first_name, a.last_name FROM actor a JOIN film_actor fa USING (actor_id) JOIN film_category fc USING (film_id) JOIN category c USING (category_id) WHERE c.name = 'Horror';
/*
 * List the first and last names of all actors who:
 * 1. have appeared in at least one movie in the "Children" category,
 * 2. but that have never appeared in any movie in the "Horror" category.
 */
