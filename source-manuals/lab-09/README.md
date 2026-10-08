# Lab 09 — Implementation of Database Transactions and Multiuser Usage

**Source-faithful Markdown transcription:** Original PDF pages 68–72.  
**For live SQL:** [Runnable lab guide](../../labs/lab-09/README.md) · [Original complete PDF transcription](../../COMPLETE_SOURCE_MANUAL.md)

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

![Diagram / screenshot from the source PDF, PDF page 69](../../assets/source-figures/page-69-image-01.png)

*Figure IX.1: Data items in the penalties table*

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

![Diagram / screenshot from the source PDF, PDF page 70](../../assets/source-figures/page-70-image-01.png)

*Figure IX.2: Data items in the penalties table after deletion*

### 9.4.6 Rollback

To undo the previous change and restore the deleted rows:

```sql
ROLLBACK WORK;
```

Repeating the SELECT statement will now return the entire PENALTIES table with all rows restored. N.B.: You must use InnoDB as the storage engine for transactions to work correctly.

### 9.4.7 Commit

To make a change permanent, use:

```sql
COMMIT WORK;
```

This statement permanently applies all changes since the last commit. The keyword WORK is optional and does not affect processing.

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

### 9.4.9 Unlock

The syntax for unlocking a table or tables is:

```sql
UNLOCK TABLES;
```

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
