# CSE 210 — Database System Lab

**10 independent, instructor-ready MySQL lab manuals** based on the *CSE 210 Database System Lab Manual*, Department of Computer Science and Engineering, Green University of Bangladesh.

Each lesson has its **own Markdown manual**, its **own complete SQL file**, sample data, a guided demonstration, expected outputs, additional student exercises, and viva/checkpoint questions. A lecturer can **open any lab and copy-paste its SQL from the Markdown** without running Labs 01–09 beforehand.

> **Important:** The sample databases are reset at the beginning of each script using `DROP DATABASE IF EXISTS cse210_labXX`. They are safe only for disposable, local lab data. **Do not run them against production or any database containing work you need to keep.**

## Full PDF-to-Markdown conversion — teach from the entire original manual

**Open [`COMPLETE_TEACHING_MANUAL.md`](COMPLETE_TEACHING_MANUAL.md)** to teach from **all 10 labs in one continuous Markdown file**. It includes the 80-page manual's explanations, headings, tables, original SQL examples, source figures/screenshots, tasks, and exercises; each lab is followed by a distinctly labeled independent working example, sample data, expected results, exercises and viva questions.

- **[`COMPLETE_SOURCE_MANUAL.md`](COMPLETE_SOURCE_MANUAL.md)** — the original uploaded 80-page PDF rendered into readable Markdown, with original diagrams/screenshots and documented source-page boundaries. Printed source SQL mistakes are retained; this is for fidelity and comparison, **not** guaranteed copy-paste executability.
- **[`COMPLETE_TEACHING_MANUAL.md`](COMPLETE_TEACHING_MANUAL.md)** — original full content **plus** independent runnable teaching demonstrations (best for classroom use).
- **[`source-manuals/`](source-manuals/)** — each original manual I–X as an individual Markdown lesson following the PDF's exact chapter structure and exercises.
- **[`labs/`](labs/)** — independently reproducible classroom versions, with each README containing the complete runnable SQL from the included `lab.sql`.
- **[`assets/source-figures/`](assets/source-figures/)** — source figures, screenshots, and table crops referenced by the Markdown files.

**Important:** Keep the `assets/` directory together with the Markdown files when uploading to GitHub, otherwise the images cannot render. Original institutional material may be protected by copyright: obtain appropriate authorization before public redistribution.

## Course content

| Lab | Lab manual | Main learning topics | SQL file |
|---|---|---|---|
| 01 | [Introduction to MySQL](labs/lab-01/README.md) | CREATE DATABASE / TABLE, INSERT, SELECT, DROP | [SQL](labs/lab-01/lab.sql) |
| 02 | [Integrity constraints](labs/lab-02/README.md) | PRIMARY / composite keys, UNIQUE, CHECK, FOREIGN KEY, CASCADE | [SQL](labs/lab-02/lab.sql) |
| 03 | [Modify tables and data](labs/lab-03/README.md) | ALTER, ADD, CHANGE, MODIFY, DROP, UPDATE, backup | [SQL](labs/lab-03/lab.sql) |
| 04 | [Basic data querying](labs/lab-04/README.md) | SELECT, DISTINCT, WHERE, comparison operators | [SQL](labs/lab-04/lab.sql) |
| 05 | [Advanced filtering](labs/lab-05/README.md) | AND/OR/NOT, ORDER BY, LIMIT, BETWEEN, IN, LIKE, NULL | [SQL](labs/lab-05/lab.sql) |
| 06 | [Aggregate and scalar functions](labs/lab-06/README.md) | COUNT, SUM, AVG, MIN/MAX, GROUP BY, HAVING, string and math | [SQL](labs/lab-06/lab.sql) |
| 07 | [JOIN operations](labs/lab-07/README.md) | INNER/LEFT/RIGHT/CROSS, multi-table JOIN, UNION | [SQL](labs/lab-07/lab.sql) |
| 08 | [Database triggers](labs/lab-08/README.md) | BEFORE/AFTER triggers, NEW/OLD, audit logging | [SQL](labs/lab-08/lab.sql) |
| 09 | [Transactions and locks](labs/lab-09/README.md) | START TRANSACTION, ROLLBACK, COMMIT, SAVEPOINT, READ lock | [SQL](labs/lab-09/lab.sql) |
| 10 | [Stored procedures and functions](labs/lab-10/README.md) | IN/OUT, CALL, CREATE PROCEDURE/FUNCTION, DELIMITER | [SQL](labs/lab-10/lab.sql) |

## Start teaching in 3 steps

