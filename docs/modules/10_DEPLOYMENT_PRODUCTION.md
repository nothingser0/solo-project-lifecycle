# Module 10: Deployment & Production Go-Live (Official Launch to Production Environment)

> **Templates to copy**: `templates/07-release-handover/DEPLOYMENT_PROTOCOL_TEMPLATE.md` · `ROLLBACK_PLAN_TEMPLATE.md` · `GO_LIVE_REPORT_TEMPLATE.md`
> 📖 **Optional** (do NOT preload): `deep-dives/10_DEPLOYMENT_PRODUCTION.md` (full ENV checklist & scripts, manual clean-release git procedure, DNS/SSL steps, migration options with SQL, mobile workflow, enterprise CAB routing)

Promotes the human-approved release candidate, configures the selected production platform, and records deployment and post-deployment verification evidence. The project owner executes production deployment and makes the Go/No-Go decision; platform-specific steps apply only when relevant.

---

## 1. Execution Cycle (Condensed)

```text
[ INPUT: M09 decision where applicable + approved release candidate + project release policy ]
  → STEP 1: [GATE] Human Go/No-Go; CI/build/security checks meet project policy; freeze exceptions recorded
  → STEP 2: Human executes approved release workflow; record commit, artifact, version, and deployment target
  → STEP 3: Apply platform-specific configuration, secrets, domain, and schema/data changes as applicable
  → STEP 4: Roll out using the selected strategy (standard, staged, canary, or blue-green); stop/rollback triggers agreed
  → STEP 5: Verify critical flows, telemetry, alerts, and service objectives against project targets
  → STEP 6: Record PVT evidence, release notes, and final status in GO_LIVE_REPORT.md → Module 11/12
```

## 2. Golden Rules

1. **Release window**: use the window and freeze rules agreed for the project; avoid periods without sufficient response/rollback coverage.
2. **Production secrets**: use production-scoped secrets from the approved secret manager; never copy credentials into docs, chat, logs, or source control. Verify the selected provider's production mode when the service has sandbox/live modes.
3. **Rollback readiness**: define measurable stop/rollback triggers, an owner, and a recovery procedure that matches the platform and data-change reversibility. Record tested recovery time; do not assume a universal time target.
4. **DNS and TLS**: apply only to public-domain services; follow registrar/hosting guidance and the project's availability needs for TTL, certificate, and cutover.
5. **Health checks**: define checks for the service's critical dependencies. Avoid unsafe writes or exposing sensitive dependency details from public health endpoints.
6. **Progressive rollout**: use canary, phased rollout, blue-green, or feature flags when supported and proportionate. Define observation period and abort thresholds before starting; otherwise document the standard rollout and rollback path.

## 3. Step-by-Step (detail & commands in deep dive)

1. **Pre-flight**: confirm the required M09 decision, release candidate/build, green CI and required M07 security/quality evidence under the project policy. A human verifies production environment and secret references without exposing values. Confirm backup/recovery steps when data changes, and record any freeze exception.
2. **Release artifact**: follow the approved release workflow. Record source commit, artifact/version, environment, CI result, release notes/changelog, and human release owner. The agent must not push, merge, tag, or deploy to production.
3. **Domain, TLS & edge**: apply only where relevant. Confirm ownership, DNS target, certificate, and required edge protections with the human operator. For client delivery, follow the signed contract and M11 handover/payment terms; no commercial milestone rule applies universally.
4. **Data import** (M08 result; greenfield bypass → seed-data check only): use the approved ETL, dump, or manual import path. Verify test-data exclusion where relevant and reconcile counts, constraints, and rejected rows against M08.
5. **Schema/data changes**: run only reviewed migration steps. Use expand-contract or another safe strategy where needed; destructive or irreversible changes require a human-approved backup, recovery, and data-impact plan.
6. **Observability**: verify selected error tracking, logs, metrics, uptime checks, and alerts where applicable. Trigger a safe test alert and record receipt; do not assume a vendor or polling interval.
7. **PVT**: verify critical user flows on the production target with safe, authorized test data. For payment/webhook systems, use the provider-approved verification path; a real charge is optional and requires explicit human authorization plus a refund/reversal plan. Record evidence in **`GO_LIVE_REPORT.md`**.
8. **Production quality recheck**: repeat only applicable M07 checks whose runtime behavior may change in production; record deltas and non-applicable checks with a reason.
9. **Production web-quality recheck**: verify applicable M02 performance budgets and accessibility behavior; check SEO/metadata only on public, indexable pages. Reuse M07 evidence and record production deltas.

## 4. Mobile (Android/iOS) — Summary

Use the selected mobile platform deployment and signing workflow. Keep signing material in an approved vault, validate the store-distributed build, and record current review status and phased-rollout options. Version compatibility or OTA updates are conditional on platform support and project needs.

## 5. Scale Adaptation (one line each)

Small → managed platform and documented prior-version rollback. Medium → choose rollout method based on downtime and data risk. Large → written rollout/rollback plan and human release approval. Enterprise → routed to A03/A00 for CAB, DR/BCP, and vendor runbook review. Do not impose patterns or recovery-time targets unsupported by the platform.

## 6. Deliverables (`docs/pm/`)

1. **`DEPLOYMENT_PROTOCOL.md`** — project-specific runbook, selected platform/topology, migration and rollout steps.
2. **`GO_LIVE_REPORT.md`** — release identity, verification evidence, telemetry, exceptions, and decision.
3. **`ROLLBACK_PLAN.md`** — recovery procedure and tested recovery time (mandatory Large scale).

## 7. Gate Exit Criteria [GATE]

- [ ] Human release decision is recorded; release commit/artifact/version and required CI/security checks are identified.
- [ ] Applicable environment, domain/TLS, migration, and secret checks are verified without exposing secret values.
- [ ] Critical PVT checks have results/evidence; failures and exceptions have an explicit disposition. Rollout strategy, observation period, stop triggers, owner, and rollback/recovery path are recorded.

---

## 🛑 EXIT [GATE] PROTOCOL

### STEP 0 — File Existence (BLOCKING)
`test -f docs/pm/GO_LIVE_REPORT.md`. Missing → **STOP**, report `CRITICAL ERROR: File GO_LIVE_REPORT.md was not created. Module 10 FAILED - cannot proceed to Module 11 (Handover & BAST).` END TURN.

### STEP 1 — Content Validation
1. Follow M11 handover and any signed contractual payment gates before transferring repositories, root access, or credentials; do not infer a universal payment schedule.
2. Confirm critical PVT results/evidence, project targets, applicable domain/TLS and monitoring checks, and documented dispositions for failures or exceptions.

### STEP 2 — Gate Verification (MANDATORY)

```
[PASTE RAW OUTPUT OF: ./scripts/gates/validate-gate.sh M10]
```

Execute `./scripts/gates/validate-gate.sh M10` (or `.ps1`). Exit 1 = incomplete; fix and re-run.

### STEP 3 — STOP & Wait for Approval
Present evidence-based go-live status and **END TURN**. Production deployment, Go/No-Go, DNS pointing, and real financial transactions remain human-only actions and decisions. Continue to handover or operations only after the responsible human confirms the next step.
