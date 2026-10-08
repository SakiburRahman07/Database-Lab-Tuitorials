# Lab 05 — Querying and Filtering Data in MySQL Table (Extended)

*CSE 210 Database System Lab · Source: `CSE_210_Database_System_Lab.md` (PDF pages 41–46, printed pages 35–40)*

---

## 1. Objective(s)

- To gather knowledge about Querying and filtering data with logic gates like AND OR as well as using limits.
- Learning about comparing tables in MySQL.
- To implement logic operations, comparisons and filtering data commands with limits in MySQL table.

---

## 2. Complete Example — copy, paste, run

The sample rows below extend the manual's data a little so that the `LIKE`, `IS NULL` and `LIMIT` demonstrations all return visible results.

```sql
-- ============================================================
-- Lab 05 : Complete demo (AND/OR/NOT, LIMIT, ORDER BY,
--           BETWEEN, IN, LIKE, IS NULL)
-- ============================================================
DROP DATABASE IF EXISTS cse210_lab05;
CREATE DATABASE cse210_lab05;
USE cse210_lab05;

-- 1) Create the employees table
CREATE TABLE employees (
    emp_no     INT(11) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(55) NOT NULL,
    last_name  VARCHAR(55) NOT NULL,
    gender     ENUM('M','F') DEFAULT NULL,
    salary     INT NOT NULL,
    entry_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (emp_no)
);

-- 2) Insert multiple values at a time
INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, salary) VALUES
(1015312001, '1989-08-28', 'Rina',  'Khanam',  'F', 45000),
(1015312002, '1988-07-19', 'Sakib', 'Hasan',   'M', 67000),
(1015312003, '1991-05-23', 'Sabbir','Rahman',  'M', 32000),
(1015312004, '1992-11-05', 'Maria', 'Karim',   'F', 28000),
(1015312005, '1990-02-14', 'Mizan', 'Rahman',  'M', 35000),
(1015312006, '1993-04-11', 'Nasir', 'Hossain', 'M', 27000);

-- Insert a single row with an explicit entry_date (all columns in table order)
INSERT INTO employees VALUES (1015312007, '1991-05-23', 'Sabbir', 'Rahman', 'M', 24000, '2017-11-11 00:00:00');
INSERT INTO employees VALUES (1015312008, '1991-05-23', 'Sabbir', 'Rahman', 'M', 25600, '2017-11-11 21:44:35');

-- One row without a gender, for the IS NULL example
INSERT INTO employees (emp_no, birth_date, first_name, last_name, salary)
VALUES (1015312009, '1994-09-30', 'Farhana', 'Akter', 31000);

SELECT * FROM employees;

-- 3) AND
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name = 'Rina' AND last_name = 'Khanam';

-- 4) OR
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name = 'Rina' OR last_name = 'Rahman';

-- 5) Precedence: AND is evaluated BEFORE OR ...
SELECT emp_no, first_name, last_name, salary
FROM employees
WHERE first_name = 'Rina' OR last_name = 'Rahman' AND salary <= 40000;

-- 6) ... so use parentheses to change the order of evaluation
SELECT emp_no, first_name, last_name, salary
FROM employees
WHERE (first_name = 'Rina' OR last_name = 'Rahman') AND salary <= 40000;

-- 7) NOT
SELECT emp_no, first_name, last_name, salary
FROM employees
WHERE NOT (gender = 'M');

-- 8) LIMIT
SELECT emp_no, first_name, last_name, salary FROM employees LIMIT 3;      -- first 3 rows
SELECT emp_no, first_name, last_name, salary FROM employees LIMIT 2, 4;   -- skip 2, next 4

-- 9) ORDER BY with LIMIT  ->  highest 3 salaries
SELECT emp_no, first_name, last_name, salary
FROM employees
ORDER BY salary DESC LIMIT 3;

-- lowest 3 salaries
SELECT emp_no, first_name, last_name, salary
FROM employees
ORDER BY salary ASC LIMIT 3;

-- 10) IN / NOT IN  (like OR / NOT OR)
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE salary IN (32000, 40000);

SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE salary NOT IN (32000, 45000, 25600);

-- 11) BETWEEN / NOT BETWEEN  (inclusive of both ends)
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE salary BETWEEN 20000 AND 43000;

SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE salary NOT BETWEEN 25600 AND 42000;

-- 12) LIKE with wildcards
--     %  = any string of zero or more characters
--     _  = exactly one character
SELECT emp_no, first_name, last_name FROM employees WHERE first_name LIKE 'm%';   -- starts with m
SELECT emp_no, first_name, last_name FROM employees WHERE first_name LIKE '%r';   -- ends with r
SELECT emp_no, first_name, last_name FROM employees WHERE first_name LIKE '%bb%'; -- contains bb
SELECT emp_no, first_name, last_name FROM employees WHERE first_name LIKE 'r__a'; -- r, any, any, a

-- 13) Checking NULL values
SELECT * FROM employees WHERE gender IS NULL;
SELECT * FROM employees WHERE gender IS NOT NULL;
```

