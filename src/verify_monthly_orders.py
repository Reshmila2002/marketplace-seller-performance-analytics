import sqlite3
import pandas as pd
from pathlib import Path

project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

database_path = (
    project_folder / "data" / "processed" / "marketplace.db"
)

query = """
SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY strftime('%Y-%m', order_purchase_timestamp)
ORDER BY order_month;
"""

with sqlite3.connect(database_path) as connection:
    monthly_orders = pd.read_sql_query(query, connection)

    original_total = connection.execute(
        "SELECT COUNT(*) FROM orders"
    ).fetchone()[0]

print("Monthly order total:", monthly_orders["total_orders"].sum())
print("Original order total:", original_total)

print(
    "Totals match:",
    monthly_orders["total_orders"].sum() == original_total
)