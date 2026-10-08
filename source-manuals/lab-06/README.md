# Lab 06 — Implementation of MySQL Aggregate Function

**Source-faithful Markdown transcription:** Original PDF pages 47–53.  
**For live SQL:** [Runnable lab guide](../../labs/lab-06/README.md) · [Original complete PDF transcription](../../COMPLETE_SOURCE_MANUAL.md)

<!-- Original PDF page 47; printed lab page 41 -->

## 6.1 Objective(s)

- Gather knowledge about the aggregate function.

- Implement different types of aggregate functions AVG, COUNT, SUM, MIN, MAX, UCASE, LCASE, FLOOR etc.

## 6.2 Problem analysis

We mainly use the aggregate functions in databases, spreadsheets and many other data manipulation software packages. In the context of business, different organization levels need different information such as top levels managers interested in knowing whole figures and not the individual details. These functions produce the summarised data from our database. Thus they are extensively used in economics and finance to represent the economic health or stock and sector performance.

**MySQL aggregate functions**

| Aggregate function | Description |
| --- | --- |
| AVG() | Return the average of non-NULL values. |
| BIT_AND() | Return bitwise AND. |
| BIT_OR() | Return bitwise OR. |
| BIT_XOR() | Return bitwise XOR. |
| COUNT() | Return the number of rows in a group, including rows with NULL values. |
| GROUP_CONCAT() | Return a concatenated string. |
| JSON_ARRAYAGG() | Return result set as a single JSON array. |
| JSON_OBJECTAGG() | Return result set as a single JSON object. |
| MAX() | Return the highest value (maximum) in a set of non-NULL values. |
| MIN() | Return the lowest value (minimum) in a set of non-NULL values. |
| STDEV() | Return the population standard deviation. |
| STDDEV_POP() | Return the population standard deviation. |
| STDDEV_SAMP() | Return the sample standard deviation. |
| SUM() | Return the summation of all non-NULL values a set. |
| VAR_POP() | Return the population standard variance. |
| VARP_SAM() | Return the sample variance. |
| VARIANCE() | Return the population standard variance. |

![Full source table, PDF page 47](../../assets/source-figures/page-47-aggregate-functions.png)

<!-- Original PDF page 48; printed lab page 42 -->

SQL functions are similar to SQL operators in that both manipulate data items and both return a result. SQL functions differ from SQL operators in the format in which they appear with their arguments. The SQL function format enables functions to operate with zero, one, or more arguments. function(argument1, argument2, ...) alias If passed an argument whose datatype differs from an expected datatype, most functions perform an implicit datatype conversion on the argument before execution. If passed a null value, most functions return a null value. SQL functions are used exclusively with SQL commands within SQL statements. There are two general types of SQL functions: single row (or scalar) functions and aggregate functions. These two types differ in the number of database rows on which they act. A single row function returns a value based on a single row in a query, whereas an aggregate function returns a value based on all the rows in a query. Single row SQL functions can appear in select lists (except in SELECT statements that contain a GROUP BY clause) and WHERE clauses. Aggregate functions are the set functions: AVG, MIN, MAX, SUM, and COUNT. You must provide them with an alias that can be used by the GROUP BY function.

### 6.2.1 Using Mathematical Function

Relational databases store information in tables — with columns that are analogous to elements in a data structure and rows which are one instance of that data structure. The SQL language is used to interact with that database information. The SQL aggregate functions — AVG, COUNT, DISTINCT, MAX, MIN, SUM — all return a value computed or derived from one column’s values, after discarding any NULL values. The syntax of all these functions is:

- AVG() The AVG() function calculates the average value of a set of values. It ignores NULL in the calculation.

```sql
SELECT column1, column2, ... AVG (column1) FROM table_name
```

- SUM(): The SUM() function returns the sum of values in a set. The SUM() function ignores NULL. If no matching row found, the SUM() function returns NULL.

