# Lab 01 — Introduction to Database, MySQL, and Managing MySQL Databases

*CSE 210 Database System Lab · Source: `CSE_210_Database_System_Lab.md` (PDF pages 7–14, printed pages 1–8)*

---

## 1. Objective(s)

- To install MySQL Database Server.
- To introduce Data Types used in Database System.
- To Create Database and Table using SQL commands.
- To Insert Data in Table.
- To Drop Database and Table.

---

## 2. Complete Example — copy, paste, run

This single script creates a database, creates a table, inserts rows, browses them, and describes the structure. Run it top-to-bottom in the phpMyAdmin SQL editor (http://localhost/phpmyadmin/ → SQL).

```sql
-- ============================================================
-- Lab 01 : Complete demo (Database + Table + Data + Queries)
-- ============================================================
DROP DATABASE IF EXISTS cse210_lab01;
CREATE DATABASE cse210_lab01;
USE cse210_lab01;

-- Create a table named Student (4 attributes in the manual's first example)
CREATE TABLE Student (
    StudentID VARCHAR(9),
    Name      VARCHAR(20),
    Address   VARCHAR(50),
    Contact   VARCHAR(11)
);

-- Describe the structure of the table
DESCRIBE Student;

-- Insert data (one row at a time)
INSERT INTO Student (StudentID, Name, Address, Contact)
VALUES ('1001', 'Das', '704, Shamim Shoroni, West Shewrapara', '01711111111');

INSERT INTO Student (StudentID, Name, Address, Contact)
VALUES ('1002', 'Hasan', '102, Shapla Shoroni, West Shewrapara', '01822222222');

-- Browse all records
SELECT * FROM Student;

-- ------------------------------------------------------------
-- Second version of the same table with different data types
-- ------------------------------------------------------------
DROP TABLE Student;

CREATE TABLE Student (
    StudentID INT,
    LastName  VARCHAR(20),
    FirstName VARCHAR(20),
    Address   VARCHAR(50),
    City      VARCHAR(20)
);

-- Insert multiple rows in one statement
INSERT INTO Student (StudentID, LastName, FirstName, Address, City) VALUES
(1001, 'Das',   'Utsha',      '704, Shamim Shoroni, West Shewrapara', 'Dhaka'),
(1002, 'Hasan', 'Md. Mehedi', '102, Shapla Shoroni, West Shewrapara', 'Dhaka'),
(1003, 'Rahman','Tanvir',     'House-12, Road-5, Dhanmondi',          'Dhaka'),
(1004, 'Islam', 'Nadia',      'Plot-7, Agrabad',                     'Chattogram'),
(1005, 'Hossain','Sabbir',    'Vill-Netrokona, P.O. Sadar',          'Mymensingh');

DESCRIBE Student;
SELECT * FROM Student;
```

**Expected output (SELECT \* FROM Student)**

| StudentID | LastName | FirstName | Address | City |
| --- | --- | --- | --- | --- |
| 1001 | Das | Utsha | 704, Shamim Shoroni, West Shewrapara | Dhaka |
| 1002 | Hasan | Md. Mehedi | 102, Shapla Shoroni, West Shewrapara | Dhaka |
| 1003 | Rahman | Tanvir | House-12, Road-5, Dhanmondi | Dhaka |
| 1004 | Islam | Nadia | Plot-7, Agrabad | Chattogram |
| 1005 | Hossain | Sabbir | Vill-Netrokona, P.O. Sadar | Mymensingh |

**Optional cleanup — deletes the demo database (run only when you are finished):**

```sql
DROP TABLE Student;
DROP DATABASE cse210_lab01;
```

---

## 3. Quick Reference — Concepts taught in this lab

### 3.1 Concepts and one-line SQL

| # | Concept | Copy-paste SQL |
| --- | --- | --- |
| 1 | Create database | `CREATE DATABASE lab2;` |
| 2 | Select / use database | `USE lab2;` |
| 3 | Create table | `CREATE TABLE Student(StudentID INT, LastName VARCHAR(20), FirstName VARCHAR(20), Address VARCHAR(50), City VARCHAR(20));` |
| 4 | Describe table structure | `DESCRIBE student;` |
| 5 | Insert one row | `INSERT INTO student (StudentID, LastName, FirstName, Address, City) VALUES (1001, 'Das', 'Utsha', '704, Shamim Shoroni, West Shewrapara', 'Dhaka');` |
| 6 | Insert many rows at once | `INSERT INTO student (StudentID, LastName, FirstName, Address, City) VALUES (1001,'Das','Utsha','Dhaka-1','Dhaka'), (1002,'Hasan','Mehedi','Dhaka-2','Dhaka');` |
| 7 | Browse all records | `SELECT * FROM student;` |
| 8 | Drop a table | `DROP TABLE student;` |
| 9 | Drop a database | `DROP DATABASE lab2;` |

### 3.2 MySQL basic data types — Table I.1

| Data Type | Description |
| --- | --- |
| CHAR(size) | Holds a fixed length string (letters, numbers, special characters). Fixed size specified in parenthesis. Can store up to 255 characters. |
| VARCHAR(size) | Holds a variable length string. Maximum size specified in parenthesis. Can store up to 255 characters. Values greater than 255 are converted to TEXT type. |
| TINYTEXT | Holds a string with a maximum length of 255 characters. |
| TEXT | Holds a string with a maximum length of 65,535 characters. |
| TINYINT(size) | -128 to 127 normal. 0 to 255 UNSIGNED*. Maximum digits may be specified in parenthesis. |
| SMALLINT(size) | -32768 to 32767 normal. 0 to 65535 UNSIGNED*. Maximum digits may be specified in parenthesis. |
| MEDIUMINT(size) | -8388608 to 8388607 normal. 0 to 16777215 UNSIGNED*. Maximum digits may be specified in parenthesis. |
| INT(size) | -2147483648 to 2147483647 normal. 0 to 4294967295 UNSIGNED*. Maximum digits may be specified in parenthesis. |
| BIGINT(size) | -9223372036854775808 to 9223372036854775807 normal. 0 to 18446744073709551615 UNSIGNED*. |
| FLOAT(size,d) | A small number with a floating decimal point. Size specifies max digits; d specifies digits to the right of decimal point. |
| DOUBLE(size,d) | A large number with a floating decimal point. Size specifies max digits; d specifies digits to the right of decimal point. |
| DECIMAL(size,d) | A DOUBLE stored as a string, allowing a fixed decimal point. Size specifies max digits; d specifies digits to the right of decimal point. |
| DATE() | A date. Format: YYYY-MM-DD. Range: '1000-01-01' to '9999-12-31'. |
| DATETIME() | A date and time combination. Format: YYYY-MM-DD HH:MI:SS. Range: '1000-01-01 00:00:00' to '9999-12-31 23:59:59'. |
| TIMESTAMP() | Stored as seconds since Unix epoch ('1970-01-01 00:00:00' UTC). Format: YYYY-MM-DD HH:MI:SS. Range: '1970-01-01 00:00:01' to '2038-01-09 03:14:07' UTC. |
| TIME() | A time. Format: HH:MI:SS. Range: '-838:59:59' to '838:59:59'. |
| YEAR() | A year in two or four digit format. Four-digit: 1901 to 2155. Two-digit: 70 to 69 (representing 1970 to 2069). |

---

## 4. Problem Analysis

Database is a key course of computer science. At the beginner level, most of the students are not familiar with how to use database in computer system. This section helps you get started with a very common database system named MySQL. We will start by installing MySQL and creating a database in the MySQL server for practicing.

![Figure I.1: Logo of MySQL](../images/figure_I_1.png)

*Figure I.1: Logo of MySQL*

After installation of proper tools, users have to create databases in the system and use them according to demand. We will create databases and tables using both the phpMyAdmin panel and SQL commands. We will also insert data into the tables and finally drop the tables and the database. The workflow of the overall lab is described in Figure I.2.

![Figure I.2: Workflow Diagram of the Lab](../images/figure_I_2.png)

*Figure I.2: Workflow Diagram of the Lab*

---

## 5. Procedure

If you want to install MySQL on Windows environment, using MySQL installer is the easiest way. MySQL installer provides you with an easy-to-use wizard that helps you to install MySQL with the following components:

- MySQL Server
- All Available Connectors
- MySQL Workbench with Sample Data Models
- MySQL Notifier
- Tools for Excel and Microsoft Visual Studio
- MySQL Sample Databases

To download MySQL installer, use the following link:

https://www.apachefriends.org/download.html

Required tools are available for all operating systems in the above link.

After installation of the downloaded XAMPP, you have to run the XAMPP control panel system. It will look like Figure I.3. To start the service, press the Start button of the Apache and MySQL module. Now, the system is ready to work with.

### 5.1 Practicing With XAMPP

To start the practice session, press the Admin button of the MySQL module or use the following link in your web browser: http://localhost/phpmyadmin/

You will get a web page like Figure I.4 in your tab.

![Figure I.3: XAMPP Control Panel](../images/figure_I_3.png)

*Figure I.3: XAMPP Control Panel*

To create a database from the phpMyAdmin panel, select the New option (uppermost option in the left side of the web page). Input a name in the Database name field and press the Create button. After that, to input data in your required structure, create a table with a table name and the required number of columns. For this, open the SQL option and write the necessary syntax. An editor space will appear like Figure I.5 where you can write required SQL commands.

---

## 6. Implementations

### 6.1 Database Creation

To create a database using SQL command, write: `CREATE DATABASE [Database_Name]`. For example, to create a database named lab2:

```sql
CREATE DATABASE lab2;
```

A database named "lab2" is created in your local-host.

### 6.2 Database Use

To use the lab2 database, write the following command in the SQL editor:

```sql
USE lab2;
```

### 6.3 Table Creation

To create a table using SQL command from the phpMyAdmin panel, open the SQL option and write the necessary command.

![Figure I.4: Session in Localhost](../images/figure_I_4.png)

*Figure I.4: Session in Localhost*

![Figure I.5: Space for Editing SQL Commands](../images/figure_I_5.png)

*Figure I.5: Space for Editing SQL Commands*

For example, to create a table named Student with 4 attributes (StudentID, Name, Address, Contact):

```sql
CREATE TABLE Student (
    StudentID VARCHAR(9),
    Name      VARCHAR(20),
    Address   VARCHAR(50),
    Contact   VARCHAR(11)
);
```

The created table will look like Figure I.6. You can also create a table with different attribute types. For example, to create a table named Student in lab2 with attributes StudentID (int), LastName (varchar), FirstName (varchar), Address (varchar), City (varchar):

```sql
CREATE TABLE Student (
    StudentID INT,
    LastName  VARCHAR(20),
    FirstName VARCHAR(20),
    Address   VARCHAR(50),
    City      VARCHAR(20)
);
```

![Figure I.6: Created Table named Student](../images/figure_I_6.png)

*Figure I.6: Created Table named Student*

### 6.4 Table Description

To describe the structure of a table, use: `DESCRIBE [Table_Name]`. For example, to describe the Student table:

```sql
DESCRIBE student;
```

The result will appear like Figure I.7 on the browser tab.

![Figure I.7: Description of Student Table](../images/figure_I_7.png)

*Figure I.7: Description of Student Table*

### 6.5 Data Insertion

To insert data into a table, write the proper SQL INSERT command in the SQL editor. For example, to insert student details into the Student table:

```sql
INSERT INTO student (StudentID, LastName, FirstName, Address, City)
VALUES (1001, 'Das', 'Utsha', '704, Shamim Shoroni, West Shewrapara', 'Dhaka');
```

Another record can be inserted as:

```sql
INSERT INTO student (StudentID, LastName, FirstName, Address, City)
VALUES (1002, 'Hasan', 'Md. Mehedi', '102, Shapla Shoroni, West Shewrapara', 'Dhaka');
```

In this way, many student records can be inserted into the Student table.

### 6.6 Data Browse

To browse and view all records in the Student table:

```sql
SELECT * FROM student;
```

A table will appear on the tab like Figure I.8.

![Figure I.8: Browsing Result of Student Table](../images/figure_I_8.png)

*Figure I.8: Browsing Result of Student Table*

### 6.7 Dropping Table and Database

To drop a table, use the command: `DROP TABLE [Table_Name]`. For example, to drop the Student table:

```sql
DROP TABLE student;
```

The Student table will be removed from the lab2 database.

To drop the lab2 database itself:

```sql
DROP DATABASE lab2;
```

---

## 7. Input/Output Summary

All the SQL commands covered in this lab follow a standard input/output pattern. The user writes commands in the SQL editor space, and the results are displayed in the browser. The key commands are summarized as: CREATE DATABASE, USE, CREATE TABLE, DESCRIBE, INSERT INTO, SELECT, DROP TABLE, and DROP DATABASE.

| Command | Purpose |
| --- | --- |
| CREATE DATABASE | Create a new database |
| USE | Select the database to work in |
| CREATE TABLE | Create a table with columns and data types |
| DESCRIBE | Show the structure of a table |
| INSERT INTO | Insert rows into a table |
| SELECT | Retrieve/browse rows |
| DROP TABLE | Delete a table |
| DROP DATABASE | Delete a whole database |

---

## 8. Discussion & Conclusion

In this lab, we have installed MySQL via XAMPP, created databases and tables both through the phpMyAdmin panel and using SQL commands. We used varchar and int as data types for attributes — numbers indicate the length of each attribute. Besides these, there are many types of data types available in MySQL, listed in **Table I.1 (Quick Reference, section 3.2)**. We have also inserted data into tables, browsed the table contents, and dropped both tables and databases. That means we have achieved all the lab objectives.

---

## 9. Lab Task (Please implement yourself and show the output to the instructor)

1. Create a database named "University".
2. Create a Table named "Teacher" with attributes named TeacherID, Name, Designation, Address, and Email.
3. Create a Table named "Student" with attributes named StudentID, Name, Address, and Phone.
4. Create a Table named "Staff" with attributes named StaffID, Name, Position, Address, and Phone.
5. Insert at least five entities in each table.
6. Drop each table of the database.

### 9.1 Problem Analysis

1. You have to create a database named "University" with the help of the create option provided in the phpMyAdmin panel or using SQL command.
2. You have to create a table named "Teacher" with attributes named TeacherID, Name, Designation, Address, and Email. You must use proper data type and size.
3. You have to create a table named "Student" with attributes named StudentID, Name, Address, and Phone. You must use proper data type and size.
4. You have to create a table named "Staff" with attributes named StaffID, Name, Position, Address, and Phone. You must use proper data type and size.
5. You have to insert at least five tuples in each of the Student, Teacher, and Staff tables.
6. You have to drop all the tables from the database.

---

## 10. Lab Exercise (Submit as a report)

- Create a Database with five or six tables.
- Use all the basic data types described in Table I.1.
- Insert five to ten tuples in each table.
- Browse each table and take a snapshot.

---

## Academic Integrity Policy

Copying from the internet, classmates, seniors, or any other unauthorized source is strictly prohibited. Full marks may be deducted if plagiarism, copied work, or academic dishonesty is detected.

Students must complete the lab task, implementation, output analysis, and lab report independently and submit authentic work for evaluation.
