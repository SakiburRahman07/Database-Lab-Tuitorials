# Setup — CSE 210 Database System Lab

This guide is written for a **Windows classroom using XAMPP**, with alternatives for an existing MySQL installation. Do this once; each lab is independent afterward.

## Option A — Windows + XAMPP + phpMyAdmin (beginner-friendly)

1. Download XAMPP from the official Apache Friends site: <https://www.apachefriends.org/>.
2. Install XAMPP, for example at `C:\xampp`. On a managed classroom machine, follow the administrator's permissions and antivirus rules.
3. Open **XAMPP Control Panel** and click **Start** next to **MySQL**. Start **Apache** too if you plan to use phpMyAdmin in the browser.
4. Verify the services indicate they are running. If MySQL fails to start, check for a port collision with another MySQL/MariaDB service (often TCP 3306).
5. Open <http://localhost/phpmyadmin/>. You should see the phpMyAdmin database panel.
6. Click the **SQL** tab, open any lab `README.md`, copy all SQL under **Complete working example**, paste, and click **Go**.
7. Select the created `cse210_labXX` from the left navigation to browse its tables.

> XAMPP is a development package. Do not expose its default configuration or a passwordless root user on the internet. Use it on a trusted local machine only.

## Option B — Command-line execution (recommended for all labs, essential for Lab 10)

### Open the client in Windows

Start XAMPP's **Shell**, or open Command Prompt (`cmd.exe`) and run:

```bat
"C:\xampp\mysql\bin\mysql.exe" -u root
```

If your local root account has a password, run:

```bat
"C:\xampp\mysql\bin\mysql.exe" -u root -p
```

Enter the password when prompted. If you installed Oracle MySQL separately, use its `mysql.exe` location instead. XAMPP may show a `MariaDB>` prompt; that is expected when its database package is MariaDB.

### Run a complete lab SQL file

At the interactive `mysql>` or `MariaDB>` prompt (note forward slashes):

```sql
SOURCE C:/path/to/CSE-210-Database-System-Lab/labs/lab-04/lab.sql;
```

Replace the example folder with the actual location and change `lab-04` to any lab number. `SOURCE` runs the full script, including its database setup.

### Alternative — Command Prompt redirection

From **Command Prompt**, after navigating to the repository folder:

```bat
"C:\xampp\mysql\bin\mysql.exe" -u root < labs\lab-04\lab.sql
```

If you use PowerShell and `<` redirection does not work, use the interactive `SOURCE` approach instead.

### Confirm your connection

```sql
SELECT VERSION();
SHOW DATABASES;
USE cse210_lab04;
SHOW TABLES;
SELECT COUNT(*) AS total_employees FROM employees;
```

That last query assumes you've already executed Lab 04. It should return `5`.

## Lab 10 routines — special case

Lab 10 uses `CREATE PROCEDURE ... BEGIN ... END` and `CREATE FUNCTION ... BEGIN ... END`. The `DELIMITER //` lines are **mysql client commands** needed to keep the entire multi-statement routine body together.

For best reliability:

1. Start MySQL from XAMPP.
2. Open the MySQL CLI using the commands above.
3. Run: `SOURCE C:/path/to/CSE-210-Database-System-Lab/labs/lab-10/lab.sql;`
4. After it finishes, call `USE cse210_lab10;` and `SHOW FUNCTION STATUS WHERE Db='cse210_lab10';`.

phpMyAdmin's routine editor/SQL parser behavior varies by version. If it does not accept the pasted `DELIMITER` form, use the CLI rather than removing `DELIMITER` and breaking the routine body.

## Important rules before you run a lab

- **Never run against production.** Every lesson starts with `DROP DATABASE IF EXISTS cse210_labXX` and intentionally erases that lab's previous data.
- If students want to preserve their results, export the corresponding database first (phpMyAdmin → **Export**) or use a different database name consistently in the SQL.
- Do not uncomment the deliberately invalid SQL queries in Lab 02 while executing the whole file. They are designed to be run **one by one** to show constraint errors.
- Do not copy multiple lab scripts into one query editor without understanding their separate database resets.
- For a clean re-run, run the **whole** lab script from its first line. Running only selected middle statements may produce duplicate key errors or a missing-table error.

## Troubleshooting table

| Issue | Likely cause | What to do |
|---|---|---|
| `localhost/phpmyadmin` does not load | Apache stopped or port conflict | Start Apache and check its logs and configured port |
| MySQL fails to start | Another process owns port 3306 or file issue | Check XAMPP logs and service conflict; do not delete database files blindly |
| `Access denied for user` | Incorrect account/password/privileges | Use the administrator-provided local login |
| `CREATE DATABASE command denied` | Account lacks permissions | Request a local training account with CREATE rights |
| `Unknown database cse210_labXX` | Started with query from the middle of the script | Run the whole script from its top |
| Foreign key insert failed | Missing referenced parent row | Insert parent row first and check correct key values |
| `CHECK` behaves unexpectedly | Older server/version differences | Check `SELECT VERSION();` and upgrade/choose compatible server |
| `DELIMITER` causes SQL syntax error | Client passed command to server | Use MySQL CLI `SOURCE` for Lab 10 |
| “Table already exists” | Script partially executed | Re-run from first line to reset its own lab DB |
| Trigger not firing | Trigger not created or wrong table | Inspect `SHOW TRIGGERS;` in Lab 08 |
| ROLLBACK does not undo CREATE/DROP | DDL may implicitly commit | Keep transactions focused on DML; use InnoDB |

## Official background references

- [MySQL Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
- [MySQL CREATE TABLE](https://dev.mysql.com/doc/refman/8.0/en/create-table.html)
- [MySQL CREATE TRIGGER](https://dev.mysql.com/doc/refman/8.0/en/create-trigger.html)
- [MySQL Stored Objects](https://dev.mysql.com/doc/refman/8.0/en/stored-objects.html)
- [Apache Friends / XAMPP](https://www.apachefriends.org/)

[Back to all labs](README.md)