To get the total order value of each product, you can use the SUM() function in conjunction with the GROUP BY clause as follows:

```sql
SELECT column1, column2, ... SUM (column1) FROM table_name
```

- MAX(): The MAX() function returns the maximum value in a set. For example, you can use the MAX() function to get the highest buy price from the products table as shown in the following query:

```sql
SELECT column1, column2, ... MAX (column1) FROM table_name
```

- MIN(): The MIN() function returns the minimum value in a set of values. Code language: MySQL (Structured Query Language) (MySQL) For example, the following query uses the MIN() function to find the lowest price from the products table:

```sql
SELECT column1, column2, ... MIN (column1) FROM table_name
```

<!-- Original PDF page 49; printed lab page 43 -->

- Count(): MySQL count() function returns the total number of values in the expression. This function produces all rows or only some rows of the table based on a specified condition, and its return type is BIGINT. It returns zero if it does not find any matching rows. It can work with both numeric and non-numeric data types.

```sql
SELECT column1, column2, ... COUNT (column1) FROM table_name
```

### 6.2.2 Using Text /String Functions:)

1. CHAR() : It returns a string made up of the ASCII representation of the decimal value list. Strings in numeric format are converted to a decimal value. Null values are ignored.

2. CONCAT() :It returns argument str1concatenated with argument str2

```sql
SELECT CONCAT (column1, column12) FROM table_name
```

3. LOWER()/LCASE():It returns argument str, with all letters in lowercase.

```sql
SELECT LOWER (column1, column12) FROM table_name
```

4. SUBSTR(): Check by yourself.

5. UPPER()/UCASE(): Check by yourself.

6. LTRIM(): Check by yourself.

7. RTRIM(): Check by yourself.

8. TRIM(): Check by yourself.

9. INSTR(): Check by yourself.

10. LENGTH(): Check by yourself.

11. LEFT(): Check by yourself.

12. RIGHT(): Check by yourself.

13. MID(): Check by yourself.

## 6.3 Procedure (Implementation in MySQL)

1. Create a table product_order_info

- Insert Data:

```sql
CREATE TABLE product_order_info(
product_no int(11) NOT NULL AUTO_INCREMENT,
product_name varchar(255) NOT NULL,
product_type
enum(‘electronics’, ‘stationary’ , ‘food’ , ‘beverage’ ) DEFAULT
NULL,
product_price FLOAT(10,2) NOT NULL,
product_quantity SMALLINT NOT NULL,
order_date datetime NOT NULL, DEFAULT current_timestamp,
PRIMARY KEY(product_no)
);
```

<!-- Original PDF page 50; printed lab page 44 -->

- Insert Multiple VALUES at a time:

```sql
INSERT INTO product_order_info (product_no, product_name, product_type,
product_price, product_quantity)
VALUES(101,‘Laptop’ , ‘electronics’ ,67000,‘1’),
(null,‘Mobile’,‘electronics’ ,23500,‘1’),
(null,‘Watch’ , ‘electronics’ ,8650,‘2’),
(null,‘Butter’, ‘stationary’, 50, ‘5’),
(null,‘Coca-cola’,‘beverage’ , 35, ‘2’),
(null,‘Seven-Up’, ‘beverage’, 55, ‘1’);
```

- AVG function

```sql
SELECT AVG(product_price) avg_product_price FROM product_order_info;

OR

SELECT AVG(product_price) avg_product_price AS avg_product_price FROM
product_order_info;
```

- COUNT function returns the number of the rows in a table.

```sql
SELECT COUNT(product_no) AS total_order FROM product_order_info;
```

- COUNT function returns the number of the rows of specific items.

```sql
SELECT COUNT(*) product_type, product_name, product_price FROM prod-
uct_order_info WHERE product_type= ‘electronics’;
```

- To get the total sales of each product,

```sql
SELECT
product_no,
product_name,
product_price,
product_quantity,
SUM(product_price
product_quantity) AS total_per_product FROM prod-
uct_order_info GROUP BY product_no;
```

