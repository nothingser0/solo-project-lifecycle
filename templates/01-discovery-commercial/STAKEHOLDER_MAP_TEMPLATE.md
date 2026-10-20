# Stakeholder Mapping: [Project Name]

**Project**: [Project Name]  
**Date**: [YYYY-MM-DD]  
**Prepared By**: [Your Name]  
**Review Cycle**: [Bi-weekly / Monthly]

---

## 1. Power/Interest Matrix

```text
                    HIGH POWER
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        │  KEEP         │   MANAGE      │
        │  SATISFIED    │   CLOSELY     │
        │               │               │
LOW     │───────────────┼───────────────│    HIGH
INTEREST│               │               │  INTEREST
        │  MONITOR      │   KEEP        │
        │               │  INFORMED     │
        │               │               │
        └───────────────┼───────────────┘
                        │
                    LOW POWER
```

---

## 2. Stakeholder Register

### Quadrant 1: MANAGE CLOSELY (Power: HIGH, Interest: HIGH)

| Name | Role/Title | Organization | Power Source | Key Interests | Communication Needs |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [Name] | Product Owner | [Company] | Budget approval, scope sign-off | ROI, timeline, business outcomes | Weekly 1:1, daily Slack updates, decision escalation |
| [Name] | CTO / Tech Lead | [Company] | Tech stack decisions, architecture approval | Technical feasibility, security, scalability | Bi-weekly tech review, architecture RFC |
| [Name] | Client CEO / Founder | [Client Org] | Final approval, payment authorization | Business impact, competitive advantage | Monthly exec summary, milestone demos |

**Strategy**: Proactive engagement. Never surprise them. Involve in all major decisions. Face-to-face or video call preferred.

---

### Quadrant 2: KEEP SATISFIED (Power: HIGH, Interest: LOW)

| Name | Role/Title | Organization | Power Source | Key Interests | Communication Needs |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [Name] | CFO / Finance | [Company] | Budget control, invoice approval | Cost containment, ROI metrics | Monthly financial summary, budget variance report |
| [Name] | Legal / Compliance | [Company] | Contract approval, risk mitigation | Regulatory compliance, liability | Quarterly risk review, compliance checklist |
| [Name] | Client's Manager | [Client Org] | Contract sign-off | No project failure, smooth handover | Bi-weekly status email (1-page) |

**Strategy**: Keep them informed enough to stay supportive. Don't overwhelm. Focus on high-level status (Green/Yellow/Red). Email summaries work best.

---

### Quadrant 3: KEEP INFORMED (Power: LOW, Interest: HIGH)

| Name | Role/Title | Organization | Power Source | Key Interests | Communication Needs |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [Name] | UI/UX Designer | [Company/Agency] | Design expertise | Design consistency, user experience | Daily design sync, Figma feedback loop |
| [Name] | QA Engineer | [Company] | Quality gates | Test coverage, bug resolution | Weekly QA standup, test plan review |
| [Name] | DevOps Engineer | [Company] | Infrastructure setup | Deployment reliability, uptime | Weekly infra sync, incident post-mortem |
| [Name] | Marketing Manager | [Company] | Go-to-market strategy | Launch readiness, feature highlights | Bi-weekly product update, feature changelog |
| [Name] | Power User / Champion | [Client Org] | User feedback, adoption advocacy | Usability, workflow efficiency | Weekly UAT session, feedback survey |

**Strategy**: High engagement, low ceremony. Slack/Discord daily updates. Involve in tactical execution. Listen to their feedback actively.

---

### Quadrant 4: MONITOR (Power: LOW, Interest: LOW)

| Name | Role/Title | Organization | Power Source | Key Interests | Communication Needs |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [Name] | Sales Team | [Company] | Pipeline influence | Feature parity with competitors | Quarterly release notes |
| [Name] | Customer Support | [Client Org] | End-user escalation | Training materials, FAQ | Post-launch handover doc, support runbook |
| [Name] | External Partner | [Partner Org] | API integration | Integration stability | Major release announcements |

**Strategy**: Minimal effort. Broadcast-style communication. Email newsletters, release notes, knowledge base updates.

---

## 3. Stakeholder Influence Network