1. Follow [SETUP.md](SETUP.md) once to install/start XAMPP or MySQL and open a query editor.
2. Choose **any** lab from the table above and open its `README.md`.
3. Explain the short theory and **copy the entire SQL block under “Complete working example”**. Run it, compare the expected results, then assign the independent tasks.

**phpMyAdmin:** open <http://localhost/phpmyadmin/> → **SQL** tab → paste the whole lab's SQL block → **Go**. **Lab 10:** use the MySQL/MariaDB command-line client for reliable `DELIMITER` handling.

**MySQL CLI (any lab):** From the interactive `mysql>` or `MariaDB>` prompt:

```sql
SOURCE C:/path/to/CSE-210-Database-System-Lab/labs/lab-01/lab.sql;
```

Change `lab-01` to the lab you're teaching. Use forward slashes on Windows for easier path handling. You can also run from a shell supporting input redirection:

```bash
mysql -u root -p < labs/lab-01/lab.sql
```

If the root account has no password on your *local teaching installation*, omit `-p`. Do not assume the teaching computer has a passwordless account.

## Repository layout

```text
CSE-210-Database-System-Lab/
├── README.md                  # Course homepage / quick navigation
├── COMPLETE_SOURCE_MANUAL.md       # 80-page PDF conversion, source-faithful
├── COMPLETE_TEACHING_MANUAL.md     # Complete source + 10 independent demos
├── source-manuals/                # 10 per-lab source transcriptions
├── assets/source-figures/        # Extracted source diagrams and screenshots
├── SETUP.md                   # Windows + XAMPP + phpMyAdmin + CLI instructions
├── INSTRUCTOR_GUIDE.md       # Suggested lab flow, student assessment, safety
├── PUBLISH_TO_GITHUB.md      # How to publish the folder to your GitHub account
├── SOURCE_NOTES.md           # Fidelity notes / corrections made to source
├── CONTRIBUTING.md           # How to suggest fixes and student contributions
├── .gitignore
├── scripts/
│   └── validate_repo.py      # Static consistency checks (not a DB execution test)
└── labs/
    ├── lab-01/
    │   ├── README.md          # Complete self-contained Markdown lesson
    │   └── lab.sql            # Same fully runnable SQL, without prose
    ├── lab-02/ ... lab-09/
    └── lab-10/
        ├── README.md
        └── lab.sql
```

## What makes the labs independent?

- Each lab creates its own **unique database**: `cse210_lab01` through `cse210_lab10`.
- Every required table and sample record is created inside that lab's script.
- A student can start with Lab 08 or Lab 10, without importing anything from earlier labs.
- The SQL is repeated **inside each Markdown manual**, so a lecturer can teach directly from the GitHub page and copy one full code block.
- Each lab contains its own source alignment, expected checks, class sequence and student tasks.

## Requirements and compatibility

- Use **MySQL 8.0.16+** for modern enforced `CHECK` constraints in Lab 02, or a compatible MariaDB version included with XAMPP.
- MySQL uses **InnoDB** for referential integrity and transactions in these examples.
- Lab 08 uses single-statement trigger bodies, suitable for most client editors; Lab 10 uses multi-statement routines and should be run with the MySQL CLI.
- XAMPP commonly includes **MariaDB** (not necessarily Oracle MySQL), so small version-specific differences are possible. Check `SELECT VERSION();`.
- See [SETUP.md](SETUP.md) for XAMPP, ports, PATH, error messages and command-line setup.

## Upload this to GitHub

Follow [PUBLISH_TO_GITHUB.md](PUBLISH_TO_GITHUB.md) to publish this folder to your GitHub account using either the website or Git commands. The ZIP is repository-ready, but no remote repository is created until you publish it.

## Teaching and academic integrity

See [INSTRUCTOR_GUIDE.md](INSTRUCTOR_GUIDE.md) for the lesson sequence, live demos, class tasks, report format, and grading ideas. The demonstration solutions are intentionally public, but students should write and submit **their own exercise solutions**, rather than claim the provided demo file as original work.

## Source and adaptation

The **topic order and course alignment** follow the uploaded GUB CSE 210 lab manual (Lab I–X). The existing `labs/lab-XX/README.md` materials are **teaching adaptations**, not literal transcriptions. The new `COMPLETE_SOURCE_MANUAL.md` separately converts the source PDF into Markdown with figures. `COMPLETE_TEACHING_MANUAL.md` clearly separates that source from adapted runnable demonstrations. Changes and limitations are documented in [SOURCE_NOTES.md](SOURCE_NOTES.md). The original PDF binary is not redistributed; the original text and figures are reproduced in Markdown, so confirm permission before public publication.

**License:** No open-source license has been assigned to the source-adapted material. Confirm ownership and permission before selecting a license or publishing content outside your authorized classroom use.
