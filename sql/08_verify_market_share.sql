-- Verify total marketplace order share

WITH state_orders AS (
    SELECT
        c.customer_state,
        COUNT(DISTINCT o.order_id) AS total_orders

    FROM orders AS o

    INNER JOIN customers AS c
        ON o.customer_id = c.customer_id

    GROUP BY c.customer_state
),

state_shares AS (
    SELECT
        customer_state,
        total_orders,

        total_orders * 100.0
        / SUM(total_orders) OVER () AS order_share

    FROM state_orders
)

SELECT
    ROUND(SUM(order_share), 2) AS total_order_share,
    SUM(total_orders) AS total_marketplace_orders,
    COUNT(*) AS total_states

FROM state_shares;