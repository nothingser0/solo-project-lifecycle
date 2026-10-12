# Module 12 Deep Dive: Warranty Boundaries, Hotfix Flow & Retainer Package Tiers

## Contents

- [Step 1 (Detail): Warranty Policy Socialization (`WARRANTY_POLICY.md`)](#step-1-detail-warranty-policy-socialization-warrantypolicymd)
- [Step 2 (Detail): Incident Triage & Hotfix Execution](#step-2-detail-incident-triage-hotfix-execution)
- [Step 3 (Detail): Negotiating Transition to Monthly Retainer (14 Days Before Warranty Expires)](#step-3-detail-negotiating-transition-to-monthly-retainer-14-days-before-warranty-expires)


> Companion to `docs/modules/12_WARRANTY_SLA_RETAINER.md` (runbook). This file holds the detailed execution steps; the runbook keeps a condensed summary.

## Step 1 (Detail): Warranty Policy Socialization (`WARRANTY_POLICY.md`)
1. Concurrently with the handover of the BAST (Module 11), deliver the **`WARRANTY_POLICY.md`** document to the Client Single PIC.
2. Affirm official communication channels:
   - Bug reports must go through official email or a single technical coordination group.
   - Sending bug messages to the solo developer's personal number outside working hours is strictly prohibited (unless the server is in *Critical Down* status).

## Step 2 (Detail): Incident Triage & Hotfix Execution
If the client reports an issue in production during the warranty period:
1. Inspect the Sentry dashboard to view stack traces and error history.
2. Create a fix branch from `main`:
   ```bash
   git checkout main
   git checkout -b fix/issue-critical-payment
   ```
3. Code the fix, run local `pnpm run test:smoke`.
4. Merge to `staging` for rapid verification, then merge to `main` and tag the hotfix:
   ```bash
   git checkout main
   git merge --no-ff fix/issue-critical-payment
   git tag -a v1.0.1 -m "hotfix: resolve payment webhook timeout"
   git push origin main --tags
   ```

## Step 3 (Detail): Negotiating Transition to Monthly Retainer (14 Days Before Warranty Expires)
Two weeks before the warranty period ends, send a routine maintenance proposal (*Retainer Proposal*).

**Reminder Automation**: Configure a calendar reminder or cron job to automatically send the proposal 14 days before the warranty expiration date:
```bash
# Example cron job: Send retainer proposal reminder
# Add to crontab or use a service scheduler (Cron / GitHub Actions)
0 9 * * * check_warranty_expiry_and_notify.sh
```

**Offer 3 package tiers**:

1. **Bronze Package (Basic Maintenance & Security)**:
   - 24/7 server monitoring (Uptime & Sentry).
   - Monthly dependency security patching and database maintenance.
   - Backup data integrity verification (*daily backup restore test*).
   - Allocation: 5 Technical consultation hours / month.
2. **Silver Package (Standard Maintenance & Optimization)**:
   - All facilities of the Bronze Package.
   - Allocation of **15 Working hours / month** for minor feature additions, UI adjustments, or report format changes.
   - Responsive SLA response time < 4 hours on business days.
3. **Gold Package (High-Priority Business SLA)**:
   - All facilities of the Silver Package.
   - Allocation of **20–30 Working hours / month** for scheduled maintenance and priority enhancements.
   - Expedited business hours response (<2 hours for Severity 1 incidents during Monday–Friday 09:00–17:00 WIB).
   - *Solo Dev Anti-Burnout Note*: Solo developers MUST NOT commit to 24/7/365 emergency weekend on-call without a rotating support team.

> Summary for the runbook: deliver WARRANTY_POLICY.md at BAST handover, hotfix via fix/* → staging → main + SemVer tag, automate the 14-day pre-expiry retainer proposal, and price Bronze/Silver/Gold tiers (5 / 15 / 20–30 hours per month) with a hard no-24/7-on-call rule for solo devs.
