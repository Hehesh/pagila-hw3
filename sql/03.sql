/*
 * List the total amount of money that customers from each country have payed.
 * Order the results from most to least money.
 */

SELECT co.country, sum(p.amount) AS total_payments
FROM country co JOIN city ci USING (country_id)
JOIN address a USING (city_id) JOIN customer c USING (address_id)
JOIN payment p USING (customer_id)
GROUP BY co.country
ORDER BY total_payments DESC, co.country DESC;
