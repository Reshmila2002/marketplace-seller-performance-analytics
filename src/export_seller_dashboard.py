
import sqlite3
import pandas as pd
from pathlib import Path

project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

database_path = (
    project_folder / "data" / "processed" / "marketplace.db"
)

sql_path = (
    project_folder / "sql" / "19_seller_dashboard_data.sql"
)

output_path = (
    project_folder / "data" / "processed"
    / "seller_dashboard_data.csv"
)

query = sql_path.read_text(encoding="utf-8")

with sqlite3.connect(database_path) as connection:
    seller_dashboard = pd.read_sql_query(
        query, connection
    )

seller_dashboard.to_csv(output_path, index=False)

print("SELLER DASHBOARD DATA EXPORTED")
print("------------------------------")
print("Total sellers:", len(seller_dashboard))
print("Duplicate seller IDs:",
      seller_dashboard["seller_id"].duplicated().sum())
print("Missing values:",
      seller_dashboard.isnull().sum().sum())
print("File location:", output_path)

print("\nFirst five records:")
print(seller_dashboard.head().to_string(index=False))
