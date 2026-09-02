options(stringsAsFactors = FALSE)

customers <- data.frame(
  CustomerID = character(), Name = character(), Email = character(),
  stringsAsFactors = FALSE
)

products <- data.frame(
  ProductID = character(), ProductName = character(), Category = character(),
  Price = numeric(), Stock = integer(),
  stringsAsFactors = FALSE
)

orders <- data.frame(
  OrderID = character(), CustomerID = character(), ProductID = character(),
  Quantity = integer(), OrderTotal = numeric(), Status = character(),
  stringsAsFactors = FALSE
)

next_order_id <- 1001

customer_class <- function(id, name, email) {
  x <- list(CustomerID = id, Name = name, Email = email)
  class(x) <- "Customer"
  x
}

product_class <- function(id, name, category, price, stock) {
  x <- list(ProductID = id, ProductName = name, Category = category,
            Price = price, Stock = stock)
  class(x) <- "Product"
  x
}

print.Customer <- function(x, ...) {
  cat("Customer:", x$CustomerID, "|", x$Name, "|", x$Email, "\n")
}

print.Product <- function(x, ...) {
  cat("Product:", x$ProductID, "|", x$ProductName, "|", x$Category,
      "| Price:", x$Price, "| Stock:", x$Stock, "\n")
}

discount_rate <- function(category, amount) {
  category <- tolower(category)
  if (category == "electronics") {
    return(ifelse(amount >= 50000, 0.15, 0.10))
  }
  if (category == "clothing") {
    return(ifelse(amount >= 5000, 0.12, 0.08))
  }
  if (category == "grocery") {
    return(ifelse(amount >= 2000, 0.05, 0.03))
  }
  0.02
}

validate_email <- function(email) {
  grepl("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", email)
}

register_customer <- function() {
  id <- paste0("C", sprintf("%03d", nrow(customers) + 1))
  name <- trimws(readline("Enter customer name: "))
  email <- trimws(readline("Enter email: "))
  if (name == "" || !validate_email(email)) {
    cat("Invalid customer details.\n")
    return(invisible(NULL))
  }
  customers <<- rbind(customers,
                       data.frame(CustomerID = id, Name = name, Email = email))
  print(customer_class(id, name, email))
  cat("Customer registered successfully.\n")
}

add_product <- function() {
  id <- paste0("P", sprintf("%03d", nrow(products) + 1))
  name <- trimws(readline("Enter product name: "))
  category <- tolower(trimws(readline("Enter category (electronics/clothing/grocery): ")))
  price <- suppressWarnings(as.numeric(readline("Enter price: ")))
  stock <- suppressWarnings(as.integer(readline("Enter stock: ")))
  valid_cat <- category %in% c("electronics", "clothing", "grocery")
  if (name == "" || !valid_cat || is.na(price) || price <= 0 || is.na(stock) || stock < 0) {
    cat("Invalid product details.\n")
    return(invisible(NULL))
  }
  products <<- rbind(products,
                      data.frame(ProductID = id, ProductName = name,
                                 Category = category, Price = price,
                                 Stock = stock))
  print(product_class(id, name, category, price, stock))
  cat("Product added successfully.\n")
}

view_products <- function() {
  if (nrow(products) == 0) cat("No products available.\n") else print(products)
}

place_order <- function() {
  if (nrow(customers) == 0 || nrow(products) == 0) {
    cat("Add at least one customer and one product first.\n")
    return(invisible(NULL))
  }
  print(customers)
  cid <- trimws(readline("Enter customer ID: "))
  if (!cid %in% customers$CustomerID) {
    cat("Customer not found.\n")
    return(invisible(NULL))
  }
  print(products)
  pid <- trimws(readline("Enter product ID: "))
  idx <- match(pid, products$ProductID)
  if (is.na(idx)) {
    cat("Product not found.\n")
    return(invisible(NULL))
  }
  qty <- suppressWarnings(as.integer(readline("Enter quantity: ")))
  if (is.na(qty) || qty <= 0 || qty > products$Stock[idx]) {
    cat("Invalid quantity or insufficient stock.\n")
    return(invisible(NULL))
  }
  base <- products$Price[idx] * qty
  rate <- discount_rate(products$Category[idx], base)
  discount <- base * rate
  total <- base - discount
  oid <- paste0("O", next_order_id)
  next_order_id <<- next_order_id + 1
  products$Stock[idx] <<- products$Stock[idx] - qty
  orders <<- rbind(orders,
                    data.frame(OrderID = oid, CustomerID = cid, ProductID = pid,
                               Quantity = qty, OrderTotal = total, Status = "Completed"))
  cat("Order placed:", oid, "\n")
  cat("Base amount: Rs.", round(base, 2), "\n")
  cat("Discount:", round(discount, 2), "(", rate * 100, "%)\n")
  cat("Final amount: Rs.", round(total, 2), "\n")
  process_payment(total)
}

process_payment <- function(amount) {
  method <- tolower(trimws(readline("Enter payment method (UPI/Card/Cash): ")))
  if (!method %in% c("upi", "card", "cash")) {
    cat("Unsupported payment method.\n")
    return(FALSE)
  }
  cat("Payment of Rs.", round(amount, 2), "processed using", toupper(method), "\n")
  TRUE
}

cancel_order <- function() {
  if (nrow(orders) == 0) {
    cat("No orders available.\n")
    return(invisible(NULL))
  }
  print(orders)
  oid <- trimws(readline("Enter order ID to cancel: "))
  idx <- match(oid, orders$OrderID)
  if (is.na(idx) || orders$Status[idx] == "Cancelled") {
    cat("Order not found or already cancelled.\n")
    return(invisible(NULL))
  }
  pidx <- match(orders$ProductID[idx], products$ProductID)
  products$Stock[pidx] <<- products$Stock[pidx] + orders$Quantity[idx]
  orders$Status[idx] <<- "Cancelled"
  cat("Order cancelled successfully. Stock restored.\n")
}

