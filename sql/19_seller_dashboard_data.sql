
-- Complete Seller Performance Dataset for Power BI
-- Delivered orders with valid delivery dates

WITH seller_items AS (
    SELECT
        oi.seller_id,
        oi.order_id,
        oi.price,
        oi.freight_value,

        CASE
            WHEN julianday(o.order_delivered_customer_date)
               > julianday(o.order_estimated_delivery_date)
            THEN 1 ELSE 0
        END AS is_late,

        julianday(o.order_delivered_customer_date)
        - julianday(o.order_purchase_timestamp)
            AS delivery_days

    FROM order_items AS oi
    INNER JOIN orders AS o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp IS NOT NULL
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
),

seller_orders AS (
    SELECT
        seller_id,
        order_id,
        MAX(is_late) AS is_late,
        MAX(delivery_days) AS delivery_days
    FROM seller_items
    GROUP BY seller_id, order_id
),

seller_delivery AS (
    SELECT
        seller_id,
        COUNT(*) AS total_orders,
        SUM(is_late) AS late_orders,
        AVG(delivery_days) AS average_delivery_days
    FROM seller_orders
    GROUP BY seller_id
),

seller_sales AS (
    SELECT
        seller_id,
        COUNT(*) AS order_item_records,
        SUM(price) AS merchandise_value,
        SUM(freight_value) AS freight_value,
        SUM(
            CASE WHEN is_late = 1
            THEN price ELSE 0 END
        ) AS delayed_merchandise_value
    FROM seller_items
    GROUP BY seller_id
)

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,

    d.total_orders,
    d.late_orders,
    d.total_orders - d.late_orders AS on_time_orders,

    ROUND(
        d.late_orders * 100.0 / NULLIF(d.total_orders, 0),
        2
    ) AS late_delivery_rate,

    ROUND(d.average_delivery_days, 2)
        AS average_delivery_days,

    v.order_item_records,
    ROUND(v.merchandise_value, 2)
        AS merchandise_value,
    ROUND(v.freight_value, 2)
        AS freight_value,
    ROUND(v.delayed_merchandise_value, 2)
        AS delayed_merchandise_value

FROM seller_delivery AS d

INNER JOIN seller_sales AS v
    ON d.seller_id = v.seller_id

INNER JOIN sellers AS s
    ON d.seller_id = s.seller_id

ORDER BY merchandise_value DESC;
