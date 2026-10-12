# Module 09: [VALIDATION GATE] UAT & Client Sign-Off on Staging

> **Templates to copy**: `templates/06-qa-uat/UAT_WORKBOOK_SMALL.md` · `UAT_SIGNOFF_SMALL.md` (Small/Fast-track) · `UAT_WORKBOOK_TEMPLATE.md` (Medium+)
> 📖 **Optional** (do NOT preload): `deep-dives/09_UAT_CLIENT_SIGNOFF.md` (training/demo/feedback templates, full client-protection scripts, full severity matrix, deemed-acceptance clause)

**BLOCKING VALIDATION GATE**: DEPLOYMENT TO PRODUCTION OR PRIMARY-DOMAIN POINTING IS PROHIBITED BEFORE THIS GATE PASSES. The Client Single PIC tests on Staging against `PRD.md` acceptance criteria; defects are triaged, scope creep deflected, and the **UAT Sign-Off Report (Berita Acara UAT)** is signed.

---

## 1. Execution Cycle (Condensed)

```text
[ INPUT: Staging ready & data populated — M07 SIT pass REQUIRED; M08 done or bypassed (greenfield) ]
  → STEP 1: Convert PRD acceptance criteria to layman test steps; provision client tester accounts
  → STEP 2: Kickoff (30-min walkthrough demo); lock window (max 5–7 business days); apply Deemed Acceptance
  → STEP 3: Triage — real bugs (Sev 1–3) vs scope creep (→ Change Request)
  → STEP 4: Fix valid bugs on fix/* → merge staging → PIC retests → RESOLVED in UAT_DEFECT_LOG.md
  → STEP 5: Sign UAT_SIGNOFF_REPORT.md → [GATE] Module 10
```

---

## 2. Solo Dev Protection Rules (full scripts in deep dive)

1. **Deflect features-as-bugs**: review agreed PRD/FSD; anything documented Out-of-Scope is `Passed UAT` — offer a formal CR form.
2. **Deemed Acceptance**: window capped 5–7 business days; no testing/written defects within 10 business days of the Staging link = legally *Deemed Accepted*; production deploy + final invoice may proceed.
3. **Iteration limit**: max **2 UAT cycles** per contract; Sev 3/4 cosmetic defects never block sign-off (deferred to warranty); 7 calendar days of client silence = **DEEMED ACCEPTED**.

## 3. Defect Severity Matrix

| Severity | Definition | Response SLA | Sign-off impact |
| :--- | :--- | :---: | :--- |
| **1 (Blocker)** | Crash, data corruption, payment failure, broken core flow | < 24 h | **BLOCKS** |
| **2 (Major)** | Feature ≠ FSD; workaround exists | < 48 h | Fix before production |
| **3 (Minor)** | Typo, margin, contrast | < 72 h | Does NOT block (warranty) |
| **Out-of-Scope (CR)** | New workflow/schema outside PRD | Same day | Rejected → CR form |

## 4. Scale Adaptation (detail in deep dive)

- **Small**: M09-LITE (`docs/qa/UAT_SIGNOFF_SMALL.md`), 2–3 days. **Tester rule**: for `Scale: small` + `Delivery: solo|portfolio|internal`, the external-tester requirement is **replaced by 1 named self-tester** (the founder/developer testing as an end user), recorded by name in `UAT_SIGNOFF_SMALL.md` — matching gate behavior. An external tester is still recommended when one is available, never mandatory at this scale.
- **Medium**: full `docs/pm/UAT_SIGNOFF_REPORT.md`, 5–7 days, PIC + staff.
- **Large**: full + per-division workbook, 10–14 days, client QA team.
- **Enterprise**: routed to A04/A00. **`Delivery: solo | internal` (Solo SaaS): UAT WAIVED** — self-test on staging; the gate validator accepts this automatically.

## 5. Deliverables (in `docs/pm/`)

1. **`docs/pm/UAT_WORKBOOK.md`** — scenario workbook + defect log (`UAT_WORKBOOK_TEMPLATE.md`; light: `UAT_WORKBOOK_SMALL.md`).
2. **`docs/pm/UAT_SIGNOFF_REPORT.md`** — signed acceptance report (`UAT_SIGNOFF_TEMPLATE.md`; Small: `docs/qa/UAT_SIGNOFF_SMALL.md`).

## 6. Gate Exit Criteria [GATE]

- [ ] All scenarios PASS, or all Severity 1 & 2 findings RESOLVED.
- [ ] Stability: 0 unresolved Sev 1; error rate < 1%; uptime ≥99% (48 h); core flows unblocked.
- [ ] Feature requests split into written CRs.
- [ ] **Client Single PIC signed `docs/pm/UAT_SIGNOFF_REPORT.md`.**

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

### STEP 0 — File Existence (BLOCKING)
`test -f docs/pm/UAT_SIGNOFF_REPORT.md` (Small: `docs/qa/UAT_SIGNOFF_SMALL.md`). Missing → **STOP**, report `CRITICAL ERROR: File UAT_SIGNOFF_REPORT.md was not created. Module 09 FAILED - cannot proceed to Module 10 (Production Deployment).` END TURN.

### STEP 1 — Content Validation
1. No merge to `main` or production deploy before this [GATE] passes — production deployment is prohibited until UAT is signed (SKILL.md rule 3; contractual stop).
2. Checklist: signature + date present, no blank signature lines; Sev 1 & 2 RESOLVED; scope creep → CR; explicit attestation (APPROVED / PASSED / UAT PASS).

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M09]
```

Execute `./scripts/gates/validate-gate.sh M09` (or `.ps1`). Exit 1 = incomplete; fix and re-run. **DO NOT deploy to production until UAT is signed.**

### STEP 3 — STOP & Wait for Approval
Present UAT closure status and **END TURN**, asking:

> *"The UAT Sign-Off Report (`docs/pm/UAT_SIGNOFF_REPORT.md`) has been officially signed. The system is authorized to merge into the `main` branch. Are you ready to execute the official launch to the Production server in Module 10 (Deployment & Production Go-Live)?"*
