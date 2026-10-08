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
