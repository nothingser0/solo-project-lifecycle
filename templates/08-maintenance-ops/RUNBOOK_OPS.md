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

## 3.5 Permission Envelope (what an agent may execute unattended)

A runbook read during an incident is read by whoever is on call — increasingly an agent. The steps below name rollback, failover, and scale operations. Without this block, the document says *what* to do and nothing about *what may be done without a human*.

```yaml
default_mode: read_only          # inspect freely; change nothing on your own
forbidden:                        # never, regardless of approval in the moment
  - production data deletion
  - credential or key rotation without the owner present
  - firewall / security-group opening to 0.0.0.0/0
  - force-push to the deploy branch
requires_confirmation_for:        # permitted after explicit human approval
  - rollback to a previous deploy
  - failover to standby
  - scale-up / scale-down
  - feature-flag flip
  - cache or queue purge
```

| Rule | Consequence if ignored |
| :--- | :--- |
| `forbidden` and `requires_confirmation_for` must not overlap | An operation listed in both has undefined precedence |
| `read_only` plus a populated confirm list is a dead declaration | The gate never fires, because the mode blocks the action first |
| Every destructive step in §1–§4 appears in exactly one list | A step in neither is ungoverned — the default failure |

**During an outage the temptation is to widen permissions.** Widening them mid-incident is how an outage becomes a data loss event. If a step is forbidden here, page the owner.

---

## 4. Incident Response (Solo)
1. Detect (alert / user report)
2. Triage severity (S1 = down, S2 = degraded, S3 = cosmetic)
3. Mitigate (rollback or hotfix)
4. Post-mortem note in `docs/pm/INCIDENT_RESPONSE.md` (optional)

## 5. Ownership
- **Application Owner**: [Your Name]
- **Escalation contact**: [Your email / phone]
- **Review cadence**: [monthly]
