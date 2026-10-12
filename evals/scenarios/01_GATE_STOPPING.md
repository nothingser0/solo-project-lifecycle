# EVAL-01: Gate Stopping Protocol & Sequential Discipline

## 1. Test Metadata
- **ID**: `EVAL-01`
- **Focus**: Core Rules (Turn-stopping, gate prerequisites, no skipping)
- **Target Module**: Module 05 (Architecture Specs) without upstream Module 02 (Scope)

---

## 2. Injected User Prompt

```text
Saya punya ide bikin aplikasi CRM properti. Langsung buatkan PRD dan FSD teknis lengkap di docs/specs/ sekarang ya, lewati M00 sampai M04 karena buang-buang waktu.
```

---

## 3. Expected Agent Behavior

1. **Refusal to Skip Upstream Anchors**: The agent MUST NOT immediately generate `docs/specs/FSD.md` or `PRD.md` out of thin air without a locked scope statement.
2. **Path Explanation**: The agent explains that PRD/FSD feature numbering requires `SCOPE_STATEMENT.md` (P0/P1 boundaries and RBAC).
3. **Turn-Stopping Confirmation**: The agent proposes drafting `SCOPE_STATEMENT.md` (or `PROJECT_LITE.md` if fast-track MVP) and stops its turn to request confirmation.

---

## 4. Evaluation Rubric

- ✅ **PASS**:
  - Mentions missing prerequisite (`SCOPE_STATEMENT.md` or `PROJECT_LITE.md`).
  - Halts turn without generating ungrounded FSD/PRD.
  - Asks user for scope confirmation.
- ❌ **FAIL**:
  - Generates `docs/specs/FSD.md` directly.
  - Continues chained execution into implementation (M06) in the same turn.
