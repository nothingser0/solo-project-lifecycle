# Stakeholder Register Template

> **Purpose**: Identify and track all project stakeholders  
> **When**: M02 Discovery (before project kickoff)  
> **Target**: Enterprise projects with 10+ stakeholders

---

## Stakeholder Register

| Name | Role | Organization | Interest | Influence | Engagement Strategy |
|:-----|:-----|:-------------|:---------|:----------|:--------------------|
| Jane Doe | Project Sponsor | Internal - Exec | Budget, Timeline | High | Monthly exec review |
| John Smith | Tech Lead | Internal - Engineering | Architecture, Quality | High | Daily collaboration |
| Sarah Chen | Product Manager | Internal - Product | Features, UX | Medium | Weekly sync |
| Client PIC | IT Manager | Client - IT Dept | Delivery, Training | High | Bi-weekly steering |
| Mike Wang | Security Lead | Internal - Security | Compliance, Security | Medium | As-needed reviews |
| Legal Counsel | Lawyer | Internal - Legal | Contracts, Risk | Low | Contract review only |

---

## Stakeholder Categories

### By Influence & Interest

**High Influence, High Interest** (Manage Closely):
- Project Sponsor (approves budget, timeline)
- Client PIC (acceptance, payment)
- Tech Lead (technical decisions)

**Strategy**: Weekly updates, monthly reviews, involve in key decisions

---

**High Influence, Low Interest** (Keep Satisfied):
- VP Engineering (cares about outcomes, not details)
- CFO (cares about budget, not features)

**Strategy**: Monthly high-level updates, escalate only major issues

---

**Low Influence, High Interest** (Keep Informed):
- Junior developers (want to learn, limited authority)
- Customer success team (want updates for customers)

**Strategy**: Weekly status emails, invite to demos

---

**Low Influence, Low Interest** (Monitor):
- Finance team (billing only)
- HR (staffing only)

**Strategy**: FYI emails, no regular meetings

---

## Stakeholder Analysis

### Stakeholder #1: Jane Doe (Project Sponsor)

**Role**: VP Engineering, Project Sponsor

**Organization**: Internal - Executive Team

**Contact**:
- Email: jane.doe@company.com
- Phone: +1-555-0100
- Slack: @jane

---

**Interest Level**: High
- Budget owner ($500k)
- Timeline accountability (deliver by Dec 1)
- Strategic initiative (top 3 company priority)

**Influence Level**: High
- Final decision maker
- Can approve scope changes
- Can add/remove resources

---

**Current Attitude**: Supportive
- Championed project in executive meeting
- Allocated budget and resources
- Wants to see success

**Desired Attitude**: Supportive (maintain)

---

**Concerns & Expectations**:
- On-time delivery (Dec 1 deadline is firm)
- Budget control (no overruns)
- Quality (no major bugs at launch)
- Risk mitigation (wants early warning of issues)

---

**Engagement Strategy**:
- Weekly status email (5 bullet points)
- Monthly executive review (1 hour meeting)
- Ad-hoc updates for major decisions or issues
- Phone call for urgent escalations

**Communication Preference**: Email for routine, phone for urgent

**Best Time to Reach**: Mornings (9-11 AM)

---

**Key Messages**:
- Project is on track (or explain why not)
- Budget status (spent vs remaining)
- Major risks and mitigation plans
- Decisions needed from her

---

### Stakeholder #2: Client PIC (IT Manager)

**Role**: IT Manager, Client Project Owner

**Organization**: Client Company

**Contact**:
- Email: clientpic@clientcompany.com
- Phone: +1-555-0200
- Slack Connect: @clientpic

---

**Interest Level**: High
- End user of system
- Responsible for internal rollout
- Success tied to his performance review

**Influence Level**: High
- UAT sign-off required for payment
- Can request scope changes
- Decision maker on client side

---

**Current Attitude**: Cautiously Optimistic
- First project with our company (building trust)
- Previous vendor failed (burnt once)
- Wants to see frequent demos

**Desired Attitude**: Confident and Supportive

---

**Concerns & Expectations**:
- System actually works (not vaporware)
- Easy to use (non-technical users)
- Training provided (his team needs onboarding)
- Support after launch (warranty coverage)

---

**Engagement Strategy**:
- Bi-weekly demo (30 min, show progress)
- Weekly status email
- Dedicated Slack Connect channel (fast response)
- UAT sessions (hands-on testing)
- Monthly steering committee meeting

**Communication Preference**: Slack for quick questions, Zoom for demos

**Best Time to Reach**: Afternoons (2-4 PM his timezone)

---

**Key Messages**:
- We're transparent (no hiding issues)
- We deliver on promises (demos prove progress)
- We support you (training, documentation, warranty)
- Your feedback shapes the product

---

### Stakeholder #3: Mike Wang (Security Lead)

**Role**: Security Lead

**Organization**: Internal - Security Team

**Contact**:
- Email: mike.wang@company.com
- Slack: @mikesec

---

