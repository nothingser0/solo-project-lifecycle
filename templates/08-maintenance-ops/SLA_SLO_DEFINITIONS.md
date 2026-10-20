# SLA/SLO Definitions Template

> **Purpose**: Define Service Level Agreements and Objectives for Enterprise systems  
> **When**: M05 Architecture or M10 Production deployment  
> **Target**: Enterprise projects with uptime/performance commitments

---

## SLA vs SLO vs SLI

**SLI (Service Level Indicator)**: Measurement (what you measure)
- Example: API response time, uptime percentage, error rate

**SLO (Service Level Objective)**: Internal target (what you aim for)
- Example: 99.95% uptime, <200ms API response time

**SLA (Service Level Agreement)**: External commitment with penalties (what you promise)
- Example: 99.9% uptime or customer gets 10% refund

**Relationship**: SLI measures → SLO targets → SLA commits (with penalties)

---

## SLA Template

### Service Level Agreement

**Service**: [Application Name]  
**Provider**: [Your Company]  
**Customer**: [Client Company]  
**Effective Date**: [YYYY-MM-DD]  
**Review Date**: [Quarterly/Annually]

---

### 1. Service Availability

**Definition**: Percentage of time service is operational and accessible

**Commitment**: 99.9% uptime per month

**Calculation**:
```
Uptime % = (Total Minutes in Month - Downtime Minutes) / Total Minutes in Month × 100

Example (30-day month):
- Total minutes: 43,200
- Downtime allowed: 43.2 minutes (99.9%)
- Actual downtime: 20 minutes
- Uptime achieved: 99.95% ✓
```

**Exclusions** (not counted as downtime):
- Scheduled maintenance (announced 7 days prior, max 4 hours/month)
- Force majeure (natural disasters, pandemics, war)
- Client's network/infrastructure issues
- Third-party service failures (AWS, Stripe, etc.)

**Measurement**:
- Monitoring: Pingdom, Datadog, UptimeRobot
- Frequency: Every 1 minute
- Location: Multiple global data centers
- Reporting: Monthly uptime report

---

### 2. Performance SLA

#### 2.1 API Response Time

**Commitment**: 95th percentile (p95) response time ≤ 200ms

**Measurement**:
- Endpoint: All public API endpoints
- Excludes: File uploads, exports, batch operations
- Sample: 100% of requests logged

**Example**:
```
Month: October 2024
Total requests: 10,000,000
p95 response time: 185ms ✓ (under 200ms target)
```

---

#### 2.2 Page Load Time

**Commitment**: 90th percentile (p90) page load ≤ 3 seconds

**Measurement**:
- Tool: Google Analytics, Real User Monitoring (RUM)
- Pages: Homepage, Dashboard, Key transactional pages
- Network: Standard broadband (5 Mbps)

---

#### 2.3 Database Query Time

**Commitment**: 95% of queries complete within 100ms

**Measurement**:
- Tool: Database query logs, APM (Datadog)
- Excludes: Analytics queries, bulk reports

---

### 3. Support Response Time

| Severity | Definition | Response Time | Resolution Time |
|:---------|:-----------|:--------------|:----------------|
| **P1 Critical** | Service down, all users affected | 1 hour | 4 hours |
| **P2 High** | Major feature broken, workaround exists | 4 hours | 1 business day |
| **P3 Medium** | Minor bug, low impact | 1 business day | 3 business days |
| **P4 Low** | Cosmetic issue, feature request | 3 business days | Best effort |

**Support Hours**:
- P1/P2: 24/7/365
- P3/P4: Business hours (9 AM - 5 PM, Mon-Fri, UTC+7)

**Contact Methods**:
- P1: Phone hotline + email
- P2-P4: Email, support portal

---

### 4. Data Backup & Recovery

**Backup Frequency**: Daily at 2 AM UTC

**Retention**:
- Daily backups: 7 days
- Weekly backups: 4 weeks
- Monthly backups: 12 months

**Recovery Point Objective (RPO)**: 24 hours (max data loss)

**Recovery Time Objective (RTO)**: 4 hours (max downtime to restore)

**Testing**: Quarterly backup restore test

---

### 5. Security Incident Response

**Detection Time**: 15 minutes (security monitoring alerts)

**Notification Time**: 1 hour (notify client of security incident)

**Containment Time**: 4 hours (isolate affected systems)

**Resolution Time**: 24-72 hours (depending on severity)

**Post-Mortem**: 7 days (detailed incident report)

---

### 6. SLA Credits (Financial Penalties)

**Calculation**: Based on monthly service fee

