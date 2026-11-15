-- Customer State Order Share Analysis

WITH state_orders AS (
    SELECT
        c.customer_state,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM orders AS o

    INNER JOIN customers AS c
        ON o.customer_id = c.customer_id

    GROUP BY c.customer_state
)

SELECT
    customer_state,
    total_orders,

    ROUND(
        total_orders * 100.0
        / SUM(total_orders) OVER (),
        2
    ) AS order_share_percentage

FROM state_orders

ORDER BY total_orders DESC;