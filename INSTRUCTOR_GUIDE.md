# Instructor's Guide — CSE 210 Database System Lab

The repository is optimized for a lecturer conducting **one independent SQL topic per class**. Lab `README.md` files have a complete copy-paste demo, concise theory, output expectations, guided student practice, and viva questions. Avoid using the demo code as a student submission template.

## Recommended 75-minute class plan

| Time | Classroom activity |
|---|---|
| 0–10 min | Explain objectives, core terms, one practical use case |
| 10–20 min | Review table structure and ask students to predict output |
| 20–40 min | Copy-paste the complete demo SQL; step through key SELECT queries/results |
| 40–55 min | Students do two individual exercises and compare outcomes |
| 55–65 min | Evaluate individual attempts, troubleshoot, discuss common errors |
| 65–75 min | Mini-viva, reflection, assign lab-report tasks |

A fresh lab may be run in **any order** because each SQL file resets only its own `cse210_labXX` database. If you want to break the demo into smaller stages in phpMyAdmin, first execute the initial database setup and `INSERT`s, then run the selected SELECT queries one by one.

## What to display on the projector

1. **Lab README** on GitHub (theory, objectives and full SQL snippet).
2. **phpMyAdmin SQL tab** or MySQL CLI for demonstration.
3. **Tables and result sets** (explain schema/data/output relationship).
4. **One corrected failure** where it helps (for example, UNIQUE violation in Lab 02).
5. **Independent student exercise** and expected checkpoint only, not a solution copy.

## Lab-specific teaching emphasis

| Lab | Essential live demonstration | Warning to mention |
|---|---|---|
| 01 | Three tables created, filled and browsed | DROP TABLE permanently removes a table |
| 02 | PK/FK actions and commented constraint violations | `SET DEFAULT` is not supported as an InnoDB FK action |
| 03 | ALTER before/after, safe UPDATE and backup comparison | UPDATE without WHERE modifies all rows |
| 04 | DISTINCT results vs original row count | DISTINCT does not delete table data |
| 05 | AND/OR precedence; `IS NULL`; LIMIT | ORDER BY gives LIMIT a reliable order |
| 06 | Group revenue and HAVING | `price * quantity`, not just SUM(price), measures sales |
| 07 | INNER / LEFT / RIGHT and unmatched rows | MySQL has no direct FULL OUTER JOIN |
| 08 | Salary normalization and audit rows | Triggers are MySQL syntax, not PL/SQL |
| 09 | Delete → ROLLBACK vs Delete → COMMIT | InnoDB and DDL implicit commits |
| 10 | CALL OUT param and SELECT function | Use CLI when handling DELIMITER |

## Student report (recommended)

1. Lab title, date, ID and objective.
2. Own table design/schema or adapted dataset (do not submit unmodified demo).
3. SQL code and a short purpose statement for each important operation.
4. Screenshots of **actual** result sets and any relevant deliberate error messages.
5. Two short explanations: what worked, what was learned, and where/why an error happened.
6. Answer the checkpoint questions in the lesson.

## Suggested 100-point rubric

| Criterion | Marks |
|---|---:|
| Correct schema and independent setup | 20 |
| Correct SQL, commands and meaningful constraints | 30 |
| Output verification and interpretation | 20 |
| Exercise extension / problem-solving | 15 |
| Report clarity, discussion and viva | 15 |
| **Total** | **100** |

## Practical rules

- At the beginning of each class, show **which database** is going to be dropped/recreated.
- Encourage each student to work in their own local account/server; do not share one database name on a multiuser instance without isolation.
- After teaching, require students to complete a modified scenario (new data, new queries) rather than simply re-submit the demo SQL.
- Where the original manual uses figures or example tables without fully described values, this repository supplies **explicit reproducible sample data** instead. Student output should be compared with those sample rows, not screenshot dimensions from the PDF.
- Trigger salary-increment tasks require a clear rule for every publication-count case before grading; the source leaves publication count 4 undefined.
- Waiver percentages depend on the institution's current authorized policy; **do not invent percentages** for graded work.
- Do not ask students to publicly upload real student emails, phone numbers, grades, identity numbers, or passwords. The sample data is synthetic.

[Return to repository home](README.md)
