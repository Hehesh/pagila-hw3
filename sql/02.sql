/*
 * Compute the country with the most customers in it. 
 */

SELECT co.country, count(*) AS count
FROM customer c JOIN address a USING (address_id) JOIN city ci USING (city_id) JOIN country co USING (country_id)
GROUP BY co.country
ORDER BY count(*) DESC
LIMIT 1;
