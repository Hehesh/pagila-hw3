/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN LATERAL (
  SELECT count(*) FILTER (WHERE cat.name = 'Action') AS action_count
  FROM (
    SELECT r.inventory_id
    FROM rental r
    WHERE r.customer_id = c.customer_id
    ORDER BY r.rental_date DESC
    LIMIT 5
  ) recent
  JOIN inventory i USING (inventory_id)
  JOIN film_category fc USING (film_id)
  JOIN category cat USING (category_id)
) x ON true
WHERE x.action_count >= 4;
