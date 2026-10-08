# Lab 09 — Implementation of Database Transactions and Multiuser Usage

*CSE 210 Database System Lab · Source: `CSE_210_Database_System_Lab.md` (PDF pages 68–72, printed pages 62–66)*

---

## 1. Objective(s)

- To Implement Commit.
- To Implement Rollback.
- To Lock and Unlock a Table.

---

## 2. Complete Example — copy, paste, run

Run the statements in order and watch the row count change: **6 → 4 → 6**, then a committed change that ends with **6 rows (row 6 removed, row 7 added)**.

```sql
-- ============================================================
-- Lab 09 : Complete demo (COMMIT / ROLLBACK / LOCK TABLES)
-- ============================================================
DROP DATABASE IF EXISTS cse210_lab09;
CREATE DATABASE cse210_lab09;
USE cse210_lab09;

-- 1) Table must use a transaction-capable storage engine (InnoDB)
CREATE TABLE penalties (
    PAYMENTNO   INT NOT NULL,
    PLAYERNO    INT NOT NULL,
    PAYMENTDATE DATE NOT NULL,
    AMOUNT      DOUBLE NOT NULL,
    PRIMARY KEY (PAYMENTNO)
) ENGINE = InnoDB;

INSERT INTO penalties (PAYMENTNO, PLAYERNO, PAYMENTDATE, AMOUNT) VALUES
(1, 10,  '2021-08-02', 40.5),
(2, 13,  '2021-08-03', 500),
(3, 75,  '2021-08-04', 200),
(4, 90,  '2021-08-04', 102.5),
(5, 10,  '2021-08-06', 56.05),
(6, 100, '2021-08-07', 100);

SELECT COUNT(*) AS row_count FROM penalties;    -- 6

-- 2) Turn auto-commit OFF: now we must end each transaction ourselves
SET @@AUTOCOMMIT = 0;

-- 3) Delete both payments of player 10  ->  4 rows remain
DELETE FROM penalties WHERE PLAYERNO = 10;
SELECT COUNT(*) AS row_count FROM penalties;    -- 4 (not yet permanent)

-- 4) Undo that change  ->  all 6 rows are back
ROLLBACK WORK;
SELECT COUNT(*) AS row_count FROM penalties;    -- 6

-- 5) Update a row, then undo the update as well
UPDATE penalties SET AMOUNT = 9999 WHERE PAYMENTNO = 1;
SELECT * FROM penalties;                        -- row 1 shows 9999
ROLLBACK WORK;
SELECT * FROM penalties;                        -- row 1 shows 40.5 again

-- 6) Insert + delete, then make it PERMANENT
INSERT INTO penalties (PAYMENTNO, PLAYERNO, PAYMENTDATE, AMOUNT)
VALUES (7, 55, '2021-08-08', 75.25);
DELETE FROM penalties WHERE PAYMENTNO = 6;
COMMIT WORK;
SELECT * FROM penalties;                        -- row 7 kept, row 6 gone forever

-- 7) Back to the default behaviour (each statement commits on its own)
SET @@AUTOCOMMIT = 1;

-- 8) Locking -------------------------------------------------------------
SHOW TABLE STATUS LIKE 'penalties';             -- Engine should be InnoDB

LOCK TABLE penalties READ;
-- other sessions may still READ the table, but writing is blocked:
-- UPDATE penalties SET AMOUNT = 1 WHERE PAYMENTNO = 1;   <-- try it, it is blocked
SELECT * FROM penalties;
UNLOCK TABLES;

LOCK TABLE penalties WRITE;                     -- exclusive: only this session may use it
UNLOCK TABLES;

SELECT * FROM penalties ORDER BY PAYMENTNO;

-- Optional cleanup
-- DROP DATABASE cse210_lab09;
```

**Step-by-step expected output**

| Step | Command | `COUNT(*)` / effect |
| --- | --- | --- |
| 1 | after INSERT | 6 rows |
| 3 | `DELETE … PLAYERNO = 10` (auto-commit off) | 4 rows (temporary) |
| 4 | `ROLLBACK WORK` | 6 rows restored |
| 5 | `UPDATE …` then `ROLLBACK WORK` | change undone |
| 6 | INSERT #7 + DELETE #6 + `COMMIT WORK` | 6 rows: #1–#5, #7 |
| 8 | `LOCK TABLE … READ` / `UNLOCK TABLES` | other sessions can read, not write |

