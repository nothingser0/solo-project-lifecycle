# Communication Plan: [Project Name]

**Project**: [Project Name]  
**Timeline**: [Start Date] - [End Date]  
**Prepared By**: [Your Name]  
**Last Updated**: [YYYY-MM-DD]

---

## 1. Communication Objectives

- **Primary Goal**: [E.g., "Ensure all stakeholders aligned on scope, timeline, and deliverables"]
- **Secondary Goals**:
  - Early warning system for risks and blockers
  - Transparent progress tracking
  - Minimize surprises and scope creep
  - Build trust through consistent updates

---

## 2. Stakeholder Communication Matrix

### Tier 1: MANAGE CLOSELY (Daily/Weekly Sync)

| Stakeholder | Role | Cadence | Channel | Format | Content | Timing |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [Product Owner] | Decision Maker | Daily standup (async) | Slack DM | 3-sentence update | Yesterday/Today/Blockers | 09:00 WIB daily |
| [Product Owner] | Decision Maker | Weekly 1:1 sync | Zoom call (30 min) | Status dashboard + decision items | Progress, risks, decisions needed | Fri 15:00 WIB |
| [CTO/Tech Lead] | Tech Authority | Bi-weekly review | Zoom call (45 min) | Architecture review + code walkthrough | Tech debt, security, scalability | Every other Wed 14:00 WIB |

**Key Actions**:
- Never let them discover issues from others first
- Bring 2-3 options for every decision request, with recommendation
- Confirm decisions in writing (email/Slack) within 2 hours

---

### Tier 2: KEEP SATISFIED (Bi-weekly/Monthly)

| Stakeholder | Role | Cadence | Channel | Format | Content | Timing |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [CFO] | Budget Approval | Bi-weekly | Email (formal) | Executive summary (1-page) | RAG status, budget burn, risks | Every other Fri 17:00 WIB |
| [Legal/Compliance] | Risk Mitigation | Monthly | Email + attachment | Compliance checklist | Security audit, data privacy updates | Last Fri of month |
| [Client CEO] | Final Approver | Monthly | Email (exec summary) + optional call | Top-down status report | Business outcomes, milestone achieved | 1st Mon of month 10:00 WIB |

**Executive Summary Template**:
```markdown
**Status**: 🟢 Green / 🟡 Yellow / 🔴 Red  
**Progress**: [X]% complete (Week [Y] of [Z])  
**Budget**: $[X] spent / $[Y] total ([Z]% utilization)  
**Key Wins**: [1-2 highlights]  
**Risks**: [Top 1-2 risks with mitigation]  
**Asks**: [Explicit decision/approval needed]  
**Next Milestone**: [What's shipping next + date]
```

---

### Tier 3: KEEP INFORMED (Weekly Standup)

| Stakeholder | Role | Cadence | Channel | Format | Content | Timing |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [Designer] | UI/UX | Weekly sync | Discord + Figma | Design review + feedback | Design iteration status, UI changes | Mon 10:00 WIB |
| [QA Engineer] | Quality Gate | Weekly | Slack channel | Test report + bug triage | Test coverage, P0/P1 bugs, release readiness | Thu 16:00 WIB |
| [DevOps] | Infrastructure | Weekly | Slack DM | Infra health check | Uptime, deployment status, incident log | Wed 11:00 WIB |
| [Marketing] | Launch Prep | Bi-weekly | Email + demo link | Feature showcase | New features, screenshots, launch ETA | Every other Tue 14:00 WIB |

**Standup Update Template** (for Slack/Discord):
```markdown
**Last Week**:
- ✅ Shipped: [Feature X, Bug fix Y]
- 🚧 In Progress: [Feature Z - 60% done]

**This Week**:
- 🎯 Goal: [Complete Feature Z, start QA testing]
- 📅 Milestone: [Deploy to staging by Friday]

**Blockers**:
- ⚠️ [Blocker description] - Need [Action] from [Person] by [Date]

**Asks**:
- 🙏 [Specific request with deadline]
```

