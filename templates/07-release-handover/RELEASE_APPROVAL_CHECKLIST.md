# Release Approval Checklist

> **Purpose**: Gate production deployments with formal approval  
> **When**: M10 Deployment (before every production release)  
> **Target**: Enterprise projects with change control requirements
>
> Adapt this optional checklist to the project's risk, SLOs, and release policy. Blank checkboxes are not evidence. All numerical values below are project-defined; example thresholds must not be treated as defaults.

---

## Go/No-Go Decision

**Question**: Is this release ready for production?

**Decision Makers**:
- Tech Lead (technical readiness)
- QA Lead (quality assurance)
- Product Manager (business readiness)
- Security Lead (security approval)
- Operations Lead (infrastructure readiness)

**Decision**: [GO / GO WITH CONDITIONS / NO-GO]

**NO-GO Criteria** (any one fails = no release):
- Critical bugs unresolved
- Security vulnerabilities (critical/high)
- Failed load test
- Incomplete documentation
- Missing rollback plan

---

## Pre-Release Checklist

### 1. Code Quality ✅

- [ ] All code merged to main branch
- [ ] Required code review completed under project policy
- [ ] No merge conflicts
- [ ] Build passing (CI/CD green)
- [ ] TypeScript strict mode (zero errors)
- [ ] Linter passing (zero warnings for new code)
- [ ] No `console.log` statements in production code
- [ ] No commented-out code blocks
- [ ] No TODO comments for critical features

**Verified by**: Tech Lead  
**Date**: _______  
**Sign-off**: _______

---

### 2. Testing ✅

- [ ] Applicable unit, integration, and end-to-end checks meet project release policy
- [ ] Test coverage meets the agreed project threshold, if one is defined
- [ ] Smoke tests passing on staging
- [ ] Regression tests passing
- [ ] Cross-browser testing (Chrome, Firefox, Safari, Edge)
- [ ] Mobile testing (iOS, Android)
- [ ] Accessibility testing (WCAG 2.1 AA)

**Test Results**:
- Unit tests: ____ / ____ passed
- Integration tests: ____ / ____ passed
- E2E tests: ____ / ____ passed
- Coverage: _____%

**Verified by**: QA Lead  
**Date**: _______  
**Sign-off**: _______

---

### 3. Security ✅

- [ ] Security scan completed (Snyk, Dependabot)
- [ ] No critical vulnerabilities
- [ ] No high vulnerabilities (or documented exceptions)
- [ ] Penetration test completed (if required)
- [ ] OWASP Top 10 checklist completed
- [ ] Secrets not hardcoded (environment variables only)
- [ ] Input validation on all endpoints
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output escaping)
- [ ] CSRF protection enabled
- [ ] Authentication & authorization tested
- [ ] Rate limiting configured
- [ ] Security headers configured (CSP, HSTS, etc.)

**Security Scan Results**:
- Critical: 0
- High: ____ (exceptions documented)
- Medium: ____
- Low: ____

**Verified by**: Security Lead  
**Date**: _______  
**Sign-off**: _______

---

### 4. Performance ✅

- [ ] Load testing completed
- [ ] System meets the project's documented load target, if applicable
- [ ] API response time meets the documented SLO, if applicable
- [ ] Page load time meets the documented budget, if applicable
- [ ] Database query time meets the documented SLO, if applicable
- [ ] No memory leaks detected
- [ ] CDN configured (if applicable)
- [ ] Caching configured (Redis, browser cache)
- [ ] Asset optimization (minification, compression)

**Load Test Results**:
- Peak load tested: ____ users
- API p95 latency: ____ ms
- Page load p90: ____ s
- Error rate: ____% (project target: ____%)

**Verified by**: Tech Lead  
**Date**: _______  
**Sign-off**: _______

---

### 5. Infrastructure ✅

