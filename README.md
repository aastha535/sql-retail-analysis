Retail Sales Performance Analysis | SQL

Project Type: Personal Project
Tools: SQL (PostgreSQL/MySQL/SQL Server compatible)
Dataset: Retail sales transactions (columns: order_id, customer_name, region, city, category, sub_category, product_name, quantity, unit_price, discount, sales, profit, payment_mode)

1. Project Overview

This project demonstrates end-to-end SQL analysis of retail sales data to extract actionable business insights. The focus is on:

Identifying high-performing regions, cities, categories, and products

Analyzing customer behavior, including repeat customers

Evaluating the impact of discounts on profitability

Ranking products and sub-categories for strategic decision-making

Goal: Help business teams make data-driven decisions to improve revenue, profit, and customer retention.

2. Key Business Questions

Which regions, cities, and categories generate the highest revenue and profit?

Who are the top customers and repeat customers?

Which products and sub-categories are most profitable?

How do discounts affect sales and profit?

Which payment modes are preferred across regions?

3. Project Structure
📁 SQL-Retail-Analysis
 ├── dataset.csv          # Raw dataset
 ├── queries.sql          # SQL queries (beginner + advanced)
 └── README.md            # Project documentation (this file)


Notes:

All SQL queries are written to run independently.

Queries include aggregations, filtering, window functions, and CTEs.

Insights are documented in this README.

4. SQL Queries & Insights
A. Basic Metrics (KPI Overview)

Query: Total sales, profit, and quantity

SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM sales_data;


Insight:

Provides overall business performance metrics.

Serves as a baseline for detailed analysis.

B. Regional & City Performance

Query: Total sales and profit by region

SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;


Insight:

Identified the most profitable regions.

Business can allocate resources and marketing campaigns to top regions.

Query: Top 10 cities by sales

SELECT
    city,
    SUM(sales) AS city_sales
FROM sales_data
GROUP BY city
ORDER BY city_sales DESC
LIMIT 10;


Insight:

Highlights high-performing cities for targeted promotions.

C. Product & Category Analysis

Query: Total profit by category and sub-category

SELECT
    category,
    sub_category,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY category, sub_category
ORDER BY total_profit DESC;


Insight:

Identifies high-profit categories and sub-categories.

Helps prioritize inventory and marketing focus.

Query: Top 5 products per region (Advanced: Window Function)

SELECT *
FROM (
    SELECT
        region,
        product_name,
        SUM(profit) AS total_profit,
        RANK() OVER (PARTITION BY region ORDER BY SUM(profit) DESC) AS product_rank
    FROM sales_data
    GROUP BY region, product_name
) AS ranked_products
WHERE product_rank <= 5
ORDER BY region, product_rank;


Insight:

Provides region-specific product rankings.

Supports region-level inventory and marketing strategies.

D. Customer Analysis

Query: Repeat customers

WITH repeat_customers AS (
    SELECT customer_name, COUNT(DISTINCT order_id) AS total_orders
    FROM sales_data
    GROUP BY customer_name
    HAVING COUNT(DISTINCT order_id) > 1
)
SELECT *
FROM repeat_customers
ORDER BY total_orders DESC;


Insight:

Identified loyal customers who place multiple orders.

Business can create loyalty programs or personalized offers for repeat customers.

Query: Top 10 customers by total sales

SELECT
    customer_name,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;


Insight:

Recognizes high-value customers for strategic relationship management.

E. Discount Impact Analysis

Query: High discount impact on profit

SELECT
    category,
    sub_category,
    COUNT(order_id) AS orders_count,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    AVG(discount) AS avg_discount
FROM sales_data
WHERE discount > 0.2
GROUP BY category, sub_category
ORDER BY total_profit ASC;


Insight:

Discounts over 20% increased sales but decreased profitability in certain categories.

Supports data-driven discount strategy to maximize profit.

F. Payment Mode Analysis

Query: Orders and sales by payment mode

SELECT
    payment_mode,
    COUNT(order_id) AS total_orders,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY payment_mode
ORDER BY total_orders DESC;


Insight:

Shows the most preferred payment methods across all transactions.

Helps optimize checkout processes and payment options.

5. Key Takeaways / Recommendations

Focus marketing and inventory on top regions and cities.

Promote high-profit categories and products.

Target repeat customers for loyalty campaigns.

Use discounts strategically, avoiding over-discounting high-margin items.

Optimize payment options based on customer preference.

6. Skills Demonstrated

SQL Aggregations (SUM, AVG, COUNT)

Filtering & conditional logic (WHERE, HAVING)

Grouping & Ranking (GROUP BY, RANK(), PARTITION BY)

Window Functions & CTEs

Business analysis mindset: KPIs, customer behavior, profitability

Insight generation & actionable recommendations

7. Recruiter-Friendly Notes

Queries are structured for clarity and efficiency.

Insights are separate from code, making it professional & portfolio-ready.

This project demonstrates analytical thinking, SQL proficiency, and business insight — perfect for an intern or junior data analyst role.
