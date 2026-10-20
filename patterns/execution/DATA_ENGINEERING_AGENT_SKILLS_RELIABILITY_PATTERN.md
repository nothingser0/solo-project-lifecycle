# Data Engineering Agent Skills & Production Reliability Pattern

> **Module**: M06 (Development Execution), M07 (Quality Assurance), & M10 (Deployment)  
> **Source**: Adapted from a published data-engineering agent-skills library.  
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

### 2.1 Backfill & replay is a gate, not a task

A backfill is the highest-risk routine operation in a data platform: rerun a job without bounds and you double-count revenue, or silently drop a partition nobody notices for a week. **Do not start until a written replay plan exists.**

Required in the plan, before any rerun:

| Field | Why |
| :--- | :--- |
| Affected window and partitions | "Everything" is not a scope; a bounded window is |
| Source of truth and downstream targets | What you recompute *from*, and what you will overwrite |
| Execution mode (`replay` / `merge` / `overwrite`) | Overwrite is destructive; replay usually is not |
| Idempotency proof | Why running this twice produces the same result as once |
| Publish pause state | Consumers must know the numbers are mid-repair |
| Rollback in plain language | Not "restore backup" — which backup, and how long |
| Validation checks with thresholds | Numbers, not "looks right" |
| Approvals | A named person, before, not after |

**Reconciliation gates before reopening publish** (minimum):

1. Row count or volume parity within a stated threshold
2. Duplicate check on business keys — the most common backfill defect
3. Metric reconciliation on business-critical aggregates
4. Schema and nullability contract checks

**Separate backfill semantics from incremental ones.** A backfill run usually needs different concurrency limits, and its watermark handling must not skip or duplicate late-arriving data. Metric definitions must stay comparable across the replay window, or the "before" and "after" are not the same measure.

**The rule that prevents most incidents**: publish stays paused until the reconciliation gates pass. A partial publish is worse than a late one — it makes the numbers plausible and wrong.

---
- **Safe Backfill & Replay**: Enforce partition re-computation rules without dropping downstream production tables.
- **Kafka & Spark Reliability**: Guardrails against consumer lag, out-of-order events, and executor memory overflow.
- **MCP Data Observability**: Symptom-to-MCP mapping for live lag, Spark execution plans, and run-state diagnosis.
