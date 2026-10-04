# Bug Triage Matrix (M07.2)

> **Purpose**: Classify and prioritize bugs during QA/UAT  
> **When**: M07 QA phase or M09 UAT  
> **Who**: Tech lead or QA lead

---

## Severity Levels

### S1 - Critical
**Definition**: Production down, no workaround, affects all/most users

**Examples**:
- Login completely broken (no one can access)
- Payment processing fails (revenue impact)
- Data corruption or loss
- Security vulnerability (SQL injection, XSS)
- Server crashes repeatedly

**SLA**: Fix within 4 hours  
**Response**: Drop everything, all hands on deck

---

### S2 - High
**Definition**: Major feature broken, workaround exists or affects subset of users

**Examples**:
- Export feature fails (can manually copy data)
- Email notifications not sending (can check in-app)
- Admin panel inaccessible (regular users OK)
- Slow performance (>10s load time)
- Browser-specific bug (works in Chrome, fails in Safari)

**SLA**: Fix within 24 hours  
**Response**: Priority for next sprint

---

### S3 - Medium
**Definition**: Minor bug, doesn't block core functionality

**Examples**:
- Form validation too strict (rejects valid input)
- UI element misaligned
- Minor typo in user-facing text
- Search results not optimal
- Missing "nice to have" feature

**SLA**: Fix within 3 days  
**Response**: Add to backlog, fix when capacity available

---

### S4 - Low
**Definition**: Cosmetic issue, polish, no functional impact

**Examples**:
- Button color not matching design
- Inconsistent font sizes
- Minor spacing issues
- Tooltip text unclear
- Placeholder text awkward

**SLA**: Fix within 7 days (or defer to later)  
**Response**: Fix during polish phase or defer

---

## Priority Matrix (Severity × Frequency)

| Severity | Always (100%) | Often (>50%) | Sometimes (10-50%) | Rarely (<10%) |
|:---------|:--------------|:-------------|:-------------------|:--------------|
| **S1 Critical** | 🔴 P1 | 🔴 P1 | 🔴 P1 | 🟡 P2 |
| **S2 High** | 🔴 P1 | 🟡 P2 | 🟡 P2 | 🟢 P3 |
| **S3 Medium** | 🟡 P2 | 🟢 P3 | 🟢 P3 | 🟢 P4 |
| **S4 Low** | 🟢 P3 | 🟢 P4 | 🟢 P4 | ⚪ Defer |

**Priority Actions**:
- **P1**: Fix immediately (this sprint)
- **P2**: Fix next sprint
- **P3**: Add to backlog (fix when capacity)
- **P4**: Defer or won't fix

---

## Decision Tree

```
Bug Reported
│
├─ Does it block launch?
│  ├─ Yes → S1/S2 (must fix)
│  └─ No → Continue
│
├─ Does it affect core functionality?
│  ├─ Yes → S2/S3 (prioritize)
│  └─ No → S4 (polish)
│
├─ Is there a workaround?
│  ├─ Yes → Lower priority
│  └─ No → Higher priority
│
├─ How many users affected?
│  ├─ All → Higher severity
│  ├─ Subset → Medium severity
│  └─ Edge case → Lower severity
│
└─ Assign severity (S1-S4) + frequency → Priority (P1-P4)
```

---

## Triage Questions

**For each bug, ask**:

1. **Can we ship without fixing this?**
   - No → S1/S2 (must fix)
   - Yes → S3/S4 (nice to fix)

2. **Is there a workaround?**
   - No → Higher priority
   - Yes → Lower priority

3. **How many users affected?**
   - All users → Higher severity
   - Specific role/scenario → Lower severity

4. **What's the business impact?**
   - Revenue loss → S1
   - User frustration → S2/S3
   - Cosmetic → S4

5. **How long to fix?**
   - <2 hours → Fix now
   - 2-8 hours → Schedule this sprint
   - >8 hours → Evaluate if worth it

---

## Bug Triage Meeting (Weekly)

**Attendees**: Tech lead, QA, Product owner  
**Duration**: 30 minutes  
**Agenda**:

1. **Review new bugs** (5 min)
   - Assign severity + priority
   - Assign owner

2. **Review open bugs** (15 min)
   - Update status
   - Re-prioritize if needed

3. **Review fixed bugs** (5 min)
   - Ready for QA verification

4. **Defer/Close bugs** (5 min)
   - Won't fix (document why)
   - Cannot reproduce (request more info)

---

## Example: Bug Triage Session

