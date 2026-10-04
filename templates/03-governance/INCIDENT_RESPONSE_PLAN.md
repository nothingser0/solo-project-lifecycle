# Incident Response Plan

> **Purpose**: Respond to security incidents and production outages  
> **When**: Activated when incident detected  
> **Target**: Enterprise projects with 24/7 uptime requirements

---

## Incident Severity Levels

| Severity | Definition | Examples | Response Time | Escalation |
|:---------|:-----------|:---------|:--------------|:-----------|
| **SEV-1 Critical** | Complete service outage, data breach | API down for all users, database compromised | 15 minutes | Immediate |
| **SEV-2 High** | Major feature down, security vulnerability | Payment processing broken, XSS vulnerability | 1 hour | Within 30 min |
| **SEV-3 Medium** | Minor feature degraded, performance issue | Slow page load, single endpoint failing | 4 hours | Within 2 hours |
| **SEV-4 Low** | Cosmetic issue, minor bug | UI glitch, typo | Best effort | No escalation |

---

## Incident Response Phases

### Phase 1: Detection (0-5 minutes)

**How Incidents Are Detected**:
- [ ] Automated monitoring alerts (Datadog, Pingdom)
- [ ] User reports (support tickets, social media)
- [ ] Team member discovery

**Initial Actions**:
1. Acknowledge alert (stop paging)
2. Assess severity (SEV-1 to SEV-4)
3. Create incident ticket (Jira, PagerDuty)
4. Notify on-call engineer

---

### Phase 2: Triage (5-15 minutes)

**Incident Commander Assigned**:
- SEV-1/SEV-2: On-call engineer becomes Incident Commander
- SEV-3/SEV-4: Regular team member handles

**Initial Assessment**:
- [ ] What is broken? (API, database, frontend, etc.)
- [ ] How many users affected? (all, subset, single user)
- [ ] What is the impact? (data loss, downtime, security breach)
- [ ] Is this escalating or stable?

**Communication**:
- [ ] Post in #incidents Slack channel
- [ ] Update status page (status.yourcompany.com)
- [ ] Notify stakeholders (CTO, Product Manager)

**Example Slack Post**:
```
🔴 SEV-1 INCIDENT
Title: API Down - All Endpoints Returning 500
Impact: 100% of users cannot access system
Start Time: 2024-10-04 02:15 UTC
Incident Commander: @john
Status: Investigating
```

---

### Phase 3: Investigation (15-60 minutes)

**Gather Information**:
- [ ] Check monitoring dashboards (Datadog, Grafana)
- [ ] Review recent deployments (last 24 hours)
- [ ] Check infrastructure status (AWS Health Dashboard)
- [ ] Review error logs (CloudWatch, Sentry)
- [ ] Check third-party services (Stripe, SendGrid status pages)

**Form Hypothesis**:
- What changed recently? (deployment, config, infrastructure)
- Is this a known issue? (check runbooks, past incidents)
- Can we reproduce the issue?

**Decision Point**:
- If root cause found → Proceed to Mitigation
- If root cause unclear → Escalate, add more engineers

---

### Phase 4: Mitigation (Immediate)

**Goal**: Stop the bleeding (restore service ASAP)

**Common Mitigation Strategies**:

1. **Rollback**:
   ```bash
   # Rollback to previous version
   git revert HEAD
   kubectl rollout undo deployment/api
   # or
   vercel rollback
   ```

2. **Failover**:
   - Switch to backup database (read replica → primary)
   - Reroute traffic to healthy region
   - Enable maintenance mode

3. **Scale Up**:
   ```bash
   # Increase resources
   kubectl scale deployment/api --replicas=10
   ```

4. **Disable Feature**:
   - Use feature flag to disable broken feature
   - Allows rest of system to function

5. **Circuit Breaker**:
   - Disable failing third-party integration
   - Use cached data or fallback

**Time Limit**: 
- SEV-1: Mitigation within 1 hour or escalate to executive team
- SEV-2: Mitigation within 4 hours

---

### Phase 5: Resolution (1-24 hours)

**Goal**: Permanent fix (not just band-aid)

**Actions**:
- [ ] Implement proper fix
- [ ] Test fix in staging
- [ ] Deploy fix to production
- [ ] Verify issue resolved (monitoring confirms)
- [ ] Monitor for recurrence (next 24 hours)

