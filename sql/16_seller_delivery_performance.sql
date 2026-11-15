
-- Seller Delivery Performance Analysis
-- Only completed deliveries with valid delivery dates

WITH seller_orders AS (
    SELECT DISTINCT
        oi.seller_id,
        o.order_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date

    FROM order_items AS oi

    INNER JOIN orders AS o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp IS NOT NULL
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
),

seller_performance AS (
    SELECT
        so.seller_id,
        s.seller_state,

        COUNT(*) AS total_orders,

        SUM(
            CASE
                WHEN julianday(so.order_delivered_customer_date)
                   > julianday(so.order_estimated_delivery_date)
                THEN 1
                ELSE 0
            END
        ) AS late_orders,

        ROUND(
            AVG(
                julianday(so.order_delivered_customer_date)
                - julianday(so.order_purchase_timestamp)
            ),
            2
        ) AS average_delivery_days

    FROM seller_orders AS so

    INNER JOIN sellers AS s
        ON so.seller_id = s.seller_id

    GROUP BY so.seller_id, s.seller_state
)

SELECT
    seller_id,
    seller_state,
    total_orders,
    late_orders,

    ROUND(
        late_orders * 100.0 / NULLIF(total_orders, 0),
        2
    ) AS late_delivery_rate,

    average_delivery_days

FROM seller_performance

WHERE total_orders >= 30

ORDER BY late_delivery_rate DESC, total_orders DESC

LIMIT 20;