- [ ] Production environment provisioned
- [ ] Database migrations tested on staging
- [ ] Database migrations reversible (rollback script ready)
- [ ] Infrastructure as Code (IaC) applied
- [ ] Applicable certificate is valid under the project's renewal policy
- [ ] DNS configured correctly
- [ ] Load balancer configured
- [ ] Auto-scaling configured (if applicable)
- [ ] Monitoring configured (Datadog, CloudWatch)
- [ ] Alerting configured (PagerDuty, Slack)
- [ ] Log aggregation configured (CloudWatch, Splunk)
- [ ] Backup jobs scheduled and tested

**Verified by**: DevOps Lead  
**Date**: _______  
**Sign-off**: _______

---

### 6. Documentation ✅

- [ ] Release notes written
- [ ] User documentation updated
- [ ] API documentation updated
- [ ] Runbook updated (deployment, rollback procedures)
- [ ] Architecture diagrams updated (if changed)
- [ ] Environment variables documented
- [ ] Third-party dependencies documented

**Verified by**: Tech Lead  
**Date**: _______  
**Sign-off**: _______

---

### 7. Data Migration ✅

**If database changes**:

- [ ] Migration script tested on staging (3x)
- [ ] Migration estimated time: ____ minutes
- [ ] Downtime required: ____ minutes (or zero-downtime)
- [ ] Rollback script tested
- [ ] Data validation queries ready
- [ ] Backup taken before migration
- [ ] Migration plan documented

**Verified by**: Database Admin  
**Date**: _______  
**Sign-off**: _______

---

### 8. Business Readiness ✅

- [ ] Feature complete (all acceptance criteria met)
- [ ] UAT sign-off received from client
- [ ] Training materials ready (if user-facing)
- [ ] Support team notified of changes
- [ ] Marketing notified (if user-facing)
- [ ] Legal review completed (if needed)
- [ ] Privacy policy updated (if data collection changes)
- [ ] Terms of service updated (if applicable)

**Verified by**: Product Manager  
**Date**: _______  
**Sign-off**: _______

---

### 9. Communication ✅

- [ ] Release announcement drafted
- [ ] Stakeholders notified (date, time, impact)
- [ ] Support team briefed on changes
- [ ] Status page ready (status.yourcompany.com)
- [ ] Incident response team on standby
- [ ] Rollback contact list confirmed
- [ ] Customer communication plan ready (if downtime)

**Deployment Window**: __________ (date/time)  
**Expected Downtime**: ____ minutes  
**On-call Engineer**: __________  

**Verified by**: Project Manager  
**Date**: _______  
**Sign-off**: _______

---

### 10. Rollback Plan ✅

- [ ] Rollback procedure documented
- [ ] Rollback tested on staging
- [ ] Rollback time estimated: ____ minutes
- [ ] Previous version deployable (container image, Git tag)
- [ ] Database rollback script ready (if needed)
- [ ] Feature flags configured (can disable features without deploy)
- [ ] Rollback decision criteria defined

**Rollback Decision Criteria**:
- [ ] Project-defined error-rate trigger breached for the agreed observation window
- [ ] Project-defined latency trigger breached for the agreed observation window
- [ ] Critical bug discovered
- [ ] Project-defined customer impact trigger met

**Verified by**: Tech Lead  
**Date**: _______  
**Sign-off**: _______

---

## Deployment Checklist

**Day Before Deployment**:
- [ ] All pre-release checks completed
- [ ] Go/no-go meeting held
- [ ] GO decision documented
- [ ] Deployment plan reviewed with team
- [ ] On-call schedule confirmed

**2 Hours Before**:
- [ ] Final build created (production artifacts)
- [ ] Database backup taken
- [ ] Status page updated ("Scheduled maintenance")
- [ ] Stakeholders notified ("Deployment starting soon")

**During Deployment**:
- [ ] Enable maintenance mode (if downtime required)
- [ ] Run database migrations
- [ ] Deploy application (blue-green or canary)
- [ ] Run smoke tests
- [ ] Monitor error rates and latency
- [ ] Verify critical flows (login, checkout, etc.)

