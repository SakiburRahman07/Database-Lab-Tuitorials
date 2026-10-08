# Lab 02: Implementation of Integrity Constraints in MySQL

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab02` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** PRIMARY KEY, composite key, NOT NULL, UNIQUE, FOREIGN KEY, CASCADE, SET NULL, RESTRICT, DEFAULT, AUTO_INCREMENT, CHECK, CASE  
**Original manual alignment:** Source Lab II (pages 9–19); retains its key and referential-integrity topics but resolves overlapping table definitions.

## 1. Learning objectives

1. Define column and table integrity constraints.
2. Use primary and composite keys correctly.
3. Observe referential actions when a parent row is updated or deleted.
4. Distinguish invalid inserts from valid rows, and distinguish `CASE` from a constraint.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

Constraints protect data quality. A **primary key** identifies a row; a **composite primary key** identifies a row using two or more fields. `UNIQUE` prevents duplicate values, `NOT NULL` requires a value, and a **foreign key** restricts relationships. `ON DELETE SET NULL` keeps child rows while clearing the FK, `CASCADE` propagates parent changes/removals, and `RESTRICT` blocks changes that would break a relationship. `DEFAULT` fills an omitted field; `CHECK` enforces a condition. The `CASE` **expression** categorizes results; it is not a constraint.

## 4. Instructor's walkthrough

1. Introduce the `departments` parent table, then the `students` and `enrollments` child tables.
2. Use `SHOW CREATE TABLE students` to locate each constraint.
3. Delete department 3 and observe that Sami remains but his `department_id` becomes `NULL`.
4. Update department ID 2 to 20 and observe cascade to Mitu.
5. Delete student 5 and observe that the matching enrollment is deleted.
6. Uncomment **one** failing statement at a time to show its error, then re-comment it.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.

```sql
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
```

## 6. Expected results to check in front of students

- After department 3 is deleted, student 4 has `department_id = NULL`.
- After changing department 2 to 20, student 3 has `department_id = 20`.
- Four students remain after deleting student 5; five enrollments remain.
- The commented bad INSERT/DELETE examples should generate errors if deliberately run individually.

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab02;
SELECT student_id,name,department_id FROM students ORDER BY student_id;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. Create a fresh three-table project containing at least two `UNIQUE` constraints.
2. Give every table a primary key and one child table a foreign key.
3. Try a deliberate duplicate email and record the error message.
4. Explain why `ON DELETE SET DEFAULT` is not a usable InnoDB FK action.

## 8. Viva / checkpoint questions

1. Can a primary key contain `NULL`?
2. How is `UNIQUE` different from a primary key?
3. Compare `CASCADE`, `SET NULL`, and `RESTRICT` with examples.

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab02;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
