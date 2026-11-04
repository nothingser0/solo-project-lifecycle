# Module 10 Deep Dive: Production Deployment — ENV Verification, Clean Release, Data Migration Options & Mobile Workflows

## Contents

- [Step 1 (Detail): Verify Production Environment Variables](#step-1-detail-verify-production-environment-variables)
- [Step 2 (Detail): Clean Release Merge — Manual Procedure](#step-2-detail-clean-release-merge-manual-procedure)
- [Step 3 (Detail): Contractual Client DNS and Handover Conditions](#step-3-detail-contractual-client-dns-and-handover-conditions)
- [Step 4 (Detail): Import Verified Client Real Data — 3 Options](#step-4-detail-import-verified-client-real-data-3-options)
- [Step 5 (Detail): Schema Migration](#step-5-detail-schema-migration)
- [Section 4 (Full): Mobile App Deployment Specific Workflow (Android & iOS)](#section-4-full-mobile-app-deployment-specific-workflow-android-ios)
- [Enterprise Scale Advisory (A03/A00)](#enterprise-scale-advisory-a03a00)


> Companion to `docs/modules/10_DEPLOYMENT_PRODUCTION.md` (runbook). This file holds the detailed execution steps; the runbook keeps a condensed summary.

## Step 1 (Detail): Verify Production Environment Variables

Before production cutover, the human operator verifies environment and secret configuration using the selected provider and stack tooling. Prefer non-emitting checks that return pass/fail without printing secret values. Never paste production secrets or connection strings into a document, command example, chat, or shell history.

**Environment checklist**:
- [ ] Required production variables are present in the approved secret manager and scoped to the right environment.
- [ ] Provider integrations use production mode where a sandbox/live distinction exists.
- [ ] Database, email, storage, CORS, and callback targets match the production environment where applicable.
- [ ] Signing, encryption, and session material meet the selected stack's security guidance and is not reused from development.
- [ ] Production monitoring and alert configuration uses the production environment.
- [ ] No test credentials or sandbox endpoints are configured for production integrations.

**Stop the cutover** if any required value is missing, points to a non-production service, or cannot be safely verified.

**Rollback Plan Dry-Run Verification**:
- [ ] Recovery procedure and rollback/forward-fix paths tested in an appropriate non-production environment, where feasible.
- [ ] Migration recovery path tested where feasible; document irreversible changes and human-approved recovery alternatives.
- [ ] Record the project-approved recovery-time target and the tested result, or state that no target is defined.

**Migration risk**: schema changes may be irreversible or incompatible with older application versions. Validate the selected recovery path in a non-production environment and document data loss or forward-fix risks before release.

**Pre-deploy DB snapshot** (if updating an existing system):
```bash
pg_dump -U postgres -d [production_database] -F c -b -v -f "backup-pre-deploy-[date].dump"
```

---

## Step 2 (Detail): Clean Release Merge — Manual Procedure

> **Goal**: `main` must contain ONLY production code + client-facing specs — never the AI harness
> (`AGENTS.md`, `TODO.md`, `docs/pm/`, `docs/qa/`, …) nor internal process documents.
> Full runbook: `RELEASE_WORKFLOW.md` (root harness). Exclusions live in `scripts/release/release-exclude.txt`.

**Why not `git merge --no-ff staging`?** A plain merge carries the harness from `dev` straight into
`main`. `.gitignore` cannot remove files that are already tracked. Harness must be untracked
(`git rm --cached`) on a temporary release branch BEFORE merging.

**Human-only release procedure**: An agent must not execute build/release, merge, tag, push, or deployment commands. The human release owner follows protected-branch and approval policy; use a PR/review workflow where required.

**Automated release tooling (human-operated)**:
```bash
./scripts/release/build-clean-release.sh v1.0.0            # Git Bash / macOS / Linux
.\scripts\release\build-clean-release.ps1 -Version v1.0.0  # Windows PowerShell
```

**Manual**:
```bash
# 1. Build a release branch from dev
git checkout dev
git checkout -B release/v1.0.0

# 2. Strip dev-only artifacts on the release branch (own commit)
while IFS= read -r f; do
  f="${f%$'\r'}"; [ -z "$f" ] && continue
  case "$f" in \#*) continue ;; esac
  git rm -r --cached --quiet "$f" 2>/dev/null || true
done < scripts/release/release-exclude.txt
git commit -m "chore(release): strip dev-only artifacts for v1.0.0"

# 3. Squash-merge into main and commit one clean release commit
git checkout main
git merge --squash --allow-unrelated-histories release/v1.0.0
git commit -m "release: v1.0.0"

# 4. VERIFY (mandatory) — abort if any harness path is still tracked
git ls-files | grep -iE "AGENTS|CONTEXT|TODO|LEARNINGS|docs/pm|docs/qa|scripts/release" \
  && echo "❌ HARNESS PRESENT — DO NOT PUSH" || echo "✅ CLEAN"

# 5. Delete release branch, push, tag
git branch -D release/v1.0.0
git push origin main
git tag -a v1.0.0 -m "Release Production v1.0.0 - Go-Live"
git push origin v1.0.0
```

> `--allow-unrelated-histories` is required when `main` was created as an orphan (no shared parent);
> it is harmless otherwise. If a PR/review workflow is required instead of a direct push, keep the
> release branch (`--keep-branch`) and open the PR — but note the harness will still appear in
> `main`'s *history* via the old `dev` commits (the *tree* stays clean).

---

## Step 3 (Detail): Contractual Client DNS and Handover Conditions

> For projects using the supplied 30/40/30 SOW terms, apply the agreed milestone and DNS/handover conditions in that signed contract. Other projects follow their own signed terms.
> - In Module 10, the developer deploys to a **developer-controlled production/preview server** to execute PVT testing and produce `GO_LIVE_REPORT.md`.
> - For client delivery, follow the signed contract and approved handover terms for DNS, platform ownership, and credential transfer. Never use access or credentials as leverage outside that agreement.
> - For `Delivery: solo | internal | portfolio`, configure the primary production domain directly.

**DNS & SSL steps**:
1. Log into the domain provider's DNS dashboard (Cloudflare, Niagahoster, Route53).
2. Point DNS Records (Staged / Production based on delivery model):
   - `Type A`: `@` → Production Server IP / Load Balancer.
   - `CNAME`: `app` or `www` → hosting domain (Vercel / Cloud Run).
3. Verify DNS propagation using `dig` or `nslookup`.
4. Verify certificate validity and TLS configuration against the selected provider and the project security policy; record the evidence.

---

## Step 4 (Detail): Import Verified Client Real Data — 3 Options

> **M08 CONDITIONAL BYPASS**: M08 Data Migration is skipped for greenfield projects (no legacy data). If M08 executed, follow the steps below; if skipped, jump to schema migration and verify seed data only.

**OPTION A: Re-run ETL Script to Production** (Recommended — Fresh Import)

If source data (Excel/CSV) is still available and unchanged since UAT:

```bash
# Human operator runs the approved ETL using secret-manager-injected production access; never put connection strings in command arguments or shell history.
node scripts/runtime/etl-import.js --source <approved-source-file>

# Verify row count
psql $DATABASE_URL -c "SELECT COUNT(*) FROM documents;"
psql $DATABASE_URL -c "SELECT COUNT(*) FROM users;"
```

**Benefit**: Fresh data, no staging artifacts, reconciliation identical to UAT.

**OPTION B: Import an Approved Staging Snapshot** (only with human approval and verified M08 reconciliation)

Pre-Migration Test Data Verification (MANDATORY before dump):

```bash
# Verify no test data in staging
psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM users WHERE email LIKE '%test%';"        # Expected: 0
psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM documents WHERE title = 'Test Document';" # Expected: 0
psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM users WHERE email LIKE '%@example.com';"  # Expected: 0
```

**STOP if test data, client data, or unapproved records are present.** A staging snapshot is not automatically safe for production; use only an approved, reconciled import and the project data-handling plan.

```bash
# Dump staging DB
pg_dump -U postgres -h staging-db -d legal_vault_staging -F c -b -v -f staging-uat-approved.dump

# Restore to production DB
pg_restore -U postgres -h prod-db -d legal_vault_prod -v staging-uat-approved.dump

# Verify row count match
psql postgresql://prod-db/legal_vault_prod -c "SELECT COUNT(*) FROM documents;"
```

**Risk**: Ensure staging DB is clean and no test data is mixed in.

**OPTION C: Manual Migration (Last Resort)**

Use a manual import only when volume and risk are within the project-approved limit and a validated ETL path is unavailable:

```bash
# Export staging data to CSV
psql postgresql://staging-db/legal_vault_staging -c "COPY documents TO STDOUT WITH CSV HEADER" > documents.csv

# Import to production
psql postgresql://prod-db/legal_vault_prod -c "COPY documents FROM STDIN WITH CSV HEADER" < documents.csv
```

**Post-Migration Verification (MANDATORY)**:

```bash
# Check row count consistency (IF M08 executed: match M08 reconciliation report)
echo "Users: $(psql $PROD_DB_URL -tAc 'SELECT COUNT(*) FROM users')"
echo "Documents: $(psql $PROD_DB_URL -tAc 'SELECT COUNT(*) FROM documents')"

# Check data integrity
psql $PROD_DB_URL -c "SELECT * FROM documents WHERE created_at IS NULL LIMIT 5;"   # Expected: 0 rows

# Check foreign key integrity
psql $PROD_DB_URL -c "SELECT COUNT(*) FROM documents d LEFT JOIN users u ON d.creator_id = u.id WHERE u.id IS NULL;"  # Expected: 0

# Run the approved application smoke-test procedure using a designated test account. Do not print or save access tokens.
```

**IF M08 executed**: Match row count with `UAT_SIGNOFF_REPORT.md` Section "Data Migration Reconciliation".
**IF M08 skipped** (Small/Medium greenfield): Verify seed data exists (admin user, sample records).

---

## Step 5 (Detail): Schema Migration

```bash
# Human operator runs the reviewed migration with production credentials injected by the approved secret manager. Record the artifact and migration result; never put secret values in command args or history.
```

*Migration note: choose a migration strategy based on compatibility, data risk, and rollback limits. Destructive or irreversible operations need an explicit human-approved recovery and data-impact plan.*

---

## Section 4 (Full): Mobile App Deployment Specific Workflow (Android & iOS)

If the project includes a mobile application (Flutter / React Native / Native), the deployment process involves App Store Ecosystem characteristics distinct from web:

```text
[ SOURCE CODE STAGING ]
           │
           ├──────────────────────────────────────┐
           ▼                                      ▼
   [ ANDROID RELEASE ]                     [ IOS RELEASE ]
   • Signing: Release Keystore (.jks)     • Signing: Distribution Cert & Provisioning Profile
   • Build: Android App Bundle (.aab)     • Build: iOS Archive (.ipa) via Xcode / Fastlane
   • Beta: Internal App Sharing           • Beta: Apple TestFlight Internal/External
           │                                      │
           ▼                                      ▼
[ GOOGLE PLAY CONSOLE ]                    [ APPLE APP STORE CONNECT ]
• Store review timing and staged rollout options vary; check the current provider status and project release plan.
• Use staged rollout only where the store supports it; choose progression and pause criteria from project risk and available telemetry.
```

### 4.1 Key Management & Signing (Keystore & Certificates)
- **Android**: Generate production keystore and store the `.jks` file along with alias passwords in an encrypted vault (Bitwarden). *If the keystore is lost, the application can never be updated on the Google Play Store again.*
- **iOS**: Enroll in the Client's Apple Developer Program ($99/year). Create distribution certificates and App Store Provisioning Profiles.

### 4.2 Pre-Public Beta Testing Strategy (TestFlight & Internal Sharing)
- Use internal/beta distribution before public rollout when supported and proportionate; record the tested build and decision.
- **Android**: Upload to the **Internal Testing** track in Google Play Console → share link with Client Single PIC for verification on real Android devices.
- **iOS**: Upload to **TestFlight** → invite Client Single PIC Apple ID email address to test on real iPhone devices.

### 4.3 Factoring in App Store Review Buffer
- Unlike web which can be released instantly in 2 minutes, mobile releases depend on human review schedules:
  - Check the current App Store review status and account-specific timing before communicating a launch date.
  - Check the current Play Console review status and account-specific timing before communicating a launch date.
- **Client Complaint Mitigation Strategy**: State in the schedule that mobile go-live dates are calculated from when the app status changes to *Ready for Sale / Published* by app stores.

### 4.4 Rollback & Mobile Emergency Updates (OTA & Force Update)
- Mobile apps cannot be rolled back instantly if critical bugs reach users.
- **Version compatibility and emergency updates**: define a force-update or compatibility policy only when the app, backend, and store workflow need one. OTA updates apply only where supported and permitted by the selected platform and release policy.
- **OTA updates**: use only when supported, permitted by the selected platform and app-store policy, and covered by testing and rollback procedures.

---

## Enterprise Scale Advisory (A03/A00)

Enterprise-scale deployments follow the applicable A03/A00 governance: CAB, DR/BCP, vendor runbook review, and release approvals required by the organization. Use the organization-defined notice period and release controls.

> Summary for the runbook: use non-emitting production-secret verification, the approved protected release workflow, contract-specific client handover terms, reconciled data migration, and a platform-supported rollout/recovery plan. Mobile store review and emergency update policies are platform- and project-specific.