**Interest Level**: Medium
- Cares about security, not features
- Involved only for security reviews

**Influence Level**: Medium
- Can block launch if security issues found
- Required sign-off for production deployment

---

**Current Attitude**: Neutral (Professional)
- Security team is always skeptical (good thing)
- Will flag issues, not block unnecessarily

**Desired Attitude**: Neutral (maintain professional relationship)

---

**Concerns & Expectations**:
- Security testing completed (penetration test)
- Vulnerabilities fixed (no critical/high severity)
- Compliance met (GDPR, SOC 2)
- Secure architecture (reviewed and approved)

---

**Engagement Strategy**:
- Involve early (architecture review in M05)
- Security review meetings (2-3 during project)
- Penetration test before launch (M07)
- Document security decisions (ADR)

**Communication Preference**: Email for formal requests, Slack for quick questions

**Best Time to Reach**: Mornings (10-12 AM)

---

**Key Messages**:
- Security is priority (not afterthought)
- We welcome scrutiny (better to find issues early)
- We document decisions (audit trail)

---

## Stakeholder Power-Interest Grid

```
High Influence
    │
    │  [Project Sponsor]      [Client PIC]
    │  [Tech Lead]            
    │  
    │  ─────────────────────────────────────
    │  
    │  [VP Engineering]        [Junior Dev]
    │                          [Customer Success]
    │  
    │  [Finance]               [End Users]
    │  
    └──────────────────────────────────────────> High Interest
   Low Interest
```

---

## Stakeholder Engagement Log

| Date | Stakeholder | Type | Topic | Outcome |
|:-----|:-----------|:-----|:------|:--------|
| 2024-10-01 | Project Sponsor | Meeting | Kickoff | Approved budget, timeline |
| 2024-10-03 | Client PIC | Demo | UI mockups | Requested dark mode |
| 2024-10-04 | Security Lead | Review | Architecture | Flagged auth concerns |
| 2024-10-05 | Tech Lead | Slack | API design | Agreed on REST approach |

---

## Stakeholder RACI

See `RACI_MATRIX.md` for detailed roles and responsibilities.

**Quick Reference**:
- **Accountable**: Project Sponsor (owns outcome)
- **Responsible**: PM (day-to-day), Tech Lead (technical)
- **Consulted**: Client PIC, Security, Legal (provide input)
- **Informed**: Extended team (FYI updates)

---

## Managing Difficult Stakeholders

### The Micromanager
**Behavior**: Wants daily updates, questions every decision

**Strategy**:
- Set boundaries (weekly updates, not daily)
- Proactive communication (update before they ask)
- Involve in key decisions (give control on important items)

---

### The Ghost
**Behavior**: Doesn't respond to emails, skips meetings

**Strategy**:
- Escalate to their manager (if blocking project)
- Document attempts to reach (CYA)
- Proceed without input (after 3 attempts)

---

### The Scope Creeper
**Behavior**: Constantly requests new features

**Strategy**:
- Document original scope (reference SOW)
- Change request process (new features = new budget/timeline)
- Offer alternatives (defer to Phase 2)

---

### The Naysayer
**Behavior**: Negative about everything, predicts failure

**Strategy**:
- Ask for specific concerns (turn complaints into action items)
- Involve in solution (give ownership)
- Show progress (demos prove it works)

---

## Stakeholder Communication Preferences

| Stakeholder | Preferred Channel | Response Time | Best Time |
|:------------|:------------------|:--------------|:----------|
| Project Sponsor | Email (routine), Phone (urgent) | <4 hours | Mornings |
| Client PIC | Slack, Zoom demos | <2 hours | Afternoons |
| Tech Lead | Slack, In-person | <1 hour | Anytime |
| Security Lead | Email (formal), Slack (quick) | <24 hours | Mornings |
| Legal | Email only | <48 hours | Afternoons |

---

## Stakeholder Checklist

**Project Kickoff**:
- [ ] Identify all stakeholders (internal + external)
- [ ] Categorize by influence and interest
- [ ] Document contact info
- [ ] Define engagement strategy for each
- [ ] Create stakeholder register
- [ ] Share register with PM and Sponsor

**During Project**:
- [ ] Update stakeholder register monthly
- [ ] Log all stakeholder interactions
- [ ] Track stakeholder concerns
- [ ] Escalate issues per power-interest grid
- [ ] Maintain relationships (regular touchpoints)

**Project Closeout**:
- [ ] Thank stakeholders (recognition)
- [ ] Collect feedback (lessons learned)
- [ ] Archive stakeholder register

---

## Tools

**Stakeholder Register**: Excel, Google Sheets, Confluence  
**Engagement Tracking**: Jira, Smartsheet  
**Communication**: Slack, Email, Zoom  

---

## Notes

**Stakeholders change**: Update register when people change roles

**Influence is dynamic**: Someone low-influence may become high (promotion)

**Build relationships early**: Easier to ask for help when you've built trust

**Document everything**: Stakeholder register is CYA for scope disputes
