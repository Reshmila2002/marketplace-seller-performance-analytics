# Import required libraries
import sqlite3
from pathlib import Path

# Define project directory
project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

# Create database file inside data/processed
database_path = (
    project_folder
    / "data"
    / "processed"
    / "marketplace.db"
)

# Connect to SQLite database
connection = sqlite3.connect(database_path)

print("SQLite database created successfully!")
print("Database location:", database_path)

# Close database connection
connection.close()

print("Database connection closed successfully!")