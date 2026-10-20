# Escalation Matrix Template

> **Purpose**: Define clear escalation paths for issues, risks, and decisions  
> **When**: M02 Discovery or project kickoff  
> **Target**: Enterprise projects with multiple decision-making layers

---

## Escalation Principles

**When to Escalate**:
- Issue unresolved after 2 attempts
- Decision beyond your authority level
- Risk threatens project timeline/budget/scope
- Conflict between stakeholders
- Resource constraint blocking progress

**When NOT to Escalate**:
- Normal day-to-day issues (solve at team level)
- Issues you haven't tried to solve yourself
- To bypass process or accountability

---

## Escalation Levels

### Level 0: Self-Resolution (0-24 hours)
**Try First**: Solve at your level

**Examples**:
- Code bug (debug yourself)
- Unclear requirement (ask teammate)
- Tool not working (check documentation)

**Escalation Trigger**: Can't resolve in 24 hours

---

### Level 1: Team Lead (24-72 hours)
**Who**: Direct manager, team lead, tech lead

**Examples**:
- Technical blocker (architecture decision needed)
- Conflicting priorities (which task first?)
- Resource need (need another developer's help)

**Contact**: Slack DM, daily standup

**Response Time**: 4 hours

**Escalation Trigger**: Unresolved after 3 days

---

### Level 2: Project Manager (72 hours - 1 week)
**Who**: Project Manager, Product Manager

**Examples**:
- Cross-team coordination issue
- Scope clarification needed
- Timeline concern (task taking longer than expected)
- External dependency blocking progress

**Contact**: Slack, email, 1-on-1 meeting

**Response Time**: 24 hours

**Escalation Trigger**: Unresolved after 1 week or impacts milestone

---

### Level 3: Steering Committee (1-2 weeks)
**Who**: Project Sponsor, Client PIC, Department Heads

**Examples**:
- Scope change request (add/remove features)
- Timeline slip >1 week
- Budget overrun >10%
- Major technical decision (architecture pivot)
- Stakeholder conflict

**Contact**: Steering committee meeting (bi-weekly), emergency call

**Response Time**: 3 business days (next steering meeting)

**Escalation Trigger**: Threatens project success or needs executive decision

---

### Level 4: Executive Leadership (Critical)
**Who**: VP Engineering, CTO, CEO

**Examples**:
- Budget overrun >25%
- Timeline slip >1 month
- Legal/compliance issue
- Client threatening to cancel
- Major security incident

**Contact**: Email + phone call (urgent)

**Response Time**: 24 hours

**Escalation Trigger**: Project at risk of failure or external crisis

---

## Escalation Matrix by Issue Type

### Technical Issues

| Issue | Level 1 | Level 2 | Level 3 | Level 4 |
|:------|:--------|:--------|:--------|:--------|
| **Bug** | Tech Lead | PM (if blocking milestone) | Sponsor (if delaying launch) | N/A |
| **Architecture Decision** | Tech Lead | PM + Architect | Steering (if cost impact) | Exec (if major pivot) |
| **Performance Issue** | Tech Lead | PM (if user-impacting) | Steering (if requires resources) | Exec (if SLA breach) |
| **Security Vulnerability** | Security Lead | PM + Tech Lead | Sponsor (if critical/high) | Exec (if data breach) |
| **Infrastructure Outage** | DevOps Lead | PM | Sponsor (if >4 hours) | Exec (if >24 hours) |

---

### Scope & Requirements

| Issue | Level 1 | Level 2 | Level 3 | Level 4 |
|:------|:--------|:--------|:--------|:--------|
| **Unclear Requirement** | Product Owner | PM | Steering (if impacts scope) | N/A |
| **Scope Creep** | PM | Steering | Sponsor | Exec (if >25% budget) |
| **Client Change Request** | PM | Steering (if cost/timeline impact) | Sponsor (if major) | Exec (if contract amendment) |
| **Conflicting Requirements** | Product Owner | PM | Steering | N/A |

---

### Timeline & Budget

| Issue | Level 1 | Level 2 | Level 3 | Level 4 |
|:------|:--------|:--------|:--------|:--------|
| **Task Delay <3 days** | Team Lead | PM (FYI) | N/A | N/A |
| **Task Delay 3-7 days** | Team Lead | PM | Steering (FYI) | N/A |
| **Milestone Delay >1 week** | PM | Steering | Sponsor | Exec (if final deadline) |
| **Budget Overrun <10%** | PM | Steering | Sponsor | N/A |
| **Budget Overrun >10%** | PM | Steering | Sponsor | Exec (if >25%) |

---

### Resource Issues

| Issue | Level 1 | Level 2 | Level 3 | Level 4 |
|:------|:--------|:--------|:--------|:--------|
| **Need Help from Teammate** | Team Lead | PM | N/A | N/A |
| **Need Additional Developer** | Team Lead | PM | Steering | Sponsor |
| **Key Person Leaving** | Team Lead | PM | Steering | Exec (if critical) |
| **Vendor Not Responding** | PM | Steering | Sponsor | Exec (legal action) |

---

### Stakeholder & Communication

| Issue | Level 1 | Level 2 | Level 3 | Level 4 |
|:------|:--------|:--------|:--------|:--------|
| **Client Unresponsive** | PM | Steering | Sponsor | Exec (escalate to client exec) |
| **Conflicting Feedback** | PM | Steering | Sponsor | N/A |
| **Client Dissatisfaction** | PM | Steering | Sponsor | Exec (if contract risk) |
| **Internal Conflict** | Team Lead | PM | Steering (if blocking) | N/A |

---

## Escalation Contact List

| Level | Name | Role | Email | Phone | Slack | Availability |
|:------|:-----|:-----|:------|:------|:------|:-------------|
| **L1** | John Smith | Tech Lead | john@company.com | +1-555-0101 | @john | 9-6 PM |
| **L1** | Sarah Chen | Team Lead | sarah@company.com | +1-555-0102 | @sarah | 9-6 PM |
| **L2** | Mike Wang | Project Manager | mike@company.com | +1-555-0103 | @mikewang | 8-7 PM |
| **L3** | Jane Doe | Project Sponsor | jane@company.com | +1-555-0100 | @jane | 9-5 PM |
| **L3** | Client PIC | IT Manager | clientpic@client.com | +1-555-0200 | @clientpic | 9-5 PM |
| **L4** | VP Engineering | Executive | vp@company.com | +1-555-0001 | @vp-eng | On-call 24/7 |

**After-Hours**: For production incidents (SEV-1), page on-call via PagerDuty: +1-555-ONCALL

---

## Escalation Process

### Step 1: Attempt Resolution (Level 0)
**Before escalating, try**:
- [ ] Research the issue (Google, documentation)
- [ ] Ask a teammate (Slack, quick chat)
- [ ] Try alternative approaches (at least 2 attempts)
- [ ] Document what you've tried

**Time Limit**: 24 hours for normal issues, 4 hours for blockers

---

### Step 2: Escalate to Level 1 (Team Lead)
**How to Escalate**:
1. Send Slack DM or mention in standup
2. Provide context: What's wrong, what you tried, why blocked
3. Request specific help or decision

**Example**:
```
Hey @john, I'm blocked on the payment integration.

Issue: Stripe API returning 401 errors
What I tried:
- Verified API keys (correct)
- Tested with Postman (works)
- Checked code (looks correct)

I've spent 6 hours on this and need help debugging.
Can you pair with me this afternoon?
```

---

### Step 3: Escalate to Level 2 (PM)
**When**: Team lead can't resolve, or issue impacts timeline/scope

**How to Escalate**:
1. Email or Slack PM
2. CC team lead (keep them informed)
3. Explain issue, impact, and urgency

**Example**:
```
Subject: Escalation - Payment Integration Blocked (Milestone Risk)

Hi Mike,

I'm escalating a blocker that's impacting M3 (Alpha Release, Oct 15).

Issue: Stripe payment integration failing (3 days blocked)
Impact: Payment feature is 0% complete, was planned for 50% by today
Root cause: Unknown (debugged with John, no resolution)

Options:
1. Engage Stripe support (2-3 day turnaround)
2. Switch to PayPal (4-5 days to implement)
3. Defer payment to M4 (pushes timeline 1 week)

I recommend Option 1 (Stripe support).

Can we discuss today? This is blocking 2 developers.

[Your Name]
```

---

### Step 4: Escalate to Level 3 (Steering Committee)
**When**: PM can't resolve, or decision needs client/sponsor approval

**How to Escalate**:
1. Add to steering committee meeting agenda (if not urgent)
2. For urgent issues: Email sponsor + PM + client PIC
3. Prepare decision paper (context, options, recommendation)

**Example Decision Paper**:
```
Subject: Decision Needed - Payment Provider Change

DECISION NEEDED: Switch from Stripe to PayPal for payment processing

CONTEXT:
- Stripe integration blocked for 5 days
- Root cause: Stripe API changes, breaking our implementation
- Contacted Stripe support, no resolution timeline

OPTIONS:
Option 1: Wait for Stripe fix
- Cost: $0
- Timeline: Unknown (could be weeks)
- Risk: High (no control over Stripe)

Option 2: Switch to PayPal
- Cost: $15k (4 days dev work)
- Timeline: 1 week
- Risk: Medium (PayPal API is stable)

Option 3: Defer payment to Phase 2
- Cost: $0
- Timeline: Launch without payment (collect later)
- Risk: High (client may reject)

RECOMMENDATION: Option 2 (Switch to PayPal)

IMPACT:
- Budget: +$15k (3% increase, within contingency)
- Timeline: M3 delayed 1 week (Oct 15 → Oct 22)
- Scope: No change (payment feature still delivered)

DECISION NEEDED BY: Oct 6 (to stay on adjusted timeline)

[Your Name], Project Manager
```

---

### Step 5: Escalate to Level 4 (Executive)
**When**: Project at risk, legal issue, client crisis

**How to Escalate**:
1. Email + phone call (don't just email)
2. CC all stakeholders (PM, Sponsor, Client PIC)
3. Be clear and concise (exec time is limited)

**Example**:
```
Subject: URGENT - Project at Risk of Cancellation

Jane, [exec name],

We have a critical situation that needs executive attention.

SITUATION:
Client is threatening to cancel project due to repeated delays.

BACKGROUND:
- M2 delayed 2 weeks (design changes)
- M3 delayed 1 week (payment integration issue)
- Client patience exhausted, sent formal complaint yesterday

CLIENT DEMAND:
Deliver M3 (Alpha) by Oct 15 or cancel contract + refund $250k

OUR OPTIONS:
Option 1: Agree to Oct 15 (risky, may fail)
Option 2: Negotiate Oct 22 (more realistic)
Option 3: Accept cancellation (lose $250k + reputation)

RECOMMENDATION: Option 2 (Negotiate Oct 22)

I propose we set up a call with client's CEO today to negotiate.
I need executive support to rebuild trust.

Available for call anytime today.

Mike Wang, Project Manager
Phone: +1-555-0103
```

---

## Escalation Response SLA

| Level | Response Time | Resolution Time |
|:------|:--------------|:----------------|
| **Level 1** (Team Lead) | 4 hours | 3 days |
| **Level 2** (PM) | 24 hours | 1 week |
| **Level 3** (Steering) | 3 business days | 2 weeks |
| **Level 4** (Executive) | 24 hours | As needed |

**Note**: Resolution time is to provide decision/guidance, not to fully solve issue

---

## Escalation Red Flags

**Don't Escalate If**:
❌ You haven't tried to solve it yourself  
❌ You're just passing the buck (avoiding responsibility)  
❌ It's a normal day-to-day issue  
❌ You're escalating to make someone else look bad

**Do Escalate If**:
✅ You've genuinely tried (2+ attempts)  
✅ It's beyond your authority/expertise  
✅ It threatens project success  
✅ Client/stakeholder needs decision  

---

## Escalation Etiquette

**Before Escalating**:
- Document what you've tried
- Prepare options (not just problems)
- Check if it really needs escalation

**When Escalating**:
- Be factual (not emotional)
- Provide context (why it matters)
- Suggest solution (not just complain)
- Set urgency (when decision needed)

**After Escalating**:
- Follow up (don't assume it's handled)
- Close the loop (update stakeholders on resolution)
- Thank the person who helped

---

## Escalation Log

| Date | Issue | Escalated To | Outcome | Time to Resolve |
|:-----|:------|:-------------|:--------|:----------------|
| 2024-10-04 | Payment API blocked | Tech Lead | Engaged Stripe support | 3 days |
| 2024-10-06 | Client change request | Steering Committee | Approved +$15k budget | 1 week |
| 2024-10-10 | Timeline slip | Project Sponsor | Negotiated with client | 2 days |

**Purpose**: Track escalations to identify patterns (frequent escalations = process problem)

---

## Common Escalation Scenarios

### Scenario 1: Developer Blocked on Technical Issue

**Initial Action** (Level 0):
- Google the error
- Check Stack Overflow
- Review documentation
- Try 2-3 different approaches

**Escalate to Tech Lead** (Level 1):
- After 4-8 hours blocked
- Provide what you've tried
- Request pairing session

**Escalate to PM** (Level 2):
- After 2 days blocked
- If blocking milestone
- Request external help (vendor support)

---

### Scenario 2: Client Requesting Scope Change

**Initial Action** (Level 0):
- Acknowledge request (don't commit)
- Document what they're asking for

**Escalate to PM** (Level 1):
- Immediately (scope changes need PM review)
- PM assesses impact (cost, timeline)

**Escalate to Steering** (Level 2):
- PM escalates with impact analysis
- Steering approves/rejects with client

**Escalate to Executive** (Level 3):
- If >25% budget impact
- If contract amendment needed

---

### Scenario 3: Project Running Over Budget

**Initial Action** (Level 0):
- PM tracks budget weekly
- Identifies trend early (10% over)

**Escalate to Steering** (Level 1):
- When 10-20% over budget
- Present options (reduce scope, add budget)

**Escalate to Executive** (Level 2):
- When >20% over budget
- Executive approves budget increase or scope cut

---

## Checklist

**Before Escalating**:
- [ ] I've tried to solve it myself (2+ attempts)
- [ ] I've documented what I tried
- [ ] I know who to escalate to
- [ ] I have context prepared (issue, impact, options)
- [ ] I've set urgency (when decision needed)

**When Escalating**:
- [ ] Clear subject line (Escalation - [Issue])
- [ ] Factual description (not emotional)
- [ ] Impact stated (timeline, budget, scope)
- [ ] Options provided (not just problem)
- [ ] Recommendation given (my preferred option)
- [ ] Deadline stated (decision needed by X)

**After Escalating**:
- [ ] Follow up if no response in SLA time
- [ ] Update stakeholders on resolution
- [ ] Document outcome in escalation log
- [ ] Thank the person who helped

---

## Notes

**Escalation is not failure**: Asking for help is strength, not weakness

**Escalate early**: Small issues become big issues if ignored

**Bring solutions, not just problems**: Always suggest options

**Don't skip levels**: Escalate to Level 1 first, not straight to executive