- MAX function returns the maximum value in a set of values.

```sql
SELECT MAX(product_price) max_price FROM product_order_info;
```

- MIN function returns the minimum value in a set of values.

```sql
SELECT MIN(product_price) max_price FROM product_order_info;
```

2. Using LENGTH(), UCASE/ UPPER CASE(), LCASE/ LOWER CASE(), MID(), ROUND/ FLOOR/ CELLING(), CONCAT():

- MySQL LENGTH function

```sql
SELECT product_no,product_name,product_price,
LENGTH(product_price) FROM product_order_info ;
```

<!-- Original PDF page 51; printed lab page 45 -->

Example-2:

```sql
SELECT product_no,product_name,product_price
FROM product_order_info WHERE LENGTH(product_price)>5;
```

- UCASE function

```sql
SELECT product_no,product_name,product_price,
UCASE(product_price) FROM product_order_info ;
```

- LCASE function

```sql
SELECT product_no,product_name,product_price,
LCASE(product_price) FROM product_order_info ;
```

- FLOOR function

```sql
SELECT product_no,product_name,product_price,
FLOOR(product_price) FROM product_order_info ;
```

- CELLING function

```sql
SELECT product_no,product_name,product_price,
CEIL(product_price) FROM product_order_info ;
```

- ROUND function

```sql
SELECT product_no,product_name,product_price,
ROUND(product_price) FROM product_order_info ;
```

- MID function

```sql
SELECT product_no,product_name,product_price,
MID(product_price,1,3) FROM product_order_info ;
```

- CONCAT function

```sql
SELECT product_no,product_name,product_price,
CONCAT(product_name, ’ ’, product_type) FROM product_order_info ;
```

3. Sorting data using ORDER BY, GROUP BY try by yourself

## 6.4 Discussion & Conclusion

In summary, this experiment makes a brief analysis of the Aggregate Function implemented by MySQL 8.0 from the source level.Aggregate Function saves the intermediate values of corresponding calculation results without GROUP BY by defining member variables, saves the keys and aggregated values of corresponding GROUP BY by using Temp Table with GROUP BY, and introduces the optimization methods of some Aggregate Functions.Of course, there are two important types of aggregation here: ROLL UP and WIN- DOWS functions, which will be introduced separately in future chapters due to space lim-

<!-- Original PDF page 52; printed lab page 46 -->

itations.I hope this article can help readers understand the implementation of MySQL Aggregate Function.

## 6.5 Lab Task (Please implement yourself and show the output to the instructor)

- Task-1:

![Diagram / screenshot from the source PDF, PDF page 52](../../assets/source-figures/page-52-image-01.png)

*Figure VI.1: Employees Table Information*

1. Input multiple data existing employees database or your existing database table.

2. Write a SQL query for searching employees average age, maximum, minimum salary.

3. Write a SQL statement to find the average purchase amount of all orders.

4. Implement UCASE, LCASE, MID, FLOOR, CELLING, LENGTH function.

5. Which department are paid most and which department are paid less Salary?

<!-- Original PDF page 53; printed lab page 47 -->

## 6.6 Lab Exercise (Submit as a report)

![Diagram / screenshot from the source PDF, PDF page 53](../../assets/source-figures/page-53-image-01.png)

*Figure VI.2: Employees Table Information*

1. Write a query to list the number of jobs available in the employees table.

2. Write a query to get the minimum salary from employees table.

3. Write a query to get the maximum salary of an employee working as a Programmer.

4. Write a query to get the average salary for each job ID excluding programmer.

5. Attach with query codes and with output screenshots in the report.

### Academic Integrity Policy

Copying from the internet, classmates, seniors, or any other unauthorized source is strictly prohibited. Full marks may be deducted if plagiarism, copied work, or academic dishonesty is detected.

Students must complete the lab task, implementation, output analysis, and lab report independently and submit authentic work for evaluation.
