# Module 09: [VALIDATION GATE] UAT & Client Sign-Off on Staging

> **Templates to copy**: `templates/06-qa-uat/UAT_WORKBOOK_SMALL.md` · `UAT_SIGNOFF_SMALL.md` (Small/Fast-track) · `UAT_WORKBOOK_TEMPLATE.md` (Medium+)
> 📖 **Optional** (do NOT preload): `deep-dives/09_UAT_CLIENT_SIGNOFF.md` (training/demo/feedback templates, full client-protection scripts, full severity matrix)

**BLOCKING VALIDATION GATE**: DEPLOYMENT TO PRODUCTION OR PRIMARY-DOMAIN POINTING IS PROHIBITED BEFORE THIS GATE PASSES. The Client Single PIC tests on Staging against `PRD.md` acceptance criteria; defects are triaged, scope creep deflected, and the **UAT Sign-Off Report (Berita Acara UAT)** is signed.

---

## 1. Execution Cycle (Condensed)

```text
[ INPUT: Staging ready & data populated — M07 SIT pass REQUIRED; M08 done or bypassed (greenfield) ]
  → STEP 1: Convert PRD acceptance criteria to layman test steps; provision client tester accounts
  → STEP 2: Kickoff; name testers, approver, and any veto authority; agree the test window and decision process in the SOW/project plan
  → STEP 3: Triage — real bugs (Sev 1–3) vs scope creep (→ Change Request)
  → STEP 4: Fix valid bugs on fix/* → merge staging → PIC retests → RESOLVED in UAT_DEFECT_LOG.md
  → STEP 5: Sign UAT_SIGNOFF_REPORT.md → [GATE] Module 10
```

---

## 2. Solo Dev Protection Rules (full scripts in deep dive)

1. **Deflect features-as-bugs**: review agreed PRD/FSD; anything documented Out-of-Scope is `Passed UAT` — offer a formal CR form.
2. **Acceptance window**: record the agreed start/end, response expectations, and escalation path in the signed SOW/project plan. Deemed acceptance is never inferred by this workflow; use it only when explicit contract language has been reviewed for the applicable agreement and jurisdiction. Silence alone does not authorize the agent or developer to mark UAT approved or deploy.
3. **Iteration limit**: record any contractual cycle limit; do not invent a default. Sev 3/4 cosmetic defects may be deferred only with the Client Single PIC's documented approval and an owner/target date.
4. **Conditional Sign-Off with Punch List (Defect Containment)**:
   - If non-critical defects (normally Sev 3/4; Sev 2 only if release policy allows) remain at the end of the UAT window, the Client Single PIC may execute a **Conditional Sign-Off** containing an explicit **Punch List**.
   - A Punch List binds the Developer to resolve listed minor items during the 30-day warranty period (M12) without blocking production deployment or milestone payment release.
5. **Defect Verification Evidence**:
   - Client defect submissions MUST include verifiable reproduction evidence (exact input payload, timestamp, screenshot, or video recording).
   - If a report is not yet reproducible, record it as `NEEDS REPRODUCTION`, capture the missing evidence, and agree who will investigate. Lack of a repro alone does not prove the issue harmless or set its severity; the PIC decides disposition under the release policy.

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

The workbook maps every in-scope acceptance criterion to one or more test scenarios. Each scenario records its requirement/AC ID, preconditions, business-language steps, expected result, tester, observed result, status, and evidence. Use Given/When/Then when it clarifies the behavior; it is optional for manual UAT.

## 6. Gate Exit Criteria [GATE]

- [ ] Every in-scope P0 acceptance criterion is mapped to a scenario and PASS, or has a documented exception approved by the authorized PIC under the release policy. All other applicable scenarios have a recorded result and evidence; blocked/untested items are dispositioned.
- [ ] Stability and service-level results meet the project's M02 NFR and M10 release criteria; do not apply universal error-rate or uptime thresholds absent an agreed target.
- [ ] Feature requests split into written CRs.
- [ ] Every in-scope acceptance criterion is mapped to a UAT scenario; untested, blocked, failed, and N/A cases have an explicit disposition and evidence/reason.
- [ ] Tester, Client Single PIC approver, and any release veto authority are named; final Go/No-Go and residual risks are documented.
- [ ] **Client Single PIC signed `docs/pm/UAT_SIGNOFF_REPORT.md` (or approved Small template).**

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
