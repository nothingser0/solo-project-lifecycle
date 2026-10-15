# Module 12: Warranty Period & Transition to Monthly Retainer / SLA Support

> **Templates to copy**: `templates/08-maintenance-ops/WARRANTY_POLICY_SMALL.md` (30-day simplified, MVP/small) · `WARRANTY_POLICY_TEMPLATE.md` · `SLA_RETAINER_CONTRACT_TEMPLATE.md`
> 📖 **Optional** (do NOT preload): `deep-dives/12_WARRANTY_SLA_RETAINER.md` (policy socialization details, hotfix git flow, proposal cron, full Bronze/Silver/Gold definitions)

Culminating phase: manage the bug-fix warranty metered, establish SLAs, handle production incidents, and convert one-off projects into recurring revenue (**Monthly Retainer / SLA Contract**).

---

## 1. Execution Cycle (Condensed)

```text
[ INPUT: Stamped BAST (M11) + system LIVE in production ]
  → STEP 1: Warranty boundaries — starts at BAST signing (not coding); 30/60/90 days (Small/Mid/Large);
    scope = pure bug fixes violating FSD/PRD only
  → STEP 2: SLA matrix & working hours — Mon–Fri 09:00–17:00 WIB;
    Sev 1: respond <2 h / resolve <24 h; Sev 2: <8 h / <48 h; Sev 3: next business day
  → STEP 3: Incident handling — Sentry/uptime triage → fix/* → hotfix staging → tag main;
    post-mortem on downtime
  → STEP 4: Retainer transition — Bronze/Silver/Gold proposal 14 days before warranty expiry;
    sign SLA contract; preventive maintenance schedule
  → OUTPUT: WARRANTY_POLICY.md & SLA_RETAINER_CONTRACT.md
```

## 2. "Warranty vs Retainer" Boundary

| Parameter | Warranty | Monthly Retainer |
| :--- | :--- | :--- |
| **Cost** | FREE (in initial contract) | PAID monthly, upfront |
| **Duration** | 30 / 60 / 90 calendar days | Ongoing (6–12 months) |
| **Scope** | **Pure bug fixes vs FSD/PRD only** | Monitoring, updates, backup checks, minor-feature hours |
| **New features** | **PROHIBITED** → CR | Included in monthly hours |
| **External causes** | **VOID** (3rd-party server changes / API format changes) | Handled from retainer hours |
| **Unauthorized changes** | **VOID** (Code/schema modified by client/3rd party terminates warranty immediately) | Billed at standard hourly recovery rate |

## 3. Step-by-Step (detail in deep dive)

1. **Policy socialization**: deliver `WARRANTY_POLICY.md` with the BAST (M11). Official channels only: bug reports via email / one coordination group; no personal-number messages outside working hours (except *Critical Down*).
2. **Hotfix flow**: Sentry triage → `git checkout -b fix/*` from `main` → local `pnpm run test:smoke` → merge `staging` verify → 🛑 **STOP: the human merges `main`, tags `v1.0.1`, and pushes `--tags`.** The agent prepares and verifies the fix on `fix/*`/`staging` but must not merge to `main` or tag — pushing to `main` is a production deploy, reserved to the human per M10 STEP 1 ("no agent auto-deploy").
3. **Retainer transition**: send proposal 14 days pre-expiry (cron: `0 9 * * * check_warranty_expiry_and_notify.sh`). Tiers — **Bronze**: monitoring, monthly patching, backup restore checks, 5 h consult; **Silver**: +15 h/month minor features, <4 h response business days; **Gold**: +20–30 h/month, <2 h Sev 1 response.
   - **Retainer Commercial Guardrails**: Retainer fees are strictly pre-paid monthly (due on the 1st, service suspended if unpaid by the 7th). Unused monthly hours do not rollover (*use-it-or-lose-it*, max 20% exception only if specified) to protect solo bandwidth against infinite backlog hoarding.
   - *Anti-burnout rule: solo devs MUST NOT commit to 24/7/365 weekend on-call without a rotating team.*

## 4. Scale & Waiver Rules

Small → `docs/pm/RUNBOOK_OPS.md` (Solo/Internal), 30-day warranty for clients, best-effort/24 h. Medium → `WARRANTY_POLICY.md` 60 days, 4–8 h response, 10–15 h retainer. Large → `WARRANTY_POLICY` + `INCIDENT_RESPONSE.md` mandatory, 90 days, 1–2 h response. Enterprise → A04/A00.

## 5. Deliverables (`docs/pm/`)

1. **`WARRANTY_POLICY.md`** — boundaries, working hours, covered-bug definitions; must include Warranty Coverage + Exclusions and the Severity/SLA matrix (solo/internal: replaced by **`RUNBOOK_OPS.md`**).
2. **`RUNBOOK_OPS.md`** — self-op runbook (backups, recovery drills, telemetry) for solo/internal products.
3. **`SLA_RETAINER_CONTRACT.md`** — monthly retainer agreement.
4. **`INCIDENT_RESPONSE.md`** — production incident SOP (mandatory Large scale).

## 6. [GATE] Exit Criteria

- [ ] 30/60/90-day warranty passed with no pending Severity 1 & 2 tickets.
- [ ] `WARRANTY_POLICY.md` issued (or `RUNBOOK_OPS.md` for solo/internal).
- [ ] Warranty sign-off signed or Monthly Retainer Contract (`SLA_RETAINER_CONTRACT.md`) signed.
- [ ] System stable and autonomous on production with active monitoring.

---

## 🛑 LIFECYCLE COMPLETION PROTOCOL

### STEP 0 — File Existence (BLOCKING)
Client: `test -f docs/pm/WARRANTY_POLICY.md`. Solo/Internal: `test -f docs/pm/RUNBOOK_OPS.md`. Missing → **STOP**, report `CRITICAL ERROR: File WARRANTY_POLICY.md was not created. Module 12 INCOMPLETE - lifecycle cannot be closed.` END TURN.

### STEP 1 — Content Validation
Checklist: period/coverage/exclusions documented (no placeholders, SLA matrix present); no pending Sev 1/2 tickets; monitoring active. Then determine closure type:

### STEP 2 — Closure Decision Matrix (MANDATORY)

| Closure Type | Condition | Action |
| :--- | :--- | :--- |
| **A. Client Project (Exit)** | Client maintains internally; assets handed over (M11); warranty expired | Lifecycle **100% COMPLETE**; offer optional retainer. END TURN. |
| **B. In-House / Ongoing Service** | Self-owned product, or retainer signed with continued development | **TRANSITION TO M13** (baseline metrics, feedback loop, growth experiments, scaling) — ask approval first. |
| **C. Retainer Maintenance-Only** | SLA for fixes & monitoring only; no features | Maintenance mode; lifecycle COMPLETE. END TURN. |

| Condition | → M13? | Reason |
|---|---|---|
| Client project, handover complete | ❌ | Client owns product |
| Client project + retainer signed | ✅ | Ongoing ops needed |
| In-house product (solo owner) | ✅ | Continuous growth |
| SLA maintenance-only | ❌ | Reactive mode |
| Warranty expired, no contract | ❌ | Project closed |

### STEP 3 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M12]
```

Execute `./scripts/gates/validate-gate.sh M12` (or `.ps1`). Exit 1 = incomplete; fix and re-run before declaring closure. Gate exit checklist: policy documented · no Sev 1/2 pending · closure type A/B/C determined · Type B needs user approval for M13 · Type A/C need final closure acknowledgment.
