-- Verify purchase-frequency customer totals

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM orders AS o

    INNER JOIN customers AS c
        ON o.customer_id = c.customer_id

    WHERE o.order_status = 'delivered'

    GROUP BY c.customer_unique_id
)

SELECT
    COUNT(*) AS total_customers,

    SUM(
        CASE WHEN total_orders = 1 THEN 1 ELSE 0 END
    ) AS one_time_customers,

    SUM(
        CASE WHEN total_orders > 1 THEN 1 ELSE 0 END
    ) AS repeat_customers

FROM customer_orders;