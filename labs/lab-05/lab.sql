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