low_stock_report <- function(threshold = 5) {
  x <- products[products$Stock <= threshold, ]
  if (nrow(x) == 0) cat("No low-stock products.\n") else print(x)
}

best_selling_products <- function() {
  x <- orders[orders$Status == "Completed", ]
  if (nrow(x) == 0) {
    cat("No completed orders.\n")
    return(invisible(NULL))
  }
  agg <- aggregate(Quantity ~ ProductID, data = x, sum)
  agg <- merge(agg, products[, c("ProductID", "ProductName", "Category")], by = "ProductID")
  agg <- agg[order(-agg$Quantity), ]
  print(agg)
  invisible(agg)
}

customer_purchase_report <- function() {
  x <- orders[orders$Status == "Completed", ]
  if (nrow(x) == 0) {
    cat("No completed orders.\n")
    return(invisible(NULL))
  }
  agg <- aggregate(OrderTotal ~ CustomerID, data = x, sum)
  agg <- merge(agg, customers, by = "CustomerID")
  agg <- agg[order(-agg$OrderTotal), ]
  print(agg)
  invisible(agg)
}

sales_report <- function() {
  x <- orders[orders$Status == "Completed", ]
  revenue <- if (nrow(x) == 0) 0 else sum(x$OrderTotal)
  cat("Total orders:", nrow(x), "\n")
  cat("Total revenue: Rs.", round(revenue, 2), "\n")
  if (nrow(x) > 0) {
    cat("Average order value: Rs.", round(mean(x$OrderTotal), 2), "\n")
    cat("Maximum order value: Rs.", round(max(x$OrderTotal), 2), "\n")
  }
  invisible(revenue)
}

save_data <- function() {
  write.csv(customers, "data/customers.csv", row.names = FALSE)
  write.csv(products, "data/products.csv", row.names = FALSE)
  write.csv(orders, "data/orders.csv", row.names = FALSE)
  cat("Data saved to data/ directory.\n")
}

load_data <- function() {
  if (file.exists("data/customers.csv")) customers <<- read.csv("data/customers.csv")
  if (file.exists("data/products.csv")) products <<- read.csv("data/products.csv")
  if (file.exists("data/orders.csv")) orders <<- read.csv("data/orders.csv")
  if (nrow(orders) > 0) {
    nums <- suppressWarnings(as.integer(sub("O", "", orders$OrderID)))
    if (any(!is.na(nums))) next_order_id <<- max(nums) + 1
  }
  cat("Data loaded.\n")
}

show_graphs <- function() {
  x <- orders[orders$Status == "Completed", ]
  if (nrow(x) == 0) {
    cat("No completed orders for graphs.\n")
    return(invisible(NULL))
  }
  revenue_by_customer <- aggregate(OrderTotal ~ CustomerID, data = x, sum)
  barplot(revenue_by_customer$OrderTotal, names.arg = revenue_by_customer$CustomerID,
          main = "Revenue by Customer", xlab = "Customer", ylab = "Revenue (Rs.)")
  sales_by_product <- aggregate(Quantity ~ ProductID, data = x, sum)
  barplot(sales_by_product$Quantity, names.arg = sales_by_product$ProductID,
          main = "Units Sold by Product", xlab = "Product", ylab = "Quantity")
  plot(x$Quantity, x$OrderTotal, pch = 19,
       main = "Quantity vs Order Value", xlab = "Quantity", ylab = "Order Value (Rs.)")
  invisible(NULL)
}

seed_demo_data <- function() {
  customers <<- data.frame(
    CustomerID = c("C001", "C002", "C003"),
    Name = c("Aarav", "Diya", "Rahul"),
    Email = c("aarav@example.com", "diya@example.com", "rahul@example.com")
  )
  products <<- data.frame(
    ProductID = c("P001", "P002", "P003", "P004", "P005"),
    ProductName = c("Laptop", "Headphones", "T-Shirt", "Rice Bag", "Smartphone"),
    Category = c("electronics", "electronics", "clothing", "grocery", "electronics"),
    Price = c(65000, 3000, 1200, 1500, 40000),
    Stock = c(8L, 20L, 30L, 12L, 10L)
  )
  cat("Demo data loaded.\n")
}

menu <- function() {
  repeat {
    cat("\n===== E-COMMERCE ORDER AND CUSTOMER ANALYTICS SYSTEM =====\n")
    cat("1. Register Customer\n")
    cat("2. Add Product\n")
    cat("3. View Products\n")
    cat("4. Place Order\n")
    cat("5. Cancel Order\n")
    cat("6. Sales Report\n")
    cat("7. Best-Selling Products\n")
    cat("8. Customer Purchase Comparison\n")
    cat("9. Low-Stock Products\n")
    cat("10. Show Graphs\n")
    cat("11. Save Data\n")
    cat("12. Load Data\n")
    cat("13. Load Demo Data\n")
    cat("0. Exit\n")
    choice <- trimws(readline("Enter choice: "))
    switch(choice,
      "1" = register_customer(),
      "2" = add_product(),
      "3" = view_products(),
      "4" = place_order(),
      "5" = cancel_order(),
      "6" = sales_report(),
      "7" = best_selling_products(),
      "8" = customer_purchase_report(),
      "9" = low_stock_report(),
      "10" = show_graphs(),
      "11" = save_data(),
      "12" = load_data(),
      "13" = seed_demo_data(),
      "0" = { cat("Application closed.\n"); break },
      cat("Invalid choice. Try again.\n")
    )
  }
}

if (interactive()) menu()
