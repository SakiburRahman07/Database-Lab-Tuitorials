# Lab 04 — Querying and Filtering Data in MySQL Table

*CSE 210 Database System Lab · Source: `CSE_210_Database_System_Lab.md` (PDF pages 37–40, printed pages 31–34)*

---

## 1. Objective(s)

- To gather knowledge about Querying and filtering data in MySQL table.
- To implement distinct and filtering data commands in MySQL table.

---

## 2. Complete Example — copy, paste, run

```sql
-- ============================================================
-- Lab 04 : Complete demo (SELECT / DISTINCT / WHERE / operators)
-- ============================================================
DROP DATABASE IF EXISTS cse210_lab04;
CREATE DATABASE cse210_lab04;
USE cse210_lab04;

-- 1) Create the employees table
CREATE TABLE employees (
    Emp_id     INT(11) NOT NULL,
    First_Name VARCHAR(255) NOT NULL,
    Last_name  VARCHAR(55) NOT NULL,
    DOB        DATE NOT NULL,
    Gender     ENUM('Male','Female') DEFAULT NULL,
    Salary     INT NOT NULL,
    Entry_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (Emp_id)
);

-- 2) Insert multiple values at a time
INSERT INTO employees (Emp_id, First_Name, Last_name, DOB, Gender, Salary) VALUES
(1, 'Sabbir', 'Rahman', '1998-08-02', 'Male',   30000),
(2, 'Sakib',  'Hasan',  '1998-08-02', 'Male',   20000),
(3, 'Ananna', 'Rahman', '1998-08-02', 'Female', 40000),
(4, 'Jannat', 'Hasan',  '1998-08-02', 'Female', 45000),
(5, 'Sabbir', 'Hossain','1998-07-02', 'Male',   25000);

-- 3) View all data
SELECT * FROM employees;

-- 4) Remove duplicate rows with DISTINCT
SELECT DISTINCT First_Name, Last_name FROM employees;
SELECT DISTINCT Last_name FROM employees;

-- 5) WHERE with an integer value
SELECT First_Name, Last_name, Salary
FROM employees
WHERE Emp_id = 2;

-- 6) WHERE with a string value
SELECT Emp_id, Last_name, DOB, Salary, Entry_date
FROM employees
WHERE First_Name = 'Sabbir';

-- 7) Comparison operators: >  >=  <  <=  <>  =
SELECT Emp_id, First_Name, Last_name, Salary
FROM employees
WHERE Salary >= 40000;

SELECT Emp_id, First_Name, Last_name, Salary
FROM employees
WHERE Salary <> 30000;      -- <> means "not equal to"

SELECT Emp_id, First_Name, Last_name, Salary
FROM employees
WHERE Salary < 30000;

SELECT Emp_id, First_Name, Last_name, Salary
FROM employees
WHERE Gender = 'Female';
```

**Expected output**

| Query | Rows returned |
| --- | --- |
| `SELECT * FROM employees` | 5 rows (Emp_id 1–5) |
| `SELECT DISTINCT Last_name` | Rahman, Hasan, Hossain |
| `WHERE Emp_id = 2` | Sakib Hasan, 20000 |
| `WHERE First_Name = 'Sabbir'` | rows 1 and 5 |
| `WHERE Salary >= 40000` | Ananna (40000), Jannat (45000) |
| `WHERE Salary <> 30000` | rows 2, 3, 4, 5 |
| `WHERE Gender = 'Female'` | Ananna, Jannat |

---

## 3. Quick Reference — Concepts taught in this lab

| # | Concept | Copy-paste SQL |
| --- | --- | --- |
| 1 | SELECT all columns | `SELECT * FROM employees;` |
| 2 | SELECT specific columns | `SELECT First_Name, Salary FROM employees;` |
| 3 | SELECT DISTINCT (remove duplicates) | `SELECT DISTINCT Last_name FROM employees;` |
| 4 | WHERE — integer condition | `SELECT * FROM employees WHERE Emp_id = 2;` |
| 5 | WHERE — string condition | `SELECT * FROM employees WHERE First_Name = 'Sabbir';` |
| 6 | Comparison `=` (equal) | `SELECT * FROM employees WHERE Salary = 30000;` |
| 7 | Comparison `<>` (not equal) | `SELECT * FROM employees WHERE Salary <> 30000;` |
| 8 | Comparison `>` / `>=` | `SELECT * FROM employees WHERE Salary >= 40000;` |
| 9 | Comparison `<` / `<=` | `SELECT * FROM employees WHERE Salary < 30000;` |
| 10 | Combine column list + WHERE | `SELECT Emp_id, First_Name, Salary FROM employees WHERE Salary > 25000;` |

### General syntax

