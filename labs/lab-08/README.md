# Lab 08: Implementing Database Triggers

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab08` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** BEFORE INSERT, BEFORE UPDATE, AFTER UPDATE, NEW, OLD, trigger-driven normalization and audit  
**Original manual alignment:** Source Lab VIII (pages 55–61); preserves 1500-minimum-salary demonstration in valid MySQL syntax.

## 1. Learning objectives

1. Describe when a MySQL row trigger executes.
2. Create a BEFORE trigger to enforce a minimum salary.
3. Explain NEW versus OLD row values.
4. Record changes in an audit table using AFTER UPDATE.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

A MySQL trigger fires automatically in response to INSERT, UPDATE, or DELETE on a table. A **BEFORE** row trigger can modify `NEW` values; an **AFTER** trigger is useful for writing audit records. `OLD` refers to the previous row (for UPDATE/DELETE); `NEW` refers to the incoming/current row (for INSERT/UPDATE). Oracle PL/SQL trigger clauses such as `INSTEAD OF` and `WHEN` are not drop-in MySQL syntax, so this lab uses MySQL trigger syntax only.

## 4. Instructor's walkthrough

1. Explain the original minimum-salary business rule (1500).
2. Create customers and salary_audit, then inspect the three triggers.
3. Insert a customer with salary 1200 and display the saved value.
4. Update an existing salary below the minimum and observe correction.
5. Update a salary above the minimum, then inspect old/new values in salary_audit.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.

```sql
-- CSE 210 | Lab 08 | BEFORE/AFTER row triggers
-- Uses simple single-statement trigger bodies: convenient in CLI and phpMyAdmin.
DROP DATABASE IF EXISTS cse210_lab08;
CREATE DATABASE cse210_lab08 CHARACTER SET utf8mb4;
USE cse210_lab08;

CREATE TABLE customers (
  id INT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  age INT NOT NULL,
  address VARCHAR(80) NOT NULL,
  salary DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE salary_audit (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  old_salary DECIMAL(10,2) NOT NULL,
  new_salary DECIMAL(10,2) NOT NULL,
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- BEFORE INSERT: enforce the lesson's minimum salary of 1500.
CREATE TRIGGER trg_customers_min_salary_insert
BEFORE INSERT ON customers
FOR EACH ROW
SET NEW.salary = GREATEST(NEW.salary,1500.00);

-- BEFORE UPDATE: minimum salary is also enforced on updates.
CREATE TRIGGER trg_customers_min_salary_update
BEFORE UPDATE ON customers
FOR EACH ROW
SET NEW.salary = GREATEST(NEW.salary,1500.00);

-- AFTER UPDATE: audit changes; only updates create records.
CREATE TRIGGER trg_customers_salary_audit
AFTER UPDATE ON customers
FOR EACH ROW
INSERT INTO salary_audit(customer_id,old_salary,new_salary)
VALUES(OLD.id,OLD.salary,NEW.salary);

INSERT INTO customers VALUES
(1001,'Asha',23,'Dhaka',3000.00),
(1002,'Rafi',27,'Gazipur',2200.00),
(1003,'Mitu',24,'Cumilla',1800.00),
(1004,'Sami',22,'Dhaka',1200.00),
(1005,'Nila',25,'Khulna',3500.00);
SELECT id,name,salary FROM customers ORDER BY id;
-- Should store 1500.00, not 1200.00.
SELECT salary AS corrected_insert_salary FROM customers WHERE id=1004;
-- Update one person to 1000 => minimum 1500, audited.
UPDATE customers SET salary=1000.00 WHERE id=1002;
-- Update another person to 4500 => value remains 4500, audited.
UPDATE customers SET salary=4500.00 WHERE id=1005;
SELECT id,name,salary FROM customers ORDER BY id;
SELECT customer_id,old_salary,new_salary FROM salary_audit ORDER BY audit_id;
SHOW TRIGGERS;
-- Student extension: a separate employee salary-raise trigger based on publication count.
```

## 6. Expected results to check in front of students

- Customer **1004** is inserted with stored salary **1500.00**, not 1200.00.
- Customer **1002** ends with salary **1500.00** after an attempted update to 1000.
- Customer **1005** ends with salary **4500.00**.
- The audit table contains **2 rows**, one for each UPDATE (not for INSERT).

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab08;
SELECT customer_id,old_salary,new_salary FROM salary_audit ORDER BY audit_id;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. Create an `employees` table with `emp_id`, `basic_salary`, `start_date` and `publication_count`.
2. Implement a BEFORE UPDATE salary adjustment for the publication-based rules listed in Source Lab VIII (clearly define the unspecified case of 4 publications).
3. Create a StudentInfo/WaiverInfo design and add a waiver trigger, **only after confirming the current authorized GUB waiver policy**.
4. Explain why repeatedly applying a percentage on every UPDATE may accidentally compound salary.

## 8. Viva / checkpoint questions

1. When would you choose BEFORE rather than AFTER?
2. What do OLD and NEW mean?
3. Why should business rules be documented before writing a trigger?

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab08;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
