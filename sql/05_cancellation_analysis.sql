-- Monthly Order Cancellation Analysis
-- Reporting period: January 2017 to August 2018

SELECT
    strftime('%Y-%m', order_purchase_timestamp)
        AS order_month,

    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN order_status = 'canceled' THEN 1
            ELSE 0
        END
    ) AS canceled_orders,

    ROUND(
        SUM(
            CASE
                WHEN order_status = 'canceled' THEN 1
                ELSE 0
            END
        ) * 100.0 / NULLIF(COUNT(*), 0),
        2
    ) AS cancellation_rate

FROM orders

WHERE order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp < '2018-09-01'

GROUP BY strftime('%Y-%m', order_purchase_timestamp)

ORDER BY cancellation_rate DESC;