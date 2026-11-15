import sqlite3
from pathlib import Path

# Define database location
project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

database_path = (
    project_folder
    / "data"
    / "processed"
    / "marketplace.db"
)

# Connect to the existing SQLite database
connection = sqlite3.connect(database_path)

try:
    # Find all tables in the database
    query = """
    SELECT name
    FROM sqlite_master
    WHERE type = 'table'
    ORDER BY name;
    """

    tables = connection.execute(query).fetchall()

    print("DATABASE VERIFICATION")
    print("---------------------")
    print("Total tables:", len(tables))

    # Count records in each table
    for (table_name,) in tables:

        count_query = f'SELECT COUNT(*) FROM "{table_name}"'

        count = connection.execute(
            count_query
        ).fetchone()[0]

        print(f"{table_name}: {count:,} rows")

finally:
    connection.close()

print("\nDatabase verification completed!")