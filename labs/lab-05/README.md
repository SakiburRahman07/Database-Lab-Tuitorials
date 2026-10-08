# Lab 05: Advanced Querying and Filtering in MySQL

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab05` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** AND, OR, NOT, parentheses, ORDER BY, ASC/DESC, LIMIT/OFFSET, BETWEEN, IN, LIKE, IS NULL  
**Original manual alignment:** Source Lab V (pages 35–40); expands its Boolean, ORDER BY, LIMIT, BETWEEN/IN/LIKE and NULL coverage.

## 1. Learning objectives

1. Combine multiple conditions using Boolean operators.
2. Sort and limit query results deterministically.
3. Apply range, list, and string pattern filters.
4. Correctly test for NULL values.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

Logical precedence matters: `AND` is evaluated before `OR`; parentheses make your intention explicit. `ORDER BY salary DESC, emp_no` produces stable top-N results. `LIMIT` restricts how many rows are displayed and `OFFSET` skips rows. `BETWEEN` includes endpoints. In `LIKE`, `%` matches zero or more characters and `_` matches exactly one. SQL `NULL` means unknown/missing; use `IS NULL`, not `= NULL`.

## 4. Instructor's walkthrough

1. Query Rina using `AND`, then use `OR` to broaden the result.
2. Compare precedence with and without parentheses on the same query.
3. Sort salaries descending and display the top three; demonstrate OFFSET.
4. Show `IN`, `NOT IN`, `BETWEEN` and `NOT BETWEEN`.
5. Demonstrate wildcard matching and `gender IS NULL`.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.

```sql
-- CSE 210 | Lab 05 | Advanced filtering and sorting
DROP DATABASE IF EXISTS cse210_lab05;
CREATE DATABASE cse210_lab05 CHARACTER SET utf8mb4;
USE cse210_lab05;

CREATE TABLE employees (
  emp_no INT PRIMARY KEY,
  birth_date DATE NOT NULL,
  first_name VARCHAR(55) NOT NULL,
  last_name VARCHAR(55) NOT NULL,
  gender ENUM('M','F') NULL,
  salary INT NOT NULL,
  entry_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO employees (emp_no,birth_date,first_name,last_name,gender,salary,entry_date) VALUES
(101,'1989-08-28','Rina','Khanam','F',45000,'2024-01-10 09:00:00'),
(102,'1988-07-19','Sakib','Hasan','M',67000,'2023-06-01 10:00:00'),
(103,'1991-05-23','Sabbir','Rahman','M',32000,'2024-03-15 09:30:00'),
(104,'1992-02-11','Ruba','Rahman','F',40000,'2024-05-20 11:00:00'),
(105,'1990-09-03','Mina','Akter',NULL,25600,'2025-02-01 12:00:00'),
(106,'1995-12-24','Rahim','Karim','M',24000,'2025-04-01 08:00:00');

-- AND / OR / NOT, precedence, parentheses.
SELECT emp_no,first_name,last_name FROM employees
WHERE first_name='Rina' AND last_name='Khanam';
SELECT emp_no,first_name FROM employees WHERE first_name='Rina' OR salary>60000 ORDER BY emp_no;
SELECT emp_no,first_name FROM employees WHERE NOT (salary>=40000) ORDER BY emp_no;
SELECT emp_no,first_name FROM employees
WHERE first_name='Rina' OR last_name='Rahman' AND salary<=40000 ORDER BY emp_no;
SELECT emp_no,first_name FROM employees
WHERE (first_name='Rina' OR last_name='Rahman') AND salary<=40000 ORDER BY emp_no;

-- Sorting, top N, deterministic pagination.
SELECT emp_no,first_name,salary FROM employees ORDER BY salary DESC,emp_no ASC LIMIT 3;
SELECT emp_no,first_name,salary FROM employees ORDER BY emp_no LIMIT 2 OFFSET 2;
SELECT emp_no,first_name,salary FROM employees ORDER BY salary ASC;

-- BETWEEN includes both endpoints; IN matches a listed value.
SELECT emp_no,first_name,salary FROM employees WHERE salary BETWEEN 25600 AND 45000 ORDER BY emp_no;
SELECT emp_no,first_name,salary FROM employees WHERE salary NOT BETWEEN 25600 AND 45000 ORDER BY emp_no;
SELECT emp_no,first_name,salary FROM employees WHERE salary IN (32000,40000) ORDER BY emp_no;
SELECT emp_no,first_name,salary FROM employees WHERE salary NOT IN (32000,45000,25600) ORDER BY emp_no;

-- LIKE: % = any-length string; _ = one character.
SELECT emp_no,first_name FROM employees WHERE first_name LIKE 'R%' ORDER BY emp_no;
SELECT emp_no,first_name FROM employees WHERE first_name LIKE '%a' ORDER BY emp_no;
SELECT emp_no,first_name FROM employees WHERE first_name LIKE '%bb%' ORDER BY emp_no;
SELECT emp_no,first_name FROM employees WHERE first_name LIKE 'R__a' ORDER BY emp_no;
-- NULL must be checked with IS NULL rather than = NULL.
SELECT emp_no,first_name FROM employees WHERE gender IS NULL;
```

## 6. Expected results to check in front of students

- The highest three salaries are **Sakib 67000**, **Rina 45000**, and **Ruba 40000**.
- The `R__a` pattern matches **Rina** and **Ruba**.
- `gender IS NULL` finds **Mina**.
- Changing parentheses in the two precedence queries changes which rows match.

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab05;
SELECT emp_no,first_name,salary FROM employees ORDER BY salary DESC,emp_no LIMIT 3;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. List employees who earn between 30000 and 45000, ordered by salary.
2. Find first names containing `a` but not ending in `a`.
3. Return the second and third highest earners using LIMIT/OFFSET.
4. Recreate the bank-loan filtering questions from Source Lab V using your own data.

## 8. Viva / checkpoint questions

1. Does `BETWEEN 10 AND 20` include 10 and 20?
2. What is the difference between `%` and `_` in LIKE?
3. Why use ORDER BY before LIMIT in ranking queries?

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab05;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
