import sqlite3
import pandas as pd
from pathlib import Path

# Define project folder
project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

# Set folder and database paths
raw_folder = project_folder / "data" / "raw"

database_path = (
    project_folder / "data" / "processed" / "marketplace.db"
)

# Map CSV files to SQL table names
datasets = {
    "olist_customers_dataset.csv": "customers",
    "olist_orders_dataset.csv": "orders",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "olist_geolocation_dataset.csv": "geolocation",
    "product_category_name_translation.csv": "category_translation"
}

# Connect to SQLite
connection = sqlite3.connect(database_path)

try:
    for filename, table_name in datasets.items():

        file_path = raw_folder / filename

        print(f"Importing {filename} ...")

        # Read CSV
        df = pd.read_csv(file_path)

        # Import into SQLite
        df.to_sql(
            table_name,
            connection,
            if_exists="replace",
            index=False
        )

        print(
            f"Successfully imported {len(df)} rows "
            f"into {table_name}"
        )

    connection.commit()
    print("\nAll datasets imported successfully!")

finally:
    connection.close()