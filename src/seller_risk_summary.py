
import pandas as pd
from pathlib import Path

project_folder = Path(
    r"C:\DataAnalytics\Marketplace-Intelligence"
)

file_path = (
    project_folder / "data" / "processed"
    / "seller_risk_analysis.csv"
)

# Load filtered seller risk data
seller_risk = pd.read_csv(file_path)

# Calculate summary metrics
total_sellers = len(seller_risk)

total_orders = seller_risk["total_orders"].sum()

total_late_orders = seller_risk["late_orders"].sum()

total_merchandise_value = seller_risk["merchandise_value"].sum()

delayed_merchandise_value = (
    seller_risk["delayed_merchandise_value"].sum()
)

# Calculate weighted late delivery rate
weighted_late_rate = (
    total_late_orders / total_orders * 100
    if total_orders > 0 else 0
)

print("SELLER RISK SUMMARY")
print("-------------------")

print("Qualifying sellers:", total_sellers)
print("Seller-associated orders:", total_orders)
print("Late seller-associated orders:", total_late_orders)

print(
    "Weighted late delivery rate:",
    round(weighted_late_rate, 2),
    "%"
)

print(
    "Total merchandise value: R$",
    round(total_merchandise_value, 2)
)

print(
    "Delayed merchandise value: R$",
    round(delayed_merchandise_value, 2)
)

print(
    "Delayed merchandise value share:",
    round(
        delayed_merchandise_value
        / total_merchandise_value * 100,
        2
    ) if total_merchandise_value > 0 else 0,
    "%"
)
