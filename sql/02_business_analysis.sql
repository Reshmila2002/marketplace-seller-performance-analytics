-- Query 1: Monthly marketplace order trends

SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY strftime('%Y-%m', order_purchase_timestamp)
ORDER BY order_month;
