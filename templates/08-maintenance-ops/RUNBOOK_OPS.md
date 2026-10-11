# RUNBOOK_OPS.md (Operations Runbook — Solo / Internal Delivery)

> **Purpose**: Lightweight operations manual for solo/internal projects. Replaces the client-oriented WARRANTY_POLICY.md for non-client delivery.
> **Location**: `docs/pm/RUNBOOK_OPS.md`
> **Gate**: Module 12 (Lightweight) — `Delivery: solo | portfolio | internal`

---

## 1. Rollback Procedure
- **Last-known-good deploy**: [git tag / release ID]
- **Rollback command**: [e.g., `vercel rollback <deployment>` / `git revert <sha> && git push`]
- **Estimated rollback time**: [< 5 min]

## 2. Backup & Restore
- **Database backup**: [provider auto-backup / scheduled `pg_dump` cron]
- **Backup frequency**: [daily / hourly]
- **Restore procedure**: [steps to restore from latest snapshot]
- **Retention**: [e.g., 7 daily + 4 weekly]

## 3. Monitoring & Alerts
- **Uptime monitor**: [URL / service, e.g., UptimeRobot]
- **Error tracking**: [Sentry project link]
- **Alert destination**: [email / Slack / WhatsApp]
- **Key metrics watched**: [error rate, p95 latency, DB connections]

## 4. Incident Response (Solo)
1. Detect (alert / user report)
2. Triage severity (S1 = down, S2 = degraded, S3 = cosmetic)
3. Mitigate (rollback or hotfix)
4. Post-mortem note in `docs/pm/INCIDENT_RESPONSE.md` (optional)

## 5. Ownership
- **Application Owner**: [Your Name]
- **Escalation contact**: [Your email / phone]
- **Review cadence**: [monthly]