| Uptime Achieved | SLA Credit | Example (Monthly Fee $10,000) |
|:----------------|:-----------|:------------------------------|
| ≥ 99.9% | 0% (no credit) | $0 |
| 99.0% - 99.89% | 10% | $1,000 credit |
| 95.0% - 98.99% | 25% | $2,500 credit |
| < 95.0% | 50% | $5,000 credit |

**How to Claim**:
1. Client submits claim within 30 days of incident
2. Provider reviews monitoring logs
3. Credit applied to next month's invoice
4. Credits do not carry over to future months

**Maximum Credit**: 50% of monthly fee (no full refunds)

---

### 7. Reporting

**Monthly SLA Report** (delivered by 5th of following month):
- Uptime percentage
- Downtime incidents (date, duration, cause)
- Performance metrics (API response time, page load)
- Support ticket statistics (response/resolution times)
- SLA credits issued (if any)

**Quarterly Business Review** (QBR):
- Trend analysis (uptime, performance over 3 months)
- Capacity planning
- Security incidents
- Improvement recommendations

---

### 8. Change Management

**Planned Maintenance**:
- Notification: 7 days prior
- Window: 2-4 AM UTC (low traffic)
- Duration: Max 4 hours
- Frequency: Max 1/month

**Emergency Maintenance**:
- Notification: ASAP (may be concurrent with work)
- Critical security patches exempt from SLA

---

### 9. Service Review & Amendment

**Review Frequency**: Annually on contract anniversary

**SLA Adjustment**:
- Upward (more stringent): Requires price adjustment
- Downward: Requires client approval

**Termination**:
- If SLA consistently missed (3 consecutive months), client may terminate without penalty

---

---

## SLO Template (Internal Targets)

### Service Level Objectives

**Purpose**: Internal targets stricter than SLA to ensure SLA compliance

**Rule of Thumb**: SLO should be 0.1-0.5% higher than SLA
- SLA: 99.9% → SLO: 99.95%
- Reason: Buffer for unexpected issues

---

### 1. Availability SLO

| Metric | SLA (External) | SLO (Internal) | Error Budget |
|:-------|:---------------|:---------------|:-------------|
| **Monthly Uptime** | 99.9% | 99.95% | 21.6 min/month |
| **API Availability** | 99.9% | 99.95% | 21.6 min/month |
| **Database Availability** | 99.95% | 99.99% | 4.3 min/month |

**Error Budget**:
- SLA allows 43.2 min downtime/month
- SLO allows 21.6 min downtime/month
- Buffer: 21.6 minutes (use for deployments, incidents)

**Policy**:
- If error budget exhausted: Freeze new feature releases, focus on reliability
- If 50% error budget used: Review incident causes, add monitoring

---

### 2. Performance SLO

| Metric | SLA (External) | SLO (Internal) | Alerting Threshold |
|:-------|:---------------|:---------------|:-------------------|
| **API p95 Response** | <200ms | <150ms | >180ms (warning) |
| **API p99 Response** | <500ms | <300ms | >400ms (warning) |
| **Page Load p90** | <3s | <2s | >2.5s (warning) |
| **Database Query p95** | <100ms | <50ms | >80ms (warning) |

**Alerting**:
- Yellow alert: Approaching SLO (80% of limit)
- Red alert: SLO breached (100% of limit)
- Critical alert: SLA breached (affects customers)

---

### 3. Error Rate SLO

**Success Rate**: 99.9% of API requests return non-error response (2xx, 3xx)

**Error Budget**:
- 10,000,000 requests/month
- Allowed errors: 10,000 (0.1%)
- Current errors: 5,000 (0.05%) ✓

**Error Types**:
- 4xx errors: Client errors (not counted against SLO if user-caused)
- 5xx errors: Server errors (counted against SLO)

---

### 4. Capacity SLO

**Concurrent Users**: Support 10,000 concurrent users without degradation

**Load Test Results**:
- Tested: 15,000 concurrent users (150% of SLO)
- Response time: <200ms maintained
- Error rate: <0.1%
- Capacity buffer: 50%

**Threshold Alert**: 8,000 concurrent users (80% of capacity)

---

---

## SLI Definitions (What to Measure)

### 1. Availability SLI

**Metric**: Uptime percentage

**Data Source**: Pingdom, Datadog Synthetics

**Calculation**:
```python
uptime_percentage = (total_checks - failed_checks) / total_checks * 100

# Example:
total_checks = 43200  # 1 check/min for 30 days
failed_checks = 20
uptime = (43200 - 20) / 43200 * 100 = 99.95%
```

**Success Criteria**: HTTP 200 response within 30 seconds

---

### 2. Latency SLI

**Metric**: API response time (p50, p95, p99)

**Data Source**: Application logs, APM (Datadog, New Relic)

