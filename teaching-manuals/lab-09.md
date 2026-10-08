
<a id="lab-09"></a>

# Lab 09 — Implementation of Database Transactions and Multiuser Usage

> **ORIGINAL PDF TRANSCRIPTION BELOW:** The source paragraphs, original tables, exercises, code fragments and image references retain their original teaching sequence. Text labeled **Instructor-added** is new, not from the PDF.

<!-- Original PDF page 68; printed lab page 62 -->

## 9.1 Objective(s)

- To Implement Commit.

- To Implement Rollback.

- To Lock and Unlock a Table.

## 9.2 Problem Analysis

So far in this lab, we have assumed that you are the only user of the database. If you do the examples and exercises at home, that assumption is probably correct. But if you work with MySQL in a company setting, the odds are good that you share the database with many other users. We call this multi-user usage, as opposed to single-user usage. In a multi-user environment, you should not need to be aware that other users are accessing the database concurrently, because MySQL hides this from you as much as possible. The following question might arise: What happens if I access a row that is already in use by someone else? This section answers that question. We start with a concept that forms the basis of multi-user usage: the transaction (also called unit of work). We also discuss the concepts savepoint, lock, deadlock, and isolation level, and we consider the LOCK TABLE statement. Not all storage engines support transactions; for example, InnoDB and BDB do, but MyISAM and MEMORY do not. Therefore, this lab assumes that you created the tables with one of the storage engines that does support transactions.

## 9.3 Procedure

First, we open our database system and prepare it to execute our given instructions. Then, we create a database and a table. After that we implement commit, rollback, and locking/unlocking of a table.

## 9.4 Implementations

### 9.4.1 Database Creation

To create a database, write the command CREATE DATABASE [Database_Name]. For example, to create a database named lab9:

```sql
CREATE DATABASE lab9;
```

A database named lab9 is created in your local host.

<!-- Original PDF page 69; printed lab page 63 -->

### 9.4.2 Database Use

To use the lab9 database, write the following command in the SQL editor:

```sql
USE lab9;
```

### 9.4.3 Creating a Table

To create a table named penalties in database lab9, with attributes paymentno (int), playerno (int), paymentdate (date), and amount (double), where paymentno is the Primary Key:

```sql
CREATE TABLE `lab9`.`penalties` (

`PAYMENTNO`
INT
NOT NULL,
`PLAYERNO`
INT
NOT NULL,
`PAYMENTDATE` DATE
NOT NULL,
`AMOUNT`
DOUBLE NOT NULL,
PRIMARY KEY (`PAYMENTNO`)
);
```

Then, insert data into the penalties table. A sample populated table is shown in Figure IX.1.

![Diagram / screenshot from the source PDF, PDF page 69](../assets/source-figures/page-69-image-01.png)

*Figure IX.1: Data items in the penalties table*


### Instructor-added live example — Create an InnoDB transactional table

> **ADDED TEACHING EXAMPLE — not text from the PDF.** Copy the **entire** code block into the phpMyAdmin SQL tab and click **Go**. This demonstration sets up its own practice objects, so it does not need any previous lab. Re-running it resets only the indicated `demo_*` tables.

```sql
CREATE DATABASE IF NOT EXISTS cse210_examples_lab09;
USE cse210_examples_lab09;
DROP TABLE IF EXISTS demo_penalties;
CREATE TABLE demo_penalties(payment_no INT PRIMARY KEY,amount INT NOT NULL) ENGINE=InnoDB;
INSERT INTO demo_penalties VALUES (1,100),(2,200),(3,300);
SHOW TABLE STATUS LIKE 'demo_penalties';
SELECT * FROM demo_penalties;
```

**Expected output / explanation:** Three records, InnoDB engine.

### 9.4.4 Turning Off Auto-Commit

When a session is started in MySQL, the AUTOCOMMIT system variable is normally turned on. The following statement turns it off:

```sql
SET @@AUTOCOMMIT = 0;
```

When auto-commit must be turned on again, issue:

```sql
SET @@AUTOCOMMIT = 1;
```

After auto-commit has been turned off, a transaction can consist of multiple SQL statements, and you must explicitly indicate the end of each transaction.

<!-- Original PDF page 70; printed lab page 64 -->


