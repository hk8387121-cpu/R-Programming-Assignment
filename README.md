# E-Commerce Order and Customer Analytics System

ITA0401 – Statistics with R Programming

## Project Overview

A menu-driven R application for managing customers, products, inventory, and orders while generating sales and customer analytics.

## Features

- Customer registration with input validation
- Product management for Electronics, Clothing, and Grocery
- Inventory updates during order placement and cancellation
- Category-based discount calculation
- Payment processing using UPI, Card, or Cash
- Order placement and cancellation
- Total revenue and order-value reports
- Best-selling product analysis
- Customer purchase comparison
- Low-stock identification
- Data-frame filtering, aggregation, sorting, merging, and CSV file handling
- S3-based Customer and Product objects
- Bar charts and scatter plots using base R graphics

## Folder Structure

```text
.
├── README.md
├── implementation/
│   └── e_commerce_analytics.R
├── data/
│   ├── customers.csv
│   ├── products.csv
│   └── orders.csv
├── pseudocode/
│   └── pseudocode.md
└── results/
    └── sample_results.md
```

## How to Run

Open `implementation/e_commerce_analytics.R` in RStudio and run the script.

Use option `13` first to load the built-in demo data. Then use the menu options to test orders, reports, inventory, and graphs.

The `save_data()` option writes the current data to the `data/` folder. The `load_data()` option reads the CSV files back into the application.

## Main Menu

1. Register Customer
2. Add Product
3. View Products
4. Place Order
5. Cancel Order
6. Sales Report
7. Best-Selling Products
8. Customer Purchase Comparison
9. Low-Stock Products
10. Show Graphs
11. Save Data
12. Load Data
13. Load Demo Data
0. Exit

## Technologies

- R Programming Language
- Base R data frames
- S3 object-oriented programming
- CSV file I/O
- Base R visualization

## Assignment Deliverables

The repository contains the implementation, pseudocode, sample results, and datasets required for the ITA0401 assignment.