---

### Tier 4: MONITOR (Milestone Broadcasts)

| Stakeholder | Role | Cadence | Channel | Format | Content | Timing |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| [Sales Team] | Pipeline | Quarterly | Email broadcast | Release notes | New features, competitive positioning | After each major release |
| [Support Team] | End-user Help | Post-launch | Knowledge base + video | Training materials | User manual, FAQ, troubleshooting guide | 1 week before launch |
| [External Partner] | Integration | Ad-hoc | Email notification | API changelog | Breaking changes, new endpoints | 2 weeks before deployment |

---

## 3. Communication Channels & Tools

| Channel | Purpose | Response SLA | Working Hours | Escalation |
| :--- | :--- | :--- | :--- | :--- |
| **Slack/Discord** | Daily tactical updates, quick questions | <2 hours | Mon-Fri 09:00-18:00 WIB | Call if no reply >4 hours |
| **Email** | Formal approvals, executive summaries | <24 hours | Mon-Fri 09:00-17:00 WIB | Slack DM if urgent |
| **Zoom/Google Meet** | Weekly syncs, demos, decision meetings | Scheduled | Book 24h in advance | Reschedule once, max 2h delay |
| **Project Dashboard** | Real-time progress tracking | Updated daily | 24/7 read-only access | N/A |
| **Phone/WhatsApp** | Emergencies only (P0 incidents) | <30 minutes | 24/7 for P0 only | CEO/CTO for data breach |

**Tool Stack**:
- Task tracking: [Linear / Jira / Notion]
- Documentation: [Notion / Confluence / Google Docs]
- Design: [Figma / Adobe XD]
- Code: [GitHub / GitLab]
- Metrics: [Datadog / Grafana / Custom dashboard]

---

## 4. Meeting Cadence & Agenda

### Daily Standup (Async, 5 min)
- **Participants**: Solo Dev → Product Owner
- **Format**: Slack message at 09:00 WIB
- **Template**: Yesterday / Today / Blockers

### Weekly 1:1 Sync (30 min)
- **Participants**: Solo Dev + Product Owner
- **Frequency**: Every Friday 15:00 WIB
- **Agenda**:
  1. Progress review (10 min): Demo what shipped
  2. Blockers & risks (10 min): Discuss mitigation
  3. Next week priorities (5 min): Confirm top 3 tasks
  4. Decisions needed (5 min): Approval requests

### Bi-weekly Tech Review (45 min)
- **Participants**: Solo Dev + CTO/Tech Lead + (optional) Security Reviewer
- **Frequency**: Every other Wednesday 14:00 WIB
- **Agenda**:
  1. Architecture changes (15 min): RFC review
  2. Code quality (10 min): Tech debt, test coverage
  3. Security & performance (10 min): Audit findings
  4. Infrastructure (10 min): Scaling plan, uptime report

### Monthly Executive Review (60 min)
- **Participants**: Solo Dev + Product Owner + CFO + CEO
- **Frequency**: First Monday of month 10:00 WIB
- **Agenda**:
  1. Milestone achieved (15 min): Demo + business metrics
  2. Budget & timeline (15 min): Burn rate, forecast
  3. Risk & mitigation (15 min): Top 3 risks + response plan
  4. Next month roadmap (15 min): Priorities + resource needs

---

## 5. Escalation Matrix

