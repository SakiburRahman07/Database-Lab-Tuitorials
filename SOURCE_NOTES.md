# Source Fidelity and SQL Adaptation Notes

This teaching repository follows the ten-part structure of the supplied *Database System Lab Manual — CSE 210*, Department of Computer Science and Engineering, Green University of Bangladesh. The `labs/lab-XX/` files are **original Markdown-based teaching adaptations**, not an official replacement for the institutional manual. This repository **also includes** `COMPLETE_SOURCE_MANUAL.md` and `source-manuals/`, representing a source-faithful PDF-to-Markdown conversion. The original text and image crops are kept separate from changes to the runnable SQL. `COMPLETE_TEACHING_MANUAL.md` combines both, with labeled source and instructor adaptation sections.

## Original chapter alignment

| Repository lab | Original lab | Approximate printed pages |
|---|---|---|
| 01 | Introduction to Database, MySQL, and Managing MySQL Databases | 1–8 |
| 02 | Implementation of Integrity Constraints in MySQL | 9–19 |
| 03 | Modifying MySQL Databases and Updating Data | 20–30 |
| 04 | Querying and Filtering Data | 31–34 |
| 05 | Extended Querying and Filtering | 35–40 |
| 06 | MySQL Aggregate Function | 41–47 |
| 07 | Relational Databases (JOIN) | 48–54 |
| 08 | Database Triggers | 55–61 |
| 09 | Transactions and Multiuser Usage | 62–66 |
| 10 | Stored Procedures and Functions | 67–74 |

## Changes made for practical teaching

- **Standalone setup:** Every lab creates its own database and tables rather than depending on prior labs, so lecturers can begin at any lab. This is a deliberate teaching change.
- **Consistent syntax:** Several sample definitions in the source reuse table names with conflicting definitions or mismatch table and column names. The new scripts use one internally consistent schema per lab.
- **Correct MySQL ALTER syntax:** `MODIFY COLUMN` or `CHANGE COLUMN` is used when changing column data types/definitions, instead of relying on the generic `ALTER COLUMN ... datatype` syntax printed in Lab III.
- **Data type reliability:** IDs use integer keys where appropriate, phone numbers use character data, money uses `DECIMAL`, and sample dates have valid values.
- **Integrity details:** Foreign-key actions are demonstrated on correctly related parent/child tables. MySQL InnoDB does not implement `ON DELETE SET DEFAULT` as an FK action; it is discussed, not run.
- **DISTINCT:** Clarified that DISTINCT filters duplicates from a result, rather than deleting rows from storage.
- **Aggregate expressions:** Corrected invalid or ambiguous SUM/COUNT syntax; revenue uses `price * quantity`, and string functions use text fields rather than price values.
- **JOIN sample keys:** The original join example has inconsistent course department IDs and student IDs; the new dataset has valid foreign keys, deliberately unmatched records, and clear result counts.
- **Trigger dialect:** Source Lab VIII discusses PL/SQL/Oracle-specific clauses but implements a MySQL example. The new working code uses supported MySQL `CREATE TRIGGER ... FOR EACH ROW` syntax.
- **Transactions:** Clear `START TRANSACTION`/`ROLLBACK`/`COMMIT` blocks remove reliance on session autocommit state; table lock is kept outside those blocks.
- **Functions:** Added function data-access characteristics and correct MySQL CLI DELIMITER instructions; a table-reading function is not falsely labelled deterministic.
- **Policy omissions:** A publication count of exactly 4 has no stated increment in the source trigger exercise; current tuition waiver policy is not included. Exercises direct the instructor to define/verify these externally, without guessing.
- **Integrity & copyright:** The original file is not bundled; no institutional endorsement or open-source reuse rights are implied.

## Validation boundary

The included `scripts/validate_repo.py` checks file presence, Markdown/SQL code block consistency, unique database names, and common lesson elements. This is **static validation**, not SQL runtime execution. Actual compatibility depends on the MySQL/MariaDB version and local privileges. For production classroom use, test each `lab.sql` against the exact installed DBMS first.

[Return to repository home](README.md)

## Full source transcription limitations

- All 80 PDF pages were processed, including the printed table of contents, 10 labs, figures, screenshots and academic integrity notes.
- The original text is derived from PDF text objects: discretionary hyphenation and original line breaks are normalized for Markdown readability, so it is a **source-faithful conversion**, not a typeset facsimile.
- Multicolumn PDF tables were reconstructed where possible, with cropped table images preserved as the visual reference.
- The original PDF contains errors, inconsistent identifiers and some SQL written for other database systems. In the source transcription, those remain source content; use the independent teaching scripts for classroom copy/paste.
- New adaptation sections are labeled separately. Static repository validation does not guarantee successful SQL execution on the user's specific MySQL/MariaDB version.
- To publish source-extracted text or figures in a public GitHub repository, ensure that the manual's rights holder authorizes redistribution.
