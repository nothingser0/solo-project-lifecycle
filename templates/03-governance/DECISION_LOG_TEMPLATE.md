# Decision Log

> **Module**: M00–M12 (any phase that produces a decision) — `docs/DECISION_LOG.md`
> **Source**: Adapted from `devfolorunso/business-analyst-agent-skill` (MIT) — the `DEC-` log row structure (context, options, decision, rationale, owner, status). Written for this framework.
> **Relationship to other artifacts**: `ADR_TEMPLATE.md` records *architecture* decisions in depth (one file each). `MEETING_NOTES_TEMPLATE.md` records what one meeting decided. **This file is the one place you can read every business decision in sequence** — including the ones made in conversation, not in a meeting.

---

## Why a separate log

Decisions leak. Someone agrees to a pricing rule in a call, it never reaches the SRS, and six weeks later the invoice logic contradicts a customer promise. The ADR does not help — it is scoped to architecture and lives one-file-per-decision. Meeting notes do not help — nobody reads twelve meetings to find one ruling.

The log is a **ledger**, not a document. One row per decision, appended, never rewritten.

| Artifact | Answers |
| :--- | :--- |
| `ADR_TEMPLATE.md` | *Why* did we choose this architecture? (deep, per-decision) |
| `MEETING_NOTES_TEMPLATE.md` | What happened in this meeting? (per meeting) |
| **This file** | What has been decided, in what order, and is it still true? (across the project) |

---

## Log

| ID | Date | Phase | Decision | Options considered | Rationale | Decided by | Status | Supersedes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **DEC-001** | YYYY-MM-DD | M02 | Invoicing follows the Indonesian tax calendar (monthly, not per-transaction) | Per-transaction · monthly batch · hybrid | Client's accountant files monthly; per-transaction adds work with no benefit | Client PIC (meeting 2026-10-19) | ✅ ACTIVE | — |
| **DEC-002** | YYYY-MM-DD | M04 | Mobile-first, desktop is responsive fallback | Desktop-first · mobile-first · separate builds | 80% of stated users are on Android phones | Human (owner) | ✅ ACTIVE | — |
| **DEC-003** | YYYY-MM-DD | M05 | No offline mode in v1 | Offline-first · cache-only · none | Scope cut: offline sync would add ~3 weeks; deferred to v1.1 | Client PIC | ⏸ DEFERRED | — |

**Status legend**: ✅ ACTIVE · 🔄 SUPERSEDED (replaced by a later ID) · ⏸ DEFERRED (decided not to decide now) · ❌ REVERSED (was decided, then undone) · 🔶 PROPOSED (not yet agreed — do not build against it).

---

## Rules

1. **Only ACTIVE decisions may be built against.** A 🔶 PROPOSED row looks like a decision to everyone who finds it later. If it is not agreed, either leave it out or mark it clearly.
2. **Never rewrite a row.** If a decision changes, add a new row and set the old one to 🔄 SUPERSEDED, naming the new ID. A log you can edit is a log that lies about what happened.
3. **The rationale column is the point.** "Chose Postgres" is not a decision, it is an outcome. "Chose Postgres because the client's DBA supports it and migration cost from MySQL was 2 days" is a decision.
4. **Record who decided**, not who attended. If nobody can be named, it was not decided — it was discussed.
5. **Scope-changing decisions need a change request.** If the decision adds, removes or reshapes a deliverable, it also goes through `CHANGE_REQUEST_TEMPLATE.md`; record the CR id.
6. **Decisions made in conversation count.** The reason this log exists is that chat and calls are where most decisions actually happen. Append them the same day.
7. **Tie to requirements.** A `DEC-` that changes behaviour should be cited from the affected `FR-`/`BR-` row in `REQUIREMENTS_REGISTER.md`.

---

## What does not belong here

| Not a decision | Put it in |
| :--- | :--- |
| "We discussed payment options" | `MEETING_NOTES.md` → Summary |
| "We should consider caching" | `MEETING_NOTES.md` → Open questions |
| An architectural choice needing full context | `ADR_TEMPLATE.md` (and cite the ADR id here) |
| A belief that might be true | `ASSUMPTIONS_CONSTRAINTS.md` → `ASM-NNN` |
| A risk that might happen | `RISK_REGISTER.md` |

---

## Exit checklist

- [ ] Every row has a status; nothing is left ambiguous
- [ ] Superseded rows remain in place and name their replacement
- [ ] Every ACTIVE row names who decided
- [ ] Reasons are recorded, not just outcomes
- [ ] Scope-changing decisions cite a change request
- [ ] `PROPOSED` rows are visually distinct from `ACTIVE`
