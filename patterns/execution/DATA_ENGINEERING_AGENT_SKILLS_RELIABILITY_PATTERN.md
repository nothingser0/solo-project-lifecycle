# Vaquar Khan Data Engineering Agent Skills & Production Reliability Pattern

> **Module**: M06 (Development Execution), M07 (Quality Assurance), & M10 (Deployment)  
> **Source**: Adapted from Vaquar Khan's Data Engineering Agent Skills (`vaquarkhan/data-engineering-agent-skills`).  
> **Scope**: Production-grade data engineering agent workflows, dataset contract verification, safe backfill/replay, Kafka & Spark reliability, and MCP observability guardrails.

---

## 1. Five-Stage DE Agent Lifecycle
1. **Spec (`/spec`)**: Define dataset contracts, source schemas, and consumer SLAs upfront before writing code.
2. **Plan (`/plan`)**: Map out partition strategies, idempotency keys, and backfill windows.
3. **Build (`/build`)**: Implement transformations with structured error handling and idempotent writes.
4. **Validate (`/validate`)**: Run contract checks against sample data or local DuckDB engines.
5. **Review & Ship (`/review` → `/ship`)**: Independent parallel review across reliability, security, and analytics engineering perspectives.

---

## 2. Production Reliability & Guardrails
- **Safe Backfill & Replay**: Enforce partition re-computation rules without dropping downstream production tables.
- **Kafka & Spark Reliability**: Guardrails against consumer lag, out-of-order events, and executor memory overflow.
- **MCP Data Observability**: Symptom-to-MCP mapping for live lag, Spark execution plans, and run-state diagnosis.
