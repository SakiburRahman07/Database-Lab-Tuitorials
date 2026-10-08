# Lab 10 — Implementation of Functions and Stored Procedures in MySQL

*CSE 210 Database System Lab · Source: `CSE_210_Database_System_Lab.md` (PDF pages 73–80, printed pages 67–74)*

---

## 1. Objective(s)

- To understand the concept of Stored Procedures in MySQL.
- To understand the concept of Functions in MySQL.
- To implement a Stored Procedure using IN and OUT parameters.
- To implement a Function that returns a computed value.
- To distinguish between Functions and Stored Procedures.

---

## 2. Complete Example — copy, paste, run

```sql
-- ============================================================
-- Lab 10 : Complete demo (Stored Procedure + Function)
-- ============================================================
DROP DATABASE IF EXISTS cse210_lab10;
CREATE DATABASE cse210_lab10;
USE cse210_lab10;

-- 1) Create the Employees table and load data
CREATE TABLE Employees (
    EmployeeID INT NOT NULL,
    Name       VARCHAR(100) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary     DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (EmployeeID)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary) VALUES
(101, 'Ava',   'Finance', 6000.00),
(102, 'Rahul', 'IT',      6500.00),
(103, 'Mei',   'HR',      5500.00);

SELECT * FROM Employees;

-- 2) STORED PROCEDURE with IN and OUT parameters -------------------------
DROP PROCEDURE IF EXISTS GetEmployeeName;

DELIMITER //
CREATE PROCEDURE GetEmployeeName (
    IN  p_emp_id INT,
    OUT p_name   VARCHAR(100)
)
BEGIN
    SELECT Name INTO p_name
    FROM Employees
    WHERE EmployeeID = p_emp_id;
END //
DELIMITER ;

-- Call it and read the OUT parameter
CALL GetEmployeeName(102, @emp_name);
SELECT @emp_name;                       -- Rahul

-- 3) FUNCTION: annual salary (monthly x 12) ------------------------------
DROP FUNCTION IF EXISTS GetAnnualSalary;

DELIMITER //
CREATE FUNCTION GetAnnualSalary (emp_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE annual DECIMAL(12,2);
    SELECT Salary * 12 INTO annual
    FROM Employees
    WHERE EmployeeID = emp_id;
    RETURN annual;
END //
DELIMITER ;

SELECT GetAnnualSalary(101) AS AnnualSalary;      -- 72000.00

-- 4) FUNCTION: 10% tax on a salary --------------------------------------
DROP FUNCTION IF EXISTS CalculateTax;

DELIMITER //
CREATE FUNCTION CalculateTax (salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN salary * 0.10;               -- 10% tax rate
END //
DELIMITER ;

SELECT Name, Salary, CalculateTax(Salary) AS Tax
FROM Employees;

-- 5) Clean up (only when you are finished)
-- DROP PROCEDURE GetEmployeeName;
-- DROP FUNCTION GetAnnualSalary;
-- DROP FUNCTION CalculateTax;
-- DROP DATABASE cse210_lab10;
```

**Expected output**

`SELECT @emp_name`:

| @emp_name |
| --- |
| Rahul |

`SELECT GetAnnualSalary(101)`:

| AnnualSalary |
| --- |
| 72000.00 |

`SELECT Name, Salary, CalculateTax(Salary) AS Tax`:

| Name | Salary | Tax |
| --- | --- | --- |
| Ava | 6000.00 | 600.00 |
| Rahul | 6500.00 | 650.00 |
| Mei | 5500.00 | 550.00 |

---

## 3. Quick Reference — Concepts taught in this lab

### 3.1 Concepts and one-line SQL

| # | Concept | Copy-paste SQL |
| --- | --- | --- |
| 1 | Procedure — general syntax | `CREATE PROCEDURE name (parameter_list) BEGIN /* SQL */ END;` |
| 2 | Parameter types | `IN` (input, read-only), `OUT` (result to caller), `INOUT` (both) |
| 3 | Call a procedure | `CALL GetEmployeeName(102, @emp_name);` |
| 4 | Read an OUT parameter | `SELECT @emp_name;` |
| 5 | Function — general syntax | `CREATE FUNCTION name (p INT) RETURNS type DETERMINISTIC BEGIN ... RETURN value; END;` |
| 6 | Call a function inside a query | `SELECT GetAnnualSalary(101) AS AnnualSalary;` |
| 7 | Variables inside the body | `DECLARE annual DECIMAL(12,2);` and `SELECT ... INTO variable` |
| 8 | Change the terminator | `DELIMITER //` … `//` … `DELIMITER ;` |
| 9 | Drop a procedure | `DROP PROCEDURE IF EXISTS GetEmployeeName;` |
| 10 | Drop a function | `DROP FUNCTION IF EXISTS GetAnnualSalary;` |

### 3.2 Stored Procedure template (IN / OUT)

```sql
DELIMITER //
CREATE PROCEDURE GetEmployeeName (
    IN  p_emp_id INT,
    OUT p_name   VARCHAR(100)
)
BEGIN
    SELECT Name INTO p_name
    FROM Employees
    WHERE EmployeeID = p_emp_id;
END //
DELIMITER ;

CALL GetEmployeeName(102, @emp_name);
SELECT @emp_name;
```

