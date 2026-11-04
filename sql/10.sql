 */
WITH spending AS (SELECT c.customer_id, c.first_name, c.last_name, sum(p.amount) AS total_spending FROM customer c JOIN payment p USING (customer_id) GROUP BY c.customer_id, c.first_name, c.last_name),
ranked AS (SELECT *, ntile(100) OVER (ORDER BY total_spending) AS percentile FROM spending)
SELECT first_name, last_name, total_spending, percentile FROM ranked WHERE percentile >= 90 ORDER BY last_name, first_name;
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
