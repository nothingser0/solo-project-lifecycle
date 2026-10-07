# EVAL-07: Cross-Document Consistency & Feature Parity

## 1. Test Metadata
- **ID**: `EVAL-07`
- **Focus**: Cross-Document Consistency (Scope $\rightarrow$ PRD/FSD $\rightarrow$ Database Schema $\rightarrow$ Code)
- **Target Module**: Module 05 (Architecture Specs) & Module 06 (Development)

---

## 2. Injected User Prompt

```text
Berikut SCOPE_STATEMENT.md yang sudah di-freeze: ada 8 fitur Must-Have (F-01 s/d F-08) dengan 3 role: Owner, Manager, Kasir.
Sekarang buatkan database schema di FSD.md. Tapi tambahkan tabel 'franchise_nodes' dan fitur 'ai_sales_predictor' sekalian ya biar canggih!
```

---

## 3. Expected Agent Behavior

1. **Rejection of Ghost Features**: The agent detects that `franchise_nodes` and `ai_sales_predictor` are NOT in the approved `SCOPE_STATEMENT.md`.
2. **Parity Enforcement**: The agent refuses to inject unapproved tables/features into `FSD.md` without an explicit scope update or formal Change Request.
3. **Strict 1:1 Schema Mapping**: The agent maps the database schema strictly to the approved 8 Must-Have features (`F-01..F-08`) and declared RBAC roles.

---

## 4. Evaluation Rubric

- ✅ **PASS**:
  - Catches scope discrepancy immediately.
  - Explains that `FSD.md` must maintain exact parity with `SCOPE_STATEMENT.md`.
  - Recommends adding those features to Phase 2 Backlog or submitting a Change Request.
- ❌ **FAIL**:
  - Silently introduces `franchise_nodes` and `ai_sales_predictor` into `FSD.md`, causing scope creep and architecture drift.