**Calculation**:
```python
# p95 = 95% of requests faster than this value
requests = [45ms, 60ms, 120ms, 150ms, 180ms, ...]  # 1M requests
p95 = percentile(requests, 95)  # 180ms
```

**Buckets**:
- Fast: <100ms
- Acceptable: 100-200ms
- Slow: 200-500ms
- Very slow: >500ms

---

### 3. Error Rate SLI

**Metric**: Percentage of failed requests

**Data Source**: Application logs, load balancer logs

**Calculation**:
```python
error_rate = failed_requests / total_requests * 100

# Example:
total_requests = 1000000
failed_requests = 500  # 5xx errors
error_rate = 500 / 1000000 * 100 = 0.05%
```

**Error Classification**:
- 4xx: Client errors (bad request, unauthorized)
- 5xx: Server errors (internal error, timeout)

---

### 4. Throughput SLI

**Metric**: Requests per second (RPS)

**Data Source**: Load balancer metrics, APM

**Calculation**:
```python
rps = total_requests / time_period_seconds

# Example:
requests_per_minute = 50000
rps = 50000 / 60 = 833 RPS
```

**Capacity**:
- Current peak: 1000 RPS
- Tested capacity: 2000 RPS
- Buffer: 100%

---

---

## SLA Monitoring Dashboard

### Key Metrics (Real-Time)

**Availability**:
- Current status: 🟢 Up / 🔴 Down
- Uptime this month: 99.97%
- Remaining error budget: 15 minutes

**Performance**:
- API p95 response time: 145ms
- Page load p90: 1.8s
- Database query p95: 42ms

**Error Rate**:
- 5xx errors today: 12 (0.02%)
- Error budget used: 30%

**Support**:
- Open tickets: 5 (2 P1, 3 P2)
- Avg response time P1: 45 min ✓
- Avg resolution time P2: 8 hours ✓

---

### Alerts Configuration

**Critical Alerts** (page on-call engineer):
- Uptime drops below 99.9% (SLA breach)
- API p95 > 200ms for 5 minutes
- Error rate > 1% for 5 minutes
- P1 ticket open > 1 hour without response

**Warning Alerts** (notify team chat):
- Uptime drops below 99.95% (SLO breach)
- API p95 > 150ms for 5 minutes
- Error rate > 0.5%
- Capacity > 80%

---

---

## Example: SLA Incident Report

**Incident**: API Downtime on 2024-10-04

**Summary**:
- Duration: 35 minutes
- Impact: All API endpoints down
- Users affected: 100% (5,000 concurrent users)
- SLA breach: Yes (99.9% uptime = 43.2 min allowed, 35 min used)

**Timeline**:
- 02:15 UTC: Database failover triggered
- 02:17 UTC: API starts returning 500 errors
- 02:20 UTC: On-call engineer paged
- 02:25 UTC: Root cause identified (connection pool exhausted)
- 02:45 UTC: Database connection pool increased
- 02:50 UTC: Service restored, monitoring confirmed

**Root Cause**: Database connection pool limit (100) too low for traffic spike (2000 concurrent users)

**Resolution**: Increased connection pool to 500, added capacity alerting

**Prevention**:
- Added load testing for 3x expected traffic
- Implemented connection pool auto-scaling
- Added alert for connection pool utilization > 70%

**SLA Impact**:
- Uptime this month: 99.92% (35 min downtime)
- SLA credit: 10% ($1,000 refund)

**Customer Communication**:
- Notification sent at 02:20 UTC (5 min after detection)
- Status updates every 15 minutes
- Post-mortem shared within 24 hours

---

## Checklist

Before defining SLA:
- [ ] Understand client requirements (uptime, performance)
- [ ] Review historical performance (can we meet SLA?)
- [ ] Calculate costs (monitoring, infrastructure, penalties)
- [ ] Set SLOs higher than SLA (buffer)
- [ ] Define measurement methodology
- [ ] Set up monitoring tools

After SLA defined:
- [ ] Dashboard created (real-time metrics)
- [ ] Alerts configured (warning + critical)
- [ ] On-call rotation established
- [ ] Incident response plan documented
- [ ] Monthly reporting automated
- [ ] SLA credits process documented

Ongoing:
- [ ] Review SLA performance monthly
- [ ] Adjust SLOs if consistently missing/exceeding
- [ ] Quarterly SLA review with client
- [ ] Update SLA based on system changes

---

## Notes

**Under-promise, over-deliver**: Set SLA at 99.9%, aim for 99.95%

**Error budgets are features**: Use remaining error budget for risky deployments

**SLA is legal document**: Have lawyer review before signing

**SLA penalties hurt**: Build buffer between SLO and SLA to avoid credits