**Post-Deployment**:
- [ ] Smoke tests passed
- [ ] Monitoring shows healthy metrics
- [ ] Error rate within the documented project target
- [ ] API latency within SLA
- [ ] Disable maintenance mode
- [ ] Status page updated ("All systems operational")
- [ ] Stakeholders notified ("Deployment complete")
- [ ] Monitor for 1 hour (intensive)
- [ ] Monitor for 24 hours (normal)

---

## Go/No-Go Meeting Agenda

**Attendees**: All decision makers (Tech Lead, QA, PM, Security, DevOps)

**Duration**: 30 minutes

**Agenda**:
1. Review pre-release checklist (10 min)
2. Each lead reports status (10 min)
3. Discuss any concerns (5 min)
4. Go/no-go decision (5 min)

**Decision**:
- ✅ **GO**: Applicable release criteria pass and the authorized human approves deployment.
- ⚠️ **GO with conditions**: Only with an authorized, documented exception, named risk owner, mitigation, and follow-up date.
- ❌ **NO-GO**: Critical issues, reschedule deployment

---

## Common No-Go Reasons

**Critical Bug**:
```
Issue: Payment processing fails for international cards
Impact: 30% of customers cannot checkout
Decision: NO-GO until fixed
```

**Failed Load Test**:
```
Issue: System fails below the project's documented load target
Impact: Black Friday launch at risk
Decision: NO-GO until performance improved
```

**Security Vulnerability**:
```
Issue: SQL injection found in search endpoint
Severity: Critical
Decision: NO-GO until patched
```

**Incomplete Testing**:
```
Issue: A required E2E check is failing under the project's release policy
Impact: Release criteria are not yet met
Decision: NO-GO until the failure is resolved or formally dispositioned under policy
```

---

## Release Approval Record Template

- **Release / version / artifact**: [identifier]
- **Date and release window**: [date, time, timezone]
- **Human Go/No-Go decision maker**: [name / role]
- **Decision**: [GO / GO WITH CONDITIONS / NO-GO]
- **Required approvers under project policy**: [names / roles and decisions]
- **Conditions and exceptions**: [owner, mitigation, deadline, approval or none]
- **Project risk assessment**: [summary]
- **Rollback / recovery plan**: [path and evidence]
- **Expected downtime / user impact**: [project estimate or none]
- **On-call / response owner**: [name / role]

---

## Checklist Template (Copy-Paste)

```
RELEASE APPROVAL CHECKLIST

Release: v______
Date: ______
Deployment Window: ______

1. CODE QUALITY
   [ ] All code merged
   [ ] Code review completed
   [ ] Build passing
   Sign-off: ______

2. TESTING
   [ ] Unit tests: ____ / ____ passed
   [ ] Integration tests: ____ / ____ passed
   [ ] E2E tests: ____ / ____ passed
   [ ] Coverage: _____%
   Sign-off: ______

3. SECURITY
   [ ] Security scan: 0 critical, ____ high
   [ ] Pen test: Passed
   Sign-off: ______

4. PERFORMANCE
   [ ] Load test: ____ users, ____ ms latency
   Sign-off: ______

5. INFRASTRUCTURE
   [ ] Monitoring configured
   [ ] Backups tested
   Sign-off: ______

6. DOCUMENTATION
   [ ] Release notes written
   Sign-off: ______

7. DATA MIGRATION
   [ ] Migration tested 3x
   [ ] Rollback ready
   Sign-off: ______

8. BUSINESS READINESS
   [ ] UAT sign-off received
   Sign-off: ______

9. COMMUNICATION
   [ ] Stakeholders notified
   Sign-off: ______

10. ROLLBACK PLAN
    [ ] Rollback tested
    [ ] Rollback time: ____ min
    Sign-off: ______

DECISION: [ ] GO  [ ] NO-GO

APPROVALS:
- Tech Lead: ______
- QA Lead: ______
- Security Lead: ______
- DevOps Lead: ______
- Product Manager: ______
```

---

## Notes

**Never skip the checklist**: Production issues are expensive

**Document exceptions**: If check can't be completed, explain why

**NO-GO is not failure**: Better to delay than deploy broken code

**Monitor intensively post-deploy**: First hour is critical
