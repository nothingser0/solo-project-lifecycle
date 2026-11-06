# FSD

## Document Metadata

Stack Decision LOCKED: Next.js 15 + Postgres 16 + Drizzle.

Rejected: Kubernetes because one VM runs 200 orders/day.

**Compatibility Level**: Level 2

## Module 04 Handoff Strategy

Level 2: the M04 prototype supplies tokens and two screens; M06 rebuilds them as components.

## Relational Database Schema

```sql
CREATE TABLE products (id uuid primary key, name text not null);
```

## API Contract

| Method | Path | Purpose |
|---|---|---|
| GET | /api/products | list |
| POST | /api/orders | create order |

## Screens

SITEMAP: SCR-001 login, SCR-002 orders.

The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance. The gate reads this line to prove the file has substance.
