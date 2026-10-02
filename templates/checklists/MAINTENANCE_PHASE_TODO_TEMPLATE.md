# Maintenance, Warranty, & Operations Phase TODO Template (Module 12 - Module 13)

> Atomic task checklist template for the Post-Release phase: Defect Warranty Period, Monitoring & Observability Setup (APM), Technical/Product Metrics Baseline Establishment, and Continuous Iteration Planning (SLA Retainer / Product Growth).
> Rules: Guard production system stability proactively. Enforce clear boundaries between warranty bug fixes and new feature requests (*scope creep control*). Monitor system health using automated telemetry rather than waiting for end-user complaints.

---

## Maintenance & Operations Metadata
- **System Name**: [System / Application Name]
- **Production Target URL**: `https://app.clientdomain.com`
- **Lead Operations / On-Call Engineer**: [Your Name]
- **Client Management PIC**: [Client PIC Name]
- **Warranty Period**: [30 / 60 / 90 Calendar Days] (From: [YYYY-MM-DD] to [YYYY-MM-DD])
- **Follow-On Contract Model**: [ ] Complimentary Warranty (Standard) | [ ] Monthly SLA Retainer | [ ] Clean-Break Handover
- **Operational Status**: [ ] WARRANTY ACTIVE | [ ] SLA RETAINER ACTIVE | [ ] ARCHIVED / CLOSED

---

## 1. Module 12: Warranty Period Management & Defect Servicing (Warranty Period Tasks)

### 1.1 Warranty Initiation & Scope Boundary
- [ ] `maintenance/warranty-kickoff.md`: Issue formal confirmation letter of warranty commencement calculated from the Final BAST signing date - expect warranty start and expiration dates documented in black and white
- [ ] `maintenance/warranty-scope-policy.md`: Enforce and communicate Warranty Scope Boundaries to all client stakeholders:
  - **COVERED**: Code bugs/defects deviating from agreed FSD/SOW specification documents, internal server crashes, database query failures
  - **NOT COVERED**: New workflow/feature requests (*Change Requests*), UI redesigns based on new aesthetic preferences, damage caused by client team manual code modifications, drastic third-party API changes outside developer control
  - expect liability boundaries understood and acknowledged in writing by client
- [ ] `maintenance/support-channels.md`: Establish official support channels (*Support Ticket Channel*: Helpdesk Portal / Support Email / Dedicated Slack Channel) - expect centralized, auditable communications rather than ad-hoc direct messages

### 1.2 Incident Triage & Service Level Agreement (SLA Tiers)
- [ ] Apply incident ticket classification matrix and response/resolution time commitments:
  - **Tier 1 - Critical Outage (P1)**: Total system downtime or data corruption. Response time: < 1 hour. Resolution/workaround target: < 4 hours.
  - **Tier 2 - Major Degradation (P2)**: Core business features disrupted for majority of users. Response time: < 2 hours. Resolution target: < 12 hours.
  - **Tier 3 - Moderate Defect (P3)**: Non-critical functional bug with available workaround. Response time: < 8 hours. Resolution target: < 48 hours.
  - **Tier 4 - Minor / Cosmetic (P4)**: Text typo or minor cosmetic defect. Response time: < 24 hours. Resolution target: Scheduled in periodic patch releases.
  - expect ticket handling workflow adheres to SLA commitments
- [ ] `maintenance/incident-log.md`: Log every incident ticket reported during the warranty period: Ticket ID, Reporter, Ingest Timestamp, Severity, Root Cause Analysis (RCA), Handling Time, Resolution Timestamp - expect all tickets tracked accountably

### 1.3 Post-Incident Analysis (Post-Mortem & Root Cause Analysis)
- [ ] `maintenance/post-mortems/YYYY-MM-DD-incident-rca.md`: For every P1 or P2 incident, compile Root Cause Analysis (RCA) document using the 5-Whys methodology:
  - Incident timeline (*Incident Timeline*)
  - Business impact and number of affected users
  - Technical root cause (*Root Cause*)
  - Emergency corrective action (*Corrective Action*)
  - Preventative action to prevent recurrence (*Preventative Action*)
  - expect professional transparency that builds client trust
- [ ] Deploy corrective patch to production and re-verify with ticket reporter - expect incident ticket closed with RESOLVED status

