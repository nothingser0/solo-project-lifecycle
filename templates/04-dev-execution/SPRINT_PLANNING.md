# Sprint Planning Template

> **Purpose**: Plan 2-week sprint for development team  
> **Duration**: 1-2 hours  
> **When**: Start of every 2-week sprint (M06.5)  
> **Target**: Medium/Large projects with 3-6+ team

---

## Sprint Information

**Sprint Number**: Sprint #___  
**Sprint Duration**: 2 weeks  
**Sprint Start Date**: [YYYY-MM-DD]  
**Sprint End Date**: [YYYY-MM-DD]  
**Team**: [List team members]

---

## Sprint Goal

**Primary Goal** (What are we trying to achieve this sprint?):

_________________________________

**Success Criteria**:
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]

**Example**:
```
Primary Goal: Complete user authentication module
Success Criteria:
- Users can register with email/password
- Users can log in and access dashboard
- Password reset flow working end-to-end
```

---

## Team Capacity

**Total Team Hours Available**:

| Team Member | Role | Days Available | Hours/Day | Total Hours |
|:------------|:-----|:---------------|:----------|:------------|
| [Name 1] | Developer | 10 days | 6 hours | 60 hours |
| [Name 2] | Developer | 8 days (2 days off) | 6 hours | 48 hours |
| [Name 3] | Designer | 10 days | 4 hours | 40 hours |

**Total Sprint Capacity**: _____ hours

**Buffer**: Reserve 20% for unplanned work (bugs, meetings, interruptions)  
**Available for Sprint Tasks**: _____ hours (80% of total)

---

## Backlog Refinement

**Stories Ready for Sprint** (Must have clear acceptance criteria):

| Story ID | Story Title | Priority | Estimated Hours | Assigned To |
|:---------|:------------|:---------|:----------------|:------------|
| US-101 | User registration | Must | 16h | Dev 1 |
| US-102 | Login page | Must | 12h | Dev 1 |
| US-103 | Password reset | Should | 20h | Dev 2 |
| US-104 | Dashboard layout | Must | 16h | Designer + Dev 2 |

**Total Estimated**: _____ hours  
**Capacity Check**: ☐ Within capacity ☐ Over capacity (remove items)

---

## Sprint Backlog (Committed Stories)

### Story 1: [Story Title]

**Story ID**: US-___  
**Priority**: Must / Should / Could

**Description**:
As a [user role], I want [feature], so that [benefit].

**Acceptance Criteria**:
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

**Tasks** (broken down):
- [ ] [Task 1] - [2h] - [Assigned to]
- [ ] [Task 2] - [4h] - [Assigned to]
- [ ] [Task 3] - [3h] - [Assigned to]

**Definition of Done**:
- [ ] Code complete
- [ ] Unit tests written
- [ ] Code reviewed
- [ ] Deployed to staging
- [ ] Acceptance criteria met

---

### Story 2: [Story Title]

[Repeat format above for each story]

---

## Risks & Dependencies

**Risks**:
- [ ] **Risk 1**: [Description] - Mitigation: [Plan]
- [ ] **Risk 2**: [Description] - Mitigation: [Plan]

**Dependencies**:
- [ ] **Dependency 1**: Waiting on [what] from [who] by [date]
- [ ] **Dependency 2**: Requires [resource/access/decision]

**Example**:
```
Risks:
- Third-party API may be slow → Mitigation: Mock API for testing
- Designer on leave 3 days → Mitigation: Get designs approved before leave

Dependencies:
- Need staging server access from client by Monday
- Payment gateway test credentials by Wednesday
```

---

## Sprint Schedule

**Daily Standup**:
- Time: [9:00 AM every day]
- Duration: 15 minutes max
- Format: Async (Slack) or Sync (call)

**Mid-Sprint Check-in** (Day 5):
- Review progress
- Adjust scope if needed

**Sprint Demo** (Day 10, end of sprint):
- Show completed work to client/stakeholders
- Duration: 30 minutes

**Sprint Retrospective** (Day 10, after demo):
- What went well?
- What can improve?
- Action items for next sprint

---

## Communication Plan

**Team Updates**:
- Daily: Standup notes in Slack #standup channel
- Weekly: Progress summary to client (Friday)

**Client Communication**:
- Friday update email: "Sprint X Progress - [% complete]"
- Demo call: [Scheduled date/time]

**Escalation Path**:
- Blocker? Raise in standup immediately
- Critical issue? Notify tech lead via WhatsApp

---

## Sprint Commitment

**Team Agreement**:
- [ ] We commit to these stories for this sprint
- [ ] We understand the sprint goal
- [ ] We agree on capacity estimate
- [ ] We will attend daily standups
- [ ] We will raise blockers early

**Signed by Team**:
- [ ] [Team Member 1]
- [ ] [Team Member 2]
- [ ] [Team Member 3]

**Date**: [YYYY-MM-DD]

---

---

## How to Run Sprint Planning Meeting

### Before Meeting (30 min prep)
- [ ] Product owner prioritizes backlog
- [ ] Stories have clear acceptance criteria
- [ ] Team reviewed stories briefly

### During Meeting (1-2 hours)