| Issue Type | Severity | First Contact | Response SLA | Escalate To | Escalation SLA |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Blocker (dev stuck >3 days)** | High | Product Owner (Slack) | <4 hours | CTO / External consultant | <24 hours |
| **Scope creep request** | Medium | Product Owner (email) | <48 hours | CFO (if budget) + CEO (if timeline) | <1 week |
| **Budget overrun (>10%)** | High | CFO (email + call) | <24 hours | CEO + Board | <48 hours |
| **Client dependency delay** | Medium | Product Owner (Slack) | <24 hours | Client CEO | <3 days |
| **P0 production incident** | Critical | CTO (phone) + PO (Slack) | <30 minutes | CEO (if data breach) | <2 hours |
| **Timeline slip (>2 weeks)** | High | Product Owner (call) | <24 hours | CEO + CFO | <48 hours |
| **Design approval delay** | Low | Designer + PO (Slack) | <48 hours | Proceed with last approved version | <5 days |

**Escalation Protocol**:
1. Attempt resolution at current level first (document attempts)
2. Notify stakeholder of pending escalation (give 24h to respond)
3. Escalate with context: Problem + Impact + Options + Recommendation
4. CC original contact on escalation (transparency)

---

## 6. Status Report Templates

### Weekly Status Report (for "Keep Satisfied" Tier)

**Subject**: [Project Name] - Week [X] Status Report 🟢

```markdown
**Status**: 🟢 Green (on track)  
**Progress**: 45% complete (Week 5 of 10)  
**Budget**: $18K spent / $40K total (45% utilized, on track)

**This Week's Wins**:
- ✅ Completed user authentication module (OAuth2 + 2FA)
- ✅ Integrated Stripe payment gateway (test mode)
- ✅ Deployed staging environment (https://staging.example.com)

**Next Week's Goals**:
- 🎯 Complete product catalog CRUD APIs
- 🎯 Start QA testing on authentication flow
- 🎯 Design review for checkout page

**Risks & Mitigation**:
- ⚠️ **RISK**: Client data migration delayed by 3 days (client-side issue)
  - **Impact**: May delay user import feature by 1 week
  - **Mitigation**: Building mock data generator to continue dev; actual data can be imported post-launch
  - **Status**: Escalated to Client CEO on [Date]

**Blockers**:
- 🚧 Awaiting design approval for mobile responsive layout (sent Mon, no response yet)
  - **Ask**: Need approval by Wed EOD or will proceed with desktop-first approach

**Asks**:
- 🙏 Approve additional $2K budget for SMS gateway (Twilio) for OTP verification
- 🙏 Schedule 30-min demo with Sales team for feedback (propose: next Tue 14:00 WIB)

**Attachments**:
- [Link to Figma prototype]
- [Link to staging environment]
- [Link to updated project timeline (Gantt)]
```

---

### Monthly Executive Summary (1-Page)

**Subject**: [Project Name] - Monthly Executive Summary - [Month YYYY]

```markdown
## Executive Summary: [Month] Progress

**Overall Status**: 🟢 Green  
**Timeline**: On track for [Launch Date]  
**Budget**: [X]% utilized, [Y]% remaining buffer  
**Key Metric**: [E.g., "40% feature completion, 0 P0 bugs"]

---

### 🎯 Business Outcomes Delivered This Month
1. **User Authentication**: OAuth2 + 2FA live on staging, ready for security audit
2. **Payment Integration**: Stripe connected, test transactions successful
3. **Staging Environment**: Accessible for stakeholder review at [URL]

---

### 📊 Progress Metrics
| Metric | Target | Actual | Status |
| :--- | :---: | :---: | :---: |
| Feature Completion | 50% | 45% | 🟡 Slightly behind |
| Test Coverage | 80% | 75% | 🟢 On track |
| Budget Utilization | 50% | 45% | 🟢 Under budget |
| Timeline | Week 6 of 12 | Week 6 of 12 | 🟢 On schedule |

---

### ⚠️ Top 3 Risks
1. **Client Data Migration Delay** (Impact: Medium, Probability: High)
   - **Mitigation**: Mock data fallback, post-launch import option
   - **Owner**: Product Owner (client-side action)

2. **Design Approval Bottleneck** (Impact: Low, Probability: Medium)
   - **Mitigation**: Time-bound approval SLA (48h), proceed with defaults if no response
   - **Owner**: Solo Dev + Designer

3. **Third-party API Stability** (Impact: High, Probability: Low)
   - **Mitigation**: Circuit breaker pattern, fallback to queue-based retry
   - **Owner**: Solo Dev (already implemented)

---

### 🚀 Next Month Roadmap
- Complete all P0 features (8 remaining)
- Security audit & penetration testing
- UAT with 10 pilot users
- Production deployment preparation

---

### 💰 Financial Update
- **Spent to Date**: $18,000 (45%)
- **Remaining Budget**: $22,000 (55%)
- **Forecast**: On track to finish at $38K (5% under budget)
- **Additional Requests**: $2K for SMS gateway (Twilio OTP)

---

### 🙏 Executive Decisions Needed
1. **Budget Approval**: Additional $2K for SMS gateway (ROI: improved security, reduced fraud risk)
2. **Go/No-Go**: Security audit vendor selection (3 quotes attached, recommend Vendor B: $5K, 2-week turnaround)

---

**Prepared By**: [Your Name]  
**Next Review**: [Date]
```

