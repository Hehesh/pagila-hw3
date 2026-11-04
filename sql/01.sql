SELECT count(*) AS count
FROM customer AS c
JOIN address AS a ON a.address_id = c.address_id
JOIN city AS ci ON ci.city_id = a.city_id
JOIN country AS co ON co.country_id = ci.country_id
WHERE co.country IS DISTINCT FROM 'United States';
/*
 * Compute the number of customers who live outside of the US.
 *
 * NOTE:
 * It is possible to solve this problem with the "cheesy" query
 * ```
 * SELECT 563 AS count;
 * ```
 * Although this type of query will pass the test case for your homework,
 * it will not score you any points on your midterm/final exams.
 * I therefore strongly recommend that you solve this query "properly".
 *
 * Your goal should be to have your queries remain correct even if the data in the database changes arbitrarily.
 */