### 3.3 Function template

```sql
DELIMITER //
CREATE FUNCTION GetAnnualSalary (emp_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE annual DECIMAL(12,2);
    SELECT Salary * 12 INTO annual
    FROM Employees
    WHERE EmployeeID = emp_id;
    RETURN annual;
END //
DELIMITER ;

SELECT GetAnnualSalary(101) AS AnnualSalary;
```

> `DETERMINISTIC` tells MySQL that the function always produces the same output for the same input, which helps the optimizer. Functions only allow **IN** parameters.

---

## 4. Problem Analysis

In database systems, we often need to perform the same set of SQL operations repeatedly. Writing the same queries again and again in application code is inefficient and error-prone. MySQL provides two powerful tools to store and reuse SQL logic inside the database itself: Stored Procedures and Functions. A Stored Procedure is a named collection of SQL statements that is saved in the database and can be called (executed) whenever needed. It can accept input values, perform complex operations such as INSERT, UPDATE, or DELETE, and return output values through OUT parameters. A Function is similar to a procedure, but it must always return exactly one value and is designed to be used directly inside SQL queries, much like built-in MySQL functions such as NOW() or COUNT(). Both procedures and functions help reduce code duplication, improve maintainability, and move business logic closer to the data. In this lab, we will create a simple Employees table, then write and execute both a stored procedure and a function on it.

---

## 5. Procedure

First, we open the database system (via phpMyAdmin or the MySQL command line) and prepare it to accept our instructions. Then we create a database and a table, insert sample data, and implement a stored procedure and a function. Finally, we call each one and observe the output.

---

## 6. Implementations

### 6.1 Database and Table Setup

**Database Creation**

To create a database named lab_fp, write:

```sql
CREATE DATABASE lab_fp;
```

**Database Use**

To select and use the newly created database:

```sql
USE lab_fp;
```

**Table Creation**

Create a table named Employees with four attributes: EmployeeID (int, primary key), Name (varchar), Department (varchar), and Salary (decimal):

```sql
CREATE TABLE Employees (
    EmployeeID INT NOT NULL,
    Name       VARCHAR(100) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary     DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (EmployeeID)
);
```

**Data Insertion**

Insert three sample employee records into the Employees table:

```sql
INSERT INTO Employees (EmployeeID, Name, Department, Salary) VALUES
(101, 'Ava',   'Finance', 6000.00),
(102, 'Rahul', 'IT',      6500.00),
(103, 'Mei',   'HR',      5500.00);
```

After insertion, the Employees table contains the following records:

| EmployeeID | Name | Department | Salary |
| --- | --- | --- | --- |
| 101 | Ava | Finance | 6000.00 |
| 102 | Rahul | IT | 6500.00 |
| 103 | Mei | HR | 5500.00 |

### 6.2 Implementing a Stored Procedure

A stored procedure is created using the CREATE PROCEDURE statement. The general syntax is:

```sql
CREATE PROCEDURE procedure_name (parameter_list)
BEGIN
    -- SQL statements
END;
```

Parameters can be of three kinds:

- **IN** — the caller passes a value into the procedure (read-only inside).
- **OUT** — the procedure sends a value back to the caller.
- **INOUT** — the parameter is both passed in and returned.

**Example: Get Employee Name by ID**

The following procedure accepts an employee ID as input and returns the corresponding employee name as output:

```sql
DELIMITER //
CREATE PROCEDURE GetEmployeeName (
    IN  p_emp_id INT,
    OUT p_name   VARCHAR(100)
)
BEGIN
    SELECT Name INTO p_name
    FROM Employees
    WHERE EmployeeID = p_emp_id;
END //
DELIMITER ;
```

N.B.: The DELIMITER command is used to temporarily change the statement terminator from `;` to `//`, so that MySQL does not treat the semicolons inside the procedure body as the end of the CREATE statement. After the procedure is defined, the delimiter is reset to `;`.

**Calling the Procedure**

To execute the procedure and retrieve the name of employee number 102:

```sql
CALL GetEmployeeName(102, @emp_name);
SELECT @emp_name;
```

The variable `@emp_name` stores the OUT result. The output will be:

| @emp_name |
| --- |
| Rahul |

### 6.3 Implementing a Function

A function is created using the CREATE FUNCTION statement. Unlike a procedure, a function must always return a single value using the RETURN statement. The general syntax is:

```sql
CREATE FUNCTION function_name (parameter_list)
RETURNS data_type
DETERMINISTIC
BEGIN
    -- SQL statements
    RETURN value;
END;
```

The keyword DETERMINISTIC tells MySQL that the function always produces the same output for the same input, which helps the optimizer. Functions only allow IN parameters.

**Example 1: Calculate Annual Salary**

The following function takes an employee ID and returns that employee's annual salary (monthly salary multiplied by 12):

