
<a id="lab-07"></a>

# Lab 07 — Implementation of Relational Databases (Join Function)

> **ORIGINAL PDF TRANSCRIPTION BELOW:** The source paragraphs, original tables, exercises, code fragments and image references retain their original teaching sequence. Text labeled **Instructor-added** is new, not from the PDF.

<!-- Original PDF page 54; printed lab page 48 -->

## 7.1 Objective(s)

- We learned about the need to normalize to make it easier to maintain the data.Though this makes it easier to maintain and update the data, it makes it very inconvenient to view and report information.

- Through the use of database joins we can stitch the data back together to make it easy for a person to use and understand.

## 7.2 Problem analysis

Before we begin let’s look into why you have to combine data in the first place. SQLite and other databases such as Microsoft SQL server and MySQL are relational databases. These types of databases make it really easy to create tables of data and a facility to relate (join or combine) the data together. As requirements are cast into table designs, they are laid up against some best practices to minimize data quality issues. This process is called normalization and it helps each table achieve singular meaning and purpose. For instance, if I had a table containing all the students and their classes, then wanted to change a student’s name, I would have to change it multiple times, once for each class the student enrolled in. We can easily produce these details with the help of JOIN function.

**MySQL JOIN functions**

| JOIN function | Description |
| --- | --- |
| Cross Joins | return all combinations of rows from each table. |
| Inner joins | return rows when the join condition is met. |
| Outer joins | return all the rows from one table, and if the join condition is met, columns from the other. |
| Left Outer Join | Return all rows from the “left” table, and matching rows from the “right” table. |
| Right Outer Join | Return all rows from the “right” table, and matching rows from the “left” table. |
| Full Join | Return all rows from an inner join, when no match is found, return nulls for that table. |

![Full source table, PDF page 54](../assets/source-figures/page-54-join-functions.png)

![Source PDF table, PDF page 54](../assets/source-figures/page-54-table-07.png)

<!-- Original PDF page 55; printed lab page 49 -->

![Diagram / screenshot from the source PDF, PDF page 55](../assets/source-figures/page-55-image-01.png)

*Figure VII.1: Classification of Join Operations*

### 7.2.1 Join Function

- Cross Joins: Cross joins return all combinations of rows from each table. So, if you’re looking to find all combinations of size and color, you would use a cross join. Join conditions are not used with cross joins.

- Inner joins: Inner joins return rows when the join condition is met. This is the most common Database join. A common scenario is to join the primary key of once table to the foreign key of another.

This is used to perform “lookup,” such are to get the employee’s name from their employeeID.

- Outer joins: Outer joins return all the rows from one table, and if the join condition is met, columns from the other. They differ from an inner join, since an inner join wouldn’t include the non-matching rows in the final result.

Consider an order entry system. There may be cases where we want to list all employees regardless of whether they placed a customer order. In this case an outer join comes in handy.

When using an outer join all employees, even those not matching orders, are included in the result.


### Instructor-added live example — INNER JOIN versus LEFT JOIN

> **ADDED TEACHING EXAMPLE — not text from the PDF.** Copy the **entire** code block into the phpMyAdmin SQL tab and click **Go**. This demonstration sets up its own practice objects, so it does not need any previous lab. Re-running it resets only the indicated `demo_*` tables.

```sql
CREATE DATABASE IF NOT EXISTS cse210_examples_lab07;
USE cse210_examples_lab07;
DROP TABLE IF EXISTS demo_join_orders;
DROP TABLE IF EXISTS demo_join_customers;
CREATE TABLE demo_join_customers (id INT PRIMARY KEY, name VARCHAR(30));
CREATE TABLE demo_join_orders (id INT PRIMARY KEY, customer_id INT, amount INT,
 FOREIGN KEY(customer_id) REFERENCES demo_join_customers(id));
INSERT INTO demo_join_customers VALUES (1,'Asha'),(2,'Rafi'),(3,'Mitu');
INSERT INTO demo_join_orders VALUES (10,1,500),(11,1,600),(12,2,700);
SELECT c.name,o.amount FROM demo_join_customers c INNER JOIN demo_join_orders o ON c.id=o.customer_id ORDER BY o.id;
SELECT c.name,o.amount FROM demo_join_customers c LEFT JOIN demo_join_orders o ON c.id=o.customer_id ORDER BY c.id,o.id;
```

