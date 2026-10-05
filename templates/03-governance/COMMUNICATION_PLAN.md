# Communication Plan Template

> **Purpose**: Define communication strategy for Enterprise projects  
> **When**: M02 Discovery or project kickoff  
> **Target**: Enterprise projects with 10+ stakeholders

---

## Communication Objectives

**Goals**:
- Keep stakeholders informed of progress
- Surface blockers early
- Align expectations across teams
- Build trust through transparency
- Document decisions for future reference

---

## Stakeholder Groups

### Executive Sponsors
**Who**: CEO, CTO, VP Engineering  
**Interest**: Budget, timeline, strategic alignment  
**Communication Needs**: High-level status, major decisions, escalations

**Channels**:
- Monthly Executive Review (1 hour meeting)
- Weekly status email (5 bullet points)
- Ad-hoc updates for major issues

**Frequency**: Weekly email, monthly meeting

---

### Project Steering Committee
**Who**: Project Sponsor, Product Manager, Tech Lead, Client PIC  
**Interest**: Scope, milestones, risks  
**Communication Needs**: Detailed progress, upcoming milestones, risk mitigation

**Channels**:
- Bi-weekly Steering Committee Meeting (1 hour)
- Weekly status report (email)
- Slack channel for urgent issues

**Frequency**: Bi-weekly meeting, weekly report

---

### Core Project Team
**Who**: Developers, QA, DevOps, Designers  
**Interest**: Day-to-day tasks, blockers, technical decisions  
**Communication Needs**: Real-time coordination, task updates, technical discussions

**Channels**:
- Daily standup (15 min)
- Slack #project-name channel
- Sprint planning/retro (bi-weekly)

**Frequency**: Daily standup, real-time Slack

---

### Extended Team
**Who**: Security, Legal, Finance, Customer Success  
**Interest**: Compliance, contracts, billing, customer impact  
**Communication Needs**: FYI updates, review requests, approval workflows

**Channels**:
- Email updates (as needed)
- Slack mentions (for reviews)
- Monthly all-hands presentation

**Frequency**: As needed

---

### Client Stakeholders
**Who**: Client's project team, end users  
**Interest**: Feature delivery, training, go-live readiness  
**Communication Needs**: Demo previews, UAT coordination, launch timeline

**Channels**:
- Bi-weekly demo (30 min)
- UAT feedback sessions
- Weekly status email
- Dedicated Slack Connect channel

**Frequency**: Bi-weekly demo, weekly email

---

## Communication Matrix

| Stakeholder Group | What | Channel | Frequency | Owner |
|:------------------|:-----|:--------|:----------|:------|
| **Executive Sponsors** | High-level status, budget, risks | Email report | Weekly | PM |
| **Executive Sponsors** | Strategic review, milestone updates | Executive Review Meeting | Monthly | Sponsor |
| **Steering Committee** | Progress, milestones, blockers | Steering Meeting | Bi-weekly | PM |
| **Steering Committee** | Written status | Email report | Weekly | PM |
| **Core Team** | Daily progress, blockers | Daily Standup | Daily | Tech Lead |
| **Core Team** | Sprint planning, retros | Sprint Ceremonies | Bi-weekly | PM |
| **Core Team** | Real-time coordination | Slack #project | Real-time | All |
| **Extended Team** | FYI updates, reviews | Email, Slack | As needed | PM |
| **Client Stakeholders** | Feature demo, feedback | Demo Meeting | Bi-weekly | PM |
| **Client Stakeholders** | Status updates | Email report | Weekly | PM |
| **All Stakeholders** | Major announcements | Email broadcast | As needed | Sponsor |

---

## Meeting Schedule

### Daily Standup (15 minutes)
**Attendees**: Core team (devs, QA, DevOps)  
**Time**: 10:00 AM local time  
**Format**: 
- What I did yesterday
- What I'm doing today
- Blockers

**Rules**:
- Max 1 minute per person
- Parking lot for deep discussions
- Stand up (keeps it short)

---

### Sprint Planning (2 hours, bi-weekly)
**Attendees**: Core team + PM  
**Agenda**:
1. Review previous sprint (30 min)
2. Demo completed work (30 min)
3. Plan next sprint (60 min)

**Output**: Sprint backlog with committed stories