### Instructor-added live example — See transaction state

> **ADDED TEACHING EXAMPLE — not text from the PDF.** Copy the **entire** code block into the phpMyAdmin SQL tab and click **Go**. This demonstration sets up its own practice objects, so it does not need any previous lab. Re-running it resets only the indicated `demo_*` tables.

```sql
CREATE DATABASE IF NOT EXISTS cse210_examples_lab09;
USE cse210_examples_lab09;
DROP TABLE IF EXISTS demo_penalties;
CREATE TABLE demo_penalties(payment_no INT PRIMARY KEY,amount INT NOT NULL) ENGINE=InnoDB;
INSERT INTO demo_penalties VALUES (1,100),(2,200),(3,300);
SELECT @@autocommit AS autocommit_is_on;
START TRANSACTION;
SELECT COUNT(*) AS rows_in_transaction FROM demo_penalties;
COMMIT;
```

**Expected output / explanation:** The COMMIT closes the transaction. START TRANSACTION works regardless of initial autocommit.

### 9.4.5 Deleting from the penalties Table

To delete rows where PLAYERNO = 10:

```sql
DELETE FROM `penalties` WHERE PLAYERNO = 10;
```

The effect becomes apparent when you issue the following SELECT statement:

```sql
SELECT * FROM `penalties`;
```

The result is shown in Figure IX.2. Two rows have been deleted from the table. However, the change is not yet permanent because auto-commit has been turned off. The user or application now has a choice: the change can be undone with ROLLBACK, or made permanent with COMMIT.

![Diagram / screenshot from the source PDF, PDF page 70](../assets/source-figures/page-70-image-01.png)

*Figure IX.2: Data items in the penalties table after deletion*


### Instructor-added live example — DELETE inside a transaction

> **ADDED TEACHING EXAMPLE — not text from the PDF.** Copy the **entire** code block into the phpMyAdmin SQL tab and click **Go**. This demonstration sets up its own practice objects, so it does not need any previous lab. Re-running it resets only the indicated `demo_*` tables.

```sql
CREATE DATABASE IF NOT EXISTS cse210_examples_lab09;
USE cse210_examples_lab09;
DROP TABLE IF EXISTS demo_penalties;
CREATE TABLE demo_penalties(payment_no INT PRIMARY KEY,amount INT NOT NULL) ENGINE=InnoDB;
INSERT INTO demo_penalties VALUES (1,100),(2,200),(3,300);
START TRANSACTION;
DELETE FROM demo_penalties WHERE payment_no=1;
SELECT COUNT(*) AS count_during_transaction FROM demo_penalties;
ROLLBACK;
```

**Expected output / explanation:** Count during transaction is 2; ROLLBACK restores the third row.

### 9.4.6 Rollback

To undo the previous change and restore the deleted rows:

```sql
ROLLBACK WORK;
```

Repeating the SELECT statement will now return the entire PENALTIES table with all rows restored. N.B.: You must use InnoDB as the storage engine for transactions to work correctly.


### Instructor-added live example — ROLLBACK restores a prior value

> **ADDED TEACHING EXAMPLE — not text from the PDF.** Copy the **entire** code block into the phpMyAdmin SQL tab and click **Go**. This demonstration sets up its own practice objects, so it does not need any previous lab. Re-running it resets only the indicated `demo_*` tables.

```sql
CREATE DATABASE IF NOT EXISTS cse210_examples_lab09;
USE cse210_examples_lab09;
DROP TABLE IF EXISTS demo_penalties;
CREATE TABLE demo_penalties(payment_no INT PRIMARY KEY,amount INT NOT NULL) ENGINE=InnoDB;
INSERT INTO demo_penalties VALUES (1,100),(2,200),(3,300);
START TRANSACTION;
UPDATE demo_penalties SET amount=999 WHERE payment_no=2;
SELECT amount AS before_rollback FROM demo_penalties WHERE payment_no=2;
ROLLBACK;
SELECT amount AS after_rollback FROM demo_penalties WHERE payment_no=2;
```

**Expected output / explanation:** 999 becomes 200 again.

### 9.4.7 Commit

To make a change permanent, use:

```sql
COMMIT WORK;
```

