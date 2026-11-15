-- Query 1: Join orders with customer locations

--SELECT
--    o.order_id,
--    o.order_status,
--    o.order_purchase_timestamp,
--    c.customer_city,
--    c.customer_state

--FROM orders AS o

--INNER JOIN customers AS c
--    ON o.customer_id = c.customer_id

--  LIMIT 10;

-- Query 2: Total marketplace orders by customer state

SELECT
    c.customer_state,

    COUNT(DISTINCT o.order_id) AS total_orders

FROM orders AS o

INNER JOIN customers AS c
    ON o.customer_id = c.customer_id

GROUP BY c.customer_state

ORDER BY total_orders DESC;