---

## 3. Quick Reference — Concepts taught in this lab

### 3.1 Concepts and one-line SQL

| # | Concept | Copy-paste SQL |
| --- | --- | --- |
| 1 | Turn auto-commit OFF (start manual transactions) | `SET @@AUTOCOMMIT = 0;` |
| 2 | Turn auto-commit back ON | `SET @@AUTOCOMMIT = 1;` |
| 3 | Delete rows inside a transaction | `DELETE FROM penalties WHERE PLAYERNO = 10;` |
| 4 | ROLLBACK — undo everything since the last commit | `ROLLBACK WORK;` |
| 5 | COMMIT — make everything permanent | `COMMIT WORK;` |
| 6 | Lock a table for reading | `LOCK TABLE penalties READ;` |
| 7 | Lock a table for writing (exclusive) | `LOCK TABLE penalties WRITE;` |
| 8 | Other lock modes | `LOCK TABLE penalties READ LOCAL;` / `LOCK TABLE penalties LOW_PRIORITY WRITE;` |
| 9 | Release all locks | `UNLOCK TABLES;` |
| 10 | Check the storage engine of a table | `SHOW CREATE TABLE penalties;` or `SHOW TABLE STATUS LIKE 'penalties';` |

### 3.2 The transaction pattern (teach this order)

```sql
SET @@AUTOCOMMIT = 0;      -- 1. take control
DELETE FROM penalties WHERE PLAYERNO = 10;   -- 2. do the work
SELECT * FROM penalties;    -- 3. check the (temporary) result
ROLLBACK WORK;              -- 4a. not happy -> undo everything
COMMIT WORK;                -- 4b. happy -> keep everything forever
SET @@AUTOCOMMIT = 1;       -- 5. give control back to MySQL
```

### 3.3 Storage engines

| Engine | Supports transactions? |
| --- | --- |
| InnoDB | Yes (used throughout this lab) |
| BDB | Yes |
| MyISAM | No |
| MEMORY | No |

---

## 4. Problem Analysis

So far in this lab, we have assumed that you are the only user of the database. If you do the examples and exercises at home, that assumption is probably correct. But if you work with MySQL in a company setting, the odds are good that you share the database with many other users. We call this multi-user usage, as opposed to single-user usage. In a multi-user environment, you should not need to be aware that other users are accessing the database concurrently, because MySQL hides this from you as much as possible. The following question might arise: What happens if I access a row that is already in use by someone else? This section answers that question. We start with a concept that forms the basis of multi-user usage: the transaction (also called unit of work). We also discuss the concepts savepoint, lock, deadlock, and isolation level, and we consider the LOCK TABLE statement. Not all storage engines support transactions; for example, InnoDB and BDB do, but MyISAM and MEMORY do not. Therefore, this lab assumes that you created the tables with one of the storage engines that does support transactions.

---

## 5. Procedure

First, we open our database system and prepare it to execute our given instructions. Then, we create a database and a table. After that we implement commit, rollback, and locking/unlocking of a table.

---

## 6. Implementations

### 6.1 Database Creation

To create a database, write the command `CREATE DATABASE [Database_Name]`. For example, to create a database named lab9:

```sql
-- IF NOT EXISTS: the same database name is also used in Lab 08
CREATE DATABASE IF NOT EXISTS lab9;
```

A database named lab9 is created in your local host.

### 6.2 Database Use

To use the lab9 database, write the following command in the SQL editor:

```sql
USE lab9;
```

### 6.3 Creating a Table

To create a table named penalties in database lab9, with attributes paymentno (int), playerno (int), paymentdate (date), and amount (double), where paymentno is the Primary Key:

```sql
CREATE TABLE `lab9`.`penalties` (
    `PAYMENTNO`   INT NOT NULL,
    `PLAYERNO`    INT NOT NULL,
    `PAYMENTDATE` DATE NOT NULL,
    `AMOUNT`      DOUBLE NOT NULL,
    PRIMARY KEY (`PAYMENTNO`)
) ENGINE = InnoDB;
```

