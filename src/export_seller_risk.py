
import sqlite3
import pandas as pd
from pathlib import Path

# Define project location
project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

# Database and SQL paths
database_path = (
    project_folder / "data" / "processed" / "marketplace.db"
)

sql_file = (
    project_folder / "sql" / "18_seller_risk_prioritization.sql"
)

# Output folder
output_folder = project_folder / "data" / "processed"
output_folder.mkdir(parents=True, exist_ok=True)

# Read SQL query
query = sql_file.read_text(encoding="utf-8")

# Execute SQL
with sqlite3.connect(database_path) as connection:
    seller_risk = pd.read_sql_query(query, connection)

# Export to CSV
output_file = output_folder / "seller_risk_analysis.csv"

seller_risk.to_csv(output_file, index=False)

print("Seller risk dataset exported successfully!")
print("Total sellers:", len(seller_risk))
print("File saved to:", output_file)

# Display first five records
print("\nFirst five records:")
print(seller_risk.head().to_string(index=False))