**Expected output highlights**

| Query | Rows returned |
| --- | --- |
| `first_name='Rina' AND last_name='Khanam'` | 1 row (1015312001) |
| `first_name='Rina' OR last_name='Rahman'` | Rina + all Rahman rows |
| `LIMIT 3` | first 3 rows |
| `LIMIT 2, 4` | rows 3–6 |
| `ORDER BY salary DESC LIMIT 3` | 67000, 45000, 35000 |
| `salary BETWEEN 20000 AND 43000` | 32000, 28000, 35000, 27000, 24000, 25600, 31000 |
| `first_name LIKE 'm%'` | Maria, Mizan |
| `first_name LIKE '%r'` | Nasir |
| `first_name LIKE '%bb%'` | Sabbir (×4) |
| `first_name LIKE 'r__a'` | Rina |
| `gender IS NULL` | Farhana Akter |

---

## 3. Quick Reference — Concepts taught in this lab

### 3.1 Concepts and one-line SQL

| # | Concept | Copy-paste SQL |
| --- | --- | --- |
| 1 | AND (both conditions true) | `SELECT * FROM employees WHERE first_name='Rina' AND last_name='Khanam';` |
| 2 | OR (either condition true) | `SELECT * FROM employees WHERE first_name='Rina' OR last_name='Rahman';` |
| 3 | NOT (negate a condition) | `SELECT * FROM employees WHERE NOT (gender='M');` |
| 4 | Parentheses change precedence | `SELECT * FROM employees WHERE (first_name='Rina' OR last_name='Rahman') AND salary<=40000;` |
| 5 | LIMIT n (first n rows) | `SELECT * FROM employees LIMIT 3;` |
| 6 | LIMIT offset, count | `SELECT * FROM employees LIMIT 2, 4;` |
| 7 | ORDER BY DESC | `SELECT * FROM employees ORDER BY salary DESC;` |
| 8 | ORDER BY ASC | `SELECT * FROM employees ORDER BY salary ASC;` |
| 9 | Highest 3 values (ORDER BY + LIMIT) | `SELECT * FROM employees ORDER BY salary DESC LIMIT 3;` |
| 10 | BETWEEN (inclusive range) | `SELECT * FROM employees WHERE salary BETWEEN 20000 AND 43000;` |
| 11 | NOT BETWEEN | `SELECT * FROM employees WHERE salary NOT BETWEEN 25600 AND 42000;` |
| 12 | IN (list of values) | `SELECT * FROM employees WHERE salary IN (32000,40000);` |
| 13 | NOT IN | `SELECT * FROM employees WHERE salary NOT IN (32000,45000,25600);` |
| 14 | LIKE — starts with | `SELECT * FROM employees WHERE first_name LIKE 'm%';` |
| 15 | LIKE — ends with | `SELECT * FROM employees WHERE first_name LIKE '%r';` |
| 16 | LIKE — contains | `SELECT * FROM employees WHERE first_name LIKE '%bb%';` |
| 17 | LIKE — fixed positions | `SELECT * FROM employees WHERE first_name LIKE 'r__a';` |
| 18 | IS NULL / IS NOT NULL | `SELECT * FROM employees WHERE gender IS NULL;` |