### 1.4 Transition to Maintenance Contract (SLA Retainer Proposal)
- [ ] `maintenance/sla-retainer-proposal.md`: At 14 days before warranty expiration, draft and deliver Continuous Maintenance Service Agreement (*SLA Retainer Contract*) proposal:
  - Monthly support hour packages (e.g., 10 hours, 20 hours, or 40 hours per month)
  - Fixed monthly retainer fee (*Monthly Retainer Fee*)
  - Blended hourly rate for additional Change Request work beyond allotment (*Blended Hourly Rate*)
  - Routine preventative maintenance (monthly OS/framework security patches, database audits)
  - expect retainer proposal delivered on time before client support continuity lapses
- [ ] Negotiate and sign new retainer contract or execute final warranty closure procedures (*Warranty Sign-off / Closure Certificate*) if client opts for self-maintenance - expect operational status clearly finalized

---

## 2. Module 13: Monitoring & Observability Systems Setup (Monitoring Setup)

### 2.1 Application Performance Monitoring & Error Tracking (APM & Error Tracking)
- [ ] Install and initialize crash/error monitoring SDK in backend and frontend (Sentry / Datadog / Highlight.io / Bugsnag):
  - Configure unhandled promise rejection and fatal exception tracking
  - Attach user context data (pseudonymized User ID, environment tag: `production`)
  - Configure sensitive data sanitization (*Data Scrubbing*): scrub passwords, credit card numbers, and JWT tokens from error logs
  - expect browser client and backend server errors automatically captured in monitoring dashboard
- [ ] Implement performance transaction tracing (*Performance Tracing / OpenTelemetry*): track slow database queries (*slow queries > 500ms*) and external API execution latency - expect bottleneck visualizations mapped

### 2.2 Synthetic Uptime Monitoring
- [ ] Register external uptime monitoring probes (BetterStack / UptimeRobot / Pingdom / Cloudflare Healthchecks):
  - Monitor public `/healthz` endpoint every 1-minute interval from multiple global geographic regions
  - Assert HTTP 200 OK status and response latency < 1000 ms
  - Monitor SSL/TLS certificate validity (automated warning if expiration < 30 days)
  - expect automated alerts triggered when site experiences downtime
- [ ] Configure escalation alert routing (*Escalation Alert Routing*): connect downtime notifications to Telegram Bot, Discord Webhook, SMS, or PagerDuty on-call engineer - expect on-call engineer receives emergency alert in < 2 minutes of server failure

### 2.3 Centralized Logging & Retention Policies (Log Management)
- [ ] Configure centralized log aggregation (BetterStack Logs / Datadog Logs / Grafana Loki / AWS CloudWatch) - expect all logs indexed with contextual metadata (Level: INFO/WARN/ERROR, UTC Timestamp, Request ID, Path)
- [ ] Implement log retention policy (*Log Retention Policy*): retain standard operational logs for 30 days and security audit logs (*Security Audit Trail*) for minimum 365 days per data privacy compliance - expect log storage remains cost-effective and compliant

### 2.4 Automated Database Backups & Restoration Drills (Backup & Restore Drills)
- [ ] Schedule automated daily database backups (*Automated Daily Database Backup / Snapshots*) with retention of 30 daily snapshots and 12 monthly snapshots - expect snapshots automatically archived in isolated cloud storage
- [ ] `maintenance/drills/backup-restore-drill.md`: Perform backup restoration drill to isolated staging environment at least once per quarter:
  - Download latest backup snapshot
  - Restore into clean database
  - Verify data integrity and relational constraints
  - Record actual recovery duration vs target RTO
  - expect empirical evidence that backups are fully recoverable (*valid & non-corrupted backups*)

---

## 3. Module 13: Baseline Metrics Establishment & Health Dashboard (Metrics Baseline)

### 3.1 Technical Performance Metrics Measurement (Technical Baseline)
- [ ] `ops/metrics/technical-baseline.md`: Measure and establish baseline numbers during week 2 of normal production operation:
  - **Uptime / Availability**: Record actual uptime percentage (minimum target: 99.9% = max downtime 43 minutes/month)
  - **Transaction Latency**: Average API response time (p50 target < 100 ms, p95 target < 500 ms, p99 target < 1500 ms)
  - **Error Rate**: Ratio of HTTP 5xx errors to total requests (target < 0.05%)
  - **Average Server Load**: CPU, RAM, Disk space utilization percentages, and DB connection pool peak
  - expect baseline metrics documented as benchmark for future anomaly detection
- [ ] `ops/metrics/core-web-vitals.md`: Record real frontend user experience metrics (Real User Monitoring - RUM):
  - Largest Contentful Paint (LCP): target < 2.5 seconds
  - Interaction to Next Paint (INP): target < 200 ms
  - Cumulative Layout Shift (CLS): target < 0.1
  - expect all metrics categorized as "Good" (Green) on Google PageSpeed Insights

