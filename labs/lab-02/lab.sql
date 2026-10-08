-- CSE 210 | Lab 02 | Integrity constraints
DROP DATABASE IF EXISTS cse210_lab02;
CREATE DATABASE cse210_lab02 CHARACTER SET utf8mb4;
USE cse210_lab02;

-- PRIMARY KEY, NOT NULL, UNIQUE, DEFAULT and CHECK.
CREATE TABLE departments (
  department_id INT PRIMARY KEY,
  department_name VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB;
INSERT INTO departments VALUES (1,'CSE'),(2,'EEE'),(3,'BBA');

CREATE TABLE students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  age INT NOT NULL,
  department_id INT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'Active',
  CONSTRAINT chk_student_age CHECK (age >= 16),
  CONSTRAINT fk_student_department FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;
INSERT INTO students (name,email,age,department_id) VALUES
('Asha','asha@example.edu',20,1),
('Rafi','rafi@example.edu',22,1),
('Mitu','mitu@example.edu',21,2),
('Sami','sami@example.edu',19,3),
('Nila','nila@example.edu',23,2);

-- Composite PRIMARY KEY: one student can enroll in several courses.
CREATE TABLE enrollments (
  student_id INT NOT NULL,
  course_code VARCHAR(12) NOT NULL,
  grade CHAR(2),
  PRIMARY KEY(student_id,course_code),
  CONSTRAINT fk_enroll_student FOREIGN KEY(student_id)
    REFERENCES students(student_id) ON DELETE CASCADE
) ENGINE=InnoDB;
INSERT INTO enrollments VALUES
(1,'CSE210','A'),(1,'CSE211','B+'),(2,'CSE210','A-'),
(3,'EEE201','B'),(4,'BUS101','A'),(5,'EEE201','B+');

-- RESTRICT prevents removing a referenced parent row.
CREATE TABLE courses (
  course_code VARCHAR(12) PRIMARY KEY,
  title VARCHAR(80) NOT NULL
) ENGINE=InnoDB;
INSERT INTO courses VALUES ('CSE210','Database System Lab'),('CSE211','Database Systems');
CREATE TABLE class_sections (
  section_id INT PRIMARY KEY,
  course_code VARCHAR(12) NOT NULL,
  CONSTRAINT fk_section_course FOREIGN KEY(course_code)
    REFERENCES courses(course_code) ON DELETE RESTRICT
) ENGINE=InnoDB;
INSERT INTO class_sections VALUES (1,'CSE210');

-- Demo: ON DELETE SET NULL keeps the child student but clears department_id.
DELETE FROM departments WHERE department_id = 3;
SELECT student_id,name,department_id,status FROM students ORDER BY student_id;
-- Demo: ON UPDATE CASCADE propagates a changed department primary key.
UPDATE departments SET department_id=20 WHERE department_id=2;
SELECT student_id,name,department_id FROM students ORDER BY student_id;

-- Demo: ON DELETE CASCADE removes only that student's enrollments.
DELETE FROM students WHERE student_id=5;
SELECT * FROM enrollments ORDER BY student_id,course_code;

-- CASE is an expression, not an integrity constraint.
SELECT student_id, name, age,
  CASE WHEN age >= 21 THEN '21 or older' ELSE 'Under 21' END AS age_group
FROM students ORDER BY student_id;
SHOW CREATE TABLE students;

-- EXPECTED ERRORS: Run individually ONLY to demonstrate constraint violations.
-- INSERT INTO students(name,email,age) VALUES (NULL,'x@example.edu',20); -- NOT NULL
-- INSERT INTO students(name,email,age) VALUES ('Copy','asha@example.edu',20); -- UNIQUE
-- INSERT INTO students(name,email,age) VALUES ('Young','young@example.edu',14); -- CHECK
-- INSERT INTO students(name,email,age,department_id) VALUES ('Wrong','wrong@example.edu',20,999); -- FOREIGN KEY
-- INSERT INTO enrollments VALUES (1,'CSE210','B'); -- composite PK duplicate
-- DELETE FROM courses WHERE course_code='CSE210'; -- RESTRICT
-- NOTE: InnoDB does not support ON DELETE SET DEFAULT for foreign keys.
