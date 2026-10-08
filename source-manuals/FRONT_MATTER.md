# CSE 210 — Original PDF Front Matter and Table of Contents

<!-- Original PDF page 1; printed lab page front matter -->

![Diagram / screenshot from the source PDF, PDF page 1](../assets/source-figures/page-01-image-01.png)

## Department of Computer Science and Engineering

Faculty of Science and Engineering

## CSE 210

![Diagram / screenshot from the source PDF, PDF page 1](../assets/source-figures/page-01-image-02.png)

Prepared for Academic Laboratory Activities

Department of Computer Science and Engineering, GUB

<!-- Original PDF page 2; printed lab page front matter -->

<!-- Original PDF page 3; printed lab page front matter -->

```text
Contents

I    Introduction to Database, MySQL, and Managing MySQL
     Databases                                                                          1
     1.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     1
     1.2   Problem Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .       1
     1.3   Procedure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      2
     1.4   Practicing With XAMPP . . . . . . . . . . . . . . . . . . . . . . .          2
     1.5   Implementations . . . . . . . . . . . . . . . . . . . . . . . . . . .        3
           1.5.1      Database Creation . . . . . . . . . . . . . . . . . . . .         3
           1.5.2      Database Use . . . . . . . . . . . . . . . . . . . . . . .        3
           1.5.3      Table Creation . . . . . . . . . . . . . . . . . . . . . .        3
           1.5.4      Table Description . . . . . . . . . . . . . . . . . . . .         5
           1.5.5      Data Insertion . . . . . . . . . . . . . . . . . . . . . .        5
           1.5.6      Data Browse . . . . . . . . . . . . . . . . . . . . . . .         6
           1.5.7      Dropping Table and Database . . . . . . . . . . . . .             6
     1.6   Input/Output Summary . . . . . . . . . . . . . . . . . . . . . . .           6
     1.7   Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .          7
     1.8   Lab Task (Please implement yourself and show the output to the
           instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    7
           1.8.1      Problem Analysis . . . . . . . . . . . . . . . . . . . .          7
     1.9   Lab Exercise (Submit as a report) . . . . . . . . . . . . . . . . . .        8
II   Implementation of Integrity Constraints in MySQL                                   9
     2.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     9
     2.2   Problem analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .       9
     2.3   Procedure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .      9
     2.4   Implementations . . . . . . . . . . . . . . . . . . . . . . . . . . .       10
           2.4.1      Database Creation . . . . . . . . . . . . . . . . . . . .        10
           2.4.2      Database Use . . . . . . . . . . . . . . . . . . . . . . .       11
           2.4.3      Declaration of Primary Key . . . . . . . . . . . . . . .         11
           2.4.4      NOT NULL Constraints . . . . . . . . . . . . . . . . .           11
           2.4.5      Create Composite Key . . . . . . . . . . . . . . . . . .         12
           2.4.6      Implementation of Unique . . . . . . . . . . . . . . .           12
           2.4.7      Implementation of Foreign Key . . . . . . . . . . . .            13
           2.4.8      Data Insertion . . . . . . . . . . . . . . . . . . . . . .       14
           2.4.9      Implementation of CASECADE . . . . . . . . . . . .               15
           2.4.10     Implementation of SET NULL . . . . . . . . . . . . .             15
           2.4.11     Implementation of RESTRICT . . . . . . . . . . . . .             16
           2.4.12     Implementation of SET DEFAULT . . . . . . . . . . .              16
           2.4.13     Implementation of AUTO_INCREMENT . . . . . . .                   17
```

<!-- Original PDF page 4; printed lab page front matter -->

```text
2.4.14     MySQL CHECK Constraint . . . . . . . . . . . . . . .             17
            2.4.15     Implementation of DEFAULT . . . . . . . . . . . . . .            18
            2.4.16     MySQL CASE Examples . . . . . . . . . . . . . . . . .            18
      2.5   Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .         18
      2.6   Lab Task (Please implement yourself and show the output to the
            instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   19
            2.6.1      Problem analysis . . . . . . . . . . . . . . . . . . . . .       19
      2.7   Lab Exercise (Submit as a report) . . . . . . . . . . . . . . . . . .       19
III   Modifying MySQL databases and Updating Data in MySQL
      Table                                                                             20
      3.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    20
      3.2   Problem analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .      20
            3.2.1      Table modification using alter table . . . . . . . . . .         20
      3.3   Procedure (Implementation in MySQL) . . . . . . . . . . . . . .             20
      3.4   Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .         29
      3.5   Lab Task (Please implement yourself and show the output to the
            instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   29
      3.6   Lab Exercise (Submit as a report) . . . . . . . . . . . . . . . . . .       30
IV    Querying and Filtering data in MySQL Table                                        31
      4.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    31
      4.2   Problem analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .      31
            4.2.1      Filtering and Fetching Data in MySql Table . . . . . .           31
      4.3   Procedure (Implementation in MySQL) . . . . . . . . . . . . . .             31
      4.4   Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .         33
      4.5   Lab Task (Please implement yourself and show the output to the
            instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   33
      4.6   Lab Exercise (Submit as a report) . . . . . . . . . . . . . . . . . .       33
V     Querying and Filtering data in MySQL Table (Extended)                             35
      5.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    35
      5.2   Problem analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .      35
            5.2.1      Logical Operators . . . . . . . . . . . . . . . . . . . .        35
            5.2.2      MySQL LIMIT (ORDER BY, ASC, DESC) . . . . . . .                  36
            5.2.3      Between, Not Between In, Not In . . . . . . . . . . . .          36
      5.3   Procedure (Implementation in MySQL) . . . . . . . . . . . . . .             36
      5.4   Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .         39
      5.5   Lab Task (Please implement yourself and show the output to the
            instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   39
      5.6   Lab Exercise (Submit as a report) . . . . . . . . . . . . . . . . . .       39
VI    Implementation of MySQL Aggregate Function                                        41
      6.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    41
      6.2   Problem analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .      41
            6.2.1      Using Mathematical Function . . . . . . . . . . . . .            42
            6.2.2      Using Text /String Functions:) . . . . . . . . . . . . .         43
      6.3   Procedure (Implementation in MySQL) . . . . . . . . . . . . . .             43
```

