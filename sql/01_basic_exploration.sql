-- ============================================================
-- 01 · Basic exploration
-- Skills: SELECT, WHERE, GROUP BY, ORDER BY, aggregate functions
-- ============================================================

-- 1.1  Total orders, revenue, avg check
SELECT
    COUNT(*)                             AS total_orders,
    SUM(total)                           AS total_revenue,
    ROUND(AVG(total), 0)                 AS avg_check,
    COUNT(*) FILTER (WHERE status = 'cancelled') AS cancelled
FROM orders;


-- 1.2  Revenue by district — which Prague districts generate the most?
SELECT
    c.district,
    COUNT(o.order_id)                    AS orders,
    SUM(o.total)                         AS revenue,
    ROUND(AVG(o.total), 0)              AS avg_check
FROM orders o
JOIN cafes c ON c.cafe_id = o.cafe_id
WHERE o.status = 'picked_up'
GROUP BY c.district
ORDER BY revenue DESC;


-- 1.3  Top-10 best-selling products by quantity
SELECT
    oi.product,
    oi.category,
    SUM(oi.qty)                          AS units_sold,
    SUM(oi.line_total)                   AS revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'picked_up'
GROUP BY oi.product, oi.category
ORDER BY units_sold DESC
LIMIT 10;


-- 1.4  Orders by hour of day — when is peak demand?
SELECT
    hour,
    COUNT(*)                             AS orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM orders
WHERE status = 'picked_up'
GROUP BY hour
ORDER BY hour;


-- 1.5  Platform split (iOS / web)
SELECT
    platform,
    COUNT(DISTINCT customer_id)          AS customers,
    COUNT(*)                             AS orders,
    SUM(total)                           AS revenue
FROM orders
WHERE status = 'picked_up'
GROUP BY platform
ORDER BY revenue DESC;
