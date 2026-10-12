# Module 11: [HANDOVER GATE] Final Settlement, Training, BAST, & Repository Handover

> **Templates to copy**: `templates/07-release-handover/BAST_EMAIL_SMALL.md` (remote/small) · `BAST_TEMPLATE.md` · `TRAINING_PLAN.md` · `USER_MANUAL_TEMPLATE.md` (Medium+ → `docs/USER_MANUAL.md`)
> 📖 **Optional** (do NOT preload): `deep-dives/11_HANDOVER_BAST.md` (training quota details, credential inventory, Git transfer steps, BAST signing, retrospective)

**CLOSURE & HANDOVER GATE**: TRANSFERRING GIT REPO OWNERSHIP, SERVER ROOT CREDENTIALS, AND SIGNING THE BAST ARE PROHIBITED BEFORE THE FINAL SETTLEMENT (100%) HAS CLEARED AND IS CONFIRMED IN THE DEVELOPER'S BANK ACCOUNT. Execute metered training, hand over `USER_MANUAL.md`, transfer repo securely, and sign the **Berita Acara Serah Terima (BAST)** that starts the Warranty Period (M12).

---

## 1. Execution Cycle (Condensed)

```text
[ INPUT: System LIVE + GO_LIVE_REPORT.md (M10) ]
  → STEP 1: Issue final settlement invoice (Milestone 3: 30%, or 50% on Small fast-track); due ≤7 business days.
    CRITICAL SEQUENCE: 100% payment RECEIVED → THEN point official client DNS & train
  → STEP 2: Training (payment-confirmed prerequisite): 1 staff session + 1 super-admin session;
    record videos + hand over USER_MANUAL.md; extra sessions = extra fees
  → STEP 3: [GATE] Cash Flow Gate — bank statement checked. Paid in full → Step 4;
    NOT received → HOLD repo transfer & root accounts
  → STEP 4: Git ownership transfer to client org; credentials via encrypted channels (Bitwarden/1Password)
  → STEP 5: BAST signing — Rp 10,000 meterai / e-Meterai, co-signed by Client Single PIC;
    warranty clock (M12) starts
  → OUTPUT: Signed BAST, transferred repo, 100% paid
```

## 2. Golden Rule: "No Pay, No Root"

Finance departments delay final payments once they control the repo/servers; the developer's only leverage is **root accounts + repo ownership**. Staged handover: at go-live grant only **Standard User / Operational Admin** app access; during payment wait the client may operate the system daily but the developer retains infrastructure access; after 100% clears, transfer repo ownership + root credentials.

## 3. Step-by-Step (detail in deep dive)

1. **Training quota**: max **2 × 60-min sessions** (staff operations; super-admin management). Record sessions; deliver recordings + `USER_MANUAL.md` for self-service onboarding.
2. **Credential handover (zero plaintext)**: never WhatsApp/plaintext email. Use Bitwarden Send / 1Password / Yopass (self-destructing links) + shared vault for the warranty period. Hand over: prod & staging admin logins, DB credentials, API keys (payment/email/storage), hosting/cloud, domain/DNS, Git access — inventory in `HANDOVER_PROTOCOL.md`. Client rotates all passwords within 7 days.
3. **Git transfer**: GitHub/GitLab → "Transfer Ownership" → client organization; client PIC promoted to Owner; developer PATs removed from client CI/CD.
4. **BAST signing**: deliverables breakdown (source code, live URL, manual), acceptance sign-off, formal warranty start/end dates; Rp 10,000 meterai or e-Meterai; co-signed with Client Single PIC.

## 4. Scale & Waiver Rules

Small → 1 optional Meet session, quickstart guide, `BAST_EMAIL_SMALL.md`. Medium → 2 sessions, formal `USER_MANUAL.md`, stamped BAST. Large → per-department sessions + LMS, `HANDOVER_PROTOCOL.md` mandatory, cloud tenant transfer. Enterprise → A00 advisory dossier. **`Delivery: solo | internal` (Solo SaaS): client BAST handover WAIVED** — retain repo ownership & credentials; the gate validator accepts this automatically.

## 5. Post-Project Retrospective (optional, internal)

1–2 h after final payment using `templates/08-maintenance-ops/PROJECT_RETROSPECTIVE_TEMPLATE.md` (went well / went wrong / lessons / process improvements). Recommended every project.

## 6. Deliverables

`docs/USER_MANUAL.md` (or root); **`docs/pm/HANDOVER_PROTOCOL.md`** (transfer report + account inventory); **`docs/pm/BAST.md`** (stamped certificate activating warranty; Small: `BAST_EMAIL_SMALL.md`); bank-statement proof of 100% settlement.

## 7. [GATE] Exit Criteria

- [ ] **Final settlement (100%) cleared and confirmed in the Developer's bank account.**
- [ ] Training sessions delivered per quota; `docs/USER_MANUAL.md` delivered.
- [ ] Git repo + production credentials transferred to the client organization.
- [ ] **Official stamped BAST (`docs/pm/BAST.md`) signed by both parties.**

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

### STEP 0 — File Existence (BLOCKING)
`test -f docs/pm/BAST.md` (Small accepts `docs/pm/BAST_EMAIL_SMALL.md`). Missing → **STOP**, report `CRITICAL ERROR: File BAST.md was not created. Module 11 FAILED - cannot proceed to Module 12 (Warranty & SLA).` END TURN.

### STEP 1 — Content & Payment Validation
1. No Module 12 (warranty) kickoff until this [GATE] passes and the user approves — M11 is a contractual stop (SKILL.md rule 3); "No Pay, No Root" applies throughout.
2. Checklist: BAST has signature + duty stamp + warranty period (no blank signature lines, no placeholders); **payment 100% received** (statement/screenshot) — BAST must attest settlement, not arrears; repo transferred; credentials handed over encrypted.

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M11]
```

Execute `./scripts/gates/validate-gate.sh M11` (or `.ps1`). Exit 1 = incomplete; fix and re-run. **DO NOT transfer repo/credentials until 100% payment is confirmed.**

### STEP 3 — STOP & Wait for Approval
Display closure summary (signed BAST, warranty dates, retainer offering) and **END TURN**, prompting:

> *"The project has been officially handed over and closed (BAST signed). The official warranty period runs from today until [End Date] (Duration: 30 days for small scale / 60 days for mid-scale / 90 days for large scale). Would you like to draft the warranty policy and Monthly Retainer SLA proposal (Module 12)?"*
