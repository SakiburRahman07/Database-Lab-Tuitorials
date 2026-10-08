# Publish this teaching repository on GitHub

The folder you received is already a GitHub-ready repository. Publishing it requires signing in to **your** GitHub account; no GitHub repository is created automatically by downloading these files.

## Method 1 — GitHub website (no Git commands)

1. Sign in to <https://github.com/>.
2. Click **+ → New repository**.
3. Repository name: `CSE-210-Database-System-Lab`.
4. Add a description such as: `Independent MySQL lab manuals, working SQL demos and exercises for CSE 210`.
5. Choose **Public** only if you have permission to publish this source-adapted material; otherwise choose **Private**.
6. Keep **Add a README** and **Add .gitignore** unchecked because the folder already contains these.
7. Click **Create repository**.
8. Extract the downloaded ZIP. In your empty GitHub repository choose **uploading an existing file** (or **Add file → Upload files**), and upload the **contents of the extracted folder**, preserving the `labs/`, `scripts/`, and `.github/` folders.
9. Commit the files. Refresh the repository homepage and verify that `README.md` shows the list of all ten labs.

If your browser does not reliably upload entire folder trees, use Method 2.

## Method 2 — Git command line

Install Git from <https://git-scm.com/> and create an empty repository on GitHub as described above. In a terminal **inside the extracted folder**, run:

```bash
git init
git add .
git commit -m "Add 10 standalone database lab manuals"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/CSE-210-Database-System-Lab.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username. GitHub may ask you to authenticate via Git Credential Manager, SSH or a personal access token; do not put passwords or tokens into your Markdown files or commit history.

## Check after publishing

- Open the repository's `README.md` and click through [Lab 01](labs/lab-01/README.md) and [Lab 10](labs/lab-10/README.md).
- Ensure the code blocks render with SQL syntax highlighting and the links to `lab.sql` work.
- Open the **Actions** tab if it is enabled. The included workflow checks **file/Markdown consistency**, not runtime SQL behavior.
- Test the scripts on your lab's actual XAMPP/MySQL version before the course begins.

[Back to repository README](README.md)
