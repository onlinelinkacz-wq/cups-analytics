-- ============================================================
-- 04 · Time analysis and trends
-- Skills: DATE functions, GROUP BY with dates, basic window (LAG)
-- ============================================================

-- 4.1  Orders and revenue by week
SELECT
    DATE_TRUNC('week', date)::DATE AS week,
    COUNT(*)                       AS orders,
    SUM(total)                     AS revenue,
    ROUND(AVG(total), 0)           AS avg_check
FROM orders
WHERE status = 'picked_up'
GROUP BY DATE_TRUNC('week', date)
ORDER BY week;


-- 4.2  Weekday comparison — which days are busiest?
SELECT
    weekday,
    COUNT(*)        AS orders,
    SUM(total)      AS revenue,
    ROUND(AVG(total), 0) AS avg_check
FROM orders
WHERE status = 'picked_up'
GROUP BY weekday
ORDER BY
    CASE weekday
        WHEN 'Po' THEN 1 WHEN 'Út' THEN 2 WHEN 'St' THEN 3
        WHEN 'Čt' THEN 4 WHEN 'Pá' THEN 5 WHEN 'So' THEN 6
        WHEN 'Ne' THEN 7
    END;


-- 4.3  New customers per week — is the app growing?
SELECT
    DATE_TRUNC('week', signup_date)::DATE AS week,
    COUNT(*) AS new_customers
FROM customers
GROUP BY DATE_TRUNC('week', signup_date)
ORDER BY week;


-- 4.4  Weekly revenue growth (week over week)
WITH weekly AS (
    SELECT
        DATE_TRUNC('week', date)::DATE AS week,
        SUM(total)                     AS revenue
    FROM orders
    WHERE status = 'picked_up'
    GROUP BY DATE_TRUNC('week', date)
)
SELECT
    week,
    revenue,
    LAG(revenue) OVER (ORDER BY week) AS prev_week,
    CASE
        WHEN LAG(revenue) OVER (ORDER BY week) > 0
        THEN ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY week))
             / LAG(revenue) OVER (ORDER BY week), 1)
    END AS wow_growth_pct
FROM weekly
ORDER BY week;
