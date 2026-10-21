# Solo Capacity Risk Acceptance

> **When**: `scripts/gates/classify-scale.sh` evaluates the project to **Large** (16–25 P0
> features / multi-service) with **no** non-delegable obligation — i.e. no
> formal external audit/certification/sector approval obligation and no legacy-core replacement. Baseline privacy duties (including UU PDP) are still required where applicable, but are not a non-delegable assurance obligation.
> Without this file the gate blocks with exit 2.
> **Where**: `docs/pm/SOLO-CAPACITY-RISK-ACCEPTANCE.md`
> **Who**: a real human. The AI agent may draft every field, but **`Accepted-By` and `Accepted-On`
> must be the human's own** — the agent may never accept delivery risk on the human's behalf
> (`docs/AUTHORITY.md`).

---

## What this accepts — and what it cannot

Large-scope solo delivery is a **schedule and quality risk**, not a legal one. This file records
that the human chose to carry it. The gate then continues (exit 5) but the override is **always
surfaced** — it never reads as a clean pass.

**This file cannot open the non-delegable block.** Formal external assurance obligations and legacy-core
replacement require a licensed third party (audit certificate, vendor engagement) that no
signature can manufacture. Those stay hard-blocked (exit 2) regardless of this file.

---

## 1. Capacity evidence (be concrete — these are the numbers being wagered)

```
- Evaluated-Scale: large
- P0-Feature-Count: [N — from Intake-P0-Features]
- Integrations: [count + names — from Intake-Integrations]
- Solo-Hours-per-Week: [realistic sustained hours; the classifier assumes 28]
- Weeks-To-Target: [planned duration]
- Total-Capacity: [hours/week × weeks]
- No-Non-Delegable-Obligation: yes   # if "no", STOP — this override is not available
```

---

## 2. Milestone plan (a Large scope solo is only viable when decomposed)

> The gate does not verify this section, but an undecomposed Large scope is how solo
> delivery fails quietly. Reuse `templates/00-pre-sales-enterprise/WBS_PHASING_TEMPLATE.md`.

| Phase | Scope (P0 count) | Target | Solo? |
|---|---|---|---|
| 1 | [e.g. Core backbone, 8–10 P0] | Scale: medium | yes |
| 2 | [e.g. Integrations, 6–8 P0] | Scale: medium | yes |
| 3 | [e.g. Legacy connector] | vendor package | advisor |

---

## 3. Risks explicitly accepted

- **Quality**: reduced review depth vs a team; the anti-slop scan and M07/M09 still apply.
- **Timeline**: estimates assume sustained hours; illness/scope drift move the date.
- **Bus factor**: a single maintainer; the M12 runbook is the mitigant.
- **Support**: warranty/SLA response times depend on the same one person.

---

## 4. Sign-off (HUMAN ONLY — the agent never fills these)

```
- Accepted-By: [real human name]
- Accepted-On: [YYYY-MM-DD]
- Scope-Version: [SCOPE_STATEMENT.md version or commit the acceptance covers]
- Re-Accept-If: [e.g. scope grows past 25 P0, or a compliance obligation appears]
```

> **Re-check trigger**: any growth past 25 P0 features, any new statutory-compliance or
> legacy-core answer in the Intake, or a change beyond the recorded `Scope-Version`, invalidates
> this acceptance — re-run the classifier and re-accept.