This statement permanently applies all changes since the last commit. The keyword WORK is optional and does not affect processing.


### Instructor-added live example — COMMIT makes changes durable

> **ADDED TEACHING EXAMPLE — not text from the PDF.** Copy the **entire** code block into the phpMyAdmin SQL tab and click **Go**. This demonstration sets up its own practice objects, so it does not need any previous lab. Re-running it resets only the indicated `demo_*` tables.

```sql
CREATE DATABASE IF NOT EXISTS cse210_examples_lab09;
USE cse210_examples_lab09;
DROP TABLE IF EXISTS demo_penalties;
CREATE TABLE demo_penalties(payment_no INT PRIMARY KEY,amount INT NOT NULL) ENGINE=InnoDB;
INSERT INTO demo_penalties VALUES (1,100),(2,200),(3,300);
START TRANSACTION;
UPDATE demo_penalties SET amount=250 WHERE payment_no=2;
COMMIT;
ROLLBACK;
SELECT amount AS after_commit FROM demo_penalties WHERE payment_no=2;
```

**Expected output / explanation:** Amount remains 250 after the later ROLLBACK.

### 9.4.8 Locking

A number of mechanisms exist to keep concurrency high while still preventing conflicts. This section discusses the locking mechanism in MySQL. The syntax is:

```sql
LOCK TABLE table_name <lock_type>;
```

For example, to lock the penalties table in READ mode:

<!-- Original PDF page 71; printed lab page 65 -->

```sql
LOCK TABLE penalties READ;
```

Besides READ, MySQL supports READ LOCAL, WRITE, and LOW_PRIORITY WRITE.


### Instructor-added live example — READ lock (single session)

> **ADDED TEACHING EXAMPLE — not text from the PDF.** Copy the **entire** code block into the phpMyAdmin SQL tab and click **Go**. This demonstration sets up its own practice objects, so it does not need any previous lab. Re-running it resets only the indicated `demo_*` tables.

```sql
CREATE DATABASE IF NOT EXISTS cse210_examples_lab09;
USE cse210_examples_lab09;
DROP TABLE IF EXISTS demo_penalties;
CREATE TABLE demo_penalties(payment_no INT PRIMARY KEY,amount INT NOT NULL) ENGINE=InnoDB;
INSERT INTO demo_penalties VALUES (1,100),(2,200),(3,300);
LOCK TABLES demo_penalties READ;
SELECT COUNT(*) AS rows_while_locked FROM demo_penalties;
UNLOCK TABLES;
```

**Expected output / explanation:** The read succeeds under the lock; the lock is released.

### 9.4.9 Unlock

The syntax for unlocking a table or tables is:

```sql
UNLOCK TABLES;
```


### Instructor-added live example — Unlock tables (paired lock/unlock)

> **ADDED TEACHING EXAMPLE — not text from the PDF.** Copy the **entire** code block into the phpMyAdmin SQL tab and click **Go**. This demonstration sets up its own practice objects, so it does not need any previous lab. Re-running it resets only the indicated `demo_*` tables.

```sql
CREATE DATABASE IF NOT EXISTS cse210_examples_lab09;
USE cse210_examples_lab09;
DROP TABLE IF EXISTS demo_penalties;
CREATE TABLE demo_penalties(payment_no INT PRIMARY KEY,amount INT NOT NULL) ENGINE=InnoDB;
INSERT INTO demo_penalties VALUES (1,100),(2,200),(3,300);
LOCK TABLES demo_penalties READ;
SELECT * FROM demo_penalties;
UNLOCK TABLES;
```

**Expected output / explanation:** All rows are visible, and UNLOCK TABLES releases the lock.

## 9.5 Discussion & Conclusion

You may find it difficult to set InnoDB as your storage engine. To solve this, select the table in phpMyAdmin, go to the Operations tab, find the Storage Engine option, and select InnoDB. You can also use any other storage engine that supports transactions.

## 9.6 Lab Task (Please implement yourself and show the output to the instructor)

Perform the following operations sequentially on a table of your choice:

1. INSERT a new record.

2. DELETE an existing record.

3. ROLLBACK WORK — verify the deleted record is restored.

4. UPDATE a record.

5. ROLLBACK WORK — verify the update is undone.