**Expected output / explanation:** INNER JOIN = 3 rows; LEFT JOIN = 4 rows including Mitu with NULL amount.

## 7.3 Procedure (Implementation in MySQL)

1. Create a Data

- Create a table student:

<!-- Original PDF page 56; printed lab page 50 -->

```sql
CREATE TABLE student(
s_id int(11) NOT NULL AUTO_INCREMENT,
FirstName varchar(255) NOT NULL,
LastName varchar(255 ) NOT NULL,
Address varchar(255 ) NOT NULL,
dept_name enum( ‘CSE’, ‘EEE’ , ‘ TEX’ ) DEFAULT NULL,
AdmissionDate datetime NOT NULL DEFAULT current_timestamp(),
PRIMARY KEY(S_ID)
);
```

- Insert values into student table:

```sql
INSERT INTO student (s_id, FirstName, LastName, Address, dept_name)
VALUES(142002015, ‘Zeseya’ , ‘Sharmin’ , ‘Dhaka’ , ‘CSE’),
(142002001, ‘Sakib’ , ‘Hasan’ , ‘Natore’ , ‘CSE’),
(162002002, ‘Asef’, ‘Tajwar’ , ‘Rangpur’ , ‘EEE’),
(162002003, ‘Maruf’, ‘Hasan’, ‘Barisal’, ‘EEE’),
(172082002, ‘Ashek’ , ‘Farabi’, ‘Gazipur’ ,‘TEX’),
(173002003, ‘Ismile’ , ‘Hasan’ , ‘Barisal’ , ‘TEX’);
```

- Create a table department:

```sql
CREATE TABLE department(
dept_id int(11) NOT NULLAUTO_INCREMENT,
dept_name enum( ‘CSE’, ‘EEE’, ‘TEX’) DEFAULT NULL,
dept_location varchar(255 ) NOT NULL,
PRIMARY KEY(dept_id)
);
```

- Insert values into department table:

```sql
INSERT INTO department (dept_id, dept_name, dept_location)
VALUES(101, ‘CSE’, ‘Building-2’),
(102, ‘EEE’, ‘Building-2’),
(103, ‘TEX’, ‘Building-1’);
```

- Create another table course_registrstion:

```sql
CREATE TABLE course_registration(
reg_serial int(11) NOT NULL AUTO_INCREMENT,
course_code varchar(255) NOT NULL,
course_title varchar(255 ) NOT NULL,
dept_id int(11 ) NOT NULL,
s_id varchar(255 ) NOT NULL,
PRIMARY KEY(reg_serial)
);
```

- Insert values into course_registration table:

<!-- Original PDF page 57; printed lab page 51 -->

```sql
INSERT INTO course_registration(course_code,course_title,dept_id,s_id)
VALUES(‘CSE 311’, ‘Computer Networks’,101,142002015),
(‘CSE 311’, ‘Computer Networks’,101,142002001),
(‘EEE 301’,‘Electrical Circuit’,201,162002002),
(‘TEX 201’, ‘Aparales’, 301,172002002),
(‘CSE 312’, ‘Computer Networks Lab’,101,142002015),
(‘CSE 207’, ‘Algorithm’,101,142002001);
```

- join_table:

```sql
SELECT s_id
FROM student
UNION
SELECT s_id
FROM course_registration;
```

- join_table:

```sql
SELECT s_id
FROM student
UNION ALL
SELECT s_id
FROM course_registration;
```

2. Join, Inner Join, Left Join, Right Join, Where, Group by:

- INNER JOIN example

```sql
SELECT student.s_id, student.FirstName, student.LastName
FROM student
INNER JOIN course_registration ON student.s_id = course_registration.s_id;
```

- INNER JOIN with WHERE clause

```sql
SELECT student.s_id, student.FirstName, student.LastName
FROM student
INNER JOIN course_registration ON student.s_id = course_registration.s_id
WHERE course_registration.s_id = 142002015;
```

- Multiple Inner Join

```sql
SELECT
student.s_id,
student.FirstName,
student.dept_name,
depart-
ment.dept_id, course_registration.course_code
FROM student
INNER JOIN department ON student.dept_name = department.dept_name
INNER
JOIN
course_registration
ON
department.dept_id
=
course_registration.dept_id;
```

- INNER JOIN using GROUP BY for eliminating duplicate records.

<!-- Original PDF page 58; printed lab page 52 -->

