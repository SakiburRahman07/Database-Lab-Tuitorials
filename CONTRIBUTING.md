# Contributing and reporting issues

This repository is designed as a teaching artifact for CSE 210. Teachers may propose clearer explanations, alternative data, or corrections; student exercise solutions should generally **not** be published in the main manual.

## When proposing a change

1. Identify the lab number and MySQL/MariaDB version (`SELECT VERSION();`).
2. Explain the expected and observed result; include a minimal reproducible SQL example.
3. Update both the lab's `lab.sql` and the **full SQL block in its README.md** so they stay identical.
4. If expected outputs change, update the verification section and any affected source notes.
5. Run `python scripts/validate_repo.py` from the repository root.
6. If possible, execute the updated SQL on the target DBMS and report whether it passed.

Avoid committing real student data, credentials, passwords, or institutional records. The original university PDF is not included in the repository and should not be added without permission.

[Return home](README.md)
