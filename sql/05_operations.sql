-- ============================================================
-- 05 · Operations and efficiency
-- Skills: HAVING, FILTER, COALESCE, conditional aggregation
-- ============================================================

-- 5.1  Average prep time by cafe (slowest ones)
SELECT
    c.name,
    c.district,
    COUNT(o.order_id)             AS orders,
    ROUND(AVG(o.prep_minutes), 1) AS avg_prep_min,
    ROUND(MAX(o.prep_minutes), 1) AS max_prep_min
FROM orders o
JOIN cafes c ON c.cafe_id = o.cafe_id
WHERE o.status = 'picked_up'
  AND o.prep_minutes IS NOT NULL
GROUP BY c.name, c.district
HAVING COUNT(o.order_id) >= 20
ORDER BY avg_prep_min DESC
LIMIT 10;


-- 5.2  Cancellation rate by cafe
SELECT
    c.name,
    c.district,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE o.status = 'cancelled') AS cancelled,
    ROUND(100.0 * COUNT(*) FILTER (WHERE o.status = 'cancelled')
        / COUNT(*), 1) AS cancel_rate_pct
FROM orders o
JOIN cafes c ON c.cafe_id = o.cafe_id
GROUP BY c.name, c.district
HAVING COUNT(*) >= 20
ORDER BY cancel_rate_pct DESC
LIMIT 10;


-- 5.3  Pickup mode split: "co nejdřív" vs "na čas"
SELECT
    pickup_mode,
    COUNT(*)        AS orders,
    ROUND(AVG(total), 0) AS avg_check,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM orders
WHERE status = 'picked_up'
GROUP BY pickup_mode;


-- 5.4  Promo code usage
SELECT
    COALESCE(promo_code, 'bez promo') AS promo,
    COUNT(*)                          AS orders,
    COUNT(DISTINCT customer_id)       AS unique_customers,
    SUM(discount)                     AS total_discount_given,
    ROUND(AVG(total), 0)              AS avg_check
FROM orders
WHERE status = 'picked_up'
GROUP BY promo_code
ORDER BY orders DESC;


-- 5.5  Dine-in vs takeaway
SELECT
    order_type,
    COUNT(*)        AS orders,
    SUM(total)      AS revenue,
    ROUND(AVG(total), 0) AS avg_check,
    ROUND(AVG(items_count), 1) AS avg_items
FROM orders
WHERE status = 'picked_up'
GROUP BY order_type
ORDER BY orders DESC;