```
Bug Triage - Sprint #5
Date: October 11, 2024

---

NEW BUGS (3):

BUG-042: Login fails with valid credentials
Severity: S1 (Critical)
Frequency: Always (100%)
Priority: P1 (Fix immediately)
Owner: John
SLA: 4 hours
Action: Drop current work, fix now

---

BUG-043: Export CSV has extra comma
Severity: S3 (Medium)
Frequency: Always (100%)
Priority: P2 (Fix this sprint)
Owner: Sarah
SLA: 3 days
Action: Add to sprint backlog

---

BUG-044: Button color wrong on hover
Severity: S4 (Low)
Frequency: Always (100%)
Priority: P4 (Defer)
Owner: Unassigned
SLA: 7 days
Action: Fix during polish phase

---

OPEN BUGS (2):

BUG-040: Session timeout too short
Status: In Progress (John fixing)
ETA: Today
Action: Follow up EOD

BUG-041: Email preview cuts off long text
Status: Pending (waiting for design approval)
Action: Mike to provide design fix by Monday

---

FIXED BUGS (2):

BUG-038: Registration form validation
Status: Ready for QA verification
Action: QA to test and close

BUG-039: Dashboard loading slow
Status: Fixed + deployed to staging
Action: Monitor performance metrics

---

DEFERRED BUGS (1):

BUG-037: Dark mode support
Reason: Out of current scope, Phase 2 feature
Action: Close as "Won't Fix (Now)"
```

---

## Bug Metrics to Track

**Per Sprint**:
- Total bugs reported
- Bugs by severity (S1, S2, S3, S4)
- Avg time to fix by severity
- Bug resolution rate
- Reopened bugs (sign of incomplete fix)

**Goal Trends**:
- Decreasing total bugs (improving quality)
- Decreasing S1/S2 bugs (stable system)
- Faster resolution time (efficient team)

---

## Escalation Path

**If bug count spirals**:

1. **>10 S1/S2 bugs**: Stop new features, focus on stability
2. **>50 total bugs**: Add QA resource or extend timeline
3. **Critical bug can't be fixed**: Rollback last deploy, investigate

---

## Bug vs Enhancement vs CR

**Bug**: Something that should work but doesn't (free fix)
- Example: Login fails with correct password

**Enhancement**: Improvement to existing feature (may be in scope)
- Example: Add "Remember Me" checkbox to login

**Change Request (CR)**: New feature or major change (separate quote)
- Example: Add social login (Google, Facebook)

**When in doubt**: Ask "Was this in the original requirements?"
- Yes → Bug or Enhancement
- No → Change Request

---

## Communication Template

**To Client (Weekly Bug Summary)**:
```
Subject: Bug Summary - Week of Oct 7

Hi [Client],

This week's bug status:

FIXED (3):
✅ BUG-038: Registration validation
✅ BUG-039: Dashboard performance
✅ BUG-040: Session timeout

IN PROGRESS (2):
🔄 BUG-042: Login issue (S1) - Fixing today
🔄 BUG-043: CSV export (S3) - Fixing this week

NEW (1):
🆕 BUG-044: Button color (S4) - Deferred to polish phase

On track for launch. No blockers.

Questions? Reply to this email.

Best,
[Your Name]
```

---

## Bug Triage Checklist

Daily:
- [ ] Review new bugs (assign severity)
- [ ] Update bug status (in progress, fixed, closed)
- [ ] Respond to critical bugs within 1 hour

Weekly:
- [ ] Bug triage meeting (30 min)
- [ ] Send bug summary to client
- [ ] Update sprint board with bug fixes

Before Launch:
- [ ] All S1 bugs closed
- [ ] All S2 bugs closed or have workarounds
- [ ] S3/S4 bugs documented for post-launch

---

## Tools

**Bug Tracking**:
- Linear (recommended - clean UI)
- Jira (enterprise)
- GitHub Issues (simple)
- Trello (visual)

**Bug Board Columns**:
- New → Triaged → In Progress → Fixed → Verified → Closed

---

## Integration with Workflow

**M07 QA Phase**:
- QA finds bugs → Reports using `BUG_REPORT.md`
- Tech lead triages → Assigns severity/priority (this matrix)
- Devs fix bugs → QA verifies
- Repeat until launch-ready

**M09 UAT Phase**:
- Client finds bugs → Reports via form or email
- Dev triages → Categorize (bug vs enhancement vs CR)
- Critical bugs fixed immediately
- Minor bugs added to backlog

---

## Notes

**Don't argue with client about severity**: If client says S1, treat as S1 until proven otherwise

**Time-box triage**: 30 min max, don't overanalyze

**Document deferrals**: Always explain why bug deferred (builds trust)

**Celebrate bug fixes**: "Fixed 10 bugs this week" (shows progress)