**Part 1: Sprint Goal (15 min)**
1. Product owner presents top priorities
2. Team discusses and agrees on sprint goal
3. Write goal at top of this document

**Part 2: Capacity Planning (15 min)**
1. Each team member states availability
2. Calculate total capacity
3. Apply 20% buffer for interruptions

**Part 3: Story Selection (45 min)**
1. Start with highest priority story
2. Team discusses: "Can we do this?"
3. Break into tasks, estimate hours
4. Add to sprint if within capacity
5. Repeat until capacity full

**Part 4: Risks & Commitment (15 min)**
1. Identify risks and dependencies
2. Agree on mitigation plans
3. Team commits to sprint

### After Meeting
- [ ] Update project management tool (Jira, Linear, Trello)
- [ ] Share sprint board with team
- [ ] Schedule sprint ceremonies (standup, demo, retro)

---

## Sprint Planning Anti-Patterns (Avoid!)

❌ **Over-committing**: Taking on too much → burnout, incomplete work  
✅ **Right-sizing**: Leave 20% buffer, be realistic

❌ **Vague stories**: "Make it better" → unclear success  
✅ **Clear criteria**: "Login page loads in <2s, shows error for wrong password"

❌ **No task breakdown**: Story too big, black box  
✅ **Task-level detail**: 2-4 hour tasks, clear ownership

❌ **Ignoring dependencies**: Blocked mid-sprint  
✅ **Flag upfront**: Get access/decisions before sprint starts

❌ **Solo planning**: Tech lead decides alone  
✅ **Team collaboration**: Everyone contributes, team owns commitment

---

## Example: Filled Sprint Planning

```
Sprint Number: Sprint #3
Sprint Duration: 2 weeks
Sprint Start: October 7, 2024
Sprint End: October 18, 2024
Team: John (Dev), Sarah (Dev), Mike (Designer)

---

Sprint Goal: Complete user authentication module

Success Criteria:
✓ Users can register with email/password
✓ Users can log in and access dashboard
✓ Password reset flow working end-to-end

---

Team Capacity:
- John: 10 days × 6h = 60h
- Sarah: 10 days × 6h = 60h
- Mike: 8 days × 5h = 40h (2 days client meeting)

Total: 160h
Buffer (20%): 32h
Available: 128h

---

Sprint Backlog:

Story 1: User Registration (US-101)
Priority: Must
Estimate: 16h
Assigned: John

Tasks:
- Create registration form UI (4h) - John
- Backend API endpoint (4h) - John
- Email validation (2h) - John
- Password strength check (2h) - John
- Unit tests (4h) - John

Story 2: Login Page (US-102)
Priority: Must
Estimate: 12h
Assigned: Sarah

Tasks:
- Login form UI (3h) - Sarah
- Authentication API (4h) - Sarah
- Session management (3h) - Sarah
- Tests (2h) - Sarah

Story 3: Dashboard Layout (US-103)
Priority: Must
Estimate: 20h
Assigned: Mike + Sarah

Tasks:
- Wireframe design (4h) - Mike
- Design mockups (8h) - Mike
- Implement layout (6h) - Sarah
- Responsive testing (2h) - Sarah

Story 4: Password Reset (US-104)
Priority: Should
Estimate: 18h
Assigned: John

Tasks:
- Reset request form (3h) - John
- Email with reset link (4h) - John
- Reset password page (3h) - John
- Token expiry logic (4h) - John
- Tests (4h) - John

Total Committed: 66h (John 34h, Sarah 32h, Mike 20h)
Remaining Capacity: 62h (for bugs, reviews, meetings)

---

Risks:
- Email service setup pending → Mitigation: Use mock for testing, real setup by Day 3
- Mike on leave Day 9-10 → Mitigation: Get designs approved by Day 7

Dependencies:
- Need SendGrid API keys by Monday (Oct 7)
- Client approval on dashboard design by Friday (Oct 11)

---

Sprint Commitment: COMMITTED
Date: October 6, 2024
```

---

## Integration with Workflow

**M06 Development Execution**:
- Sprint 1: Setup + landing page
- Sprint 2: Authentication module
- Sprint 3: Core CRUD features
- Sprint 4: Admin panel
- Sprint 5: Testing + polish

**Weekly Cycle**:
1. **Monday**: Sprint planning (if new sprint)
2. **Mon-Fri**: Daily standup + development
3. **Friday**: Mid-sprint check OR Sprint demo/retro (end of sprint)
4. **Weekend**: No work (team recharge)

---

## Tools

**Project Management**:
- Linear (recommended for small teams)
- Jira (for larger teams)
- Trello (visual boards)
- Notion (lightweight)

**Daily Standup**:
- Slack (async updates)
- Discord (voice calls)
- Google Meet (video calls)

**Sprint Board**:
- Columns: To Do | In Progress | Review | Done
- Move stories across as work progresses

---

## Sprint Planning Checklist

Before sprint starts:
- [ ] Sprint goal defined
- [ ] Stories have acceptance criteria
- [ ] Team capacity calculated
- [ ] Tasks estimated and assigned
- [ ] Risks identified
- [ ] Dependencies flagged
- [ ] Team committed
- [ ] Sprint board updated
- [ ] Daily standup scheduled
- [ ] Demo scheduled with client
