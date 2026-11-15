import sqlite3
from pathlib import Path
import pandas as pd

# Define project folder
project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

# Database location
database_path = (
    project_folder / "data" / "processed" / "marketplace.db"
)

# SQL file location
sql_file = project_folder / "sql" / "18_seller_risk_prioritization.sql"    

# Read the SQL query
query = sql_file.read_text(encoding="utf-8")

# Connect to database and execute query
with sqlite3.connect(database_path) as connection:
    result = pd.read_sql_query(query, connection)

# Display the result
print("SQL QUERY RESULT")
print("----------------")

print(result.to_string(index=False))

print("\nRows returned:", len(result))