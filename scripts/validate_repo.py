#!/usr/bin/env python3
"""Static consistency checks. Does NOT execute SQL on a database."""
from pathlib import Path
import re
import sys

ROOT=Path(__file__).resolve().parents[1]
failures=[]
for i in range(1,11):
    folder=ROOT / 'labs' / f'lab-{i:02}'
    md=folder / 'README.md'
    sql=folder / 'lab.sql'
    if not md.exists() or not sql.exists():
        failures.append(f'Lab {i:02}: missing README.md or lab.sql')
        continue
    guide=md.read_text(encoding='utf-8')
    script=sql.read_text(encoding='utf-8').strip()
    blocks=re.findall(r'```sql\n(.*?)\n```',guide,re.S)
    if not blocks:
        failures.append(f'Lab {i:02}: no SQL block in Markdown')
    elif blocks[0].strip()!=script:
        failures.append(f'Lab {i:02}: full Markdown SQL does not match lab.sql')
    db=f'cse210_lab{i:02}'
    for pattern,label in [
        (fr'\bDROP DATABASE IF EXISTS {db};','reset database'),
        (fr'\bCREATE DATABASE {db}\b','create database'),
        (fr'\bUSE {db};','select database'),
        (r'\bCREATE TABLE\b','create table'),
        (r'\bINSERT INTO\b','insert data'),
    ]:
        if not re.search(pattern,script,re.I):
            failures.append(f'Lab {i:02}: missing {label}')
    wrong_dbs=re.findall(r'\b(?:USE|CREATE DATABASE|DROP DATABASE IF EXISTS)\s+(cse210_lab\d+)',script,re.I)
    if any(name.lower()!=db for name in wrong_dbs):
        failures.append(f'Lab {i:02}: script references another lab database')
    for section in ['## 1. Learning objectives','## 4. Instructor','## 5. Complete working example',
                    '## 6. Expected results','## 7. Students','## 8. Viva']:
        if section not in guide:
            failures.append(f'Lab {i:02}: missing section {section}')
    print(f'Lab {i:02}: static files and structure checked')

if failures:
    for item in failures:
        print('FAIL:',item,file=sys.stderr)
    sys.exit(1)
print('PASS: 10/10 independent Markdown/SQL lessons passed static consistency checks.')
print('NOTE: This script does not execute or syntax-check SQL against MySQL/MariaDB.')
