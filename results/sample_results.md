# Sample Implementation Results

The following results are representative outputs from the implemented workflow using the built-in demo data.

## Customer Registration

Customer details are validated and assigned IDs such as `C001`.

## Product Management

Products are stored with product ID, name, category, price, and stock. Supported categories are Electronics, Clothing, and Grocery.

## Order Placement

The program validates customer ID, product ID, and quantity. It calculates the base amount, category-specific discount, final order amount, updates inventory, records the order, and processes payment.

Example:

```text
Order placed: O1001
Base amount: Rs. 65000
Discount: 9750 (15%)
Final amount: Rs. 55250
Payment of Rs. 55250 processed using UPI
```

## Order Cancellation

Cancelled orders are marked as `Cancelled` and their quantities are returned to inventory.

## Sales Report

The report displays total completed orders, total revenue, average order value, and maximum order value.

## Best-Selling Products

Completed orders are aggregated by ProductID and sorted in descending order of units sold.

## Customer Purchase Comparison

Completed purchases are aggregated by CustomerID and merged with the customer data to compare total spending.

## Low-Stock Report

Products with stock less than or equal to the threshold are listed for inventory monitoring.

## Visualization

The program generates:

- Revenue by customer bar chart
- Units sold by product bar chart
- Quantity versus order value scatter plot

## File Handling

Customers, Products, and Orders can be written to CSV files and loaded back into the application.