### 3.2 Business & Product Usage Metrics Measurement (Business Baseline)
- [ ] `ops/metrics/product-baseline.md`: Measure and record post-launch product business performance baseline:
  - Active User Count: Daily Active Users (DAU) & Monthly Active Users (MAU)
  - Core Transaction Volume: Number of successful transactions per day/week
  - Primary Flow Conversion Rate: Percentage of users completing Core User Loop from registration to conversion
  - Early Drop-off / Churn Rate: Percentage of users dropping off during onboarding steps
  - expect product baseline data sourced from analytics instrumentation (PostHog / Mixpanel / Plausible) without guesswork

### 3.3 Product Health Dashboard Setup (Product Health Dashboard)
- [ ] `ops/dashboards/product-health-dashboard.md`: Build or configure unified visual dashboard displaying key technical and business health indicators in a single view - expect dashboard accessible by technical team and client management
- [ ] Create Monthly Executive Health Digest report template to deliver to client Project Sponsor - expect stakeholders understand software performance and ROI

---

## 4. Module 13: Iteration Planning & Sustainable Growth (Iteration Planning)

### 4.1 User Feedback Loop
- [ ] `growth/user-feedback.md`: Install contextual in-app feedback widgets (NPS in-app survey, "Report Issue / Submit Feedback" button, star micro-ratings on completed transactions) - expect qualitative data flowing directly from active users
- [ ] `growth/user-feedback.md`: Categorize and cluster user feedback bi-weekly: Friction Points, Feature Requests, Bug Reports, UX Enhancements - expect recurring user needs patterns identified

### 4.2 Growth Experiment Management & Idea Backlog (Growth Backlog)
- [ ] `growth/experiment-backlog.md`: Build list of product enhancement hypotheses and A/B testing experiments:
  - Hypothesis Statement: "If we [make change X], then [metric Y will increase by Z%], because [research rationale W]"
  - Experiment priority scoring using ICE framework (*Impact 1-10, Confidence 1-10, Ease 1-10*)
  - expect experiment backlog ranked by highest implementation ROI
- [ ] Design simple A/B test experiment for highest-friction conversion elements (e.g., simplified registration form, CTA button copywriting) - expect test plan includes measurable control and variant groups

### 4.3 Iteration Sprint Planning & Technical Debt Paydown (Sprint Planning)
- [ ] `growth/sprint-backlog.md`: Formulate sprint plan for ongoing maintenance and development (2-Week / 1-Month Cycles):
  - **50% Capacity**: High-priority new features from roadmap evaluation and user feedback
  - **30% Capacity**: Technical debt paydown (*Technical Debt*), database query optimization, framework/library dependency upgrades
  - **20% Capacity**: Security patches, low-severity bug triage, and minor documentation fixes
  - expect balanced capacity allocation between business innovation and long-term system stability
- [ ] Schedule Quarterly Business Review (QBR) sessions with client stakeholders to evaluate business metric targets and plan long-term roadmap - expect strategic long-term partnership maintained

---

## 5. Maintenance & Operations Cycle Verification Gate

| Evaluation Parameter | Minimum Pass Standard | Verification Status | Evidence Notes |
| :--- | :--- | :---: | :--- |
| **Warranty Resolution** | 100% warranty bug tickets resolved, zero P1/P2 tickets open, warranty period formally concluded | [ ] PASS | Attach `maintenance/incident-log.md` |
| **Observability System** | APM active, 1-minute uptime probe active, emergency alerts connected to Telegram/Slack | [ ] PASS | Attach alert test evidence |
| **Backup Data Security** | Automated daily backup active, staging restore simulation verified successful | [ ] PASS | Attach restore drill log |
| **Performance & Business Baseline** | Technical baseline report (Uptime >= 99.9%, p95 < 500ms) & product metrics documented | [ ] PASS | Attach in `ops/metrics/` |
| **Follow-on Service Contract** | SLA Retainer transition agreed OR Warranty Closure Certificate signed | [ ] PASS | Attach SLA contract / Closure Certificate |

### Final Project Lifecycle Status:
- [ ] **TRANSITION TO ONGOING SLA RETAINER**: Client actively subscribes to monthly maintenance and product iteration service.
- [ ] **OFFICIAL PROJECT CLOSURE (LIFECYCLE COMPLETED & ARCHIVED)**: Warranty period completed, all obligations fulfilled, system operating stably under client team ownership. Repository archived.