<!-- Original PDF page 5; printed lab page front matter -->

```text
6.4   Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .         45
       6.5   Lab Task (Please implement yourself and show the output to the
             instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   46
       6.6   Lab Exercise (Submit as a report) . . . . . . . . . . . . . . . . . .       47
VII    Implementation of Relational Databases (Join Function)                            48
       7.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    48
       7.2   Problem analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .      48
             7.2.1      Join Function . . . . . . . . . . . . . . . . . . . . . . .      49
       7.3   Procedure (Implementation in MySQL) . . . . . . . . . . . . . .             49
       7.4   Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .         52
       7.5   Lab Task (Please implement yourself and show the output to the
             instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   52
       7.6   Lab Exercise (Submit as a report) . . . . . . . . . . . . . . . . . .       53
VIII   Implementation of Databases Triggers                                              55
       8.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    55
       8.2   Problem analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .      55
             8.2.1      Introduction to Trigger . . . . . . . . . . . . . . . . .        55
             8.2.2      Benefits of Trigger . . . . . . . . . . . . . . . . . . . .      55
             8.2.3      Syntax of Trigger . . . . . . . . . . . . . . . . . . . . .      56
       8.3   Procedure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     56
       8.4   Implementations . . . . . . . . . . . . . . . . . . . . . . . . . . .       57
             8.4.1      Database Creation . . . . . . . . . . . . . . . . . . . .        57
             8.4.2      Database Use . . . . . . . . . . . . . . . . . . . . . . .       58
             8.4.3      Creating a Table . . . . . . . . . . . . . . . . . . . . .       58
             8.4.4      Creating Trigger . . . . . . . . . . . . . . . . . . . . .       58
             8.4.5      Checking Trigger . . . . . . . . . . . . . . . . . . . . .       59
       8.5   Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .         59
       8.6   Lab Task (Please implement yourself and show the output to the
             instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   60
             8.6.1      Problem analysis . . . . . . . . . . . . . . . . . . . . .       60
       8.7   Lab Exercise (Submit as a report) . . . . . . . . . . . . . . . . . .       60
       8.8   Reference . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     60
IX     Implementation of Database Transactions and Multiuser
       Usage                                                                             62
       9.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    62
       9.2   Problem Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .      62
       9.3   Procedure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     62
       9.4   Implementations . . . . . . . . . . . . . . . . . . . . . . . . . . .       62
             9.4.1      Database Creation . . . . . . . . . . . . . . . . . . . .        62
             9.4.2      Database Use . . . . . . . . . . . . . . . . . . . . . . .       63
             9.4.3      Creating a Table . . . . . . . . . . . . . . . . . . . . .       63
             9.4.4      Turning Off Auto-Commit . . . . . . . . . . . . . . .            63
             9.4.5      Deleting from the penalties Table . . . . . . . . . .            64
             9.4.6      Rollback . . . . . . . . . . . . . . . . . . . . . . . . .       64
             9.4.7      Commit . . . . . . . . . . . . . . . . . . . . . . . . . .       64
```

<!-- Original PDF page 6; printed lab page front matter -->

```text
9.4.8      Locking . . . . . . . . . . . . . . . . . . . . . . . . . .      64
           9.4.9      Unlock . . . . . . . . . . . . . . . . . . . . . . . . . .       65
    9.5    Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .         65
    9.6    Lab Task (Please implement yourself and show the output to the
           instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   65
           9.6.1      Problem Analysis . . . . . . . . . . . . . . . . . . . .         65
    9.7    Lab Exercise (Case Study) . . . . . . . . . . . . . . . . . . . . . .       65
    9.8    References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    66
X   Implementation of Functions and Stored Procedures in MySQL 67
    10.1   Objective(s) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    67
    10.2   Problem Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . .      67
    10.3   Procedure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .     67
    10.4   Implementations . . . . . . . . . . . . . . . . . . . . . . . . . . .       67
           10.4.1     Database and Table Setup . . . . . . . . . . . . . . . .         67
           10.4.2     Implementing a Stored Procedure . . . . . . . . . . .            69
           10.4.3     Implementing a Function . . . . . . . . . . . . . . . .          70
    10.5   Input/Output Summary . . . . . . . . . . . . . . . . . . . . . . .          72
    10.6   Discussion & Conclusion . . . . . . . . . . . . . . . . . . . . . .         72
    10.7   Lab Task (Please implement yourself and show the output to the
           instructor) . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .   72
           10.7.1     Problem Analysis . . . . . . . . . . . . . . . . . . . .         73
    10.8   Lab Exercise (Submit as a Report) . . . . . . . . . . . . . . . . .         73
    10.9   References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .    74
```