Map who influences whom (use arrows: A → B means "A influences B's decisions"):

```text
Client CEO ──→ Product Owner ──→ Solo Developer
     │                │
     └────→ CFO       └──→ Designer
                      └──→ QA Engineer
```

**Key Insight**: If Product Owner is blocked, escalate to Client CEO. If Designer conflicts with dev timeline, PO arbitrates.

---

## 4. Stakeholder Risk Assessment

| Stakeholder | Risk Type | Mitigation Strategy |
| :--- | :--- | :--- |
| [Name - PO] | Scope creep requests without timeline adjustment | RACI matrix enforcement, change request process with time/cost impact analysis |
| [Name - CFO] | Budget cut mid-project | Monthly burn rate report, contingency plan for 20% budget reduction |
| [Name - Designer] | Design iteration delays due to unclear requirements | Design spec sign-off gate before dev, max 2 revision rounds in contract |
| [Name - Silent Approver] | Approval delays blocking launch | Time-bound approval SLA: "Approval needed by [Date], else proceed with last agreed version" |

---

## 5. Decision-Making Authority Levels

| Decision Type | Authority Level | Decision Maker(s) | Escalation Path |
| :--- | :--- | :--- | :--- |
| **Scope change** | Requires approval | Product Owner + CFO (if budget impact >10%) | CEO if PO unavailable >24h |
| **Tech stack choice** | Autonomous | Solo Developer | Inform CTO for review, escalate if security/compliance risk |
| **UI/UX design** | Requires approval | Product Owner (final), Designer (recommend) | CEO if PO and Designer disagree |
| **Launch date shift** | Requires approval | Product Owner + Client CEO | Board if delay >4 weeks |
| **Bug severity P0** | Autonomous | Solo Developer (hotfix), inform PO within 2h | Escalate to CTO if data breach risk |

---

## 6. Communication Preferences per Stakeholder

| Name | Preferred Channel | Best Time to Reach | Response SLA | Do NOT |
| :--- | :--- | :--- | :--- | :--- |
| [Product Owner] | Slack DM, 30-min call | Mon-Fri 10:00-16:00 WIB | <2 hours | Send 10-page reports, call before 9 AM |
| [CFO] | Email (formal) | Tue/Thu 14:00-17:00 WIB | <48 hours | CC on every small update, Slack for budget discussions |
| [Designer] | Figma comments, Discord | Mon-Fri 09:00-18:00 WIB | <4 hours | Ask design changes via email, batch requests |
| [CEO] | Email (exec summary) | Monthly board meeting | <1 week | Technical jargon, surprise bad news without mitigation plan |

---

## 7. Stakeholder Engagement Scorecard

Track engagement health monthly:

| Stakeholder | Responsiveness (1-5) | Alignment on Goals (1-5) | Satisfaction (1-5) | Action Items |
| :--- | :---: | :---: | :---: | :--- |
| [Product Owner] | 5 | 5 | 4 | None |
| [CFO] | 3 | 4 | 5 | Slow email replies, schedule monthly 15-min sync |
| [Designer] | 4 | 3 | 3 | Misalignment on mobile-first strategy, workshop needed |
| [CEO] | 2 | 5 | 5 | Hard to reach, delegate to PO for weekly updates |

**Scoring**:
- 5 = Excellent, no issues
- 4 = Good, minor friction
- 3 = Neutral, needs attention
- 2 = Problematic, intervention needed
- 1 = Critical, project risk

---

## 8. Change Log

| Date | Change | Reason | Updated By |
| :--- | :--- | :--- | :--- |
| [YYYY-MM-DD] | Added new CFO after org restructure | Stakeholder team change | [Your Name] |
| [YYYY-MM-DD] | Moved Designer from "Monitor" to "Keep Informed" | Increased involvement in sprint reviews | [Your Name] |

---

## Notes & Insights

- **Cultural Context**: [E.g., "Client CEO prefers hierarchical communication, always CC their manager"]
- **Political Dynamics**: [E.g., "Designer and PO have history of disagreement, mediate proactively"]
- **Upcoming Changes**: [E.g., "New CTO joining Q2, may shift tech priorities"]
