# Pseudocode – E-Commerce Order and Customer Analytics System

1. Start application.
2. Create Customers, Products, and Orders data frames.
3. Define Customer and Product classes using S3 objects.
4. Define reusable functions for registration, products, orders, discounts, payments, reports, file handling, and graphs.
5. Display menu repeatedly.
6. For customer registration, collect name and email, validate inputs, generate Customer ID, and store the customer.
7. For product management, collect product name, category, price, and stock, validate inputs, generate Product ID, and store the product.
8. For order placement, verify customer and product IDs, check stock and quantity, calculate base amount, apply category-based discount, calculate final amount, reduce stock, create order, and process payment.
9. For cancellation, locate the order, change status to Cancelled, and restore product stock.
10. Generate total revenue, average order value, best-selling product, customer purchase, and low-stock reports using data-frame aggregation, filtering, sorting, and merging.
11. Generate bar charts and scatter plots using base R graphics.
12. Save Customers, Products, and Orders as CSV files and provide a load option.
13. Continue until the user selects Exit.
14. End application.
