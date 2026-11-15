-- Seller Concentration Analysis
-- Based on merchandise value from delivered orders

WITH seller_sales AS (
    SELECT
        oi.seller_id,
        SUM(oi.price) AS merchandise_value

    FROM order_items AS oi

    INNER JOIN orders AS o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY oi.seller_id
),

ranked_sellers AS (
    SELECT
        seller_id,
        merchandise_value,

        ROW_NUMBER() OVER (
            ORDER BY merchandise_value DESC, seller_id
        ) AS seller_rank

    FROM seller_sales
)

SELECT
    COUNT(*) AS total_active_sellers,

    ROUND(SUM(merchandise_value), 2)
        AS total_merchandise_value,

    ROUND(
        SUM(
            CASE
                WHEN seller_rank <= 10
                THEN merchandise_value
                ELSE 0
            END
        ) * 100.0 / NULLIF(SUM(merchandise_value), 0),
        2
    ) AS top_10_share_percentage,

    ROUND(
        SUM(
            CASE
                WHEN seller_rank <= 20
                THEN merchandise_value
                ELSE 0
            END
        ) * 100.0 / NULLIF(SUM(merchandise_value), 0),
        2
    ) AS top_20_share_percentage,

    ROUND(
        SUM(
            CASE
                WHEN seller_rank <= 100
                THEN merchandise_value
                ELSE 0
            END
        ) * 100.0 / NULLIF(SUM(merchandise_value), 0),
        2
    ) AS top_100_share_percentage

FROM ranked_sellers;