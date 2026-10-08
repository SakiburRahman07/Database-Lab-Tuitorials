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
