# CSE 210 — Database System Lab
## Manual III: Modifying MySQL Databases and Updating Table Data

**Instructor-ready, command-by-command lab walkthrough**  
**Environment:** XAMPP → MySQL/MariaDB → phpMyAdmin → **SQL** tab  
**Scope:** **Only Lab Manual III** (original manual's printed pages 20–30; PDF pages 26–36)

> **How to teach:** Run **one `Run` code block at a time** in phpMyAdmin. Immediately run its **`Verify` block**. Ask students to predict the result before pressing **Go**. The listed outputs are **expected results** based on the supplied sample data; they are not screenshots of a live server.
>
> **Names matter:** For the main walkthrough use the exact database `cse210_manual3` and table `employees`. The company and bank exercises later use separate databases so they never interfere with this example.

---

## 1. Learning outcomes

By the end of this lab, students can:

1. Create a database, an `employees` table, and realistic starter records.
2. Use `ALTER TABLE ... ADD`, `DROP COLUMN`, `CHANGE`, and `MODIFY`.
3. Insert columns at the beginning (`FIRST`), after a column (`AFTER`), or several at once.
4. Add and remove `UNIQUE`, `PRIMARY KEY`, and `FOREIGN KEY` constraints appropriately.
5. Inspect structure and constraints with `DESCRIBE`, `SHOW COLUMNS`, `SHOW INDEX`, `SHOW CREATE TABLE`, and `information_schema`.
6. Create a table-data snapshot using `CREATE TABLE ... AS SELECT`.
7. Use `UPDATE ... SET ... WHERE ...` to change one row, several fields, or multiple rows safely.
8. Complete the Manual III **company** task and **bank** exercise.

### Teacher's running order (suggested: 110–140 minutes)

| Segment | Activities | Suggested time |
|---|---|---:|
| Launch + initial data | Setup and Activity 1 | 10 min |
| Modify table structure | Activities 2–9 | 30 min |
| Keys and constraints | Activities 10–15 | 25 min |
| Insert, inspect, backup | Activities 16–18 | 15 min |
| Update and compare | Activity 19 | 15 min |
| Company task | Section 5 | 20–25 min |
| Bank exercise / homework briefing | Section 6 | 10–20 min |

### Launch phpMyAdmin

1. Open **XAMPP Control Panel**.
2. Start **Apache** and **MySQL** (XAMPP often supplies **MariaDB**, which supports the SQL used here).
3. Open **http://localhost/phpmyadmin/**.
4. Click the **SQL** tab and paste **one** `Run` block.
5. Press **Go**, then paste its `Verify` block.
6. Leave results visible to explain what changed. **Do not paste the entire document at once.**

**How to read verification:** `DESCRIBE` and `SHOW CREATE TABLE` check **structure**; `SELECT` checks **data**; `COUNT(*)` checks **row count**. A `Query OK` message is not enough—students should prove the resulting state.

---

## 2. Setup: create and select our lab database

**Concept:** A database contains tables; `USE` chooses the database on which unqualified SQL commands operate.

**Run — first time only:**

```sql
CREATE DATABASE cse210_manual3;
USE cse210_manual3;
```

**Verify:**

```sql
SELECT DATABASE() AS active_database;
SHOW DATABASES LIKE 'cse210_manual3';
```

**Expected:** Both queries identify `cse210_manual3`.

> **If `CREATE DATABASE` says “database exists”:** It means the setup already ran. Select `cse210_manual3` in the left sidebar and run `USE cse210_manual3;`. Do **not** drop an existing database during class without confirming its contents.
>
> **Optional full reset—destructive, instructor only:** `DROP DATABASE IF EXISTS cse210_manual3;` erases **all** tables and data in that database. Run it only if you deliberately want to restart from Activity 1, then repeat setup.

---

## 3. Main live demonstration: Manual III, Activities 1–19

### Activity 1 — Create the `employees` table with `AUTO_INCREMENT` and insert starter records

**Teaching point:** `CREATE TABLE` defines columns. `AUTO_INCREMENT` generates IDs when they are omitted during `INSERT`. A MySQL `AUTO_INCREMENT` column must be indexed; we define `id` as the `PRIMARY KEY` from the start.

**Run:**

```sql
CREATE TABLE employees (
    id INT NOT NULL AUTO_INCREMENT,
    First_name VARCHAR(200) NOT NULL,
    Last_name VARCHAR(200),
    salary INT,
    PRIMARY KEY (id)
) ENGINE=InnoDB;
```

**Verify structure:**

```sql
DESCRIBE employees;
SHOW CREATE TABLE employees;
```

**Expected structure:** `id`, `First_name`, `Last_name`, `salary`. In the `DESCRIBE` output, `id` has key `PRI` and extra `auto_increment`.

**Run — put two rows in the table now so structural changes can be observed on real data:**

```sql
INSERT INTO employees (First_name, Last_name, salary)
VALUES
    ('John', 'Smith', 55000),
    ('Jane', 'Doe', 72000);
```

**Verify data:**

```sql
SELECT id, First_name, Last_name, salary
FROM employees
ORDER BY id;
```

**Expected:**

| id | First_name | Last_name | salary |
|---:|---|---|---:|
| 1 | John | Smith | 55000 |
| 2 | Jane | Doe | 72000 |

**Ask students:** Why did the `INSERT` omit `id`? What would happen if we inserted another person now?

### Activity 2 — Add one column with `ADD`

**Teaching point:** `ADD COLUMN` changes the table schema but does not invent email values for existing employees.

**Run:**

```sql
ALTER TABLE employees
ADD COLUMN email VARCHAR(100);
```

**Verify:**

```sql
DESCRIBE employees;
SELECT id, First_name, email FROM employees ORDER BY id;
```

**Expected:** `email` is now the last column; both existing rows show `NULL` under `email`.

### Activity 3 — Delete a column with `DROP COLUMN`

**Teaching point:** Removing a column removes its definition **and all stored values in that column**.

**Run:**

```sql
ALTER TABLE employees
DROP COLUMN email;
```

**Verify:**

```sql
SHOW COLUMNS FROM employees LIKE 'email';
DESCRIBE employees;
```

**Expected:** The first query returns **zero rows**; `email` is absent from the structure. The two employee records still exist.

### Activity 4 — Add a column at a specific position using `AFTER`

**Teaching point:** `AFTER Last_name` changes the displayed column order, not row order.

**Run:**

```sql
ALTER TABLE employees
ADD COLUMN email VARCHAR(100) AFTER Last_name;
```

**Verify:**

```sql
SHOW COLUMNS FROM employees;
```

**Expected column order:** `id`, `First_name`, `Last_name`, `email`, `salary`.

### Activity 5 — Add a column at the beginning with `FIRST`

**Teaching point:** `FIRST` places a new column at position 1. This example intentionally had **no** `Gender` column earlier.

**Run:**

```sql
ALTER TABLE employees
ADD COLUMN Gender CHAR(1) FIRST;
```

**Verify:**

```sql
SHOW COLUMNS FROM employees;
SELECT Gender, id, First_name FROM employees ORDER BY id;
```

**Expected:** `Gender` appears first; its values are initially `NULL`.

### Activity 6 — Add multiple columns using one `ALTER TABLE`

**Teaching point:** Several schema changes can be written in one statement, separated by commas. `DATE` stores dates as `YYYY-MM-DD`.

**Run:**

```sql
ALTER TABLE employees
ADD COLUMN Bank_account BIGINT,
ADD COLUMN Entry_Date DATE;
```

**Verify:**

```sql
DESCRIBE employees;
SELECT id, Bank_account, Entry_Date FROM employees ORDER BY id;
```

**Expected:** Two new fields (`Bank_account`, `Entry_Date`) appear, and their current values are `NULL`.

> **Data-modeling note:** The supplied manual uses `INT` for `Bank_account`. Here we use `BIGINT` to avoid overflowing when using longer demonstration numbers. In a production banking system, an account identifier is generally better stored as `VARCHAR`, since leading zeroes can matter and arithmetic on identifiers is meaningless.

### Activity 7 — Remove multiple columns in one statement

**Teaching point:** One `ALTER TABLE` statement can drop multiple columns. We remove the two temporary demonstration columns, not the original employee data.

**Run:**

```sql
ALTER TABLE employees
DROP COLUMN Gender,
DROP COLUMN email;
```

**Verify:**

```sql
SHOW COLUMNS FROM employees;
```

**Expected column order:** `id`, `First_name`, `Last_name`, `salary`, `Bank_account`, `Entry_Date`. The two dropped columns are absent.

### Activity 8 — Change a column's definition with `CHANGE`

**Teaching point:** MySQL `CHANGE old_name new_name new_data_type constraints` can redefine a column while keeping the name the same. This example demonstrates changing `salary` from an integer to text, **temporarily**, and adding `NOT NULL`.

**Run:**

```sql
ALTER TABLE employees
CHANGE COLUMN salary salary VARCHAR(50) NOT NULL;
```

**Verify:**

```sql
DESCRIBE employees;
SELECT id, salary FROM employees ORDER BY id;
```

**Expected:** `salary` has type `varchar(50)` and `Null = NO`. The values display as `55000` and `72000`; now they are stored as text rather than numeric salaries.

**Ask students:** Is `VARCHAR` a good permanent datatype for a salary? (No—use a suitable numeric datatype; we change it back in Activity 12.)

### Activity 9 — Rename `First_name` to `F_name` with `CHANGE`

**Teaching point:** `CHANGE` can rename a field. You must supply its full new datatype/constraint definition again.

**Run:**

```sql
ALTER TABLE employees
CHANGE COLUMN First_name F_name VARCHAR(100) NOT NULL;
```

**Verify:**

```sql
SHOW COLUMNS FROM employees;
SELECT id, F_name, Last_name FROM employees ORDER BY id;
```

**Expected:** `F_name` exists; `First_name` is absent. The names `John` and `Jane` are preserved. Column width is now 100 characters.

### Activity 10 — Add a `UNIQUE` constraint with `ALTER TABLE`

**Teaching point:** `UNIQUE` prevents duplicate non-NULL salary values (for this exercise). In a real employee table, salary usually **should not** be unique; here it is only a clear way to demonstrate the constraint.

**Run:**

```sql
ALTER TABLE employees
ADD CONSTRAINT uq_employees_salary UNIQUE (salary);
```

**Verify:**

```sql
SHOW INDEX FROM employees
WHERE Key_name = 'uq_employees_salary';
SHOW CREATE TABLE employees;
```

**Expected:** An index/unique key named `uq_employees_salary` appears with `Non_unique = 0`.

**Optional intentional failure — run *separately*, then explain:**

```sql
UPDATE employees
SET salary = '55000'
WHERE id = 2;
```

**Expected:** A **duplicate-entry error** (commonly error 1062); Jane's salary remains `72000`. This is a successful demonstration of the constraint without consuming an auto-increment ID. Confirm with:

```sql
SELECT COUNT(*) AS employee_count FROM employees;
```

**Expected count:** `2`.

### Activity 11 — Drop the `UNIQUE` constraint / unique index

**Teaching point:** MySQL commonly removes a `UNIQUE` constraint by dropping its corresponding unique index. This **does not** delete the `salary` column.

**Run:**

```sql
ALTER TABLE employees
DROP INDEX uq_employees_salary;
```

**Verify:**

```sql
SHOW INDEX FROM employees
WHERE Key_name = 'uq_employees_salary';
DESCRIBE employees;
```

**Expected:** The named index query returns **zero rows**, but `salary` still exists.

### Activity 12 — Correct the datatype with `MODIFY`

**Teaching point:** `MODIFY` changes the definition **without renaming** the column. Return `salary` to a numeric datatype so numeric comparisons and arithmetic work predictably.

**Run:**

```sql
ALTER TABLE employees
MODIFY COLUMN salary BIGINT NOT NULL;
```

**Verify:**

```sql
DESCRIBE employees;
SELECT id, salary, salary + 1000 AS proposed_salary
FROM employees
ORDER BY id;
```

**Expected:** `salary` type is `bigint`; `proposed_salary` is `56000` for John and `73000` for Jane. The original `salary` values have **not** changed.

### Activity 13 — Create a parent table and add a foreign key with `ALTER`

**Teaching point:** A foreign key ensures an employee's `dept_id`, when non-NULL, matches an existing `departments.dept_id`. Create the referenced parent table first.

**Run — create parent table:**

```sql
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
) ENGINE=InnoDB;
```

**Verify:**

```sql
DESCRIBE departments;
SHOW TABLES;
```

**Expected:** `departments` appears, with `dept_id` as `PRI`.

**Run — add the referencing field to `employees`:**

```sql
ALTER TABLE employees
ADD COLUMN dept_id INT NULL;
```

**Verify:**

```sql
SHOW COLUMNS FROM employees LIKE 'dept_id';
SELECT id, dept_id FROM employees ORDER BY id;
```

**Expected:** Column `dept_id` exists and the two existing employees currently have `NULL` values.

**Run — add the foreign key:**

```sql
ALTER TABLE employees
ADD CONSTRAINT fk_employees_dept
FOREIGN KEY (dept_id) REFERENCES departments(dept_id);
```

**Verify:**

```sql
SHOW CREATE TABLE employees;
```

**Expected:** The table definition includes `CONSTRAINT fk_employees_dept FOREIGN KEY (dept_id) REFERENCES departments (dept_id)` (formatting may differ by server version).

> **Why this works before inserting departments:** the existing `dept_id` values are `NULL`, which an ordinary nullable foreign key permits. Before assigning 1–5 to employees, we must insert those department IDs (Activity 16).

### Activity 14 — Add a primary key to an existing table

**Teaching point:** `ALTER TABLE ... ADD PRIMARY KEY` works only if the table does **not** already have a primary key, and the key values are unique and non-NULL. Our main `employees.id` is **already a primary key** because `AUTO_INCREMENT` needs an index. Therefore use a **separate teaching table** for this activity.

**Run:**

```sql
CREATE TABLE employee_badges (
    badge_id INT NOT NULL,
    badge_label VARCHAR(50)
) ENGINE=InnoDB;

INSERT INTO employee_badges (badge_id, badge_label)
VALUES (101, 'Staff'), (102, 'Supervisor');
```

**Verify before adding the key:**

```sql
DESCRIBE employee_badges;
SELECT * FROM employee_badges ORDER BY badge_id;
```

**Expected:** Two badge records; `badge_id` has no `PRI` marker yet.

**Run — add the primary key:**

```sql
ALTER TABLE employee_badges
ADD PRIMARY KEY (badge_id);
```

**Verify:**

```sql
DESCRIBE employee_badges;
SHOW CREATE TABLE employee_badges;
```

**Expected:** `badge_id` now has `Key = PRI`.

**Do not run:** `ALTER TABLE employees ADD PRIMARY KEY(id);` would fail because `employees` already has one.

### Activity 15 — Display all table constraints

**Teaching point:** `information_schema` stores metadata; restrict the query to the **active database** to avoid similarly named tables elsewhere.

**Run (inspection only):**

```sql
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'employees'
ORDER BY CONSTRAINT_TYPE, CONSTRAINT_NAME;
```

**Verify using another method:**

```sql
SHOW CREATE TABLE employees;
```

**Expected:** At least the `PRIMARY KEY` and the named `fk_employees_dept` / `FOREIGN KEY` appear. The temporary salary `UNIQUE` constraint from Activity 10 is **not** present because we removed it in Activity 11.

### Activity 16 — Insert five departments and complete the employee dataset

**Teaching point:** Insert parent rows before child rows that refer to them. Our first two employees already exist; add **five more** so the final set matches the manual's seven employees.

**Run — insert departments:**

```sql
INSERT INTO departments (dept_id, dept_name)
VALUES
    (1, 'Human Resources'),
    (2, 'Finance'),
    (3, 'Engineering'),
    (4, 'Marketing'),
    (5, 'Sales');
```

**Verify:**

```sql
SELECT * FROM departments ORDER BY dept_id;
SELECT COUNT(*) AS department_count FROM departments;
```

**Expected:** Five records, IDs 1–5; `department_count = 5`.

**Run — add five more employees; `id` is automatically generated:**

```sql
INSERT INTO employees
    (F_name, Last_name, salary, Bank_account, Entry_Date, dept_id)
VALUES
    ('Alice', 'Johnson', 90000, 112233445, '2020-03-10', 3),
    ('Bob', 'Williams', 48000, 556677889, '2023-07-01', 4),
    ('Charlie', 'Brown', 61000, 334455667, '2019-11-25', 5),
    ('Diana', 'Prince', 85000, 778899001, '2022-09-14', 3),
    ('Ethan', 'Hunt', 53000, 223344556, '2023-02-28', 2);
```

**Verify:**

```sql
SELECT id, F_name, Last_name, salary, dept_id
FROM employees
ORDER BY id;
```

**Expected:** Seven rows, with Alice through Ethan assigned IDs 3–7 in a new, uninterrupted run.

**Run — fill the two earlier employees' missing details:**

```sql
UPDATE employees
SET Bank_account = 123456789,
    Entry_Date = '2022-01-15',
    dept_id = 1
WHERE id = 1;

UPDATE employees
SET Bank_account = 987654321,
    Entry_Date = '2021-06-20',
    dept_id = 2
WHERE id = 2;
```

**Verify:**

```sql
SELECT id, F_name, Bank_account, Entry_Date, dept_id
FROM employees
WHERE id IN (1, 2)
ORDER BY id;

SELECT COUNT(*) AS employee_count,
       SUM(dept_id IS NULL) AS missing_department_count
FROM employees;
```

**Expected:** John has department 1 and Jane department 2 with dates/accounts entered; `employee_count = 7` and `missing_department_count = 0`.

**Optional intentional foreign-key error — run separately:**

```sql
UPDATE employees
SET dept_id = 999
WHERE id = 1;
```

**Expected:** A foreign-key constraint error (commonly 1452); John's original `dept_id = 1` is preserved. Verify:

```sql
SELECT COUNT(*) AS employee_count FROM employees;
```

**Expected:** Still `7`.

### Activity 17 — Browse all records

**Teaching point:** `SELECT *` retrieves every column. For classroom verification, an explicit column list often produces a clearer result.

**Run:**

```sql
SELECT * FROM employees;
```

**Verify and display neatly:**

```sql
SELECT id, F_name, Last_name, salary, Bank_account, Entry_Date, dept_id
FROM employees
ORDER BY id;
```

**Expected before later updates:**

| id | F_name | Last_name | salary | dept_id |
|---:|---|---|---:|---:|
| 1 | John | Smith | 55000 | 1 |
| 2 | Jane | Doe | 72000 | 2 |
| 3 | Alice | Johnson | 90000 | 3 |
| 4 | Bob | Williams | 48000 | 4 |
| 5 | Charlie | Brown | 61000 | 5 |
| 6 | Diana | Prince | 85000 | 3 |
| 7 | Ethan | Hunt | 53000 | 2 |

### Activity 18 — Create a snapshot/backup table

**Teaching point:** `CREATE TABLE ... AS SELECT` copies **existing rows and basic column definitions** at that moment. It does **not** faithfully duplicate the source table's primary key, foreign keys, unique indexes, or `AUTO_INCREMENT` settings. It is a classroom **data snapshot**, not a complete backup strategy.

**Run:**

```sql
CREATE TABLE employees_info_backup AS
SELECT * FROM employees;
```

**Verify row counts:**

```sql
SELECT COUNT(*) AS original_rows FROM employees;
SELECT COUNT(*) AS backup_rows FROM employees_info_backup;
```

**Expected:** Both return `7`.

**Verify schema difference:**

```sql
SHOW CREATE TABLE employees;
SHOW CREATE TABLE employees_info_backup;
```

**Expected:** The main table has `PRIMARY KEY`, `AUTO_INCREMENT`, and foreign-key definitions; the snapshot table generally does **not** retain those constraints.

### Activity 19 — Update existing table data with `UPDATE`

**Teaching point:** `UPDATE ... SET ... WHERE ...` changes rows, **not** the table's column definitions. The `WHERE` condition is essential when updating selected records.

#### 19A. Update one column in one employee row

**Verify BEFORE:**

```sql
SELECT id, F_name, salary FROM employees WHERE id = 1;
```

**Expected before:** `John`, `55000`.

**Run:**

```sql
UPDATE employees
SET salary = 300000
WHERE id = 1;
```

**Verify AFTER:**

```sql
SELECT id, F_name, salary FROM employees WHERE id = 1;
```

**Expected after:** `John`, `300000`. All other employees retain their salaries.

#### 19B. Update multiple columns in one row

**Verify BEFORE:**

```sql
SELECT id, F_name, Last_name FROM employees WHERE id = 2;
```

**Expected before:** `Jane Doe`.

**Run:**

```sql
UPDATE employees
SET F_name = 'Barry',
    Last_name = 'Allen'
WHERE id = 2;
```

**Verify AFTER:**

```sql
SELECT id, F_name, Last_name FROM employees WHERE id = 2;
```

**Expected after:** `Barry Allen`.

#### 19C. Update multiple rows using one statement (additional teaching demonstration)

**Verify BEFORE:**

```sql
SELECT id, F_name, dept_id, salary
FROM employees
WHERE dept_id = 3
ORDER BY id;
```

**Expected before:** Alice = `90000`; Diana = `85000`.

**Run:**

```sql
UPDATE employees
SET salary = salary + 1000
WHERE dept_id = 3;
```

**Verify AFTER:**

```sql
SELECT id, F_name, dept_id, salary
FROM employees
WHERE dept_id = 3
ORDER BY id;
```

**Expected after:** Alice = `91000`; Diana = `86000`. This shows that one `UPDATE` can affect several rows.

#### 19D. Prove that the snapshot does not update itself

**Run (read-only comparison):**

```sql
SELECT 'CURRENT' AS source_table, id, F_name, Last_name, salary
FROM employees
WHERE id IN (1, 2)
UNION ALL
SELECT 'SNAPSHOT' AS source_table, id, F_name, Last_name, salary
FROM employees_info_backup
WHERE id IN (1, 2)
ORDER BY id, source_table;
```

**Expected:** Current `id=1` has salary `300000`, while snapshot `id=1` still has `55000`. Current `id=2` is `Barry Allen`; snapshot `id=2` is still `Jane Doe`.

**Do not run on real data without a deliberate reason:**

```sql
-- WARNING: Omitting WHERE updates EVERY row.
-- UPDATE employees SET salary = 0;
```

**Final check for the main demonstration:**

```sql
SELECT COUNT(*) AS employees_now FROM employees;
SELECT COUNT(*) AS snapshot_rows FROM employees_info_backup;
SELECT COUNT(*) AS departments_now FROM departments;
```

**Expected:** `7` employees, `7` snapshot rows, and `5` departments.

---

## 4. At-a-glance command reference (the commands students just used)

| Goal | MySQL command | Verify with |
|---|---|---|
| Create table | `CREATE TABLE ...` | `DESCRIBE table_name` |
| Add a column | `ALTER TABLE ... ADD COLUMN ...` | `SHOW COLUMNS FROM ...` |
| Add a column at a position | `... ADD COLUMN ... FIRST / AFTER old_column` | `SHOW COLUMNS FROM ...` |
| Add several columns | `ALTER TABLE ... ADD COLUMN ..., ADD COLUMN ...` | `DESCRIBE ...` |
| Remove column(s) | `ALTER TABLE ... DROP COLUMN ...` | `SHOW COLUMNS FROM ...` |
| Rename + redefine | `ALTER TABLE ... CHANGE COLUMN old new datatype` | `DESCRIBE ...` |
| Change datatype only | `ALTER TABLE ... MODIFY COLUMN col datatype` | `DESCRIBE ...` |
| Add unique constraint | `ALTER TABLE ... ADD CONSTRAINT ... UNIQUE (...)` | `SHOW INDEX ...` |
| Remove unique index | `ALTER TABLE ... DROP INDEX index_name` | `SHOW INDEX ...` |
| Add primary key | `ALTER TABLE ... ADD PRIMARY KEY (...)` | `DESCRIBE ...` |
| Add foreign key | `ALTER TABLE ... ADD CONSTRAINT ... FOREIGN KEY ...` | `SHOW CREATE TABLE ...` |
| Insert records | `INSERT INTO ... VALUES ...` | `SELECT ...` / `COUNT(*)` |
| Browse records | `SELECT * FROM ...` | Inspect returned rows |
| Copy snapshot | `CREATE TABLE backup AS SELECT * FROM source` | Count both tables |
| Change values | `UPDATE ... SET ... WHERE ...` | `SELECT ... WHERE ...` |

### Important corrections to avoid errors in the supplied Manual III

The official document establishes the topic sequence, but the following adjustments make **one continuous execution** possible in phpMyAdmin:

1. **`Employee` / `employees` consistency:** We use `employees` throughout. Some systems distinguish table names by case.
2. **Initial `Gender`:** The printed creation example includes `Gender`, then tries adding `Gender` again. Our initial table omits it so Activity 5 succeeds.
3. **Missing comma in initial `CREATE TABLE`:** Column definitions need commas before `PRIMARY KEY` and between all column definitions.
4. **`AUTO_INCREMENT` and duplicate primary keys:** In MySQL an auto-increment column must be indexed. The main `employees.id` starts as a primary key; Activity 14 uses another table to demonstrate `ADD PRIMARY KEY` without a duplicate-key error.
5. **Change of datatype:** For MySQL, use `MODIFY COLUMN` or `CHANGE COLUMN`. The generic `ALTER COLUMN name datatype` shown in the background section is not the correct MySQL datatype-change syntax.
6. **Adding `UNIQUE`:** Use `ADD CONSTRAINT uq_name UNIQUE (column)` (**CONSTRAINT**, singular) rather than `ADD CONSTRAINTS`.
7. **`departments` spelling:** The printed insert example sometimes says `department`; our created parent table and insert both say `departments`.
8. **When to insert employees:** We use 2 early records to demonstrate schema changes on existing data and add 5 more after the `departments` table has been prepared. Total: 7.
9. **Safe backups:** `CREATE TABLE ... AS SELECT` makes a data snapshot; it does not preserve all keys and constraints, and later updates do not propagate.
10. **Constraint verification:** We also filter `information_schema.TABLE_CONSTRAINTS` by `TABLE_SCHEMA = DATABASE()` so metadata from another database is not confused with this one.

---

## 5. Manual III — Lab Task solution: Employee, Company, Works

**Manual task:** Create `employee(e_name, street, city)`, `company(company_name, branch, city)`, and `works(w_name, e_name, company_name, salary)`; add `emp_id` and `entry_date` to employee; rename `employee.city` to `address`; add and update `email` and `address`; back up `works` and `employee`; add a foreign key on `works.company_name`.

This is an **independent mini-project** in a different database. The following is a complete instructor demonstration / sample solution. For student assessment, you can display the task requirements first, ask students to attempt the SQL, and then reveal each answer.

### Task A — Create a separate database

**Run:**

```sql
CREATE DATABASE cse210_manual3_company;
USE cse210_manual3_company;
```

**Verify:**

```sql
SELECT DATABASE() AS active_database;
```

**Expected:** `cse210_manual3_company`.

### Task B — Create all three tables (parent tables first)

**Run:**

```sql
CREATE TABLE employee (
    e_name VARCHAR(60) PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(60)
) ENGINE=InnoDB;

CREATE TABLE company (
    company_name VARCHAR(60) PRIMARY KEY,
    branch VARCHAR(60),
    city VARCHAR(60)
) ENGINE=InnoDB;

CREATE TABLE works (
    w_name VARCHAR(60) PRIMARY KEY,
    e_name VARCHAR(60),
    company_name VARCHAR(60),
    salary INT
) ENGINE=InnoDB;
```

**Verify:**

```sql
SHOW TABLES;
DESCRIBE employee;
DESCRIBE company;
DESCRIBE works;
```

**Expected:** Three tables exist. In this demonstration `w_name` is a work/assignment identifier. The manual requests a foreign key on `company_name`, added later; we intentionally do not add it during initial creation.

### Task C — Insert data (at least two rows; here we use three)

**Run:**

```sql
INSERT INTO employee (e_name, street, city) VALUES
('Rahim', 'Road 1', 'Dhaka'),
('Karim', 'Road 2', 'Chattogram'),
('Nila',  'Road 3', 'Khulna');

INSERT INTO company (company_name, branch, city) VALUES
('TechNova', 'Head Office', 'Dhaka'),
('DataSoft', 'South Branch', 'Chattogram'),
('CloudLab', 'West Branch', 'Khulna');

INSERT INTO works (w_name, e_name, company_name, salary) VALUES
('W001', 'Rahim', 'TechNova', 35000),
('W002', 'Karim', 'DataSoft', 40000),
('W003', 'Nila', 'CloudLab', 38000);
```

**Verify:**

```sql
SELECT * FROM employee ORDER BY e_name;
SELECT * FROM company ORDER BY company_name;
SELECT * FROM works ORDER BY w_name;
```

**Expected:** Three rows in each table.

### Task D — Add `emp_id` and `entry_date` to `employee`

**Run:**

```sql
ALTER TABLE employee
ADD COLUMN emp_id INT,
ADD COLUMN entry_date DATE;
```

**Verify:**

```sql
DESCRIBE employee;
SELECT e_name, emp_id, entry_date FROM employee ORDER BY e_name;
```

**Expected:** Both new fields appear, initially with `NULL` values.

**Run — make the fields meaningful for existing rows:**

```sql
UPDATE employee
SET emp_id = 101, entry_date = '2024-01-15'
WHERE e_name = 'Rahim';

UPDATE employee
SET emp_id = 102, entry_date = '2023-06-20'
WHERE e_name = 'Karim';

UPDATE employee
SET emp_id = 103, entry_date = '2025-02-10'
WHERE e_name = 'Nila';
```

**Verify:**

```sql
SELECT e_name, emp_id, entry_date
FROM employee
ORDER BY emp_id;
```

**Expected:** IDs 101, 102, and 103 are populated. (`e_name` remains the primary key in this teaching example; the task did not require making `emp_id` a new key.)

### Task E — Rename `city` to `address`

**Run:**

```sql
ALTER TABLE employee
CHANGE COLUMN city address VARCHAR(100);
```

**Verify:**

```sql
DESCRIBE employee;
SELECT e_name, address FROM employee ORDER BY e_name;
```

**Expected:** `address` exists; `city` no longer exists in `employee`. Its old city values are retained under the renamed column.

### Task F — Add `email`, then update `email` and `address`

**Run:**

```sql
ALTER TABLE employee
ADD COLUMN email VARCHAR(100);
```

**Verify:**

```sql
SHOW COLUMNS FROM employee LIKE 'email';
```

**Expected:** `email` exists.

**Run:**

```sql
UPDATE employee
SET email = 'rahim@example.com', address = 'Road 1, Dhaka'
WHERE e_name = 'Rahim';

UPDATE employee
SET email = 'karim@example.com', address = 'Road 2, Chattogram'
WHERE e_name = 'Karim';

UPDATE employee
SET email = 'nila@example.com', address = 'Road 3, Khulna'
WHERE e_name = 'Nila';
```

**Verify:**

```sql
SELECT e_name, street, address, email
FROM employee
ORDER BY e_name;
```

**Expected:** Three non-NULL emails and three full addresses. Notice that the separately stored `street` column was not modified.

### Task G — Create two backup tables

**Run:**

```sql
CREATE TABLE employee_backup AS
SELECT * FROM employee;

CREATE TABLE works_backup AS
SELECT * FROM works;
```

**Verify:**

```sql
SELECT COUNT(*) AS current_employee_rows FROM employee;
SELECT COUNT(*) AS copied_employee_rows FROM employee_backup;
SELECT COUNT(*) AS current_works_rows FROM works;
SELECT COUNT(*) AS copied_works_rows FROM works_backup;
```

**Expected:** Every count is `3`. Again, these are **row snapshots**, not complete backups of indexes/constraints.

### Task H — Add the foreign key on `works.company_name`

**Run:**

```sql
ALTER TABLE works
ADD CONSTRAINT fk_works_company
FOREIGN KEY (company_name) REFERENCES company(company_name);
```

**Verify:**

```sql
SHOW CREATE TABLE works;

SELECT w.w_name, w.e_name, w.company_name, c.branch
FROM works AS w
JOIN company AS c ON w.company_name = c.company_name
ORDER BY w.w_name;
```

**Expected:** The first result shows `fk_works_company`; the second lists all three assignments and the correct company branch.

**Optional intentional error — run separately:**

```sql
INSERT INTO works (w_name, e_name, company_name, salary)
VALUES ('W999', 'Rahim', 'NoSuchCompany', 99999);
```

**Expected:** Foreign-key error; `W999` is rejected. Verify with:

```sql
SELECT COUNT(*) AS total_assignments FROM works;
```

**Expected:** Still `3`.

---

## 6. Manual III — Lab Exercise solution: Bank database

**Manual exercise:** Create six related tables—`branch`, `customer`, `account`, `loan`, `depositor`, and `borrower`—with keys; insert records; add and fill `Email` in `customer`; rename `customer_city`; change the datatype of `assets`.

> **Adapting the manual literally:** It says use `INTEGER` for `amount` and `balance`, and `VARCHAR(13)` for other *initial* fields. The initial `assets` field below is therefore `VARCHAR(13)` and is later modified to `BIGINT` to demonstrate the required type change. This is for the **lab exercise**, not good production financial modeling. Monetary fields should normally be numeric (often `DECIMAL` for fractional currency). The added email field uses `VARCHAR(100)` so example addresses fit.
>
> **Schema-design caveat:** The exercise names customers using `customer_name` in the `depositor` and `borrower` tables, even though the customer key is `customer_id`. To make foreign keys on those exact provided column names work, this demo also sets `customer_name UNIQUE`. **Real applications should reference `customer_id` instead**, because different people may have the same name.

### Bank A — Create a fresh independent database

**Run:**

```sql
CREATE DATABASE cse210_manual3_bank;
USE cse210_manual3_bank;
```

**Verify:**

```sql
SELECT DATABASE() AS active_database;
```

**Expected:** `cse210_manual3_bank`.

### Bank B — Create parent tables `branch` and `customer`

**Run:**

```sql
CREATE TABLE branch (
    branch_name VARCHAR(13) PRIMARY KEY,
    branch_city VARCHAR(13),
    assets VARCHAR(13)
) ENGINE=InnoDB;

CREATE TABLE customer (
    customer_id VARCHAR(13) PRIMARY KEY,
    customer_name VARCHAR(13) NOT NULL UNIQUE,
    customer_city VARCHAR(13)
) ENGINE=InnoDB;
```

**Verify:**

```sql
DESCRIBE branch;
DESCRIBE customer;
```

**Expected:** `branch_name` and `customer_id` are primary keys; `customer_name` also has a unique index.

### Bank C — Create child tables in parent-before-child order

**Run:**

```sql
CREATE TABLE account (
    account_number VARCHAR(13) PRIMARY KEY,
    branch_name VARCHAR(13) NOT NULL,
    balance INT,
    CONSTRAINT fk_account_branch
        FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
) ENGINE=InnoDB;

CREATE TABLE loan (
    loan_number VARCHAR(13) PRIMARY KEY,
    branch_name VARCHAR(13) NOT NULL,
    amount INT,
    CONSTRAINT fk_loan_branch
        FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
) ENGINE=InnoDB;

CREATE TABLE depositor (
    customer_name VARCHAR(13) NOT NULL,
    account_number VARCHAR(13) NOT NULL,
    PRIMARY KEY (customer_name, account_number),
    CONSTRAINT fk_depositor_customer
        FOREIGN KEY (customer_name) REFERENCES customer(customer_name),
    CONSTRAINT fk_depositor_account
        FOREIGN KEY (account_number) REFERENCES account(account_number)
) ENGINE=InnoDB;

CREATE TABLE borrower (
    customer_name VARCHAR(13) NOT NULL,
    loan_number VARCHAR(13) NOT NULL,
    PRIMARY KEY (customer_name, loan_number),
    CONSTRAINT fk_borrower_customer
        FOREIGN KEY (customer_name) REFERENCES customer(customer_name),
    CONSTRAINT fk_borrower_loan
        FOREIGN KEY (loan_number) REFERENCES loan(loan_number)
) ENGINE=InnoDB;
```

**Verify:**

```sql
SHOW TABLES;
SHOW CREATE TABLE depositor;
SHOW CREATE TABLE borrower;
```

**Expected:** Six tables exist. `depositor` and `borrower` each have a **composite primary key** and two foreign keys.

### Bank D — Insert parents first, then the related records

**Run — parents:**

```sql
INSERT INTO branch (branch_name, branch_city, assets) VALUES
('Dhanmondi', 'Dhaka', '150000000'),
('Gulshan', 'Dhaka', '220000000'),
('Agrabad', 'Chattogram', '175000000');

INSERT INTO customer (customer_id, customer_name, customer_city) VALUES
('C001', 'Rahim', 'Dhaka'),
('C002', 'Karim', 'Chattogram'),
('C003', 'Nila', 'Khulna');
```

**Verify:**

```sql
SELECT * FROM branch ORDER BY branch_name;
SELECT * FROM customer ORDER BY customer_id;
```

**Expected:** Three branches and three customers.

**Run — accounts, loans, depositors, and borrowers:**

```sql
INSERT INTO account (account_number, branch_name, balance) VALUES
('A101', 'Dhanmondi', 50000),
('A102', 'Gulshan', 70000),
('A103', 'Agrabad', 30000);

INSERT INTO loan (loan_number, branch_name, amount) VALUES
('L201', 'Dhanmondi', 100000),
('L202', 'Gulshan', 150000);

INSERT INTO depositor (customer_name, account_number) VALUES
('Rahim', 'A101'),
('Karim', 'A102'),
('Nila', 'A103');

INSERT INTO borrower (customer_name, loan_number) VALUES
('Rahim', 'L201'),
('Karim', 'L202');
```

**Verify:**

```sql
SELECT 'branch' AS table_name, COUNT(*) AS total FROM branch
UNION ALL SELECT 'customer', COUNT(*) FROM customer
UNION ALL SELECT 'account', COUNT(*) FROM account
UNION ALL SELECT 'loan', COUNT(*) FROM loan
UNION ALL SELECT 'depositor', COUNT(*) FROM depositor
UNION ALL SELECT 'borrower', COUNT(*) FROM borrower;
```

**Expected row counts:** `branch=3`, `customer=3`, `account=3`, `loan=2`, `depositor=3`, `borrower=2`.

### Bank E — Add and populate `Email` in `customer`

**Run:**

```sql
ALTER TABLE customer
ADD COLUMN Email VARCHAR(100);
```

**Verify structure:**

```sql
SHOW COLUMNS FROM customer LIKE 'Email';
```

**Expected:** The field exists, initially `NULL` for all customers.

**Run — set values:**

```sql
UPDATE customer SET Email = 'rahim@example.com' WHERE customer_id = 'C001';
UPDATE customer SET Email = 'karim@example.com' WHERE customer_id = 'C002';
UPDATE customer SET Email = 'nila@example.com'  WHERE customer_id = 'C003';
```

**Verify data:**

```sql
SELECT customer_id, customer_name, Email
FROM customer
ORDER BY customer_id;
```

**Expected:** All three email addresses are populated.

### Bank F — Rename `customer_city` and modify the datatype of `assets`

**Run — rename:**

```sql
ALTER TABLE customer
CHANGE COLUMN customer_city customer_address VARCHAR(50);
```

**Verify:**

```sql
DESCRIBE customer;
SELECT customer_name, customer_address FROM customer ORDER BY customer_id;
```

**Expected:** `customer_city` disappears and `customer_address` appears with the old city values preserved.

**Run — change `assets` from text to numeric:**

```sql
ALTER TABLE branch
MODIFY COLUMN assets BIGINT;
```

**Verify:**

```sql
DESCRIBE branch;
SELECT branch_name, assets, assets + 1000 AS example_new_assets
FROM branch ORDER BY branch_name;
```

**Expected:** `assets` now has type `bigint`; arithmetic works on the stored numbers. `example_new_assets` is a calculated preview—**not** a change to the table.

**Final bank verification:**

```sql
SELECT d.customer_name, d.account_number, a.branch_name, a.balance
FROM depositor AS d
JOIN account AS a ON d.account_number = a.account_number
ORDER BY d.customer_name;

SELECT b.customer_name, b.loan_number, l.amount
FROM borrower AS b
JOIN loan AS l ON b.loan_number = l.loan_number
ORDER BY b.customer_name;
```

**Expected:** All three depositors have valid accounts; both borrowers have valid loans. These joins are used only to **verify** relationships, not to introduce the next manual's full join lesson.

---

## 7. Quick questions to ask students while running the lab

1. After `ADD COLUMN email`, why are the existing email values `NULL`?
2. What is the difference between `DROP COLUMN email` and `DELETE FROM employees WHERE id = 1`?
3. What do `FIRST` and `AFTER` control—column order or row order?
4. What is the difference between `CHANGE COLUMN` and `MODIFY COLUMN`?
5. Why did adding the `UNIQUE` key prevent the extra `55000` salary?
6. Why can we not add another `PRIMARY KEY` to `employees`?
7. Why are departments inserted before non-NULL `dept_id` references are assigned?
8. When the salary changes to `300000`, why does the backup table still show `55000`?
9. What happens if an `UPDATE` statement has no `WHERE` clause?
10. Why should salaries be numeric rather than `VARCHAR`?
11. In the company task, what happens to existing records when `city` becomes `address`?
12. In the bank exercise, why do foreign-key parent tables need valid rows before their child rows can be inserted?

### Mini viva: suggested short answers

| Question | Short answer |
|---|---|
| `ALTER` vs. `UPDATE`? | `ALTER` changes **table structure**; `UPDATE` changes **existing row values**. |
| `CHANGE` vs. `MODIFY`? | `CHANGE` can rename **and** redefine; `MODIFY` redefines without renaming. |
| `DROP COLUMN` effect? | Removes the column and all data stored in that column. |
| `PRIMARY KEY`? | A unique, non-NULL identifier (one primary-key constraint per table; it may span multiple columns). |
| `UNIQUE`? | Blocks duplicate values/combinations (rules for `NULL` vary by DBMS; MySQL permits multiple `NULL` values in a normal unique index). |
| `FOREIGN KEY`? | Checks that non-NULL child-key values correspond to a valid parent key. |
| `WHERE` in `UPDATE`? | Controls which rows are changed; without it, the update usually applies to every row. |
| Is `CREATE TABLE ... AS SELECT` a full backup? | No; important constraints/indexes and later changes are not automatically copied. |

---

## 8. Completion checklist (for instructor / student)

- [ ] XAMPP MySQL service is running; phpMyAdmin SQL tab works.
- [ ] `cse210_manual3` contains `employees`, `departments`, `employee_badges`, `employees_info_backup`.
- [ ] All structural changes were verified with `DESCRIBE` / `SHOW COLUMNS`.
- [ ] `salary` is numeric (`BIGINT`) by the end.
- [ ] `F_name` is the renamed first-name field.
- [ ] Salary `UNIQUE` was created, demonstrated, and removed.
- [ ] `employees` has one primary key and a department foreign key.
- [ ] Main table: **7 employees**, **5 departments**, **7 snapshot rows**.
- [ ] Final updates changed John, Jane/Barry, Alice, and Diana as expected.
- [ ] `cse210_manual3_company` has 3 tables, the required columns, backups, and a `works` foreign key.
- [ ] `cse210_manual3_bank` has 6 tables with appropriate keys and the requested column changes.
- [ ] Students can explain the difference between a **schema change** and a **data change**.

### Troubleshooting in class

| Error / unexpected result | Likely cause | Fix |
|---|---|---|
| `No database selected` | You opened SQL tab without choosing a database | Run `USE cse210_manual3;` (or select the right practice database). |
| `Table already exists` / `Duplicate column name` | You ran a creation/addition activity twice | Verify the current schema and **skip** the completed activity; do not blindly repeat it. |
| `Multiple primary key defined` | Trying to add a primary key to a table that already has one | Use `employee_badges` for Activity 14. |
| Duplicate entry when adding `UNIQUE` | Existing rows share the same candidate unique value | Find duplicates first, or use the provided two-row setup. |
| Cannot add/update a child row: FK fails | Referenced parent ID or company does not exist | Insert the parent first and check the values. |
| `Unknown column` | Command executed out of order; rename/drop already occurred | Check `DESCRIBE` before running another statement. |
| `Data truncated` / `Out of range` | A value does not fit its datatype | Verify the values and use an appropriate numeric/string datatype. |
| Backup still shows old values | Snapshot is separate from the original | This is expected; snapshots are not synchronized. |
| Query changes too many rows | Missing or incorrect `WHERE` | Run a `SELECT` with the **same** `WHERE` condition before executing an `UPDATE`. |

**Source:** *CSE 210 Database System Lab Manual*, **Manual III: “Modifying MySQL databases and Updating Data in MySQL Table”**, printed pp. 20–30 (uploaded PDF pp. 26–36). The SQL, sample teaching order, verification queries, and separate practical solutions above are an instructor-friendly adaptation of that manual. The “Important corrections” section transparently identifies the source inconsistencies corrected for sequential execution.
