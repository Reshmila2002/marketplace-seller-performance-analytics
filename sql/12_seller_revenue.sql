-- Seller Merchandise Value Analysis
-- Includes delivered orders only

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    COUNT(*) AS items_sold,

    ROUND(SUM(oi.price), 2) AS merchandise_value,

    ROUND(SUM(oi.freight_value), 2) AS freight_value,

    ROUND(
        SUM(oi.price) / NULLIF(COUNT(DISTINCT oi.order_id), 0),
        2
    ) AS avg_merchandise_value_per_order

FROM order_items AS oi

INNER JOIN orders AS o
    ON oi.order_id = o.order_id

INNER JOIN sellers AS s
    ON oi.seller_id = s.seller_id

WHERE o.order_status = 'delivered'

GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state

ORDER BY merchandise_value DESC

LIMIT 20;