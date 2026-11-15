-- Rank monthly growth from highest to lowest

WITH monthly_orders AS (
    SELECT
        strftime('%Y-%m', order_purchase_timestamp) AS order_month,
        COUNT(*) AS total_orders
    FROM orders
    WHERE order_purchase_timestamp >= '2017-01-01'
      AND order_purchase_timestamp < '2018-09-01'
    GROUP BY strftime('%Y-%m', order_purchase_timestamp)
),

monthly_growth AS (
    SELECT
        order_month,
        total_orders,
        LAG(total_orders) OVER (
            ORDER BY order_month
        ) AS previous_month_orders
    FROM monthly_orders
)

SELECT
    order_month,
    total_orders,
    previous_month_orders,
    ROUND(
        (total_orders - previous_month_orders) * 100.0
        / NULLIF(previous_month_orders, 0),
        2
    ) AS growth_percentage
FROM monthly_growth
WHERE previous_month_orders IS NOT NULL
ORDER BY growth_percentage DESC;