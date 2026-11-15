-- Monthly order growth analysis

WITH monthly_orders AS (
    SELECT
        strftime('%Y-%m', order_purchase_timestamp) AS order_month,
        COUNT(*) AS total_orders
    FROM orders
    GROUP BY strftime('%Y-%m', order_purchase_timestamp)
),

monthly_comparison AS (
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
        (
            (total_orders - previous_month_orders) * 100.0
            / NULLIF(previous_month_orders, 0)
        ),
        2
    ) AS monthly_growth_percentage

FROM monthly_comparison
ORDER BY order_month;