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
