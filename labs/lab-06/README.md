# Lab 06: Aggregate, Mathematical and String Functions

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab06` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** COUNT, AVG, SUM, MIN, MAX, GROUP BY, HAVING, UPPER, LOWER, CONCAT, LENGTH, FLOOR, CEIL, ROUND  
**Original manual alignment:** Source Lab VI (pages 41–47); repairs malformed aggregate expressions and uses text functions on text columns.

## 1. Learning objectives

1. Summarize numerical records using aggregate functions.
2. Group records and filter groups using HAVING.
3. Distinguish row-level calculations from grouped calculations.
4. Use essential text and numeric functions.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

Aggregate functions compute values across many rows (`COUNT`, `AVG`, `SUM`, `MIN`, `MAX`). `GROUP BY` forms sets of rows and `HAVING` filters aggregate groups. `WHERE` filters individual rows *before* grouping. Scalar functions such as `UPPER`, `LOWER`, `SUBSTRING`, `FLOOR`, `CEIL`, and `ROUND` compute one result per input row. `LENGTH` counts bytes; `CHAR_LENGTH` counts characters.

## 4. Instructor's walkthrough

1. Introduce product price and quantity as two distinct values.
2. Compute total product count, average unit price, max/min, and total sales.
3. Explain why line revenue uses `product_price * product_quantity`.
4. Group by product_type and filter with HAVING.
5. Show scalar function output side-by-side with the original text/numbers.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.

```sql
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
```

## 6. Expected results to check in front of students

- `total_products = 6`.
- `total_sales = 108175.00` (sum of price × quantity).
- `electronics_count = 3`; `maximum_price = 67000.00`; `minimum_price = 35.00`.
- Category sales: electronics **107800.00**, stationery **250.00**, beverage **125.00**.

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab06;
SELECT SUM(product_price*product_quantity) AS total_sales FROM product_order_info;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. Add two products and recompute the total sales.
2. Find categories with total revenue over 200.
3. Compute the average price per product_type.
4. Using your own employee table, find the minimum, maximum, and average salary by department.

## 8. Viva / checkpoint questions

1. How is `COUNT(*)` different from `COUNT(column)`?
2. What is the difference between WHERE and HAVING?
3. Why multiply price by quantity to calculate sales?

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab06;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
