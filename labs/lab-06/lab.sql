-- CSE 210 | Lab 06 | Aggregate, text and numeric functions
DROP DATABASE IF EXISTS cse210_lab06;
CREATE DATABASE cse210_lab06 CHARACTER SET utf8mb4;
USE cse210_lab06;

CREATE TABLE product_order_info (
  product_no INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(80) NOT NULL,
  product_type ENUM('electronics','stationery','food','beverage') NOT NULL,
  product_price DECIMAL(10,2) NOT NULL,
  product_quantity SMALLINT NOT NULL,
  order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO product_order_info
(product_no,product_name,product_type,product_price,product_quantity) VALUES
(101,'Laptop','electronics',67000.00,1),
(102,'Mobile','electronics',23500.00,1),
(103,'Watch','electronics',8650.00,2),
(104,'Notebook','stationery',50.00,5),
(105,'Cola','beverage',35.00,2),
(106,'Lemon Soda','beverage',55.00,1);

-- Aggregate functions summarize multiple rows.
SELECT COUNT(*) AS total_products FROM product_order_info;
SELECT ROUND(AVG(product_price),2) AS average_price FROM product_order_info;
SELECT MIN(product_price) AS minimum_price,MAX(product_price) AS maximum_price FROM product_order_info;
SELECT SUM(product_price*product_quantity) AS total_sales FROM product_order_info;
SELECT COUNT(*) AS electronics_count FROM product_order_info WHERE product_type='electronics';

-- Row-level computed amount (not SUM across all rows).
SELECT product_no,product_name,product_quantity,
       product_price*product_quantity AS line_total
FROM product_order_info ORDER BY product_no;
-- Group totals and HAVING condition.
SELECT product_type,COUNT(*) AS products,
       SUM(product_price*product_quantity) AS category_sales
FROM product_order_info GROUP BY product_type ORDER BY product_type;
SELECT product_type,SUM(product_price*product_quantity) AS category_sales
FROM product_order_info GROUP BY product_type
HAVING SUM(product_price*product_quantity)>1000;

-- String and mathematical functions operate on each row.
SELECT product_name,UPPER(product_name) AS upper_name,
       LOWER(product_name) AS lower_name,
       LENGTH(product_name) AS byte_length,
       CHAR_LENGTH(product_name) AS char_length
FROM product_order_info ORDER BY product_no;
SELECT product_name,CONCAT(product_name,' - ',product_type) AS label,
       SUBSTRING(product_name,1,3) AS first_three,
       TRIM(CONCAT('  ',product_name,'  ')) AS trimmed
FROM product_order_info ORDER BY product_no;
SELECT product_name,product_price,
       FLOOR(product_price/3) AS floor_demo,
       CEIL(product_price/3) AS ceil_demo,
       ROUND(product_price/3,2) AS rounded_demo
FROM product_order_info ORDER BY product_no;
