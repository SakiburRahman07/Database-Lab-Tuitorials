-- CSE 210 | Lab 07 | Relational joins, UNION and grouping
DROP DATABASE IF EXISTS cse210_lab07;
CREATE DATABASE cse210_lab07 CHARACTER SET utf8mb4;
USE cse210_lab07;

CREATE TABLE departments (
  dept_id INT PRIMARY KEY,
  dept_name VARCHAR(30) NOT NULL UNIQUE,
  location VARCHAR(60) NOT NULL
) ENGINE=InnoDB;
CREATE TABLE students (
  s_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  dept_id INT NULL,
  CONSTRAINT fk_student_dept FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;
CREATE TABLE courses (
  course_code VARCHAR(10) PRIMARY KEY,
  course_title VARCHAR(80) NOT NULL,
  dept_id INT NOT NULL,
  CONSTRAINT fk_course_dept FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;
CREATE TABLE course_registration (
  reg_id INT AUTO_INCREMENT PRIMARY KEY,
  s_id INT NOT NULL,
  course_code VARCHAR(10) NOT NULL,
  CONSTRAINT uq_registration UNIQUE(s_id,course_code),
  CONSTRAINT fk_reg_student FOREIGN KEY(s_id) REFERENCES students(s_id),
  CONSTRAINT fk_reg_course FOREIGN KEY(course_code) REFERENCES courses(course_code)
) ENGINE=InnoDB;

INSERT INTO departments VALUES
(101,'CSE','Building-2'),(102,'EEE','Building-2'),
(103,'TEX','Building-1'),(104,'BBA','Building-3');
INSERT INTO students VALUES
(1,'Asha','Rahman',101),(2,'Sakib','Hasan',101),
(3,'Mitu','Karim',102),(4,'Rafi','Chowdhury',103),
(5,'Nila','Akter',101),(6,'Sami','Ahmed',NULL);
INSERT INTO courses VALUES
('CSE210','Database System Lab',101),
('CSE211','Database Systems',101),
('EEE201','Electrical Circuits',102),
('TEX201','Textile Basics',103),
('BUS101','Accounting Fundamentals',104);
INSERT INTO course_registration(s_id,course_code) VALUES
(1,'CSE210'),(1,'CSE211'),(2,'CSE210'),
(3,'EEE201'),(4,'TEX201'),(2,'CSE211');

-- INNER: only matching student registrations.
SELECT s.s_id,s.first_name,r.course_code
FROM students AS s INNER JOIN course_registration AS r ON r.s_id=s.s_id
ORDER BY s.s_id,r.course_code;
-- Multiple INNER JOINs: student -> registration -> course -> department.
SELECT s.first_name,c.course_title,d.dept_name
FROM students AS s
INNER JOIN course_registration AS r ON r.s_id=s.s_id
INNER JOIN courses AS c ON c.course_code=r.course_code
INNER JOIN departments AS d ON d.dept_id=c.dept_id
ORDER BY s.s_id,c.course_code;
-- LEFT: includes students with zero registrations.
SELECT s.s_id,s.first_name,r.course_code
FROM students AS s LEFT JOIN course_registration AS r ON r.s_id=s.s_id
ORDER BY s.s_id,r.course_code;
-- RIGHT: includes all courses, including BUS101 with no registrations.
SELECT r.s_id,c.course_code,c.course_title
FROM course_registration AS r RIGHT JOIN courses AS c ON c.course_code=r.course_code
ORDER BY c.course_code,r.s_id;
-- CROSS: 6 students x 4 departments = 24 possible pairs.
SELECT COUNT(*) AS cross_join_count FROM students CROSS JOIN departments;
-- Self-contained UNION and UNION ALL demonstrations.
SELECT dept_id FROM students WHERE dept_id IS NOT NULL
UNION
SELECT dept_id FROM courses ORDER BY dept_id;
SELECT dept_id FROM students WHERE dept_id IS NOT NULL
UNION ALL
SELECT dept_id FROM courses ORDER BY dept_id;
-- MySQL-compatible FULL OUTER JOIN emulation (no native FULL OUTER JOIN).
SELECT s.s_id,s.first_name,r.course_code
FROM students AS s LEFT JOIN course_registration AS r ON r.s_id=s.s_id
UNION ALL
SELECT s.s_id,s.first_name,r.course_code
FROM students AS s RIGHT JOIN course_registration AS r ON r.s_id=s.s_id
WHERE s.s_id IS NULL;
-- Count registrations per student: Nila and Sami have zero.
SELECT s.s_id,s.first_name,COUNT(r.reg_id) AS course_count
FROM students AS s LEFT JOIN course_registration AS r ON r.s_id=s.s_id
GROUP BY s.s_id,s.first_name ORDER BY s.s_id;
