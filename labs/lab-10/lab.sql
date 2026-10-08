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
