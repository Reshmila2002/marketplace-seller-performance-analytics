
import pandas as pd
from pathlib import Path

project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

file_path = (
    project_folder / "data" / "processed"
    / "seller_dashboard_data.csv"
)

df = pd.read_csv(file_path)

# Check basic data quality
print("SELLER DASHBOARD VERIFICATION")
print("-----------------------------")

print("Total sellers:", len(df))
print("Duplicate seller IDs:", df["seller_id"].duplicated().sum())
print("Missing values:", df.isnull().sum().sum())

# Check delivery calculations
invalid_late_counts = (
    (df["late_orders"] > df["total_orders"])
    | (df["late_orders"] < 0)
).sum()

invalid_order_totals = (
    df["late_orders"] + df["on_time_orders"]
    != df["total_orders"]
).sum()

print("Invalid late-order counts:", invalid_late_counts)
print("Inconsistent order totals:", invalid_order_totals)

# Calculate overall seller metrics
total_merchandise = df["merchandise_value"].sum()
total_seller_orders = df["total_orders"].sum()
total_late_orders = df["late_orders"].sum()

weighted_late_rate = (
    total_late_orders / total_seller_orders * 100
)

print("\nSELLER DASHBOARD KPIs")
print("----------------------")

print("Active sellers:", len(df))
print("Seller-order associations:", total_seller_orders)
print("Late seller-order associations:", total_late_orders)
print("Weighted late rate:", round(weighted_late_rate, 2), "%")
print("Merchandise value: R$", round(total_merchandise, 2))

# Reproduce the previous risk-selection rules
risk_sellers = df[
    (df["total_orders"] >= 30)
    & (df["merchandise_value"] >= 20000)
    & (
        df["late_orders"] * 100.0
        / df["total_orders"] >= 10
    )
]

print("\nRISK SCREENING VERIFICATION")
print("----------------------------")
print("Qualifying sellers:", len(risk_sellers))

print(
    "Delayed merchandise value: R$",
    round(risk_sellers["delayed_merchandise_value"].sum(), 2)
)
