
import sqlite3
import pandas as pd
from pathlib import Path

project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

database_path = (
    project_folder / "data" / "processed" / "marketplace.db"
)

sql_file = (
    project_folder / "sql" / "15_seller_state_share.sql"
)

query = sql_file.read_text(encoding="utf-8")

with sqlite3.connect(database_path) as connection:
    state_share = pd.read_sql_query(query, connection)

print("SELLER STATE SHARE VERIFICATION")
print("-------------------------------")

print(
    "Total merchandise value:",
    round(state_share["merchandise_value"].sum(), 2)
)

print(
    "Total share percentage:",
    round(state_share["merchandise_share_percentage"].sum(), 2)
)

print("Number of seller states:", len(state_share))