### 3.2 Wildcards used with LIKE

| Wildcard | Meaning | Example | Matches |
| --- | --- | --- | --- |
| `%` | any string of zero or more characters | `LIKE 'm%'` | Maria, Mizan |
| `_` | exactly one character | `LIKE 'r__a'` | Rina (4 letters, r…a) |

### 3.3 Logical operators in MySQL

| Operator | Meaning |
| --- | --- |
| AND, && | Logical AND — true when **all** operands are true |
| OR, \|\| | Logical OR — true when **at least one** operand is true |
| NOT, ! | Logical NOT — inverts TRUE/FALSE |
| = , <> or != , > , >= , < , <= | Comparison operators |

---

## 4. Problem Analysis

In SQL, all logical operators evaluate to TRUE, FALSE, or NULL (UNKNOWN). In MySQL, these are implemented as 1 (TRUE), 0 (FALSE), and NULL. Most of this is common to different SQL database servers, although some servers may return any nonzero value for TRUE. MySQL evaluates any nonzero, non-NULL value to TRUE.

### 4.1 Logical Operators

- NOT, ! — Logical NOT, evaluates to 1 if the operand is 0, to 0 if the operand is nonzero, and NOT NULL returns NULL.

```sql
SELECT column1, column2, ... FROM table_name WHERE NOT condition;
```

- AND, && — Logical AND, evaluates to 1 if all operands are nonzero and not NULL, to 0 if one or more operands are 0, otherwise NULL is returned.

```sql
SELECT column1, column2, ... FROM table_name WHERE condition1 AND condition2;
```

### 4.2 MySQL LIMIT (ORDER BY, ASC, DESC)

The LIMIT clause is used in the SELECT statement to constrain the number of rows to return. The LIMIT clause accepts one or two arguments. The values of both arguments must be zero or positive integers. The following illustrates the LIMIT clause syntax with two arguments:

```sql
SELECT select_list
FROM table_name
ORDER BY column_name
LIMIT [offset,] row_count;
```

### 4.3 Between, Not Between, In, Not In

The SQL BETWEEN operator is used along with WHERE clause for providing a range of values. The values can be the numeric value, text value, and date.

```sql
SELECT column(s)
FROM table_name
WHERE column BETWEEN value1 AND value2;
```

---

## 5. Procedure (Implementation in MySQL)

1. Using logical operators (AND, OR, NOT):

- Create the table:

```sql
CREATE TABLE employees (
    emp_no     INT(11) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(55) NOT NULL,
    last_name  VARCHAR(55) NOT NULL,
    gender     ENUM('M','F') DEFAULT NULL,
    salary     INT NOT NULL,
    entry_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (emp_no)
);
```

- Insert multiple VALUES at a time:

```sql
INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, salary) VALUES
(1015312001, '1989-08-28', 'Rina',  'Khanam', 'F', 45000),
(1015312002, '1988-07-19', 'Sakib', 'Hasan',  'M', 67000),
(1015312003, '1991-05-23', 'Sabbir','Rahman', 'M', 32000);
```

