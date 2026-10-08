# Lab 10: Functions and Stored Procedures in MySQL

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab10` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** CREATE PROCEDURE, IN/OUT parameters, CALL, CREATE FUNCTION, RETURN, DELIMITER  
**Original manual alignment:** Source Lab X (pages 67–74); builds from employee procedure/function examples and uses explicit routine characteristics.

## 1. Learning objectives

1. Create and call a stored procedure with IN and OUT parameters.
2. Create a data-reading function and a pure calculation function.
3. Use functions inside SELECT queries.
4. Understand client-side DELIMITER handling and how routines differ.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

A **stored procedure** is invoked with `CALL` and can use `IN`, `OUT`, and `INOUT` parameters; a **function** is called as part of an expression and returns one value. When defining multi-statement routines in the MySQL command-line client, `DELIMITER //` temporarily changes the client's terminator so semicolons inside `BEGIN ... END` do not cut the definition short. `DELIMITER` is a client command, not a server SQL statement.

## 4. Instructor's walkthrough

1. Demonstrate employees data and salaries.
2. Show why `GetEmployeeName` has IN ID and OUT name.
3. Call it for employee 102 and inspect the output variable.
4. Explain that the annual-salary function reads a table, so its metadata uses READS SQL DATA.
5. Call the pure CalculateTax function against all employee rows.
6. Discuss CALL versus SELECT, and procedure versus function.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.
**Routine-specific note:** For this lab, run the file using the MySQL command-line client (`SOURCE ...`), because different phpMyAdmin versions handle `DELIMITER`/compound routines differently. See [Setup](../../SETUP.md#lab-10-routines-special-case).


```sql
-- CSE 210 | Lab 10 | Stored procedures and functions
-- Recommended execution: mysql -u root -p < labs/lab-10/lab.sql
-- DELIMITER is a mysql-client command, NOT SQL; phpMyAdmin may handle it differently.
DROP DATABASE IF EXISTS cse210_lab10;
CREATE DATABASE cse210_lab10 CHARACTER SET utf8mb4;
USE cse210_lab10;

CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  department VARCHAR(50) NOT NULL,
  salary DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;
INSERT INTO employees VALUES
(101,'Ava','Finance',6000.00),
(102,'Rahul','IT',6500.00),
(103,'Mei','HR',5500.00);

DELIMITER //
-- Stored procedure: IN takes an ID, OUT returns a name.
CREATE PROCEDURE GetEmployeeName(IN p_emp_id INT,OUT p_name VARCHAR(100))
READS SQL DATA
BEGIN
  SET p_name = (SELECT name FROM employees WHERE employee_id=p_emp_id LIMIT 1);
END //

-- Table lookup: READS SQL DATA is more appropriate than DETERMINISTIC
-- because changing the table can change the result for the same ID.
CREATE FUNCTION GetAnnualSalary(p_emp_id INT)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
  DECLARE annual_salary DECIMAL(12,2);
  SET annual_salary = (SELECT salary*12 FROM employees WHERE employee_id=p_emp_id LIMIT 1);
  RETURN annual_salary;
END //

-- Pure computation: same argument => same answer.
CREATE FUNCTION CalculateTax(p_salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
NO SQL
BEGIN
  RETURN ROUND(p_salary*0.10,2);
END //
DELIMITER ;

CALL GetEmployeeName(102,@employee_name);
SELECT @employee_name AS employee_name; -- Rahul
SELECT GetAnnualSalary(101) AS annual_salary; -- 72000.00
SELECT name,salary,CalculateTax(salary) AS tax FROM employees ORDER BY employee_id;
-- Routine metadata and existence checks.
SHOW PROCEDURE STATUS WHERE Db='cse210_lab10';
SHOW FUNCTION STATUS WHERE Db='cse210_lab10';
-- To remove routines later: DROP PROCEDURE GetEmployeeName; DROP FUNCTION CalculateTax;
```

## 6. Expected results to check in front of students

- `@employee_name = Rahul` after calling GetEmployeeName(102,...).
- `GetAnnualSalary(101) = 72000.00`.
- Tax values for Ava/Rahul/Mei are **600.00 / 650.00 / 550.00**.
- Routine status queries list one procedure and two functions.

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab10;
SELECT GetAnnualSalary(101) AS annual_salary;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. Create a Students table with marks and letter grades.
2. Make a procedure GetStudentGrade(IN student_id, OUT grade).
3. Make a function GetPassFail(marks) returning Pass if marks >= 50, otherwise Fail.
4. Create a Products table, a GetProductPrice procedure, and an ApplyDiscount function (source lab extension).

## 8. Viva / checkpoint questions

1. What does an OUT parameter do?
2. Why must a stored function return a value?
3. Is DELIMITER a SQL keyword processed by the server?

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab10;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
