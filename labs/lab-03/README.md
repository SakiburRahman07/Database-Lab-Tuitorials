# Lab 03: Modifying Databases and Updating Table Data

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab03` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** ALTER TABLE ADD, DROP, MODIFY, CHANGE, named constraints, CREATE TABLE AS SELECT, UPDATE  
**Original manual alignment:** Source Lab III (pages 20–30); worked example corrected to keep ALTER and INSERT statements consistent.

## 1. Learning objectives

1. Modify a table without recreating it from scratch.
2. Add, rename, modify, and remove columns.
3. Add and remove an index/constraint.
4. Create a data backup and update selected records safely.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

`ALTER TABLE` changes the **table structure**, while `UPDATE` changes stored **row values**. In MySQL, `MODIFY COLUMN` changes type/properties without renaming; `CHANGE COLUMN old new type` can rename a field, and requires the column definition. `CREATE TABLE backup AS SELECT ...` copies data but **does not preserve** keys/indexes and should not replace a proper disaster-recovery backup.

## 4. Instructor's walkthrough

1. Display the initial employees table and identify its primary key.
2. Run each `ALTER TABLE` and then `DESCRIBE employees` to inspect changes.
3. Show how the `email` field is populated with `UPDATE`.
4. Explain `CHANGE COLUMN` versus `MODIFY COLUMN`.
5. Create `employees_backup` before updating two records; compare backup and current values.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.

```sql
-- CSE 210 | Lab 03 | ALTER TABLE and UPDATE
DROP DATABASE IF EXISTS cse210_lab03;
CREATE DATABASE cse210_lab03 CHARACTER SET utf8mb4;
USE cse210_lab03;

CREATE TABLE departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB;
INSERT INTO departments VALUES (1,'Human Resources'),(2,'Finance'),(3,'Engineering');

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50),
  salary DECIMAL(10,2) NOT NULL,
  dept_id INT,
  CONSTRAINT fk_initial_department FOREIGN KEY(dept_id)
    REFERENCES departments(dept_id)
) ENGINE=InnoDB;
INSERT INTO employees(first_name,last_name,salary,dept_id) VALUES
('John','Smith',55000,1),('Jane','Doe',72000,2),
('Alice','Johnson',90000,3),('Bob','Williams',48000,1),
('Diana','Prince',85000,3);

-- ADD, position with AFTER, and add multiple columns.
ALTER TABLE employees ADD COLUMN email VARCHAR(100) AFTER last_name;
ALTER TABLE employees ADD COLUMN bank_account VARCHAR(30),
                      ADD COLUMN entry_date DATE;
UPDATE employees SET email=CONCAT(LOWER(first_name),id,'@example.edu'),
                     entry_date='2025-01-10';

-- CHANGE renames and restates the complete column definition.
ALTER TABLE employees CHANGE COLUMN first_name f_name VARCHAR(70) NOT NULL;
-- MODIFY changes a column's type while retaining its name.
ALTER TABLE employees MODIFY COLUMN salary DECIMAL(12,2) NOT NULL;
-- Add and then remove a named UNIQUE index.
ALTER TABLE employees ADD CONSTRAINT uq_employee_email UNIQUE(email);
SHOW INDEX FROM employees;
ALTER TABLE employees DROP INDEX uq_employee_email;

-- DROP COLUMN; using a demonstration-only column.
ALTER TABLE employees ADD COLUMN temp_note VARCHAR(20);
ALTER TABLE employees DROP COLUMN temp_note;

-- ADD PRIMARY KEY to a table without one (separate from employees, which already has PK).
CREATE TABLE badge_codes (badge_id INT NOT NULL, label VARCHAR(40));
ALTER TABLE badge_codes ADD PRIMARY KEY(badge_id);

-- Backup records before changing values; CREATE TABLE ... AS does NOT copy indexes.
CREATE TABLE employees_backup AS SELECT * FROM employees;
UPDATE employees SET salary=60000 WHERE id=1;
UPDATE employees SET f_name='Janet', last_name='Dey' WHERE id=2;

SELECT * FROM employees ORDER BY id;
SELECT id,f_name,salary FROM employees_backup ORDER BY id;
DESCRIBE employees;
SHOW CREATE TABLE employees;
SELECT COUNT(*) AS backup_count FROM employees_backup;
```

## 6. Expected results to check in front of students

- The final employees table contains **5** records.
- Final first-name field is `f_name`; temporary column `temp_note` is gone.
- Employee 1 has salary **60000.00** (backup: **55000.00**).
- Employee 2 is now `Janet Dey` (backup: `Jane Doe`).
- `employees_backup` contains five rows and does not copy the original indexes.

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab03;
SELECT id,f_name,last_name,salary FROM employees ORDER BY id;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. Create the `employee`, `company`, and `works` relations described in Source Lab III.
2. Add `emp_id`, `entry_date`, and `email`; rename `city` to `address`.
3. Create a backup table for `works`.
4. Create the six-relation bank schema from the source exercise, then add an email field to customers.

## 8. Viva / checkpoint questions

1. What is the difference between `MODIFY` and `CHANGE`?
2. What can go wrong with `UPDATE` without `WHERE`?
3. Does `CREATE TABLE ... AS SELECT` copy primary and foreign keys?

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab03;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
