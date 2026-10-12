# Module 10: Deployment & Production Go-Live (Official Launch to Production Environment)

> **Templates to copy**: `templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md` · `ROLLBACK_PLAN_TEMPLATE.md` · `GO_LIVE_REPORT_TEMPLATE.md`
> 📖 **Optional** (do NOT preload): `deep-dives/10_DEPLOYMENT_PRODUCTION.md` (full ENV checklist & scripts, manual clean-release git procedure, DNS/SSL steps, migration options with SQL, mobile workflow, enterprise CAB routing)

Promotes UAT-passed code from `staging` to `main`, configures production infra (DNS, SSL TLS 1.3, production DB), runs zero-downtime migrations + observability, and verifies until officially **LIVE ON PRODUCTION**.

---

## 1. Execution Cycle (Condensed)

```text
[ INPUT: Signed UAT report (M09) + stable staging branch ]
  → STEP 1: [GATE] Go/No-Go — signed UAT; build & smoke exit 0; no agent auto-deploy (human deploys);
    no Friday/holiday releases; pre-migration DB snapshot
  → STEP 2: Clean release merge staging ──► main (harness stripped); tag v1.0.0; push → CI/CD
  → STEP 3: DNS A/CNAME + SSL TLS 1.3 (Grade A); .env.production live keys; sandbox ──► production
  → STEP 4: Zero-downtime DB migration + import verified client data (M08 result)
  → STEP 5: Sentry (env=production), uptime healthcheck /api/health @60s, backup schedule verified
  → STEP 6: PVT on public domain ──► GO_LIVE_REPORT.md ──► Module 11
```

## 2. Golden Rules

1. **No Friday Deployment**: prohibited Friday PM / weekends / holiday eves → reschedule Tuesday–Thursday 09:00–14:00; ideal **Tue/Wed 09:00–11:00**.
2. **Zero sandbox keys in prod** — live accounts only (payment, SMTP, storage).
3. **Rollback plan < 15 min** verified before deploy; no deployment before build + migrations + core tests exit 0 locally.

## 3. Step-by-Step (detail & commands in deep dive)

1. **Pre-flight**: UAT signature valid; production ENV live-key verified (non-emitting checks in deep dive: `sk_live_` prefix, no `sandbox`, prod DB/SMTP/bucket, secrets ≥32 chars & rotated, CORS = prod domain, Sentry env=production). Scan: `grep -E "sk_test|sandbox|test_" .env.production` must be empty — **STOP if not**. Rollback dry-run passed in staging; snapshot via `pg_dump`.
2. **Clean release**: `main` = production code + client-facing specs ONLY — never the harness (`AGENTS.md`, `TODO.md`, `docs/pm/`, `docs/qa/`). Use `./scripts/release/build-clean-release.sh v1.0.0` (exclusions: `scripts/release/release-exclude.txt`); verify `git ls-files | grep -iE "AGENTS|TODO|docs/pm|docs/qa"` is empty before push; then push `main` + tag `v1.0.0`.
3. **DNS & SSL** — 🛡️ **LEVERAGE RULE (`Delivery: client`)**: Milestone 3 (Final 30%) is payable **before** DNS pointing & BAST (30/40/30 contract). Deploy to a developer-controlled server for PVT + `GO_LIVE_REPORT.md`; pointing `app.client.com` and master credentials are held as commercial leverage until 100% payment clears in M11. `Delivery: solo | internal | portfolio` points the primary domain directly. Verify propagation; SSL Grade A (TLS 1.3).
4. **Data import** (M08 result; greenfield bypass → seed-data check only): A) ETL re-run to prod (recommended); B) staging dump — verify zero test data first (`%test%` / `Test Document` / `@example.com` = 0, STOP if found); C) manual CSV (<100 rows). Post-check: row counts match M08 reconciliation, no NULL timestamps, no orphaned FKs.
5. **Schema migration**: `pnpm db:migrate` against prod — **additive only**; `DROP COLUMN`/`TRUNCATE` prohibited.
6. **Observability**: Sentry DSN active; uptime monitor on `/api/health`; alert bots (Telegram/WhatsApp).
7. **PVT**: login flow; create 1 document → PDF in prod bucket; 1 real low-nominal payment (e.g. Rp 10.000 QRIS) for the prod webhook; compile into **`GO_LIVE_REPORT.md`**.
8. **Polish re-check on the production domain**: re-run rows 1–22 of `docs/qa/POLISH_AUDIT.md` (or `POLISH_AUDIT_TEMPLATE.md` for Small) against the live domain — favicon, OG preview image, page title, console errors, image weight, plus rows 21–22 (slop comments, race conditions) against the deployed build. CDN/minification/env differences surface new tells that staging hid. Record the delta in `GO_LIVE_REPORT.md`.

## 4. Mobile (Android/iOS) — Summary

Full workflow in deep dive. Keystore `.jks` loss = permanent update lockout; Play review 24–72 h (phased 10→50→100%), App Store 24–48 h (7-day phased); TestFlight/Internal Sharing beta before public; quote go-live from *Ready for Sale* status; mandatory force-update endpoint + OTA (Expo Updates / Shorebird).

## 5. Scale Adaptation (one line each)

Small → PaaS, rolling restart, git-revert rollback. Medium → Cloud Run/VPS, blue-green, snapshot swap. Large → multi-region, canary, mandatory `ROLLBACK_PLAN.md` (<15 min drill). Enterprise → **routed to A03/A00** (CAB RFC 3 days pre-deploy, DR/BCP, vendor runbook review).

## 6. Deliverables (`docs/pm/`)

1. **`DEPLOYMENT_PROTOCOL.md`** — runbook, topology, migration steps, PVT checklists.
2. **`GO_LIVE_REPORT.md`** — PVT proof, live endpoints, SSL attestation.
3. **`ROLLBACK_PLAN.md`** — <15-min recovery (mandatory Large scale).

## 7. Gate Exit Criteria [GATE]

- [ ] `main` tagged SemVer (`v1.0.0`); domain live with SSL/TLS 1.3.
- [ ] DB migration without data loss; all ENV live (not sandbox).
- [ ] PVT real-transaction test 100% PASS; uptime monitoring + Sentry active.

---

## 🛑 EXIT [GATE] PROTOCOL

### STEP 0 — File Existence (BLOCKING)
`test -f docs/pm/GO_LIVE_REPORT.md`. Missing → **STOP**, report `CRITICAL ERROR: File GO_LIVE_REPORT.md was not created. Module 10 FAILED - cannot proceed to Module 11 (Handover & BAST).` END TURN.

### STEP 1 — Content Validation
1. Never hand over repos/root passwords before M11's 100%-payment gate (M11 enforces this); no M11 tooling until this gate passes.
2. Checklist: PVT rows all PASS (no `FAIL`, no rollback/failure status, no placeholders); domain + SSL live; monitoring active; production transaction verified.

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M10]
```

Execute `./scripts/gates/validate-gate.sh M10` (or `.ps1`). Exit 1 = incomplete; fix and re-run.

### STEP 3 — STOP & Wait for Approval
Present go-live status and **END TURN**, asking — *(Client)*: ready to issue the final 30% settlement invoice before official domain pointing & repo transfer in Module 11? *(Solo/Internal)*: ready to proceed to Module 12 (Operations & Runbook)?