6. INSERT another record.

7. DELETE a record.

8. COMMIT WORK — verify the changes are now permanent.

9. UPDATE a record after committing.

### 9.6.1 Problem Analysis

Students are instructed to perform the above operations sequentially on a specific table, observing how ROLLBACK and COMMIT affect the state of data at each step.

## 9.7 Lab Exercise (Case Study)

- Find out which other storage engines support transactions and multi-user systems.

- Implement a transaction using one of them and compare its behaviour with InnoDB.

<!-- Original PDF page 72; printed lab page 66 -->

## 9.8 References

- https://dev.mysql.com/doc/refman/8.0/en/lock-tables.html

- https://ebookreading.net/view/book/EB9780131497351_49.html

### Academic Integrity Policy

Copying from the internet, classmates, seniors, or any other unauthorized source is strictly prohibited. Full marks may be deducted if plagiarism, copied work, or academic dishonesty is detected.

Students must complete the lab task, implementation, output analysis, and lab report independently and submit authentic work for evaluation.


## Instructor-added full-lab live script — complete copy-paste session

> **ADDED teaching material, not original PDF text.** This complete program initializes **its own lab database** and demonstrates the chapter from start to finish. **WARNING:** It begins by dropping and re-creating the database `cse210_lab09`; save your work before executing.

```sql
-- CSE 210 | Lab 09 | Transactions, ROLLBACK, COMMIT and locks
DROP DATABASE IF EXISTS cse210_lab09;
CREATE DATABASE cse210_lab09 CHARACTER SET utf8mb4;
USE cse210_lab09;

-- InnoDB is needed to support transaction rollback.
CREATE TABLE penalties (
  payment_no INT PRIMARY KEY,
  player_no INT NOT NULL,
  payment_date DATE NOT NULL,
  amount DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;
INSERT INTO penalties VALUES
(1,10,'2026-01-10',100.00),
(2,20,'2026-01-11',200.00),
(3,10,'2026-01-12',150.00),
(4,30,'2026-01-13',120.00);
SELECT COUNT(*) AS before_count FROM penalties;

-- Transaction 1: DELETE and undo it.
START TRANSACTION;
DELETE FROM penalties WHERE player_no=10;
SELECT COUNT(*) AS count_during_delete FROM penalties; -- 2
ROLLBACK;
SELECT COUNT(*) AS count_after_rollback FROM penalties; -- 4

-- Transaction 2: UPDATE and undo it.
START TRANSACTION;
UPDATE penalties SET amount=999.00 WHERE payment_no=2;
SELECT payment_no,amount FROM penalties WHERE payment_no=2; -- 999
ROLLBACK;
SELECT payment_no,amount FROM penalties WHERE payment_no=2; -- 200

-- Transaction 3: INSERT and DELETE, then save changes with COMMIT.
START TRANSACTION;
INSERT INTO penalties VALUES (5,40,'2026-01-14',250.00);
DELETE FROM penalties WHERE payment_no=4;
COMMIT;
SELECT payment_no,player_no,amount FROM penalties ORDER BY payment_no;
-- Row IDs now: 1,2,3,5. The committed changes survive a later ROLLBACK.
ROLLBACK;
SELECT COUNT(*) AS committed_count FROM penalties; -- 4

-- Transaction 4: SAVEPOINT can undo only part of a transaction.
START TRANSACTION;
UPDATE penalties SET amount=350.00 WHERE payment_no=1;
SAVEPOINT after_first_update;
UPDATE penalties SET amount=900.00 WHERE payment_no=2;
ROLLBACK TO SAVEPOINT after_first_update;
COMMIT;
SELECT payment_no,amount FROM penalties WHERE payment_no IN (1,2) ORDER BY payment_no;

-- Table-level READ lock; no writes attempted while locked.
-- Run as ONE session (connection). LOCK TABLES causes implicit commit.
LOCK TABLES penalties READ;
SELECT COUNT(*) AS locked_read_count FROM penalties;
UNLOCK TABLES;
-- Use two simultaneous CLI sessions for the separate concurrency exercise.
```

**Tip:** For individual concepts without affecting the full-lab demonstration, use the small independent examples inserted above. These all use `cse210_examples_lab09` instead.

