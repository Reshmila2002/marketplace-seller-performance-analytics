-- Customer Cohort Retention Analysis
-- Based on customers' delivered orders

WITH customer_purchases AS (
    SELECT DISTINCT
        c.customer_unique_id,
        substr(o.order_purchase_timestamp, 1, 7)
            AS purchase_month

    FROM orders AS o

    INNER JOIN customers AS c
        ON o.customer_id = c.customer_id

    WHERE o.order_status = 'delivered'
),

first_purchases AS (
    SELECT
        customer_unique_id,
        MIN(purchase_month) AS cohort_month

    FROM customer_purchases

    GROUP BY customer_unique_id
),

cohort_activity AS (
    SELECT
        p.customer_unique_id,
        f.cohort_month,
        p.purchase_month,

        (
            (
                CAST(substr(p.purchase_month, 1, 4) AS INTEGER)
                - CAST(substr(f.cohort_month, 1, 4) AS INTEGER)
            ) * 12
            +
            (
                CAST(substr(p.purchase_month, 6, 2) AS INTEGER)
                - CAST(substr(f.cohort_month, 6, 2) AS INTEGER)
            )
        ) AS month_number

    FROM customer_purchases AS p

    INNER JOIN first_purchases AS f
        ON p.customer_unique_id = f.customer_unique_id
),

cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(*) AS cohort_size
    FROM first_purchases
    GROUP BY cohort_month
)

SELECT
    a.cohort_month,
    a.month_number,
    s.cohort_size,

    COUNT(DISTINCT a.customer_unique_id)
        AS active_customers,

    ROUND(
        COUNT(DISTINCT a.customer_unique_id) * 100.0
        / NULLIF(s.cohort_size, 0),
        2
    ) AS retention_percentage

FROM cohort_activity AS a

INNER JOIN cohort_sizes AS s
    ON a.cohort_month = s.cohort_month

GROUP BY
    a.cohort_month,
    a.month_number,
    s.cohort_size

ORDER BY
    a.cohort_month,
    a.month_number;