#!/usr/bin/env python3
"""Bring the M05 fixture's ERD in line with its own DDL, and name the human who locked the stack.

The template ships an ERD with three entities (organizations, users, audit_logs) and a DDL with nine
tables. A project that adds tables to the DDL must add them to the ERD; that is a real defect, so the
fixture has to show the correct state before the gate can be judged.
"""
import io
import re
import sys

fsd = sys.argv[1]
s = io.open(fsd, encoding="utf-8").read()

erd = '''```mermaid
erDiagram
    ORGANIZATIONS ||--o{ USERS : "has many"
    ORGANIZATIONS ||--o{ PRODUCTS : "owns"
    ORGANIZATIONS ||--o{ AUDIT_LOGS : "records"
    USERS ||--o{ AUDIT_LOGS : "performs"
    USERS ||--o{ IDEMPOTENCY_KEYS : "issues"
    PRODUCTS ||--o{ INVENTORY_MOVEMENTS : "has"
    INVENTORY ||--|| PRODUCTS : "tracks"
    USERS ||--o{ CRM_DEALS : "owns"
    USERS ||--o{ CMS_ARTICLES : "writes"

    ORGANIZATIONS {
        uuid id PK
        string name
        string slug UK
        timestamp created_at
    }
    USERS {
        uuid id PK
        uuid org_id FK
        string email UK
        string role
        timestamp created_at
    }
    PRODUCTS {
        uuid id PK
        uuid org_id FK
        string sku UK
        string name
        integer price_idr
        timestamp created_at
    }
    INVENTORY {
        uuid id PK
        uuid product_id FK
        integer qty_on_hand
        integer reorder_point
    }
    INVENTORY_MOVEMENTS {
        uuid id PK
        uuid product_id FK
        integer delta
        string reason
        timestamp created_at
    }
    CRM_DEALS {
        uuid id PK
        uuid owner_id FK
        string stage
        integer amount_idr
    }
    CMS_ARTICLES {
        uuid id PK
        uuid author_id FK
        string slug UK
        string status
    }
    IDEMPOTENCY_KEYS {
        uuid id PK
        uuid user_id FK
        string key UK
        timestamp created_at
    }
    AUDIT_LOGS {
        uuid id PK
        uuid org_id FK
        uuid actor_id FK
        string action
        jsonb metadata
        timestamp created_at
    }
```'''

start = s.index("```mermaid\nerDiagram")
end = s.index("```", s.index("AUDIT_LOGS {", start))
end = s.index("\n", end) + 1
s = s[:start] + erd + "\n" + s[end:]

s = re.sub(r"Stack-Locked-by:[^\n]*", "Stack-Locked-by: Wahyu Nur Sagita on 2026-11-06", s)
io.open(fsd, "w", encoding="utf-8").write(s)

tables = sorted(set(re.findall(r"^CREATE TABLE (\w+)", s, re.M)))
print(f"ERD now mirrors {len(tables)} DDL tables: {' '.join(tables)}")