---

### Sprint Demo (30 minutes, bi-weekly)
**Attendees**: Core team + client stakeholders  
**Format**:
- Demo completed features (20 min)
- Q&A (10 min)

**Goal**: Get feedback, build trust

---

### Steering Committee (1 hour, bi-weekly)
**Attendees**: Sponsor, PM, Tech Lead, Client PIC  
**Agenda**:
1. Progress update (15 min)
2. Milestone review (15 min)
3. Risk review (15 min)
4. Decisions needed (15 min)

**Output**: Decision log, action items

---

### Executive Review (1 hour, monthly)
**Attendees**: Executive sponsors + PM + Tech Lead  
**Agenda**:
1. High-level status (10 min)
2. Budget vs actuals (10 min)
3. Major risks (15 min)
4. Strategic alignment (15 min)
5. Q&A (10 min)

**Format**: Slide deck (max 10 slides)

---

## Status Report Template

### Weekly Status Report

**To**: Steering Committee, Executive Sponsors  
**From**: Project Manager  
**Date**: 2024-10-04  
**Project**: [Project Name]

---

#### Overall Status
🟢 **On Track** | 🟡 **At Risk** | 🔴 **Off Track**

**This Week**: 🟢 On Track

---

#### Progress This Week
- ✅ Completed user authentication (frontend + backend)
- ✅ Deployed to staging environment
- ✅ UAT session with 5 users (positive feedback)
- 🔄 In Progress: Payment integration (70% complete)

---

#### Planned Next Week
- Complete Stripe payment integration
- Security audit for authentication flow
- Load testing (target: 5k concurrent users)

---

#### Milestones
| Milestone | Target Date | Status |
|:----------|:-----------|:-------|
| M1: Design Approved | Sep 15 | ✅ Complete |
| M2: Alpha Release | Oct 15 | 🟢 On Track |
| M3: Beta Release | Nov 15 | 🟢 On Track |
| M4: Production Launch | Dec 1 | 🟢 On Track |

---

#### Risks & Issues
| Risk | Impact | Mitigation |
|:-----|:-------|:-----------|
| Payment gateway API changes | High | Contact Stripe for migration timeline |
| Key developer on vacation Nov 1-15 | Medium | Cross-train backup developer |

---

#### Budget
- Spent to date: $250k (50% of budget)
- Remaining: $250k
- Forecast: On budget

---

#### Decisions Needed
1. **UI Design**: Client wants dark mode. Adds 2 weeks + $15k. Approve?
2. **Infrastructure**: AWS vs GCP for production. Decision needed by Oct 10.

---

#### Help Needed
- Security team review required by Oct 10 (waiting 1 week)
- Legal approval for Terms of Service (blocking UAT sign-off)

---

## Communication Channels

### Slack Channels

**#project-[name]** (Core team)
- Real-time coordination
- Technical discussions
- Quick questions

**#project-[name]-stakeholders** (Extended team)
- FYI updates
- Non-urgent questions

**#project-[name]-client** (Slack Connect with client)
- Client communication
- Demo coordination
- UAT feedback

---

### Email Distribution Lists

**project-core@company.com**
- Core team members
- Daily/frequent updates

**project-stakeholders@company.com**
- All stakeholders (core + extended)
- Weekly status reports

**project-executives@company.com**
- Executive sponsors only
- Monthly reviews, major escalations

---

### Documentation

**Confluence Space**: `https://company.atlassian.net/wiki/spaces/PROJECT`
- Meeting notes
- Decision logs
- Architecture docs
- Runbooks

**Shared Drive**: `Google Drive > Projects > [Project Name]`
- Contracts, SOW
- Budget spreadsheets
- Design mockups

---

## Communication Protocols

### Response Time Expectations

| Channel | Response Time | Use For |
|:--------|:--------------|:--------|
| **Phone Call** | Immediate | Critical incidents only |
| **Slack DM** | <1 hour | Urgent blockers |
| **Slack Channel** | <4 hours | Team coordination |
| **Email** | <24 hours | Non-urgent updates |
| **Jira Comment** | <48 hours | Task-specific questions |

---

### Escalation Path

