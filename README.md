# CSE 210 — Database System Lab (Green University of Bangladesh)

Teaching-ready lab files for **CSE 210 Database System Lab**, Department of Computer Science and Engineering, Faculty of Science and Engineering, Green University of Bangladesh (GUB).

## Lab index

| Lab | File | Topics covered |
| --- | --- | --- |
| 01 | [Lab01 — Introduction to Database, MySQL](labs/Lab01_Introduction_to_Database_MySQL.md) | XAMPP/phpMyAdmin, data types, `CREATE DATABASE`, `USE`, `CREATE TABLE`, `DESCRIBE`, `INSERT`, `SELECT`, `DROP` |
| 02 | [Lab02 — Integrity Constraints](labs/Lab02_Integrity_Constraints.md) | `PRIMARY KEY`, composite key, `NOT NULL`, `UNIQUE`, `FOREIGN KEY`, `CASCADE`, `SET NULL`, `RESTRICT`, `AUTO_INCREMENT`, `CHECK`, `DEFAULT`, `CASE` |
| 03 | [Lab03 — Modifying & Updating Data](labs/Lab03_Modifying_and_Updating_Data.md) | `ALTER TABLE` (ADD / DROP / CHANGE / MODIFY), constraints and keys via `ALTER`, `INSERT`, table copy, `UPDATE` |
| 04 | [Lab04 — Querying and Filtering](labs/Lab04_Querying_and_Filtering.md) | `SELECT`, `SELECT DISTINCT`, `WHERE`, comparison operators |
| 05 | [Lab05 — Querying and Filtering (Extended)](labs/Lab05_Querying_and_Filtering_Extended.md) | `AND`/`OR`/`NOT`, precedence, `LIMIT`, `ORDER BY`, `BETWEEN`, `IN`, `LIKE`, `IS NULL` |
| 06 | [Lab06 — Aggregate Functions](labs/Lab06_Aggregate_Functions.md) | `AVG`, `COUNT`, `SUM`, `MAX`, `MIN`, `GROUP BY`, `ORDER BY`, `LENGTH`, `UCASE`/`LCASE`, `FLOOR`, `CEIL`, `ROUND`, `MID`, `CONCAT` |
| 07 | [Lab07 — Joins](labs/Lab07_Joins.md) | `UNION`, `UNION ALL`, `INNER JOIN`, multiple joins, `GROUP BY`, `LEFT`, `RIGHT`, `CROSS`, full outer join emulation |
| 08 | [Lab08 — Triggers](labs/Lab08_Triggers.md) | Trigger structure, `BEFORE INSERT` / `BEFORE UPDATE`, `NEW`/`OLD`, `DELIMITER`, `SHOW` / `DROP TRIGGER` |
| 09 | [Lab09 — Transactions & Multiuser](labs/Lab09_Transactions_and_Multiuser.md) | `AUTOCOMMIT`, `DELETE`, `ROLLBACK`, `COMMIT`, `LOCK TABLES`, `UNLOCK TABLES`, storage engines |
| 10 | [Lab10 — Functions & Stored Procedures](labs/Lab10_Functions_and_Stored_Procedures.md) | `CREATE PROCEDURE` (`IN`/`OUT`), `CALL`, `CREATE FUNCTION`, `DECLARE`, `DELIMITER`, function vs procedure |

## How each lab file is organised

1. **Objectives** — what the lab teaches.
2. **Complete Example — copy, paste, run** — one self-contained script (`CREATE DATABASE → CREATE TABLE → INSERT → demo queries`) with expected-output tables. This is the block you run first in class.
3. **Quick Reference — Concepts taught in this lab** — a table with one row per concept and its one-line copy-paste SQL; long statements follow as their own code blocks.
4. **Problem Analysis / Procedure / Implementations** — the original manual text with figures, with every SQL snippet repaired so it runs.
5. **Discussion & Conclusion, Lab Task, Lab Exercise, References, Academic Integrity Policy** — original sections kept.

## Repository contents

- `labs/` — the 10 teachable lab files (start here).
- `CSE_210_Database_System_Lab.md` — the full original Markdown conversion of the 80-page PDF, kept as the archive source.
- `images/` — 58 cropped figures (workflow diagrams, output tables, UI screenshots) referenced by both files.

Open a lab file from this folder (or keep `labs/` next to `images/`) — all image paths are relative.

> Every "Complete Example" script in `labs/` has been executed end-to-end against MySQL/MariaDB (XAMPP). Original prose and figures are transcribed from the source PDF; SQL has been repaired (broken line wraps, missing commas, invalid keywords, wrong table names) so it runs without errors.
