# LEARNINGS.md — Cross-Session Engineering Lessons Ledger

> **Purpose**: Durable record of mistakes, root causes, and prevention rules so the same error is never repeated across sessions or by a fresh AI agent.
> **Location**: Project root `./LEARNINGS.md`.
> **Rule**: Append a row for EVERY significant defect, gate failure, or rework event. Never delete past rows — mark them `SUPERSEDED` instead.
> **Why**: AI agents and humans both re-introduce the same bug when the lesson lives only in chat history.

---

## 1. Lessons Ledger

| ID | Date | Area | What Went Wrong (Symptom) | Root Cause | Prevention Rule (What To Do Next Time) | Status |
|:---|:---|:---|:---|:---|:---|:---:|
| LRN-01 | [YYYY-MM-DD] | [DB / BE / FE / INT / Deploy] | [e.g. Webhook replayed → duplicate payment rows] | [Missing UNIQUE constraint on gateway `order_id`] | [Always add DB-level idempotency: `UNIQUE(order_id)` + `idempotency_keys` table] | ACTIVE |
| LRN-02 | [YYYY-MM-DD] | [e.g. DB] | [e.g. User from Org A could read Org B invoices] | [RLS enabled but no `org_id` policy on child tables] | [Enable RLS AND add `WHERE org_id = get_current_org_id()` policy per table; cover with an IDOR test] | ACTIVE |
| LRN-03 | [YYYY-MM-DD] | [e.g. FE] | [e.g. iOS Safari auto-zoomed on form focus] | [Input font-size < 16px] | [All mobile inputs use `text-base` (16px)] | ACTIVE |
| LRN-04 | [YYYY-MM-DD] | [e.g. AI] | [e.g. AI left `// TODO: Implement auth` in production] | [No mechanical scan in gate] | [Run anti-slop linter before M06 close; zero placeholder TODOs allowed] | ACTIVE |

---

## 2. Recurring AI-Agent Failure Modes (Watch List)

*Known traps this project must actively guard against:*
- [ ] **Hallucinated dependency**: importing a package not present in `package.json` / `composer.json` / `requirements.txt`.
- [ ] **Deprecated API**: using an API removed in the pinned framework version.
- [ ] **Fake success**: `try { fetch() } catch {}` swallowing failures and showing a false success toast.
- [ ] **Scope creep**: adding un-requested features or editing frozen specs (`PRD.md`, `FSD.md`, `DESIGN_SPEC.md`).
- [ ] **Silent type bypass**: `// @ts-ignore`, `as any`.
- [ ] **Hardcoded secret**: API key/token committed in source instead of `process.env`.

---

## 3. Resolved & Superseded Lessons

| ID | Original Lesson | Superseded By | Date |
|:---|:---|:---|:---|
| [LRN-00] | [Old approach now obsolete] | [New rule / tooling] | [YYYY-MM-DD] |

---

## How To Use (Agent + Human)
1. **Before starting a session**: read §1 and §2 to load prior lessons.
2. **After any bug, gate failure, or rework**: append one row to §1 (symptom → root cause → prevention rule).
3. **When a rule becomes obsolete**: move it to §3 as `SUPERSEDED`; never delete history.
