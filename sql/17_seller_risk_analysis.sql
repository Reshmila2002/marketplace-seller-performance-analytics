
-- Seller Risk Analysis
-- Combine merchandise value and late delivery rates

WITH seller_order_items AS (
    SELECT
        oi.seller_id,
        oi.order_id,
        oi.price,
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

seller_sales AS (
    SELECT
        seller_id,
        ROUND(SUM(price), 2) AS merchandise_value,
        COUNT(DISTINCT order_id) AS total_orders

    FROM seller_order_items

    GROUP BY seller_id
),

seller_delivery AS (
    SELECT
        seller_id,
        COUNT(*) AS total_orders,
        SUM(is_late) AS late_orders,
        ROUND(AVG(delivery_days), 2)
            AS average_delivery_days

    FROM (
        SELECT DISTINCT
            seller_id,
            order_id,

            CASE
                WHEN julianday(order_delivered_customer_date)
                   > julianday(order_estimated_delivery_date)
                THEN 1
                ELSE 0
            END AS is_late,

            julianday(order_delivered_customer_date)
            - julianday(order_purchase_timestamp)
                AS delivery_days

        FROM seller_order_items
    )

    GROUP BY seller_id
)

SELECT
    s.seller_id,
    s.seller_state,
    ss.total_orders,
    sd.late_orders,

    ROUND(
        sd.late_orders * 100.0
        / NULLIF(sd.total_orders, 0),
        2
    ) AS late_delivery_rate,

    ss.merchandise_value,
    sd.average_delivery_days

FROM seller_sales AS ss

INNER JOIN seller_delivery AS sd
    ON ss.seller_id = sd.seller_id

INNER JOIN sellers AS s
    ON ss.seller_id = s.seller_id

WHERE ss.total_orders >= 30

ORDER BY
    ss.merchandise_value DESC,
    late_delivery_rate DESC

LIMIT 20;
