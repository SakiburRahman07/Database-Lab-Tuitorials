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