```sql
SELECT column1, column2, ... FROM table_name;

SELECT DISTINCT column1, column2, ... FROM table_name;

SELECT column1, column2, ... FROM table_name WHERE condition;
```

---

## 4. Problem Analysis

The SQL DISTINCT keyword is used with the SELECT statement to eliminate all the duplicate records and fetching only unique records. There may be a situation when you have multiple duplicate records in a table. While fetching such records, it makes more sense to fetch only those unique records instead of fetching duplicate records. The SQL WHERE clause is used to specify a condition while fetching the data from a single table or by joining with multiple tables. If the given condition is satisfied, then only it returns a specific value from the table.

### 4.1 Filtering and Fetching Data in MySQL Table

The SQL SELECT statement returns a result set of records, from one or more tables. A SELECT statement retrieves zero or more rows from one or more database tables or database views. The SELECT DISTINCT statement is used to return only distinct values. Inside a table, a column often contains many duplicate values; and sometimes you only want to list the different (distinct) values.

- SELECT Syntax:

```sql
SELECT column1, column2, ... FROM table_name;
```

- SELECT DISTINCT Syntax:

```sql
SELECT DISTINCT column1, column2, ... FROM table_name;
```

- The SQL WHERE Clause syntax:

```sql
SELECT column1, column2, ... FROM table_name WHERE condition;
```

---

## 5. Procedure (Implementation in MySQL)

1. Using MySQL SELECT statement to query data (create an employees table):

```sql
CREATE TABLE employees (
    Emp_id     INT(11) NOT NULL,
    First_Name VARCHAR(255) NOT NULL,
    Last_name  VARCHAR(55) NOT NULL,
    DOB        DATE NOT NULL,
    Gender     ENUM('Male','Female') DEFAULT NULL,
    Salary     INT NOT NULL,
    Entry_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (Emp_id)
);
```

2. Insert multiple VALUES at a time:

```sql
INSERT INTO employees (Emp_id, First_Name, Last_name, DOB, Gender, Salary) VALUES
(1, 'Sabbir', 'Rahman', '1998-08-02', 'Male',   30000),
(2, 'Sakib',  'Hasan',  '1998-08-02', 'Male',   20000),
(3, 'Ananna', 'Rahman', '1998-08-02', 'Female', 40000),
(4, 'Jannat', 'Hasan',  '1998-08-02', 'Female', 45000),
(5, 'Sabbir', 'Hossain','1998-07-02', 'Male',   25000);
```

3. View data from table employees:

```sql
SELECT * FROM employees;
```

![Figure IV.1: Employees Table Information](../images/figure_IV_1.png)

*Figure IV.1: Employees Table Information*

4. Eliminating duplicate rows with DISTINCT Operator:

```sql
SELECT DISTINCT First_Name, Last_name FROM employees;
```

5. Filtering rows using MySQL WHERE:

**- MySQL WHERE Clause for INTEGER type value:**

```sql
SELECT First_Name, Last_name, Salary
FROM employees
WHERE Emp_id = 2;
```

**- MySQL WHERE Clause for String type value:**

```sql
SELECT Emp_id, Last_name, DOB, Salary, Entry_date
FROM employees
WHERE First_Name = 'Sabbir';
```

6. Using comparison operators (<, >, <=, >=, <>):

**Example 1:**

```sql
SELECT Emp_id, First_Name, Last_name
FROM employees
WHERE Salary >= 40000;
```

**Example 2:**

```sql
SELECT Emp_id, First_Name, Last_name
FROM employees
WHERE Salary <> 30000;      -- <> means "not equal to"
```

---

## 6. Discussion & Conclusion

Based on the focused objective(s) to understand about the knowledge of SELECT, WHERE and DISTINCT commands. The additional lab exercise made me more confident towards the fulfilment of the objectives(s).

---

## 7. Lab Task (Please implement yourself and show the output to the instructor)

1. Insert multiple values at a time for your existing database table (Do it for all table).
2. Remove duplicate values from all table.
3. View the data from any two tables.
4. Implement WHERE clause and search the specific information from existing tables.
5. Implement comparison operators using WHERE clause.

---

## 8. Lab Exercise (Submit as a report)

1. Input multiple data in any existing database table from previous lab report.
2. Query with primary key, query with condition, query with comparison operation.

   (Note: Implement All Query which have completed in this experiment)

3. Attach with query codes and with output screenshots in the report.

---

## Academic Integrity Policy

Copying from the internet, classmates, seniors, or any other unauthorized source is strictly prohibited. Full marks may be deducted if plagiarism, copied work, or academic dishonesty is detected.

Students must complete the lab task, implementation, output analysis, and lab report independently and submit authentic work for evaluation.