**Level 1**: Team member → Team Lead (Slack)  
**Level 2**: Team Lead → Project Manager (Slack/Email)  
**Level 3**: PM → Steering Committee (Meeting)  
**Level 4**: Steering → Executive Sponsors (Phone/Email)

**Escalation Triggers**:
- Blocker unresolved >3 days
- Budget overrun >10%
- Timeline delay >1 week
- Major risk realized

---

### Decision-Making

**Small Decisions** (team level):
- Technical implementation details
- Sprint task prioritization
- Code review approval

**Medium Decisions** (steering committee):
- Scope changes (<10% budget impact)
- Timeline adjustments (<1 week)
- Resource additions

**Large Decisions** (executive level):
- Scope changes (>10% budget impact)
- Major timeline changes (>2 weeks)
- Budget increases
- Go/no-go launch decisions

---

## Crisis Communication

### Incident Communication Plan

**Severity 1 (Critical Outage)**:
1. Notify on-call engineer (PagerDuty)
2. Post in #incidents Slack channel
3. Update status page (status.company.com)
4. Notify PM + Tech Lead immediately (phone)
5. Notify client stakeholders within 15 min (email)
6. Update every 30 min until resolved

**Severity 2 (Major Issue)**:
1. Post in #incidents Slack channel
2. Notify PM + Tech Lead (Slack)
3. Notify client stakeholders within 1 hour (email)
4. Update hourly until resolved

**Severity 3+ (Minor Issues)**:
- Document in Jira
- Mention in daily standup
- Include in weekly status report

---

### Bad News Communication

**Principle**: Deliver bad news early and with solutions

**Template**:
```
Subject: [Project Name] - Budget Overrun Alert

Team,

Bad news first: We're tracking 15% over budget ($75k).

Root cause: Unexpected complexity in payment integration 
(legacy system compatibility issues).

Mitigation options:
1. Reduce scope (remove guest checkout feature) - saves $50k
2. Request budget increase - requires executive approval
3. Defer nice-to-haves to Phase 2 - saves $30k

Recommendation: Option 3 (defer nice-to-haves)

I need a decision by Oct 10 to stay on schedule.

Call me if you want to discuss: [phone]

[Your Name]
```

---

## Communication Best Practices

### For Project Managers

**Do**:
- ✅ Send updates on time (weekly status reports)
- ✅ Be transparent about risks
- ✅ Tailor message to audience (exec vs technical)
- ✅ Document decisions in writing
- ✅ Follow up on action items

**Don't**:
- ❌ Surprise stakeholders with bad news
- ❌ Use jargon with non-technical audience
- ❌ Over-communicate (email overload)
- ❌ Make commitments you can't keep

---

### For Team Members

**Do**:
- ✅ Speak up in standup (blockers, delays)
- ✅ Update Jira tickets (keep status current)
- ✅ Respond to Slack within SLA
- ✅ Escalate blockers early

**Don't**:
- ❌ Stay blocked for days without asking for help
- ❌ Ghost on Slack (mark yourself away)
- ❌ Commit to deadlines you can't meet

---

## Communication Checklist

**Project Kickoff**:
- [ ] Communication plan created
- [ ] Stakeholder groups identified
- [ ] Meeting schedule established
- [ ] Slack channels created
- [ ] Email lists set up
- [ ] Confluence space created
- [ ] Status report template defined

**Ongoing**:
- [ ] Daily standup held
- [ ] Weekly status report sent
- [ ] Bi-weekly steering meeting
- [ ] Monthly executive review
- [ ] Meeting notes documented
- [ ] Action items tracked

**Project Closeout**:
- [ ] Final status report sent
- [ ] Lessons learned documented
- [ ] Archive Slack channels
- [ ] Archive documentation

---

## Tools

**Meetings**: Google Meet, Zoom, Microsoft Teams  
**Chat**: Slack (internal), Slack Connect (with clients)  
**Email**: Gmail, Outlook  
**Documentation**: Confluence, Google Docs  
**Project Management**: Jira, Asana, Monday.com  
**Status Page**: Statuspage.io (for incidents)

---

## Notes

**Over-communication > Under-communication**: When in doubt, share updates

**Bad news doesn't age well**: Deliver early with solutions

**Tailor your message**: Executives want high-level, team wants details

**Document decisions**: Slack conversations fade, write it down
