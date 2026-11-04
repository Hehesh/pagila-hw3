/*
 * Management wants to rank customers by how much money they have spent in order to send coupons to the top 10%.
 *
 * Write a query that computes the total amount that each customer has spent.
 * Include a "percentile" column that contains the customer's percentile spending,
 * and include only customers in at least the 90th percentile.
 * Order the results alphabetically.
 *
 * HINT:
 * I used the `ntile` window function to compute the percentile.
 */

WITH spending AS (
  SELECT c.customer_id, c.first_name, c.last_name, sum(p.amount) AS total
  FROM customer c JOIN payment p USING (customer_id)
  GROUP BY c.customer_id, c.first_name, c.last_name
), ranked AS (
  SELECT s.*, ntile(10) OVER (ORDER BY total) AS percentile
  FROM spending s
)
SELECT first_name, last_name, total, percentile
FROM ranked
WHERE percentile >= 9
ORDER BY last_name, first_name;