```sql
SELECT
student.s_id,
student.FirstName,
student.dept_name,
depart-
ment.dept_id, course_registration.course_code
FROM student
INNER JOIN department ON student.dept_name = department.dept_name
INNER
JOIN
course_registration
ON
department.dept_id
=
course_registration.dept_id
GROUP BY s_id;
```


### Instructor-added live example — LEFT/RIGHT JOIN, counts, and unmatched records

> **ADDED TEACHING EXAMPLE — not text from the PDF.** Copy the **entire** code block into the phpMyAdmin SQL tab and click **Go**. This demonstration sets up its own practice objects, so it does not need any previous lab. Re-running it resets only the indicated `demo_*` tables.

```sql
CREATE DATABASE IF NOT EXISTS cse210_examples_lab07;
USE cse210_examples_lab07;
DROP TABLE IF EXISTS demo_join_orders;
DROP TABLE IF EXISTS demo_join_customers;
CREATE TABLE demo_join_customers (id INT PRIMARY KEY, name VARCHAR(30));
CREATE TABLE demo_join_orders (id INT PRIMARY KEY, customer_id INT, amount INT,
 FOREIGN KEY(customer_id) REFERENCES demo_join_customers(id));
INSERT INTO demo_join_customers VALUES (1,'Asha'),(2,'Rafi'),(3,'Mitu');
INSERT INTO demo_join_orders VALUES (10,1,500),(11,1,600),(12,2,700);
SELECT c.name,COUNT(o.id) AS order_count FROM demo_join_customers c LEFT JOIN demo_join_orders o ON c.id=o.customer_id GROUP BY c.id,c.name ORDER BY c.id;
SELECT o.id,c.name FROM demo_join_orders o RIGHT JOIN demo_join_customers c ON o.customer_id=c.id ORDER BY c.id,o.id;
```

**Expected output / explanation:** Counts: Asha=2, Rafi=1, Mitu=0.

## 7.4 Discussion & Conclusion

In the following experiment we dig into the various join types, explore Database joins involving more than one table, and further explain join conditions, especially what can be done with non-equijoin conditions.

## 7.5 Lab Task (Please implement yourself and show the output to the instructor)

- Task-1:

![Diagram / screenshot from the source PDF, PDF page 58](../assets/source-figures/page-58-image-01.png)

*Figure VII.2: Project Table Information*

![Diagram / screenshot from the source PDF, PDF page 58](../assets/source-figures/page-58-image-02.png)

*Figure VII.3: Project Table Information*

![Diagram / screenshot from the source PDF, PDF page 58](../assets/source-figures/page-58-image-03.png)

*Figure VII.4: Client Table Information*

1. Create these tables in a company database

2. Write a SQL query for all the JOIN operation

<!-- Original PDF page 59; printed lab page 53 -->

3. Location count

- Task 2:

![Diagram / screenshot from the source PDF, PDF page 59](../assets/source-figures/page-59-image-01.png)

*Figure VII.5: Customer and Salesman table*

## 7.6 Lab Exercise (Submit as a report)

![Diagram / screenshot from the source PDF, PDF page 59](../assets/source-figures/page-59-image-02.png)

*Figure VII.6: Customer and Salesman table*

1. Write a SQL statement to find the details of a order i.e. order number, order date, amount of order, which customer gives the order and which salesman works for that customer and commission rate he gets for an order.

![Diagram / screenshot from the source PDF, PDF page 59](../assets/source-figures/page-59-image-03.png)

*Figure VII.7: Customer and Salesman table*

2. Write a SQL statement to make a list in ascending order for the customer who works either through a salesman or by own.

3. Attach with query codes and with output screenshots in the report.

<!-- Original PDF page 60; printed lab page 54 -->

### Academic Integrity Policy

Copying from the internet, classmates, seniors, or any other unauthorized source is strictly prohibited. Full marks may be deducted if plagiarism, copied work, or academic dishonesty is detected.

Students must complete the lab task, implementation, output analysis, and lab report independently and submit authentic work for evaluation.


## Instructor-added full-lab live script — complete copy-paste session

> **ADDED teaching material, not original PDF text.** This complete program initializes **its own lab database** and demonstrates the chapter from start to finish. **WARNING:** It begins by dropping and re-creating the database `cse210_lab07`; save your work before executing.

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

**Tip:** For individual concepts without affecting the full-lab demonstration, use the small independent examples inserted above. These all use `cse210_examples_lab07` instead.

