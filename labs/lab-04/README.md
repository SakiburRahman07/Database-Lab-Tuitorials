# Lab 04: Querying and Filtering Data in MySQL

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab04` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** SELECT, projections, DISTINCT, WHERE, =, <>, >, >=, <, BETWEEN  
**Original manual alignment:** Source Lab IV (pages 31–34); data and SELECT examples adapted into a reproducible lesson.

## 1. Learning objectives

1. Retrieve full rows or chosen columns.
2. Distinguish duplicate result values from duplicate stored records.
3. Use filters with text and numeric comparisons.
4. Interpret comparison operators.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

`SELECT` chooses data. In the **projection** `SELECT emp_id, salary`, only named fields are returned. `WHERE` filters rows based on a condition. `DISTINCT` removes duplicate *result rows* but does **not** delete records from the underlying table. A primary key is often an efficient way to look up one row.

## 4. Instructor's walkthrough

1. Run the `INSERT` to build a realistic five-row employee table.
2. Compare `SELECT *` with `SELECT emp_id, first_name, salary`.
3. Compare `SELECT DISTINCT gender` and `SELECT DISTINCT first_name,last_name`.
4. Run integer and string `WHERE` conditions.
5. Change >= to > or <= and ask students to predict the rows first.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.

```sql
-- CSE 210 | Lab 04 | SELECT, DISTINCT, WHERE and comparisons
DROP DATABASE IF EXISTS cse210_lab04;
CREATE DATABASE cse210_lab04 CHARACTER SET utf8mb4;
USE cse210_lab04;

CREATE TABLE employees (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  dob DATE NOT NULL,
  gender ENUM('Male','Female') NOT NULL,
  salary DECIMAL(10,2) NOT NULL,
  entry_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO employees(emp_id,first_name,last_name,dob,gender,salary) VALUES
(1,'Sabbir','Rahman','1998-08-02','Male',30000),
(2,'Sakib','Hasan','1998-08-02','Male',20000),
(3,'Ananna','Rahman','1998-08-02','Female',40000),
(4,'Jannat','Hasan','1998-08-02','Female',45000),
(5,'Sabbir','Rahman','1998-07-02','Male',25000);

-- All records and selected columns.
SELECT * FROM employees ORDER BY emp_id;
SELECT emp_id,first_name,salary FROM employees ORDER BY emp_id;
-- DISTINCT eliminates duplicate RESULT combinations (not stored rows).
SELECT DISTINCT first_name,last_name FROM employees ORDER BY first_name,last_name;
SELECT DISTINCT gender FROM employees;
-- Number and string comparisons.
SELECT emp_id,first_name,last_name,salary FROM employees WHERE emp_id=2;
SELECT emp_id,first_name,last_name FROM employees WHERE first_name='Sabbir' ORDER BY emp_id;
SELECT emp_id,first_name,salary FROM employees WHERE salary >= 40000 ORDER BY emp_id;
SELECT emp_id,first_name,salary FROM employees WHERE salary <> 30000 ORDER BY emp_id;
SELECT emp_id,first_name,salary FROM employees WHERE salary < 30000 ORDER BY emp_id;
SELECT emp_id,first_name,salary FROM employees WHERE salary BETWEEN 25000 AND 40000 ORDER BY emp_id;
-- Count the original rows (still five) and number of distinct names.
SELECT COUNT(*) AS all_rows,COUNT(DISTINCT first_name) AS distinct_first_names FROM employees;
```

## 6. Expected results to check in front of students

- The table contains **5** employees.
- `SELECT DISTINCT first_name,last_name` returns **4** unique pairs.
- Salaries >= 40000 match **Ananna and Jannat**.
- `all_rows = 5` and `distinct_first_names = 4`.

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab04;
SELECT COUNT(*) AS all_rows,COUNT(DISTINCT first_name) AS unique_first_names FROM employees;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. Return only employees whose salary is strictly above 25000.
2. Find all employees named Sabbir; compare their IDs and salaries.
3. Return unique last names only.
4. Explain why the duplicate first-and-last-name combination appears once under DISTINCT.

## 8. Viva / checkpoint questions

1. Does `DISTINCT` delete duplicate rows?
2. When would `WHERE emp_id = 2` return zero results?
3. What is the difference between `<>` and `=`?

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab04;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
