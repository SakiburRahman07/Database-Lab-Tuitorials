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
