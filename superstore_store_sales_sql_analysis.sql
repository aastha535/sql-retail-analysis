create database sales_analysis1;
use sales_analysis1;

--creating table---
CREATE TABLE sales_data (
    order_id VARCHAR(50),
    customer_name VARCHAR(100),
    region VARCHAR(50),
    city VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(150),
    quantity INT,
    unit_price DECIMAL(10,2),
    discount DECIMAL(4,2),
    sales DECIMAL(10,2),
    profit DECIMAL(10,2),
    payment_mode VARCHAR(50)
);

----data cleaning---
select * from sales_data;
--check null values--
SELECT *
FROM sales_data
WHERE sales IS NULL OR profit IS NULL;

---remove or flag negative profit orders---
SELECT *
FROM sales_data
WHERE profit < 0;

----basic KPI metrics---
SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM sales_data;

----regional performance analysis--
--sales & profit by region---
SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;

---city-level top performance--
SELECT
    city,
    SUM(sales) AS city_sales
FROM sales_data
GROUP BY city
ORDER BY city_sales DESC
LIMIT 10;

---category & product analysis---
---category profitabillity---
SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_profit DESC;

----top 10 profitable products---
SELECT
    product_name,
    SUM(profit) AS product_profit
FROM sales_data
GROUP BY product_name
ORDER BY product_profit DESC
LIMIT 10;

----discount impact analysis---
---profit & discount---
SELECT
    discount,
    COUNT(order_id) AS orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY discount
ORDER BY discount;

-----customer analysis--
---top 10 customers by sales---
SELECT
    customer_name,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

---repeat customers---
SELECT
    customer_name,
    COUNT(distinct order_id) as total_orders
    from sales_data
    group by customer_name
    having count(distinct order_id) > 1;

--payment mode analysis--
SELECT
    payment_mode,
    COUNT(order_id) AS total_orders,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY payment_mode
ORDER BY total_orders DESC;

---ranking product by profit---
SELECT
    product_name,
    SUM(profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM sales_data
GROUP BY product_name;

---repeat customers+region+ discount analysis

WITH repeat_customers AS (
    SELECT customer_name, COUNT(DISTINCT order_id) AS orders
    FROM sales_data
    GROUP BY customer_name
    HAVING COUNT(DISTINCT order_id) > 1
)
SELECT
    s.region,
    COUNT(DISTINCT rc.customer_name) AS repeat_customers,
    SUM(s.sales) AS total_sales,
    AVG(s.discount) AS avg_discount
FROM sales_data s
JOIN repeat_customers rc
    ON s.customer_name = rc.customer_name
GROUP BY s.region
ORDER BY repeat_customers DESC;

----top 5 product per region----
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

-----high discount impact on profit
SELECT
    category,
    sub_category,
    COUNT(order_id) AS orders_count,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    AVG(discount) AS avg_discount
FROM sales_data
WHERE discount > 0.2  -- filters high discount orders
GROUP BY category, sub_category
ORDER BY total_profit ASC;

----CTE+ repeat customers
WITH repeat_customers AS (
    SELECT customer_name, COUNT(DISTINCT order_id) AS total_orders
    FROM sales_data
    GROUP BY customer_name
    HAVING COUNT(DISTINCT order_id) > 1
)
SELECT
    region,
    COUNT(DISTINCT rc.customer_name) AS repeat_customers,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data s
JOIN repeat_customers rc
    ON s.customer_name = rc.customer_name
GROUP BY region
ORDER BY repeat_customers DESC;



