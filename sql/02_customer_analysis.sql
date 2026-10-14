-- ============================================================
-- 02 · Customer analysis
-- Skills: JOINs, subqueries, CASE, GROUP BY + HAVING
-- ============================================================

-- 2.1  Returning vs one-time customers
SELECT
    segment,
    COUNT(*) AS customers
FROM customers
GROUP BY segment;


-- 2.2  How many orders does a typical customer make?
SELECT
    CASE
        WHEN cnt = 1          THEN '1 order'
        WHEN cnt BETWEEN 2 AND 5   THEN '2–5 orders'
        WHEN cnt BETWEEN 6 AND 15  THEN '6–15 orders'
        ELSE '16+ orders'
    END AS bucket,
    COUNT(*) AS customers
FROM (
    SELECT customer_id, COUNT(*) AS cnt
    FROM orders
    WHERE status = 'picked_up'
    GROUP BY customer_id
) sub
GROUP BY
    CASE
        WHEN cnt = 1          THEN '1 order'
        WHEN cnt BETWEEN 2 AND 5   THEN '2–5 orders'
        WHEN cnt BETWEEN 6 AND 15  THEN '6–15 orders'
        ELSE '16+ orders'
    END
ORDER BY MIN(cnt);


-- 2.3  Top-10 customers by total spending
SELECT
    cu.customer_id,
    cu.first_name || ' ' || cu.last_name AS name,
    cu.persona,
    COUNT(o.order_id)   AS orders,
    SUM(o.total)        AS total_spent,
    MIN(o.date)         AS first_order,
    MAX(o.date)         AS last_order
FROM customers cu
JOIN orders o ON o.customer_id = cu.customer_id
WHERE o.status = 'picked_up'
GROUP BY cu.customer_id, cu.first_name, cu.last_name, cu.persona
ORDER BY total_spent DESC
LIMIT 10;


-- 2.4  Which persona spends the most?
SELECT
    cu.persona,
    COUNT(DISTINCT cu.customer_id) AS customers,
    COUNT(o.order_id)              AS orders,
    ROUND(AVG(o.total), 0)        AS avg_check,
    SUM(o.total)                   AS revenue
FROM customers cu
JOIN orders o ON o.customer_id = cu.customer_id
WHERE o.status = 'picked_up'
GROUP BY cu.persona
ORDER BY revenue DESC;


-- 2.5  Customers by age group
SELECT
    age_group,
    COUNT(*) AS customers,
    gender
FROM customers
GROUP BY age_group, gender
ORDER BY age_group, gender;
