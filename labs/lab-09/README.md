# Lab 09: Database Transactions and Multiuser Usage

[← Course home](../../README.md) · [Setup guide](../../SETUP.md) · [Download/copy standalone SQL](lab.sql)

> **Independent lab:** This lesson resets and creates **only** `cse210_lab09` and never requires any prior lab. Re-running it discards the old data in that database. Use a local learning server, **not production**.

**Course:** CSE 210 — Database System Lab  
**Estimated classroom time:** 60–90 minutes  
**Topic:** START TRANSACTION, ROLLBACK, COMMIT, SAVEPOINT, InnoDB, LOCK TABLES, UNLOCK TABLES  
**Original manual alignment:** Source Lab IX (pages 62–66); uses explicit transactions to avoid session-dependent autocommit behavior.

## 1. Learning objectives

1. Explain all-or-nothing transaction semantics.
2. Undo uncommitted INSERT, DELETE and UPDATE operations.
3. Make changes persistent with COMMIT.
4. Use SAVEPOINT and understand read locking basics.

## 2. What you need

- XAMPP with MySQL/MariaDB running **or** a compatible MySQL server (MySQL 8.0.16+ recommended for modern CHECK support).
- phpMyAdmin: <http://localhost/phpmyadmin/>; for Lab 10 use the MySQL command-line client.
- No database/table from another lab is needed. Ensure you have permission to create databases.

## 3. Short theory (explain before the code)

A transaction is a unit of work. `START TRANSACTION` starts a new unit, `ROLLBACK` discards uncommitted modifications, and `COMMIT` makes them permanent. `SAVEPOINT` marks a location to roll back to within an open transaction. **InnoDB** supports transactions. `LOCK TABLES` is a table-level concurrency mechanism and causes an implicit commit, so it is demonstrated *outside* the transaction blocks here. For real multiuser row locking, also study `SELECT ... FOR UPDATE` in two connections.

## 4. Instructor's walkthrough

1. Check the initial four penalty records.
2. Delete player 10 rows inside a transaction; compare counts before and after ROLLBACK.
3. Update one payment and roll back again.
4. Insert and delete inside a third transaction; COMMIT and show final IDs.
5. Update two rows around a SAVEPOINT and roll back only the second update.
6. Use READ lock and UNLOCK TABLES, then explain two-session experiments.

## 5. Complete working example — copy and execute

This is the **entire lesson SQL**, including its own database setup and sample data. Copy it into the phpMyAdmin **SQL** editor and click **Go**, or execute the matching `lab.sql` file with the CLI. Start at the first line; there are no missing setup steps.

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

## 6. Expected results to check in front of students

- Initial record count is **4**.
- During the delete transaction, count is **2**; after ROLLBACK it is **4**.
- Payment 2 reverts from **999.00** to **200.00**.
- After COMMIT, IDs are **1, 2, 3, 5**.
- After SAVEPOINT partial rollback, amount for payment 1 is **350.00**, payment 2 remains **200.00**.

**Quick verification query (safe to rerun after the full script):**

```sql
USE cse210_lab09;
SELECT payment_no,amount FROM penalties ORDER BY payment_no;
```

Results are derived from the sample rows above. SQL clients may show different column widths, column ordering for `SHOW` commands, or status messages.

## 7. Students' independent lab tasks

Use the example to learn the technique, then complete the following **independently**. Create your own table names or a separate exercise database if you want to keep the demo intact.

1. Run INSERT → DELETE → ROLLBACK and verify the original state.
2. Run UPDATE → ROLLBACK, then INSERT → DELETE → COMMIT.
3. Try a savepoint in a separate transaction.
4. Use two client sessions to investigate a row lock with `SELECT ... FOR UPDATE`; avoid modifying or locking shared data outside your own lab database.

## 8. Viva / checkpoint questions

1. Does ROLLBACK undo a committed transaction?
2. Why use InnoDB?
3. What is the difference between a table lock and a row lock?

## 9. Submission and instructor checkpoint

Students should submit an `.sql` file containing their own implementation, a concise explanation of each query/constraint, and screenshots or copied result tables proving that the required commands ran. Ask students to predict at least one output before execution, and check table state after each modifying query. Do not submit the provided demonstration code unchanged as original work.

## 10. Common troubleshooting

- **Database already exists / duplicate table:** start again from the top; `DROP DATABASE IF EXISTS` resets this *lab's* database (destructive).
- **Foreign key errors:** create parent tables and insert referenced parent rows before inserting children; inspect `SHOW CREATE TABLE ...`.
- **Unknown column / syntax error:** check case, spelling, commas, single quotes around strings, and the final semicolon.
- **Access denied:** use a MySQL account that can create databases on your local practice server.
- **Incorrect database selected:** run `USE cse210_lab09;` before standalone check queries.
- **Version differences:** XAMPP often bundles MariaDB rather than Oracle MySQL; compare exact server version with `SELECT VERSION();` and follow the setup notes.

---

**Back to:** [All CSE 210 labs](../../README.md) · **Script:** [`lab.sql`](lab.sql)
