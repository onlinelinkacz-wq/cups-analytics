-- ============================================================
-- 03 · Product analysis
-- Skills: CTE, JOIN, percentage calculation
-- ============================================================

-- 3.1  Revenue and units by product, sorted by revenue
WITH product_stats AS (
    SELECT
        oi.product,
        oi.category,
        SUM(oi.qty)        AS units_sold,
        SUM(oi.line_total) AS revenue
    FROM order_items oi
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.status = 'picked_up'
    GROUP BY oi.product, oi.category
)
SELECT
    product,
    category,
    units_sold,
    revenue,
    ROUND(100.0 * revenue / (SELECT SUM(revenue) FROM product_stats), 1) AS pct_of_total
FROM product_stats
ORDER BY revenue DESC;


-- 3.2  Revenue by category
SELECT
    oi.category,
    COUNT(DISTINCT o.order_id)  AS orders,
    SUM(oi.qty)                 AS units,
    SUM(oi.line_total)          AS revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'picked_up'
GROUP BY oi.category
ORDER BY revenue DESC;


-- 3.3  Most popular milk options
SELECT
    COALESCE(milk, 'standard') AS milk_type,
    COUNT(*)                   AS times_ordered,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM order_items
WHERE category IN ('Káva', 'Ledová káva')
GROUP BY milk
ORDER BY times_ordered DESC;


-- 3.4  Average price with and without customizations
SELECT
    category,
    ROUND(AVG(base_price), 0)   AS avg_base_price,
    ROUND(AVG(unit_price), 0)   AS avg_with_options,
    ROUND(AVG(options_price), 0) AS avg_upsell
FROM order_items
GROUP BY category
ORDER BY avg_upsell DESC;
