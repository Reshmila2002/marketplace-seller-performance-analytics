
-- High-Value Seller Risk Prioritization
-- Historical delivered orders with valid delivery dates

WITH item_delivery AS (
    SELECT
        oi.seller_id,
        oi.order_id,
        oi.price,

        CASE
            WHEN julianday(o.order_delivered_customer_date)
               > julianday(o.order_estimated_delivery_date)
            THEN 1
            ELSE 0
        END AS is_late

    FROM order_items AS oi

    INNER JOIN orders AS o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp IS NOT NULL
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
),

seller_summary AS (
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) AS total_orders,
        ROUND(SUM(price), 2) AS merchandise_value,
        ROUND(
            SUM(CASE WHEN is_late = 1 THEN price ELSE 0 END),
            2
        ) AS delayed_merchandise_value

    FROM item_delivery
    GROUP BY seller_id
),

seller_late_counts AS (
    SELECT
        seller_id,
        SUM(is_late) AS late_orders

    FROM (
        SELECT DISTINCT
            seller_id,
            order_id,
            is_late
        FROM item_delivery
    )

    GROUP BY seller_id
)

SELECT
    ss.seller_id,
    s.seller_state,
    ss.total_orders,
    lc.late_orders,

    ROUND(
        lc.late_orders * 100.0 / NULLIF(ss.total_orders, 0),
        2
    ) AS late_delivery_rate,

    ss.merchandise_value,
    ss.delayed_merchandise_value

FROM seller_summary AS ss

INNER JOIN seller_late_counts AS lc
    ON ss.seller_id = lc.seller_id

INNER JOIN sellers AS s
    ON ss.seller_id = s.seller_id

WHERE ss.total_orders >= 30
  AND ss.merchandise_value >= 20000
  AND lc.late_orders * 100.0
      / NULLIF(ss.total_orders, 0) >= 10

ORDER BY
    ss.delayed_merchandise_value DESC,
    lc.late_orders DESC;