- Insert single values (the value list must have the same number of values as the table's attributes):

```sql
INSERT INTO employees VALUES (1015312008, '1991-05-23', 'Sabbir', 'Rahman', 'M', 24000, '2017-11-11 00:00:00');
INSERT INTO employees VALUES (1015312009, '1991-05-23', 'Sabbir', 'Rahman', 'M', 25600, '2017-11-11 21:44:35');
```

- MySQL AND operator examples:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name = 'Rina' AND last_name = 'Khanam';
```

- MySQL OR operator examples:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name = 'Rina' OR last_name = 'Khan';
```

- Operator precedence: MySQL evaluates the OR operators after the AND operators:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name = 'Rina' OR last_name = 'Rahman' AND salary <= 40000;
```

- To change the order of evaluation, you use the parentheses, for example:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE (first_name = 'Rina' OR last_name = 'Rahman') AND salary <= 40000;
```

- MySQL creates result for OR:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name = 'Rina' OR last_name = 'Rahman';
```

2. Using limit (ORDER BY, ASC, DESC):

- Select the first 3 rows:

```sql
SELECT emp_no, first_name, last_name, salary FROM employees LIMIT 3;
```

- Skip the first 2 rows and return the next 4 rows (`LIMIT offset, row_count`):

```sql
SELECT emp_no, first_name, last_name, salary FROM employees LIMIT 2, 4;
```

- Using MySQL LIMIT to get the highest 3 values:

```sql
SELECT emp_no, first_name, last_name, salary
FROM employees
ORDER BY salary DESC LIMIT 3;
```

- Using MySQL LIMIT to get the lowest 3 values:

```sql
SELECT emp_no, first_name, last_name, salary
FROM employees
ORDER BY salary ASC LIMIT 3;
```

3. Between, Not Between, In, Not In:

- MySQL IN examples (like the OR operator):

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE salary IN (32000, 40000);
```

- MySQL NOT IN examples:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE salary NOT IN (32000, 45000, 25600);
```

- MySQL BETWEEN examples:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE salary BETWEEN 20000 AND 43000;
```

- MySQL BETWEEN to get exact values:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE salary BETWEEN 25600 AND 42000;
```

- MySQL NOT BETWEEN to get exact values:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE salary NOT BETWEEN 25600 AND 42000;
```

4. Using MySQL LIKE operator to select data based on patterns:

- The percentage ( %) wildcard allows you to match any string of zero or more characters.
- The underscore ( _ ) wildcard allows you to match any single character.

- Find employees whose first name starts with 'm':

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name LIKE 'm%';
```

- Find employees whose first name ends with 'r':

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name LIKE '%r';
```

- Find employees whose first name contains 'bb':

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name LIKE '%bb%';
```

- Find employees whose first name has 'r' as the first letter and 'a' as the fourth letter:

```sql
SELECT emp_no, first_name, last_name, salary, entry_date
FROM employees
WHERE first_name LIKE 'r__a';
```

> **Note:** `'m%'` and `'%r'` return an empty result set with only the three original sample rows (Rina / Sakib / Sabbir). Insert a few more names — see the Complete Example in section 2 — so the students can see the output.

5. Checking NULL values:

```sql
SELECT * FROM employees
WHERE gender IS NULL;
```

---

## 6. Discussion & Conclusion

Based on the focused objective(s) to understand about the knowledge of SELECT, WHERE, AND, BETWEEN, NOT BETWEEN and LIKE commands. The additional lab exercise made me more confident towards the fulfilment of the objectives(s).

---

## 7. Lab Task (Please implement yourself and show the output to the instructor)

**Task 1:** branch (branch_name, branch_city, assets) customer (customer_id, customer_name, customer_city) account (account_number, branch_name, balance) loan (loan_number, branch_name, amount) depositor (customer_name, account_number) borrower (customer_name, loan_number)

1. Input multiple data existing bank database table from previous lab report.
2. Write a SQL query for searching customers who have 30000 to 50000 loan.
3. Find the names of all branches located Between Dhaka and Cumilla.
4. To find all loan holders who have 'J' alphabets in their name or they have 'M' alphabets in the beginning of the names.

---

## 8. Lab Exercise (Submit as a report)

1. Input multiple data in any existing database table from previous lab report.
2. Query with primary key, query with condition, query with comparison operation.
3. Run all the queries using AND, OR, NOT, ORDER BY, ASC, DESC, Between, Not Between In, Not In, LIKE
4. Attach with query codes and with output screenshots in the report.

---

## Academic Integrity Policy

Copying from the internet, classmates, seniors, or any other unauthorized source is strictly prohibited. Full marks may be deducted if plagiarism, copied work, or academic dishonesty is detected.

Students must complete the lab task, implementation, output analysis, and lab report independently and submit authentic work for evaluation.
