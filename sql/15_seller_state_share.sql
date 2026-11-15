
-- Seller State Merchandise Value Share
-- Delivered orders only

WITH state_sales AS (
    SELECT
        s.seller_state,

        COUNT(DISTINCT s.seller_id) AS active_sellers,

        COUNT(DISTINCT oi.order_id) AS total_orders,

        ROUND(SUM(oi.price), 2) AS merchandise_value

    FROM order_items AS oi

    INNER JOIN orders AS o
        ON oi.order_id = o.order_id

    INNER JOIN sellers AS s
        ON oi.seller_id = s.seller_id

    WHERE o.order_status = 'delivered'

    GROUP BY s.seller_state
)

SELECT
    seller_state,
    active_sellers,
    total_orders,
    merchandise_value,

    ROUND(
        merchandise_value * 100.0
        / NULLIF(SUM(merchandise_value) OVER (), 0),
        2
    ) AS merchandise_share_percentage

FROM state_sales

ORDER BY merchandise_value DESC;
