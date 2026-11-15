-- Query 1: Display the first 10 orders

--SELECT *
--FROM orders
--LIMIT 10;

-- Query 2: Retrieve selected order columns

--SELECT
--    order_id,
--    order_status,
--    order_purchase_timestamp
--FROM orders
--LIMIT 10;

-- Query 3: Find delivered orders

--SELECT
--    order_id,
--    order_status,
--    order_purchase_timestamp,
--    order_delivered_customer_date
--FROM orders
--WHERE order_status = 'delivered'
--LIMIT 10;

-- Query 4: Find the most recent orders

--SELECT
--    order_id,
--    order_status,
--    order_purchase_timestamp
--FROM orders
--ORDER BY order_purchase_timestamp DESC
--LIMIT 10;

-- Query 5: Count total orders

--  SELECT
--    COUNT(*) AS total_orders
--FROM orders;

-- Query 6: Count delivered orders

--SELECT
--    COUNT(*) AS delivered_orders
--FROM orders
--WHERE order_status = 'delivered';

-- Query 7: Count orders by status

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;