---

## 7. Communication Dos & Don'ts

### ✅ DO
- **Proactive**: Report bad news early with mitigation options
- **Data-driven**: Use metrics (80% done, 3 bugs, 2 days delay) not vague terms ("almost done", "a few issues")
- **Options-oriented**: Present 2-3 choices with pros/cons, highlight recommendation
- **Time-bound**: Every ask has a deadline ("Need decision by Wed EOD")
- **Follow-up in writing**: Confirm verbal decisions via email/Slack within 2 hours
- **Adapt tone**: Technical with engineers, business-focused with executives

### ❌ DON'T
- **Surprise stakeholders**: No "by the way, we're 2 weeks late" in passing
- **Vague language**: "Should be done soon", "Might have an issue", "Pretty good progress"
- **Open-ended asks**: "Let me know what you think" → Should be "Approve Option A or B by Friday?"
- **Tech jargon to non-tech**: "CORS preflight failing" → "Third-party API integration issue, ETA 2 days"
- **Over-communicate to low-interest stakeholders**: Don't send daily updates to CFO
- **Radio silence**: If blocked, say you're blocked. Silence = everything is fine assumption.

---

## 8. Crisis Communication Protocol

### Trigger Events (Activate Immediately)
- Production outage >1 hour
- Data breach or security incident
- Timeline slip >3 weeks
- Budget overrun >20%
- Key stakeholder leaving project
- Legal/regulatory compliance violation

### Crisis Communication Steps
1. **Immediate Notification** (<30 min):
   - Notify "Manage Closely" tier via phone/WhatsApp
   - Subject: "URGENT: [Issue Type] - [Project Name]"

2. **Initial Assessment** (<2 hours):
   - Email to all stakeholders with:
     - What happened (facts only, no speculation)
     - Current status
     - Who is working on it
     - Next update ETA

3. **Hourly Updates** (until resolved):
   - Status update every 1-2 hours to "Manage Closely" tier
   - Daily summary to "Keep Satisfied" tier

4. **Post-Mortem** (within 1 week):
   - Root cause analysis
   - Timeline of events
   - Lessons learned
   - Prevention measures implemented

---

## 9. Change Log

| Date | Change | Reason | Updated By |
| :--- | :--- | :--- | :--- |
| [YYYY-MM-DD] | Initial communication plan | Project kickoff | [Your Name] |

---

## 10. Review & Adjustment

**Review Cadence**: Monthly (1st week of month)  
**Review Checklist**:
- [ ] Are stakeholders responding within SLA?
- [ ] Any communication gaps or over-communication?
- [ ] Channel/tool changes needed?
- [ ] Escalation matrix still accurate?
- [ ] Meeting cadence still appropriate?

**Adjustment Protocol**: If 2+ stakeholders report communication issues, schedule 30-min retrospective to adjust plan.