**Communication**:
- [ ] Update status page: "Issue resolved"
- [ ] Post in #incidents: "Incident resolved"
- [ ] Notify stakeholders

---

### Phase 6: Post-Mortem (Within 7 days)

**Goal**: Learn from incident, prevent recurrence

**Post-Mortem Meeting** (1 hour):
- Attendees: Incident Commander, engineers involved, stakeholders
- Blameless culture (focus on systems, not people)

**Post-Mortem Document**:

#### Timeline
| Time (UTC) | Event |
|:-----------|:------|
| 02:15 | Database connection pool exhausted |
| 02:17 | API starts returning 500 errors |
| 02:20 | Alert triggers, on-call paged |
| 02:25 | Root cause identified |
| 02:45 | Connection pool increased to 500 |
| 02:50 | Service restored |

#### Impact
- Duration: 35 minutes
- Users affected: 100% (5,000 concurrent users)
- Requests failed: 350,000
- Revenue impact: $2,500 (estimated)
- SLA breach: Yes (99.92% uptime this month)

#### Root Cause
Database connection pool limit (100) too low for traffic spike (2,000 concurrent users during flash sale).

#### What Went Well
- Alert triggered within 2 minutes
- On-call responded within 5 minutes
- Root cause identified quickly (10 minutes)
- Mitigation successful (no data loss)

#### What Went Wrong
- Connection pool limit not load tested
- No alert for connection pool utilization
- No auto-scaling for connection pool

#### Action Items
| Action | Owner | Due Date | Priority |
|:-------|:------|:---------|:---------|
| Increase connection pool to 500 | @john | 2024-10-05 | P0 |
| Add load test for 3x traffic | @sarah | 2024-10-10 | P1 |
| Implement connection pool auto-scaling | @mike | 2024-10-15 | P1 |
| Add alert for connection pool >70% | @john | 2024-10-06 | P0 |

---

## Incident Communication

### Internal Communication (During Incident)

**Slack #incidents Channel**:
```
02:15 - 🔴 SEV-1: API Down
02:20 - Investigating database connection issues
02:30 - Found root cause: connection pool exhausted
02:40 - Deploying fix: increasing connection pool to 500
02:50 - ✅ Service restored. Monitoring for stability.
03:00 - Incident closed. Post-mortem scheduled for Oct 5, 10 AM.
```

**Update Frequency**:
- SEV-1: Every 15 minutes
- SEV-2: Every 30 minutes
- SEV-3: Every 2 hours

---

### External Communication (Public Status Page)

**Status Page Update**:
```
[Oct 4, 02:20 UTC] Investigating
We are aware of API errors affecting all users. 
We are investigating the issue.

[Oct 4, 02:45 UTC] Identified
We have identified the root cause and are deploying a fix.

[Oct 4, 02:50 UTC] Monitoring
The issue has been resolved. We are monitoring for stability.

[Oct 4, 03:00 UTC] Resolved
The incident is fully resolved. All systems are operational.
```

**Customer Email** (for major incidents):
```
Subject: Service Incident - Oct 4, 2024

Dear Customers,

On October 4, 2024 at 02:15 UTC, we experienced a service outage 
lasting 35 minutes. During this time, the API returned errors and 
users could not access the system.

What happened:
A traffic spike during our flash sale exceeded our database 
connection pool capacity, causing API errors.

What we've done:
- Increased database connection pool capacity
- Added monitoring to prevent recurrence
- Implemented auto-scaling for future traffic spikes

We apologize for the inconvenience. If you were affected and have 
questions, please contact support@yourcompany.com.

Sincerely,
The [Company] Team
```

---

## Incident Roles & Responsibilities

### Incident Commander (IC)
**Role**: Leads incident response, makes decisions

**Responsibilities**:
- Assign tasks to engineers
- Communicate with stakeholders
- Make tough calls (rollback vs fix forward)
- Declare incident resolved
- Schedule post-mortem

**Authority**: Can override anyone during incident

---

### On-Call Engineer
**Role**: First responder, becomes IC for SEV-1/SEV-2

**Responsibilities**:
- Acknowledge page within 5 minutes
- Initial triage and assessment
- Escalate if needed
- Document timeline in incident ticket

