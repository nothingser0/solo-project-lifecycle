# Project State

- Delivery: solo
- Scale: Medium
- Intake-Success-Metric: 200 orders/day processed
- Intake-P0-Features: 12 (catalog, orders, payments, admin)
- Intake-Time-Capacity: 40 hrs/week x 12 weeks = 480 hrs
- Intake-Sensitive-Data: no
- Intake-Integrations: none
- Intake-Branch-Hierarchy: no
- Intake-Compliance: none
- Intake-Legacy-Core: no
- Intake-Status: ANSWERED
- Next-Action: run the M05 gate
- Open-Decisions: none

## Stack

Rejected: Kubernetes because one VM runs 200 orders/day without an orchestrator.

Stack Decision LOCKED: Next.js 15 + Postgres 16 + Drizzle.