Then, insert data into the penalties table. A sample populated table is shown in Figure IX.1.

```sql
INSERT INTO `penalties` (`PAYMENTNO`, `PLAYERNO`, `PAYMENTDATE`, `AMOUNT`) VALUES
(1, 10,  '2021-08-02', 40.5),
(2, 13,  '2021-08-03', 500),
(3, 75,  '2021-08-04', 200),
(4, 90,  '2021-08-04', 102.5),
(5, 10,  '2021-08-06', 56.05),
(6, 100, '2021-08-07', 100);
```

![Figure IX.1: Data items in the penalties table](../images/figure_IX_1.png)

*Figure IX.1: Data items in the penalties table*

### 6.4 Turning Off Auto-Commit

When a session is started in MySQL, the AUTOCOMMIT system variable is normally turned on. The following statement turns it off:

```sql
SET @@AUTOCOMMIT = 0;
```

When auto-commit must be turned on again, issue:

```sql
SET @@AUTOCOMMIT = 1;
```

After auto-commit has been turned off, a transaction can consist of multiple SQL statements, and you must explicitly indicate the end of each transaction.

### 6.5 Deleting from the penalties Table

To delete rows where PLAYERNO = 10:

```sql
DELETE FROM `penalties` WHERE PLAYERNO = 10;
```

The effect becomes apparent when you issue the following SELECT statement:

```sql
SELECT * FROM `penalties`;
```

The result is shown in Figure IX.2. Two rows have been deleted from the table. However, the change is not yet permanent because auto-commit has been turned off. The user or application now has a choice: the change can be undone with ROLLBACK, or made permanent with COMMIT.

![Figure IX.2: Data items in the penalties table after deletion](../images/figure_IX_2.png)

*Figure IX.2: Data items in the penalties table after deletion*

### 6.6 Rollback

To undo the previous change and restore the deleted rows:

```sql
ROLLBACK WORK;
```

Repeating the SELECT statement will now return the entire PENALTIES table with all rows restored. N.B.: You must use InnoDB as the storage engine for transactions to work correctly.

### 6.7 Commit

To make a change permanent, use:

```sql
COMMIT WORK;
```

This statement permanently applies all changes since the last commit. The keyword WORK is optional and does not affect processing.

### 6.8 Locking

A number of mechanisms exist to keep concurrency high while still preventing conflicts. This section discusses the locking mechanism in MySQL. The syntax is:

```sql
LOCK TABLE table_name <lock_type>;
```

For example, to lock the penalties table in READ mode:

```sql
LOCK TABLE penalties READ;
```

Besides READ, MySQL supports READ LOCAL, WRITE, and LOW_PRIORITY WRITE.

### 6.9 Unlock

The syntax for unlocking a table or tables is:

```sql
UNLOCK TABLES;
```

---

## 7. Discussion & Conclusion

You may find it difficult to set InnoDB as your storage engine. To solve this, select the table in phpMyAdmin, go to the Operations tab, find the Storage Engine option, and select InnoDB. You can also use any other storage engine that supports transactions.

---

## 8. Lab Task (Please implement yourself and show the output to the instructor)

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

### 8.1 Problem Analysis

Students are instructed to perform the above operations sequentially on a specific table, observing how ROLLBACK and COMMIT affect the state of data at each step.

---

## 9. Lab Exercise (Case Study)

- Find out which other storage engines support transactions and multi-user systems.
- Implement a transaction using one of them and compare its behaviour with InnoDB.

---

## 10. References

- https://dev.mysql.com/doc/refman/8.0/en/lock-tables.html
- https://ebookreading.net/view/book/EB9780131497351_49.html

---

## Academic Integrity Policy

Copying from the internet, classmates, seniors, or any other unauthorized source is strictly prohibited. Full marks may be deducted if plagiarism, copied work, or academic dishonesty is detected.

Students must complete the lab task, implementation, output analysis, and lab report independently and submit authentic work for evaluation.