**Schedule**: Rotating 1-week shifts

---

### Communications Lead
**Role**: Handles external communication

**Responsibilities**:
- Update status page
- Send customer emails (if needed)
- Handle press inquiries (if major incident)
- Draft public post-mortem (blog post)

---

### Technical Lead
**Role**: Deep technical investigation

**Responsibilities**:
- Review logs, metrics, traces
- Form hypothesis
- Implement fix
- Verify resolution

---

## Incident Runbooks

### Runbook: API Returning 500 Errors

**Symptoms**: API returning HTTP 500, error rate >1%

**Likely Causes**:
1. Database connection issues
2. Recent deployment bug
3. Third-party service down
4. Resource exhaustion (CPU, memory)

**Investigation Steps**:
1. Check Datadog dashboard for error spike
2. Review recent deployments (last 24 hours)
3. Check database status (RDS CloudWatch)
4. Check third-party service status pages
5. Review Sentry for error details

**Mitigation**:
- If recent deployment: Rollback
- If database issue: Failover to replica
- If resource exhaustion: Scale up
- If third-party issue: Enable circuit breaker

---

### Runbook: Database Down

**Symptoms**: All database queries failing

**Immediate Actions**:
1. Check AWS RDS status (CloudWatch, RDS Console)
2. Attempt to connect via `psql` or MySQL client
3. Check security groups (firewall rules)
4. Check disk space (>90% = issue)

**Mitigation**:
- If primary down: Promote read replica to primary
- If disk full: Clear old logs, increase disk size
- If network issue: Update security groups

**Recovery Time**: 5-15 minutes (automated failover)

---

### Runbook: DDoS Attack

**Symptoms**: Massive traffic spike, legitimate requests timing out

**Investigation**:
1. Check CloudWatch metrics (requests/sec)
2. Review IP addresses in access logs
3. Check for patterns (single IP, botnet)

**Mitigation**:
1. Enable rate limiting (AWS WAF, Cloudflare)
2. Block malicious IPs
3. Enable CAPTCHA for suspicious traffic
4. Contact AWS Shield (if using AWS Shield Advanced)

**Escalation**: If attack persists >1 hour, contact DDoS mitigation service

---

## Incident Checklist

**During Incident**:
- [ ] Assess severity (SEV-1 to SEV-4)
- [ ] Assign Incident Commander
- [ ] Create incident ticket
- [ ] Post in #incidents Slack channel
- [ ] Update status page
- [ ] Notify stakeholders (for SEV-1/SEV-2)
- [ ] Investigate and mitigate
- [ ] Update status page when resolved
- [ ] Post resolution in #incidents

**Post-Incident**:
- [ ] Schedule post-mortem (within 7 days)
- [ ] Write post-mortem document
- [ ] Create action items (with owners + due dates)
- [ ] Send customer communication (if needed)
- [ ] Update runbooks (if new issue)
- [ ] Track action items to completion

---

## Escalation Matrix

| Severity | Notify Immediately | Update Every | Escalate If |
|:---------|:-------------------|:-------------|:------------|
| **SEV-1** | On-call, CTO, Product Manager | 15 min | Not resolved in 1 hour |
| **SEV-2** | On-call, Team Lead | 30 min | Not resolved in 4 hours |
| **SEV-3** | Team | 2 hours | Not resolved in 1 day |
| **SEV-4** | None | Daily | N/A |

**Executive Escalation Path**:
1. On-call Engineer
2. Team Lead
3. Engineering Manager
4. VP Engineering
5. CTO
6. CEO (for PR disasters)

---

## Tools

**Monitoring & Alerting**:
- Datadog, New Relic, Sentry
- PagerDuty (on-call scheduling + paging)
- Pingdom (uptime monitoring)

**Communication**:
- Slack #incidents channel
- Status page (Statuspage.io, custom)
- Email (customer notifications)

**Incident Management**:
- PagerDuty Incident Response
- Jira (incident tickets)
- Google Docs (post-mortems)

---

## Notes

**Blameless culture**: Focus on systems, not individuals

**Post-mortems are mandatory**: Learn from every SEV-1/SEV-2

**Runbooks save time**: Document common issues

**Practice incident response**: Run fire drills quarterly
