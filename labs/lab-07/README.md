# Lab 07: Relational Databases and JOIN Operations

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab07` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** INNER JOIN, LEFT JOIN, RIGHT JOIN, CROSS JOIN, multi-table joins, UNION, UNION ALL, GROUP BY, FULL OUTER workaround  
**Original manual alignment:** Source Lab VII (pages 48–54); repairs inconsistent IDs and types in the example registrations.

## 1. Learning objectives

1. Understand how foreign keys relate normalized tables.
2. Combine matching and non-matching rows with different join types.
3. Join three or more tables.
4. Distinguish JOIN operations from UNION and compare row counts.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

A JOIN combines **columns** from related tables. `INNER JOIN` keeps matches; `LEFT JOIN` keeps all left-hand rows and fills unmatched right-hand fields with `NULL`; `RIGHT JOIN` does the opposite. `CROSS JOIN` creates every possible pair. `UNION` stacks compatible result sets and removes duplicates; `UNION ALL` retains duplicates. MySQL does not support native `FULL OUTER JOIN`, so a LEFT/RIGHT combination can emulate it.

## 4. Instructor's walkthrough

1. Draw departments → courses and students → registrations as a relational diagram.
2. Begin with INNER JOIN and show matched student-course pairs.
3. Compare LEFT and RIGHT JOIN, highlighting Nila, Sami, and BUS101.
4. Show a multi-table join with department names.
5. Count CROSS JOIN rows, then compare UNION vs UNION ALL.
6. Finish with course counts grouped per student.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.

```sql
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
```

## 6. Expected results to check in front of students

- Tables contain **6 students**, **4 departments**, **5 courses**, **6 registrations**.
- The INNER JOIN between students and registrations returns **6** rows.
- The LEFT JOIN returns **8** rows because two students have no registration.
- The RIGHT JOIN (registrations to courses) returns **7** rows because BUS101 has no registration.
- `cross_join_count = 24`; Nila and Sami have `course_count = 0`.

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab07;
SELECT s.s_id,s.first_name,COUNT(r.reg_id) AS course_count FROM students s LEFT JOIN course_registration r ON r.s_id=s.s_id GROUP BY s.s_id,s.first_name ORDER BY s.s_id;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. Create a company database with projects, clients, and employees; add sensible foreign keys.
2. Write INNER, LEFT, and RIGHT JOIN queries for that company.
3. Find the number of projects per location using GROUP BY.
4. Design an orders/customers/salespeople query to show order details and commission rate.

## 8. Viva / checkpoint questions

1. INNER JOIN vs LEFT JOIN?
2. Why does CROSS JOIN multiply the row counts?
3. What is different about UNION and JOIN?

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab07;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
