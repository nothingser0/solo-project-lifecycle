# Module 10 Deep Dive: Production Deployment — ENV Verification, Clean Release, Data Migration Options & Mobile Workflows

## Contents

- [Step 1 (Detail): Verify Production Environment Variables](#step-1-detail-verify-production-environment-variables)
- [Step 2 (Detail): Clean Release Merge — Manual Procedure](#step-2-detail-clean-release-merge-manual-procedure)
- [Step 3 (Detail): Leverage-Safe Commercial Handover Rule (Delivery: client)](#step-3-detail-leverage-safe-commercial-handover-rule-delivery-client)
- [Step 4 (Detail): Import Verified Client Real Data — 3 Options](#step-4-detail-import-verified-client-real-data-3-options)
- [Step 5 (Detail): Schema Migration](#step-5-detail-schema-migration)
- [Section 4 (Full): Mobile App Deployment Specific Workflow (Android & iOS)](#section-4-full-mobile-app-deployment-specific-workflow-android-ios)
- [Enterprise Scale Advisory (A03/A00)](#enterprise-scale-advisory-a03a00)


> Companion to `docs/modules/10_DEPLOYMENT_PRODUCTION.md` (runbook). This file holds the detailed execution steps; the runbook keeps a condensed summary.

## Step 1 (Detail): Verify Production Environment Variables

Before touching DNS or deployment, verify production ENV:

```bash
# Verify payment gateway mode
[[ "$PAYMENT_GATEWAY_MODE" =~ ^(production|live)$ ]] && echo "✅ Payment mode production" || echo "❌ NOT PRODUCTION"

# Verify database URL (non-emitting check)
echo "$DATABASE_URL" | grep -q -E 'prod|production|live' && echo "✅ Production DB verified" || echo "❌ INVALID DB TARGET"

# Verify API keys (non-emitting prefix validation)
if [[ "$STRIPE_SECRET_KEY" =~ ^sk_live_ ]]; then
  echo "✅ Stripe live key verified"
else
  echo "❌ INVALID STRIPE KEY"
fi

# Verify JWT secret non-empty
[[ -n "$JWT_SECRET" && ${#JWT_SECRET} -ge 32 ]] && echo "✅ JWT secret valid" || echo "❌ WEAK OR MISSING JWT SECRET"

# Verify encryption key non-empty
[[ -n "$ENCRYPTION_KEY" && ${#ENCRYPTION_KEY} -ge 32 ]] && echo "✅ Encryption key valid" || echo "❌ WEAK OR MISSING ENCRYPTION KEY"
```

**Checklist Production ENV**:
- [ ] `PAYMENT_GATEWAY_MODE=production` (NOT sandbox)
- [ ] `STRIPE_SECRET_KEY` (if used) starts with `sk_live_` (not `sk_test_`)
- [ ] `MIDTRANS_SERVER_KEY` (if used) does NOT contain `sandbox`
- [ ] Run verification: `grep -E "sk_test|sandbox|test_" .env.production && echo "⚠️ TEST KEYS DETECTED" || echo "✓ Production keys verified"`
- [ ] `DATABASE_URL` points to production DB
- [ ] `MIDTRANS_IS_PRODUCTION=true`
- [ ] `SMTP_HOST` is production mail server (NOT mailtrap/mailpit)
- [ ] `STORAGE_BUCKET` is production bucket (NOT staging)
- [ ] `JWT_SECRET` different from staging
- [ ] `ENCRYPTION_KEY` rotated for production
- [ ] `CORS_ORIGIN` matches production domain
- [ ] `SENTRY_DSN` with `environment: "production"`
- [ ] `SESSION_SECRET` unique to production

**STOP deployment if sandbox keys are still present!**

**Rollback Plan Dry-Run Verification**:
- [ ] Rollback plan dry-run executed in staging (verify git revert + DB restore time)
- [ ] Database migration rollback script tested (if DDL changes exist)
- [ ] Documented: can we restore last known good state in <15 minutes?

**WARNING**: DDL migrations (ADD COLUMN, DROP TABLE) may not be reversible without data loss. Test rollback procedure in staging first.

**Pre-deploy DB snapshot** (if updating an existing system):
```bash
pg_dump -U postgres -d legal_vault_prod -F c -b -v -f "backup-pre-deploy-$(date +%Y%m%d).dump"
```

---

## Step 2 (Detail): Clean Release Merge — Manual Procedure

> **Goal**: `main` must contain ONLY production code + client-facing specs — never the AI harness
> (`AGENTS.md`, `TODO.md`, `docs/pm/`, `docs/qa/`, …) nor internal process documents.
> Full runbook: `RELEASE_WORKFLOW.md` (root harness). Exclusions live in `scripts/release/release-exclude.txt`.

**Why not `git merge --no-ff staging`?** A plain merge carries the harness from `dev` straight into
`main`. `.gitignore` cannot remove files that are already tracked. Harness must be untracked
(`git rm --cached`) on a temporary release branch BEFORE merging.

**Automated (recommended)**:
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

## Step 3 (Detail): Leverage-Safe Commercial Handover Rule (Delivery: client)

> 🛡️ Under the standardized 30/40/30 contract (`03_LEGAL_SOW_CHARTER.md` and `SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md`), **Milestone 3 (Final 30%) is payable prior to DNS production pointing and BAST handover**.
> - In Module 10, the developer deploys to a **developer-controlled production/preview server** to execute PVT testing and produce `GO_LIVE_REPORT.md`.
> - Pointing the Client's official primary domain (`app.client.com`) and transferring master cloud/repo credentials **MUST BE HELD AS COMMERCIAL LEVERAGE** until 100% final payment clears in Module 11.
> - For `Delivery: solo | internal | portfolio`, configure the primary production domain directly.

**DNS & SSL steps**:
1. Log into the domain provider's DNS dashboard (Cloudflare, Niagahoster, Route53).
2. Point DNS Records (Staged / Production based on delivery model):
   - `Type A`: `@` → Production Server IP / Load Balancer.
   - `CNAME`: `app` or `www` → hosting domain (Vercel / Cloud Run).
3. Verify DNS propagation using `dig` or `nslookup`.
4. Ensure SSL certificate is issued and achieves at least a **Grade A** rating on SSL Labs (TLS 1.3 enabled).

---

## Step 4 (Detail): Import Verified Client Real Data — 3 Options

> **M08 CONDITIONAL BYPASS**: M08 Data Migration is skipped for greenfield projects (no legacy data). If M08 executed, follow the steps below; if skipped, jump to schema migration and verify seed data only.

**OPTION A: Re-run ETL Script to Production** (Recommended — Fresh Import)

If source data (Excel/CSV) is still available and unchanged since UAT:

```bash
# Run ETL script directly against production DB
DATABASE_URL="postgresql://user:***@prod-db:5432/db" node scripts/runtime/etl-import.js --source data/client-final.xlsx

# Verify row count
psql $DATABASE_URL -c "SELECT COUNT(*) FROM documents;"
psql $DATABASE_URL -c "SELECT COUNT(*) FROM users;"
```

**Benefit**: Fresh data, no staging artifacts, reconciliation identical to UAT.

**OPTION B: Copy Staging Database to Production** (Faster — Staging Dump)

Pre-Migration Test Data Verification (MANDATORY before dump):

```bash
# Verify no test data in staging
psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM users WHERE email LIKE '%test%';"        # Expected: 0
psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM documents WHERE title = 'Test Document';" # Expected: 0
psql $STAGING_DB_URL -c "SELECT COUNT(*) FROM users WHERE email LIKE '%@example.com';"  # Expected: 0
```

**STOP if test data found!** Clean staging DB before proceeding.

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

If data volume is small (<100 rows) and ETL script is unavailable:

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

# Verify application-level data access
curl -X POST https://app.client.com/api/auth/login \
  -d '{"email":"admin@client.com","password":"***"}' \
  | jq '.token' # Should return valid JWT

# Verify document retrieval
curl https://app.client.com/api/documents?limit=5 \
  -H "Authorization: Bearer ***" # Should return real documents
```

**IF M08 executed**: Match row count with `UAT_SIGNOFF_REPORT.md` Section "Data Migration Reconciliation".
**IF M08 skipped** (Small/Medium greenfield): Verify seed data exists (admin user, sample records).

---

## Step 5 (Detail): Schema Migration

```bash
DATABASE_URL="postgresql://user:***@prod-db:5432/db" pnpm db:migrate
```

*Solo Dev Note: Ensure migration scripts are additive (only adding new columns/tables); destructive commands (`DROP COLUMN` / `TRUNCATE`) are strictly prohibited.*

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
• Review: 24–72 Hours (Automated & Manual) • Review: 24–48 Hours (Strict Apple Guidelines)
• Phased Rollout: 10% ──► 50% ──► 100%    • Phased Release: 7-Day Phased
```

### 4.1 Key Management & Signing (Keystore & Certificates)
- **Android**: Generate production keystore and store the `.jks` file along with alias passwords in an encrypted vault (Bitwarden). *If the keystore is lost, the application can never be updated on the Google Play Store again.*
- **iOS**: Enroll in the Client's Apple Developer Program ($99/year). Create distribution certificates and App Store Provisioning Profiles.

### 4.2 Pre-Public Beta Testing Strategy (TestFlight & Internal Sharing)
- Directly releasing the first build to public production is prohibited.
- **Android**: Upload to the **Internal Testing** track in Google Play Console → share link with Client Single PIC for verification on real Android devices.
- **iOS**: Upload to **TestFlight** → invite Client Single PIC Apple ID email address to test on real iPhone devices.

### 4.3 Factoring in App Store Review Buffer
- Unlike web which can be released instantly in 2 minutes, mobile releases depend on human review schedules:
  - Apple App Store: Requires **24–48 business hours**.
  - Google Play Console: Requires **24–72 business hours** (especially for new developer accounts).
- **Client Complaint Mitigation Strategy**: State in the schedule that mobile go-live dates are calculated from when the app status changes to *Ready for Sale / Published* by app stores.

### 4.4 Rollback & Mobile Emergency Updates (OTA & Force Update)
- Mobile apps cannot be rolled back instantly if critical bugs reach users.
- **Mandatory Force-Update Mechanism**: Mobile apps must include a minimum version check on the splash screen (`GET /api/v1/app/version-check`). In the event of a critical bug, the backend can force users to update to the latest version before accessing the dashboard.
- **Over-The-Air (OTA) Updates**: For React Native (Expo Updates) or Flutter (Shorebird), implement an OTA patch mechanism so minor JavaScript/Dart bug fixes can be deployed immediately without going through app store review again.

---

## Enterprise Scale Advisory (A03/A00)

Enterprise-scale projects exceed solo capacity for high-blast-radius production cutovers — routed to **Phase A03/A00 Advisory**: CAB RFC documented and approved (`templates/03-governance/CAB_PROCESS.md`; RFC submitted 3 business days before deployment, CAB review of risk, blast radius, rollback plan, maintenance window), Disaster Recovery / Business Continuity Plan aligned (`templates/08-maintenance-ops/DISASTER_RECOVERY_PLAN.md`), and vendor deployment runbook reviewed with client DevOps leadership.

> Summary for the runbook: verify live ENV keys (zero sandbox), clean-release merge with harness stripping, hold client DNS pointing until final payment (Delivery: client), migrate production data via ETL re-run / staging dump / manual CSV with reconciliation, additive-only schema migrations, and mobile releases need store review buffers + force-update mechanism.
