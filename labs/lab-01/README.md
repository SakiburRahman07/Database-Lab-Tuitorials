# Lab 01: Introduction to Database, MySQL, and Managing Databases

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab01` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** CREATE DATABASE, USE, CREATE TABLE, data types, INSERT, DESCRIBE, SELECT, DROP TABLE  
**Original manual alignment:** Source Lab I (pages 1–8); examples expand the original University / Teacher / Student / Staff activity.

## 1. Learning objectives

1. Explain what a database, table, record and field mean.
2. Create a database and several tables from scratch.
3. Insert, inspect and display table rows.
4. Safely demonstrate DROP TABLE and understand data loss.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

A **database** holds related tables. A **table** organizes records (rows) into fields (columns). `INT` is suitable for numeric IDs, `VARCHAR(n)` for text, and phone numbers should be stored as text because they can begin with zero. `CREATE` changes the schema; `INSERT` adds rows; `SELECT` reads rows; `DROP` permanently removes an object.

## 4. Instructor's walkthrough

1. Point out the `CREATE DATABASE` and `USE` statements.
2. Show how each `CREATE TABLE` statement specifies column names and data types.
3. Run the INSERT statements; explain why one INSERT can add many rows.
4. Ask learners to inspect `DESCRIBE students` and `SELECT * FROM students`.
5. Demonstrate `DROP TABLE temporary_demo` and point out that the original tables survive.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.

```sql
-- CSE 210 | Lab 01 | Introduction to MySQL and database management
-- Classroom demo: reset only this lab's own database.
DROP DATABASE IF EXISTS cse210_lab01;
CREATE DATABASE cse210_lab01 CHARACTER SET utf8mb4;
USE cse210_lab01;

-- Step 1: Define tables; use VARCHAR for contact numbers (leading zeros).
CREATE TABLE teachers (
  teacher_id INT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  designation VARCHAR(60),
  address VARCHAR(100),
  email VARCHAR(100)
);
CREATE TABLE students (
  student_id INT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  address VARCHAR(100),
  phone VARCHAR(20)
);
CREATE TABLE staff (
  staff_id INT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  position VARCHAR(60),
  address VARCHAR(100),
  phone VARCHAR(20)
);

-- Step 2: Insert five rows into every table.
INSERT INTO teachers VALUES
(1,'Nadia Rahman','Professor','Dhaka','nadia@example.edu'),
(2,'Arif Hasan','Lecturer','Gazipur','arif@example.edu'),
(3,'Samia Karim','Lecturer','Dhaka','samia@example.edu'),
(4,'Imran Ahmed','Associate Professor','Cumilla','imran@example.edu'),
(5,'Tasnim Akter','Senior Lecturer','Narayanganj','tasnim@example.edu');
INSERT INTO students VALUES
(101,'Asha','Dhaka','01711000001'),
(102,'Rafi','Gazipur','01711000002'),
(103,'Mitu','Cumilla','01711000003'),
(104,'Sami','Dhaka','01711000004'),
(105,'Nila','Khulna','01711000005');
INSERT INTO staff VALUES
(201,'Kabir','Lab Assistant','Dhaka','01811000001'),
(202,'Farah','Office Assistant','Gazipur','01811000002'),
(203,'Robin','Technician','Dhaka','01811000003'),
(204,'Salma','Librarian','Cumilla','01811000004'),
(205,'Jahid','Accountant','Dhaka','01811000005');

-- Step 3: Inspect data and structure.
SHOW TABLES;
DESCRIBE students;
SELECT * FROM students ORDER BY student_id;
SELECT * FROM teachers ORDER BY teacher_id;
SELECT * FROM staff ORDER BY staff_id;
SELECT COUNT(*) AS student_count FROM students;

-- Step 4: Safely demonstrate DROP TABLE without losing class data.
CREATE TABLE temporary_demo (id INT);
SHOW TABLES;
DROP TABLE temporary_demo;
SHOW TABLES;
-- OPTIONAL CLEANUP after lab (never run during an unfinished class):
-- DROP DATABASE cse210_lab01;
```

## 6. Expected results to check in front of students

- `SHOW TABLES` lists `teachers`, `students`, and `staff` at the end.
- Each of the three tables contains five rows; `student_count` is **5**.
- The `temporary_demo` table appears briefly, then disappears after `DROP TABLE`.

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab01;
SELECT COUNT(*) AS total_students FROM students;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. Create a separate `library_books` table with `book_id`, `title`, `author`, and `price`.
2. Insert at least five books and display their records.
3. Write a query to display only `title` and `price`.
4. Explain why storing phone numbers as `INT` is risky.

## 8. Viva / checkpoint questions

1. What is the difference between a database and a table?
2. What is the difference between `DELETE` and `DROP TABLE`?
3. Why is a phone number usually stored as `VARCHAR`?

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab01;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