```sql
DELIMITER //
CREATE FUNCTION GetAnnualSalary (emp_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE annual DECIMAL(12,2);
    SELECT Salary * 12 INTO annual
    FROM Employees
    WHERE EmployeeID = emp_id;
    RETURN annual;
END //
DELIMITER ;
```

**Calling the Function**

Functions are called directly inside a SQL query, just like built-in MySQL functions:

```sql
SELECT GetAnnualSalary(101) AS AnnualSalary;
```

The output will be:

| AnnualSalary |
| --- |
| 72000.00 |

**Example 2: Calculate Tax on Salary**

The following function accepts a salary value directly and returns 10% of it as tax:

```sql
DELIMITER //
CREATE FUNCTION CalculateTax (salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN salary * 0.10; -- 10% tax rate
END //
DELIMITER ;
```

This function can be used directly in a SELECT query to compute tax for every employee:

```sql
SELECT Name, Salary, CalculateTax(Salary) AS Tax
FROM Employees;
```

The output will be:

| Name | Salary | Tax |
| --- | --- | --- |
| Ava | 6000.00 | 600.00 |
| Rahul | 6500.00 | 650.00 |
| Mei | 5500.00 | 550.00 |

---

## 7. Input/Output Summary

All implementations in this lab follow the same pattern: SQL statements are written in the phpMyAdmin SQL editor or the MySQL command line, and the results are displayed immediately below. The key commands used are summarised below.

| Command | Purpose |
| --- | --- |
| CREATE PROCEDURE | Define a new stored procedure |
| CALL | Execute a stored procedure |
| CREATE FUNCTION | Define a new function |
| SELECT func(...) | Call a function inside a query |
| DROP PROCEDURE | Remove a stored procedure |
| DROP FUNCTION | Remove a function |

---

## 8. Discussion & Conclusion

In this lab, we created a Stored Procedure and two Functions in MySQL and executed them on an Employees table. A stored procedure is most suitable for performing complex operations that involve multiple SQL statements, transaction control, or returning more than one value. A function is best used when a single computed value needs to be embedded directly inside a SELECT or WHERE clause. The key differences between the two are summarised in Table X.1.

**Table X.1: Comparison of Functions and Stored Procedures**

| Feature | Function | Stored Procedure |
| --- | --- | --- |
| Return value | Must return exactly one value | Can return 0, 1, or many values via OUT parameters |
| Parameters | IN only | IN, OUT, INOUT |
| Use in queries | Can be used in SELECT, WHERE, etc. | Cannot be used directly in SQL statements |
| DML operations | Generally not allowed | Fully supported |
| Transaction control | Not allowed | Allowed |
| Primary use | Calculations and reusable expressions | Business logic and batch processing |

Through this lab we have successfully achieved all stated objectives: creating and calling a stored procedure with IN/OUT parameters, and creating and using functions both for individual lookups and for column-level computation across a result set.

---

## 9. Lab Task (Please implement yourself and show the output to the instructor)

1. Create a database named lab_task.
2. Create a table named Students with attributes: StudentID (int, primary key), Name (varchar), Marks (decimal), Grade (varchar).
3. Insert at least five records into the Students table.
4. Write a stored procedure named GetStudentGrade that accepts a StudentID as IN and returns the corresponding Grade as OUT.
5. Call the procedure for at least two different student IDs and display the results.
6. Write a function named GetPassFail that accepts a Marks value and returns the string 'Pass' if marks ≥ 50, otherwise returns 'Fail'.
7. Use the function in a SELECT query to display Name, Marks, and Pass/Fail status for all students.

### 9.1 Problem Analysis

1. Create the lab_task database using CREATE DATABASE.
2. Create the Students table with appropriate data types and a primary key.
3. Use INSERT INTO to add at least five student records.
4. Write GetStudentGrade as a procedure with one IN and one OUT parameter. Use SELECT ... INTO to fetch the grade.
5. Call the procedure using `CALL GetStudentGrade(id, @result);` and then `SELECT @result;`.
6. Write GetPassFail as a function using an IF statement inside the function body to decide the return value.
7. Apply the function in a SELECT query: `SELECT Name, Marks, GetPassFail(Marks) AS Status FROM Students;`.

---

## 10. Lab Exercise (Submit as a Report)

- Create a database with a table named Products containing at least the columns ProductID, ProductName, Price, and Stock.
- Insert at least eight product records.
- Write a stored procedure GetProductPrice that takes a ProductID and returns its Price.
- Write a function ApplyDiscount that takes a price and a discount percentage, and returns the discounted price.
- Use ApplyDiscount in a SELECT query to show the original and discounted price for all products.
- Take screenshots of each step and include them in your report.

---

## 11. References

- https://dev.mysql.com/doc/refman/8.0/en/stored-programs-defining.html
- https://dev.mysql.com/doc/refman/8.0/en/create-procedure.html
- https://dev.mysql.com/doc/refman/8.0/en/create-function.html

---

## Academic Integrity Policy

Copying from the internet, classmates, seniors, or any other unauthorized source is strictly prohibited. Full marks may be deducted if plagiarism, copied work, or academic dishonesty is detected.

Students must complete the lab task, implementation, output analysis, and lab report independently and submit authentic work for evaluation.
