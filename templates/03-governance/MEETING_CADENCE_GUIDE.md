# Meeting Cadence Guide

> **Purpose**: Define regular meeting rhythm for Enterprise projects  
> **When**: M02 Discovery (project kickoff)  
> **Target**: Enterprise projects with distributed teams and multiple stakeholders

---

## Meeting Principles

**Goals**:
- Align team on priorities
- Surface blockers early
- Maintain momentum
- Minimize meeting overhead

**Rules**:
- Every meeting has agenda
- Every meeting has owner
- Every meeting has notes
- Cancel if no agenda

---

## Daily Meetings

### Daily Standup (15 minutes)

**Attendees**: Core development team (5-10 people)

**Time**: 10:00 AM local time (same time every day)

**Format**: 
- Stand up (keeps it short)
- Round-robin (each person 1-2 minutes)

**Agenda**:
1. What I did yesterday
2. What I'm doing today
3. Blockers

**Example**:
```
John: Yesterday finished payment API. Today starting webhook integration. 
No blockers.

Sarah: Yesterday wrote frontend tests. Today fixing flaky tests. 
Blocked: Need staging environment access.

Mike: Yesterday code review. Today deploying to staging. No blockers.
```

**Anti-patterns**:
- ❌ Solving problems during standup (use parking lot)
- ❌ Status reports to manager (it's for team coordination)
- ❌ Over 15 minutes (keep it tight)

**Tool**: In-person, Zoom, or Slack

---

## Weekly Meetings

### Sprint Planning (2 hours, bi-weekly)

**Attendees**: Development team + PM + Product Owner

**Time**: Monday 10:00 AM (start of sprint)

**Agenda**:
1. Review previous sprint (15 min)
2. Demo completed work (30 min)
3. Retrospective (30 min)
4. Plan next sprint (45 min)

**Outcome**: Sprint backlog (committed stories for next 2 weeks)

---

### Team Sync (30 minutes, weekly)

**Attendees**: Full team (dev, QA, DevOps, PM)

**Time**: Wednesday 2:00 PM

**Agenda**:
1. Wins this week (5 min)
2. Upcoming milestones (10 min)
3. Blockers and risks (10 min)
4. Open discussion (5 min)

**Purpose**: Keep everyone aligned beyond daily standup

---

### Client Demo (30 minutes, bi-weekly)

**Attendees**: Team + client stakeholders

**Time**: Friday 3:00 PM (end of sprint)

**Agenda**:
1. Demo completed features (20 min)
2. Q&A and feedback (10 min)

**Goal**: Build trust, get feedback early

---

## Bi-Weekly Meetings

### Steering Committee (1 hour)

**Attendees**: Project Sponsor, PM, Tech Lead, Client PIC

**Time**: Every other Tuesday, 2:00 PM

**Agenda**:
1. Progress update (15 min)
2. Milestone review (15 min)
3. Risk and issue review (15 min)
4. Decisions needed (15 min)

**Outcome**: Decision log, approved changes, action items

---

### Architecture Review (1 hour)

**Attendees**: Tech Lead, Senior Developers, Architect

**Time**: Every other Thursday, 10:00 AM

**Agenda**:
1. Review proposed designs (30 min)
2. Discuss technical risks (15 min)
3. Decide on approaches (15 min)

**Outcome**: Architecture decisions recorded (ADR)

---

## Monthly Meetings

### Executive Review (1 hour)

**Attendees**: Executive Sponsors + PM + Tech Lead

**Time**: First Monday of month, 9:00 AM

**Agenda**:
1. High-level status (10 min)
2. Budget vs actuals (10 min)
3. Major risks (15 min)
4. Strategic alignment (15 min)
5. Q&A (10 min)

**Format**: Slide deck (max 10 slides)

**Outcome**: Executive decision on major issues

---

### All-Hands (30 minutes)

**Attendees**: Entire project team + stakeholders

**Time**: Last Friday of month, 4:00 PM

**Agenda**:
1. Month in review (10 min)
2. Upcoming priorities (10 min)
3. Shout-outs and wins (5 min)
4. Q&A (5 min)

**Purpose**: Transparency, team morale

---

### Retrospective (1 hour)

**Attendees**: Core team only

**Time**: Last Friday of month, 2:00 PM

**Format**: Start/Stop/Continue

**Agenda**:
1. What went well (15 min)
2. What went poorly (15 min)
3. Action items (20 min)
4. Review previous action items (10 min)

**Outcome**: 3-5 concrete action items

---

## Quarterly Meetings

### Quarterly Business Review (QBR) (2 hours)

**Attendees**: All stakeholders (internal + client)

**Time**: First week of new quarter

**Agenda**:
1. Quarter in review (30 min)
2. Metrics and KPIs (30 min)
3. Lessons learned (30 min)
4. Next quarter planning (30 min)

**Outcome**: Updated roadmap, budget adjustments

---

### Security Review (1 hour)

**Attendees**: Security team + Tech Lead + DevOps

**Time**: Quarterly (scheduled in advance)

**Agenda**:
1. Security posture review (20 min)
2. Vulnerability findings (20 min)
3. Remediation plan (20 min)

**Outcome**: Security action items with owners

---

## Ad-Hoc Meetings

### Design Review (1 hour, as needed)

**Trigger**: New feature design ready

**Attendees**: Designer + PM + Tech Lead + 2 developers

**Agenda**:
1. Designer presents mockups (20 min)
2. Feasibility discussion (20 min)
3. Decisions and next steps (20 min)

---

### Incident Post-Mortem (1 hour, after SEV-1/SEV-2)

**Trigger**: Within 7 days of incident resolution

**Attendees**: Incident responders + stakeholders

**Format**: Blameless

**Agenda**:
1. Timeline review (15 min)
2. Root cause analysis (20 min)
3. Action items (20 min)
4. Review (5 min)

**Outcome**: Post-mortem document + action items

---

## Meeting Calendar (Typical Week)

### Monday
- 10:00 AM: Daily Standup (15 min)
- 10:30 AM: Sprint Planning (2 hours, bi-weekly)

### Tuesday
- 10:00 AM: Daily Standup (15 min)
- 2:00 PM: Steering Committee (1 hour, bi-weekly)

### Wednesday
- 10:00 AM: Daily Standup (15 min)
- 2:00 PM: Team Sync (30 min, weekly)

### Thursday
- 10:00 AM: Daily Standup (15 min)
- 10:00 AM: Architecture Review (1 hour, bi-weekly)

### Friday
- 10:00 AM: Daily Standup (15 min)
- 3:00 PM: Client Demo (30 min, bi-weekly)

**Total Weekly Meetings**: ~5 hours (10% of 40-hour week)

---

## Meeting Best Practices

### Before Meeting

**Meeting Owner**:
- [ ] Create agenda (at least 1 day before)
- [ ] Invite attendees (include Zoom link)
- [ ] Share pre-read materials (if any)
- [ ] Confirm attendee availability

---

### During Meeting

**Meeting Owner**:
- [ ] Start on time (don't wait for latecomers)
- [ ] Follow agenda
- [ ] Keep on track (defer tangents to parking lot)
- [ ] Document decisions
- [ ] Assign action items (owner + due date)

**Attendees**:
- [ ] Be on time
- [ ] Camera on (if remote)
- [ ] Mute when not speaking
- [ ] Participate actively

---

### After Meeting

**Meeting Owner**:
- [ ] Send meeting notes within 24 hours
- [ ] Include action items with owners
- [ ] Follow up on action items

---

## Meeting Efficiency Tips

### Tip 1: Use Asynchronous Communication

**Instead of meeting**: Slack, email, Loom video

**When to use**:
- FYI updates (no discussion needed)
- One-way information sharing
- Non-urgent decisions

**Example**: Weekly status update via email instead of meeting

---

### Tip 2: Time-Boxing

**Technique**: Allocate fixed time per agenda item

**Example**:
```
Sprint Planning (2 hours):
- Review (15 min) ⏰
- Demo (30 min) ⏰
- Retrospective (30 min) ⏰
- Planning (45 min) ⏰
```

**Benefit**: Prevents discussions from dragging on

---

### Tip 3: Parking Lot

**Purpose**: Capture off-topic discussions without derailing meeting

**How**:
1. Someone raises tangent topic
2. Add to parking lot list
3. Continue with agenda
4. After meeting, schedule separate discussion

---

### Tip 4: No-Meeting Days

**Goal**: Give team uninterrupted focus time

**Example**: No meetings on Tuesdays and Thursdays

**Exception**: Daily standup (15 min is acceptable)

---

### Tip 5: Meeting-Free Afternoons

**Goal**: Long blocks of focus time

**Schedule**: All meetings before 1 PM

**Benefit**: Afternoons for deep work

---

## Remote Meeting Tools

**Video Conferencing**: Zoom, Google Meet, Microsoft Teams

**Collaboration**: Miro (whiteboarding), Figma (design review)

**Documentation**: Google Docs, Confluence

**Async Video**: Loom (record updates)

---

## Meeting Audit (Quarterly)

**Review**:
- Which meetings add value?
- Which meetings could be emails?
- Are we over-meeting?

**Action**:
- Cancel low-value meetings
- Reduce frequency (bi-weekly → monthly)
- Reduce duration (1 hour → 30 min)

---

## Checklist

**Project Kickoff**:
- [ ] Define meeting cadence
- [ ] Schedule recurring meetings
- [ ] Assign meeting owners
- [ ] Create meeting templates (agendas, notes)

**Ongoing**:
- [ ] Send agenda 1 day before meeting
- [ ] Start/end on time
- [ ] Document decisions and action items
- [ ] Follow up on action items

**Quarterly**:
- [ ] Audit meeting effectiveness
- [ ] Cancel or adjust low-value meetings

---

## Notes

**Meetings are expensive**: 10 people × 1 hour = $1,500+ in labor

**Default to async**: Only meet when discussion needed

**Respect people's time**: Start on time, end on time, have agenda

**Cancel if no agenda**: Better to cancel than waste time
