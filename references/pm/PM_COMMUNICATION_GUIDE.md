# PM Communication Guide: Business Communication Skills for Solo Developers

**Audience**: Solo developers dealing with business stakeholders, clients, or internal teams  
**Goal**: Master professional communication to build trust, manage expectations, and protect project scope  
**Last Updated**: 2026-09-27

---

## 1. Foundation: Communication is the Best Scope Defense

**Core Principles**:
- **Clarity > Politeness**: Clarity is more important than politeness. Ambiguity = scope creep.
- **Proactive > Reactive**: Update before being asked, not after a crisis.
- **Data > Opinion**: "80% complete" is better than "almost done".
- **Options > Problems**: Never report a problem without bringing 2-3 solutions.
- **Written > Verbal**: Confirm all decisions in writing within 2 hours.

---

## 2. Executive Summary Writing (Top-Down Communication)

### Struktur 1-Page Executive Summary

```markdown
## [Project Name] - Status Update [Date]

**Status**: 🟢 Green / 🟡 Yellow / 🔴 Red  
**Progress**: [X]% complete (Week [Y] of [Z])  
**Budget**: $[Spent] / $[Total] ([Z]% utilized)

---

### Key Wins (Top 3)
1. [Specific achievement with business impact]
2. [Milestone reached ahead of schedule]
3. [Risk mitigated successfully]

### Risks & Mitigation (Top 2)
1. **Risk**: [Description]  
   **Impact**: [High/Medium/Low] - [Business consequence]  
   **Mitigation**: [Action taken + ETA]

2. **Risk**: [Description]  
   **Impact**: [High/Medium/Low]  
   **Mitigation**: [Action taken + ETA]

### Blockers (If Any)
- **Blocker**: [Description]  
  **Owner**: [Who needs to act]  
  **Needed By**: [Deadline]  
  **Consequence if Unresolved**: [Impact]

### Next Milestone
[What's shipping next] - Target: [Date]

### Asks (Explicit Decisions Needed)
1. [Decision request with 2-3 options and recommendation]
2. [Approval request with deadline]
```

### Real-World Example: Bad vs Good

**❌ Bad (Vague, No Action)**:
> "The project is going reasonably well. There are a few minor issues but they are being handled. There might be a slight delay but hopefully we can finish on time."

**✅ Good (Data-Driven, Actionable)**:
> **Status**: 🟡 Yellow (at risk)  
> **Progress**: 60% complete (Week 6 of 10)  
> **Risk**: Third-party payment API down for 2 days. Impact: Payment module delayed 3 days.  
> **Mitigation**: Switched to backup provider (Stripe → Xendit). Extra cost +$500, but keeps timeline on track.  
> **Ask**: Approve $500 budget increase by Friday EOD, or accept 1-week delay.

---

## 3. RAG Status (Red-Amber-Green) System

### Definisi Status

| Status | Meaning | Trigger | Action Required |
| :--- | :--- | :--- | :--- |
| 🟢 **Green** | On track | No blockers, timeline safe | Continue, routine updates |
| 🟡 **Yellow** | At risk | 1+ risk detected, mitigation active | Escalate to "Keep Satisfied" tier, increase update frequency |
| 🔴 **Red** | Blocked | Critical blocker >3 days, or timeline slip >2 weeks | Immediate escalation to CEO/CFO, crisis protocol |

### When to Change Status?

**Green → Yellow**:
- A blocker arises with potential to delay >3 days
- Budget burn rate >10% above forecast
- Key stakeholder unresponsive >48 hours on critical decisions

**Yellow → Red**:
- Blocker not resolved within 3 days
- Timeline slip >2 minggu confirmed
- Budget overrun >20%
- Data breach / security incident

**Red → Yellow → Green**:
- Only after mitigation action proves effective (not just a plan)
- Wait 1 sprint cycle to confirm stability

---

## 4. Status Report Format (Weekly Update)

### Template for "Keep Informed" Tier (Slack/Discord)

```markdown
**[Project Name] - Week [X] Update**

**Last Week** ✅:
- Shipped: User authentication (OAuth2 + 2FA)
- Shipped: Payment gateway integration (Stripe test mode)
- Fixed: 3 P1 bugs from QA testing

**This Week** 🎯:
- Goal: Complete product catalog CRUD APIs
- Goal: Start mobile responsive layout
- Milestone: Deploy to staging by Friday

**Blockers** 🚧:
- Waiting for design approval on checkout page (sent Mon, no reply yet)
  - **Ask**: @Designer need feedback by Wed EOD or proceeding with current version

**Metrics**:
- Progress: 65% → 70% (+5%)
- Test coverage: 75% (target: 80%)
- P0 bugs: 0 | P1 bugs: 2 (down from 5)
```

### Template for "Keep Satisfied" Tier (Email - Bi-weekly)

**Subject**: [Project Name] - Bi-weekly Status Report 🟢 [Date]

```markdown
**Status**: 🟢 Green (on track)

**Progress Summary**:
- 70% feature completion (Week 7 of 10)
- $28K spent / $40K budget (70% utilized, on track)
- 0 critical bugs, 2 minor bugs in triage

**Recent Achievements**:
1. User authentication module live on staging (OAuth2, 2FA, password reset)
2. Payment gateway integrated and tested (Stripe)
3. API documentation published (OpenAPI spec)

**Coming Next 2 Weeks**:
1. Complete product catalog + shopping cart
2. QA testing sprint (target: 80% test coverage)
3. Security audit preparation

**Risks**:
1. **Client data migration delayed by client team** (Medium impact)
   - Mitigation: Building mock data generator, real data can be imported post-launch
   - Status: Escalated to Client CEO on [Date]

**No blockers requiring executive action at this time.**

**Budget & Timeline**: On track for [Launch Date] within approved budget.

---
**Next Update**: [Date]
```

---

## 5. Risk Communication (Early Warning System)

### Formula Komunikasi Risk

```
[Risk Name] - Impact: [H/M/L], Probability: [H/M/L]

**Scenario**: [What could go wrong]
**Impact**: [Business consequence if it happens]
**Current Status**: [Is it happening now or potential?]

**Mitigation Options**:
1. [Option A]: [Description] - Cost: [X], Time: [Y], Pros/Cons
2. [Option B]: [Description] - Cost: [X], Time: [Y], Pros/Cons
3. [Option C]: [Description] - Cost: [X], Time: [Y], Pros/Cons

**Recommendation**: [Option X] because [reasoning]
**Decision Needed By**: [Date] (after this date, we default to [Option X])
```

### Real-World Example

**❌ Bad (Vague, Panic Mode)**:
> "There is a huge problem with the server! Looks like the database will overload if there are too many users. Must fix it right now or it will crash later!"

**✅ Good (Structured, Options-Oriented)**:
> **Risk**: Database Performance at Scale - Impact: High, Probability: Medium
>
> **Scenario**: Current database schema can handle ~500 concurrent users. If launch campaign brings >1000 users, response time could degrade to >10s (unusable).
>
> **Impact**: User churn, negative reviews, potential revenue loss ~$5K/week
>
> **Current Status**: Not happening yet (we're in beta with 50 users), but launch in 2 weeks
>
> **Mitigation Options**:
> 1. **Database Optimization** (add indexes, query refactor): $0 cost, 3 days work
>    - Pros: No infrastructure cost, likely solves 80% of issue
>    - Cons: May not be enough if traffic >2000 users
>
> 2. **Vertical Scaling** (upgrade database tier): +$200/month, 1 day work
>    - Pros: Quick, proven solution
>    - Cons: Ongoing cost, doesn't scale beyond 2000 users
>
> 3. **Horizontal Scaling** (read replicas + load balancer): +$500/month, 5 days work
>    - Pros: Scales to 10K+ users
>    - Cons: High cost, delays launch by 1 week
>
> **Recommendation**: Option 1 now (3 days), Option 2 if needed post-launch. Cheaper to optimize first, scale later based on real data.
>
> **Decision Needed By**: Friday EOD (so we finish optimization before launch week)

---

## 6. Scope Creep Defense Scripts

### Script 1: The "Small Feature" Request

**Client**: "Can you add feature X? It's just a small thing, should be quick, right?"

**❌ Bad Response**:
> "Oh sure, I'll give it a try."

**✅ Good Response**:
> "We can, but let's look at the trade-offs. Feature X takes an estimated 2-3 days of dev time because [brief technical reason]. We have 3 options:
> 1. **Include in this sprint**: Timeline slips by 3 days, or we drop planned feature Y
> 2. **Add to Phase 2** (post-launch): Does not affect the current release timeline
> 3. **Paid change order**: +$X if outside the original agreed scope
>
> Which one best aligns with your business priorities?"

### Script 2: The "Just Make It Work" Ambiguity

**Client**: "The dashboard needs to be user-friendly so it's easy to use."

**❌ Bad Response**:
> "Got it, I'll make it user-friendly."

**✅ Good Response**:
> "Noted. To ensure we're aligned, may I clarify what 'user-friendly' means in this context:
> - Does it mean: Loading time <2 seconds?
> - Or: Max 3 clicks to access core features?
> - Or: Mobile-responsive (usable on mobile devices)?
> - Or: Interactive tutorial/onboarding upon first login?
>
> As I understand it, the highest priorities are [X] and [Y]. Is that correct?"

### Script 3: The "Why Is This Taking So Long?"

**Client**: "Why is this taking so long? Isn't it just standard CRUD?"

**❌ Bad Response**:
> "It's complex, there are lots of things to consider." (Defensive, vague)

**✅ Good Response**:
> "True, conceptually CRUD is standard. However, several specific requirements add time:
> 1. **Security**: Encrypt sensitive data, implement RBAC for 3 user roles
> 2. **Validation**: 12 business rules that must be checked before saving data
> 3. **Integration**: Sync with 2 external APIs that are rate-limited
>
> For the 5-day estimate, the breakdown is:
> - 2 days: Core CRUD (already completed)
> - 2 days: Security + validation (in progress)
> - 1 day: API integration + testing
>
> If you want to move faster, we can temporarily skip the API integration (add it later), saving 1 day. Would you like that?"

---

## 7. Handling Difficult Stakeholders

### Type 1: The Micromanager

**Ciri-ciri**:
- Tanya progress setiap hari (berkali-kali)
- Asks for status updates on every small task
- Doesn't believe progress without visible proof (screenshots, videos)

**Strategi**:
1. **Proactive Daily Update** (morning at 09:00 before they ask):
   ```
   **Today's Focus**: Completing checkout flow backend API
   **Expected Done By**: EOD today
   **Demo Link**: https://staging.example.com/checkout (credentials: demo/demo123)
   ```

2. **Set Update Schedule**: 
   > "To keep things efficient, I will send updates at 09:00 and 17:00 daily. If any urgent blockers arise, I will notify you immediately. This way we can stay synchronized without interruptions during coding. Sound good?"

3. **Over-Document**:
   - Commit messages jelas
   - Staging environment always accessible
   - Loom videos to demo progress

### Type 2: The Scope Creeper

**Ciri-ciri**:
- Setiap minggu ada "ide bagus" baru
- "Just a small addition" is their mantra
- Unaware that accumulated "small additions" = major delay

**Strategi**:
1. **Change Request Form** (formal process):
   ```markdown
   **Feature Request**: [Name]
   **Business Value**: [Why this matters]
   **Estimated Effort**: [X days]
   **Impact on Timeline**: [+X days delay OR drop feature Y]
   **Budget Impact**: [+$X or within existing scope?]
   **Proposed Phase**: [Current sprint / Phase 2 / Paid extension]
   ```

2. **Visual Timeline Impact**:
   - Show Gantt chart: "Adding this feature = slips launch from Nov 15 to Nov 30"
   - Use trade-offs: "If this feature goes in, which one do we drop: A, B, or C?"

3. **Iron Triangle Script**:
   > "We have 3 variables: Scope, Time, Quality. Right now we are locked on Time (Nov 15 launch) and Quality (80% test coverage). If Scope increases, one of the other variables must flex. Which one would you prefer?"

### Type 3: The Silent Approver

**Ciri-ciri**:
- Does not reply to email/Slack for approval requests
- "I'll look at it later" but never completes the review
- Blocks progress due to lack of sign-off

**Strategi**:
1. **Time-Bound Approval**:
   > "I have sent the design mockups via Figma (link: ...). Need approval by Wednesday 17:00 WIB. If there is no feedback by the deadline, I will proceed on the assumption of approval to keep the timeline on track. Sound good?"

2. **Escalation Warning**:
   > "API spec approval has been pending for 3 days. If there is no feedback by tomorrow EOD, I will escalate to [Boss/PO] so it doesn't block the dev team. Prefer to get your input first if possible."

3. **Default to Last Agreed Version**:
   > "Since no feedback received on Version 3, I'm proceeding with Version 2 (last approved). Can always iterate in Phase 2 if needed."

### Type 4: The "I'll Know It When I See It"

**Ciri-ciri**:
- Cannot clearly articulate requirements
- Revisi design/feature berkali-kali setelah development dimulai
- "Hmm, that's not quite what I meant" after seeing the result

**Strategi**:
1. **Prototype-First Approach**:
   - Buat low-fidelity wireframe/mockup sebelum coding
   - 30-min feedback session setelah mockup
   - Lock design before development

2. **Revision Budget**:
   > "Design revisions: Max 2 rounds included in contract. Round 3+ = change order +$X per round. This is to protect both of our timelines."

3. **Reference Examples**:
   > "To help us align, could you share examples of websites/apps whose style you like? For instance: 'Like Linear but more minimalist' or 'Like Notion but more colorful'."

---

## 8. Email vs Slack vs Call (Choosing the Right Channel)

### Decision Matrix

| Situation | Channel | Why |
| :--- | :--- | :--- |
| **Daily tactical update** | Slack/Discord | Fast, informal, searchable |
| **Approval request** | Email (with Slack reminder) | Written record, formal |
| **Complex decision with options** | Email (detailed) + Call (discuss) | Allows prep time + real-time Q&A |
| **Scope change negotiation** | Call → Email confirmation | Human negotiation + paper trail |
| **Crisis/P0 incident** | Call/WhatsApp → Slack update | Immediate attention + broadcast |
| **Weekly status** | Email (cc all) | Broadcast, reference-able |
| **Casual check-in** | Slack DM | Low-pressure, quick sync |

### Email Subject Line Best Practices

**❌ Bad**:
> "Update"
> "Question"
> "Need help"

**✅ Good**:
> "[Project X] - Design Approval Needed by Wed EOD"
> "[Project X] - Week 7 Status Report 🟢 (70% complete)"
> "[Project X] - URGENT: API Integration Blocked - Decision Needed"

**Formula**: `[Project Name] - [Action Required / Status] - [Urgency/Deadline]`

---

## 9. Meeting Facilitation Skills

### Pre-Meeting (24h Before)

**Send Agenda**:
```markdown
**Meeting**: [Project X] - Weekly Sync
**Date**: [Date] [Time] [Timezone]
**Duration**: 30 min (hard stop)
**Attendees**: [Names]
**Location**: [Zoom link]

**Agenda**:
1. Progress review (10 min): Demo feature X
2. Blockers discussion (10 min): Payment API integration issue
3. Next week priorities (5 min): Confirm top 3 tasks
4. Decisions needed (5 min): Approve budget increase $2K for SMS gateway

**Pre-read** (optional): [Link to doc/dashboard]

**Goal**: Leave meeting with clear decision on budget and unblocked on payment API
```

### During Meeting

**Time Management**:
- Start on time (even if people late)
- Timebox each agenda item
- "Let's park that for later" for off-topic discussions
- 5-min warning before hard stop

**Decision Capture**:
- Designate note-taker (not the facilitator)
- Record decisions in real-time (shared doc)
- Action items: Owner + Deadline

**Handling Tangents**:
> "That's important, but off-agenda. Let's add to parking lot and schedule separate 15-min to discuss."

### Post-Meeting (Within 2h)

**Send Meeting Notes**:
```markdown
**Meeting Notes**: [Project X] - Weekly Sync - [Date]

**Attendees**: [Present] | **Absent**: [Names]

**Decisions Made**:
1. ✅ Approved $2K budget for SMS gateway (Twilio)
2. ✅ Agreed to drop Feature Y to keep timeline on track
3. ⏸️ Postponed decision on mobile app to Phase 2

**Action Items**:
- [ ] @SoloDev: Setup Twilio account by Wed
- [ ] @Designer: Send revised mockup by Fri EOD
- [ ] @ProductOwner: Confirm client approval on scope change by Mon

**Parking Lot** (for future discussion):
- Feature Z enhancement
- Q2 roadmap planning

**Next Meeting**: [Date] [Time]
```

---

## 10. Negotiation & Conflict Resolution

### Negotiation Framework: BATNA (Best Alternative to Negotiated Agreement)

**Before Negotiation, Prepare**:
1. **Your Position**: What you want
2. **Their Position**: What they want
3. **Your BATNA**: What you'll do if negotiation fails
4. **Their BATNA**: What they'll do if negotiation fails
5. **ZOPA (Zone of Possible Agreement)**: Overlap between your bottom line and their top line

**Example: Budget Negotiation**

- **Client**: Budget only $30K
- **You**: Need $40K to deliver all features
- **Your BATNA**: Drop 30% of features to fit $30K budget
- **Their BATNA**: Find another developer (risk: delay 2 months)
- **ZOPA**: $32K-$38K (if you optimize, they stretch budget)

**Negotiation Script**:
> "I understand the $30K budget constraint. Delivering all features requires $40K. There are 3 options:
> 1. **Full scope**: $40K, 10 weeks
> 2. **Phase 1 (MVP)**: $30K, 6 weeks → Phase 2 (remaining): $10K, 4 weeks
> 3. **Reduced scope**: $30K, 10 weeks, drop Feature X, Y, Z
>
> Which one best aligns with your business priorities?"

### Conflict Resolution: DESC Model

**D = Describe** (Facts, no judgment):
> "The design mockups have gone through 3 revision rounds, each occurring after development had already started."

**E = Express** (Impact on you):
> "This stalls development because completed code must be rewritten. The timeline risks a 2-week delay."

**S = Specify** (What you want):
> "Going forward, saya usulkan: Design locked before dev starts. Max 2 revision rounds. Round 3+ = paid change order."

**C = Consequences** (Positive if they agree, negative if not):
> "This way, we can deliver on time and on budget. Otherwise, we risk delays and budget overruns that harm both of us."

---

## 11. Cultural & Personality Adaptation

### High-Context vs Low-Context Cultures

**Low-Context** (Barat: US, Jerman, Belanda):
- Direct communication preferred
- "No" means no
- Written agreements paramount
- Conflict addressed head-on

**High-Context** (Asia: Indonesia, Jepang, Thailand):
- Indirect communication, save face
- "Yes" might mean "maybe" or "I heard you"
- Relationship > contract
- Conflict avoided or softened

**Adaptation Strategy**:

**For High-Context Clients**:
- Add buffer: "Should finish next week" → You plan 2 weeks
- Read between lines: "Sepertinya bagus" ≠ approval, follow up
- Build relationship first: 10-min small talk before business

**For Low-Context Clients**:
- Be direct: "This will delay timeline by 1 week" (no sugar-coating)
- Document everything: Email confirms all verbal discussions
- Set explicit expectations: "Silence = approval" must be stated upfront

### Personality Types (DISC Model - Quick Guide)

**D (Dominant)**: Results-focused, impatient, decisive
- **Communication Style**: Bottom-line first, bullet points, no fluff
- **What They Want**: "Will this work? How much? When?"
- **Example**: "Option A: $30K, 8 weeks. Recommend."

**I (Influencer)**: People-focused, enthusiastic, optimistic
- **Communication Style**: Storytelling, visuals, positive framing
- **What They Want**: "How will users love this?"
- **Example**: "Imagine users opening the app and seeing..."

**S (Steady)**: Process-focused, patient, reliable
- **Communication Style**: Step-by-step, reassurance, consistency
- **What They Want**: "What's the plan? Is it safe?"
- **Example**: "Here's the 5-step deployment plan. We've tested this 3 times."

**C (Conscientious)**: Detail-focused, analytical, skeptical
- **Communication Style**: Data, charts, accuracy, options
- **What They Want**: "Show me the data. What are the risks?"
- **Example**: "Test coverage 80%, P0 bugs: 0, P1 bugs: 2. Risk analysis attached."

---

## 12. Common Communication Mistakes (Anti-Patterns)

### Mistake 1: The "Almost Done" Trap

**❌ Problem**:
> "Hampir selesai kok, tinggal sedikit lagi." (Diucapkan 3 minggu berturut-turut)

**✅ Fix**:
> "Progress: 75% complete. Remaining tasks: X (2 days), Y (1 day), Z (3 days). ETA: Friday."

### Mistake 2: Over-Promising to Please

**❌ Problem**:
> "Sure, I'll try!" (Despite being unsure if feasible)

**✅ Fix**:
> "Interesting idea. Let me research it for 1-2 days for a feasibility check. I will update you on Thursday with an accurate estimate."

### Mistake 3: Hiding Bad News

**❌ Problem**:
> (Tahu ada blocker besar tapi diam 1 minggu sampai krisis)

**✅ Fix**:
> (Day 1 of blocker): "FYI, blocker X encountered. Estimated 2-3 days to resolve. Updating daily."

### Mistake 4: Technical Jargon to Non-Tech Stakeholders

**❌ Problem**:
> "CORS preflight failed because the OPTIONS request didn't return proper headers from the backend."

**✅ Fix**:
> "There is a communication issue between frontend and backend. Currently being fixed, estimated completion tomorrow."

### Mistake 5: No Follow-Up on Verbal Decisions

**❌ Problem**:
> (Meeting: "Ok approved") → (2 weeks later: "Wait, why is this feature here? I never agreed to that!")

**✅ Fix**:
> (Email 2 hours after meeting): "Confirming today's decision: Approved $2K budget for SMS gateway. Development starts tomorrow."

---

## 13. Templates Quick Reference

### 1. Daily Standup (Async Slack)
```
**Yesterday**: ✅ [Done items]
**Today**: 🎯 [Focus items]
**Blockers**: 🚧 [Issues] or "None"
```

### 2. Weekly Status Report
```
**Status**: 🟢/🟡/🔴
**Progress**: X% (Week Y of Z)
**Wins**: [3 items]
**Next Week**: [3 goals]
**Blockers**: [If any]
**Asks**: [Explicit requests]
```

### 3. Risk Report
```
**Risk**: [Name] - Impact: H/M/L, Probability: H/M/L
**Scenario**: [What could happen]
**Impact**: [Business consequence]
**Options**: [2-3 mitigation choices]
**Recommendation**: [Your pick + why]
**Decision By**: [Date]
```

### 4. Change Request
```
**Feature**: [Name]
**Business Value**: [Why needed]
**Effort**: [X days]
**Timeline Impact**: [+Y days OR drop feature Z]
**Budget Impact**: [+$X]
**Proposed**: [Current sprint / Phase 2 / Paid]
```

### 5. Meeting Notes
```
**Decisions**: [Numbered list]
**Action Items**: [@Owner: Task - Deadline]
**Parking Lot**: [Deferred topics]
**Next Meeting**: [Date/Time]
```

---

## 14. Checklist: Communication Hygiene

Daily:
- [ ] Send morning standup update to "Manage Closely" tier (09:00)
- [ ] Reply to all Slack/email within SLA (<2h for urgent, <24h for others)
- [ ] Confirm verbal decisions in writing within 2h

Weekly:
- [ ] Send status report to "Keep Informed" tier (Fri EOD)
- [ ] Update project dashboard (progress %, blocker status)
- [ ] Review upcoming week priorities with Product Owner

Bi-weekly:
- [ ] Send executive summary to "Keep Satisfied" tier
- [ ] Risk register review (any new risks?)

Monthly:
- [ ] Executive review prep (1-page summary)
- [ ] Stakeholder engagement scorecard update
- [ ] Communication plan adjustment (if needed)

Before Every Meeting:
- [ ] Send agenda 24h before
- [ ] Prepare demos/visuals
- [ ] Define meeting goal

After Every Meeting:
- [ ] Send meeting notes within 2h
- [ ] Confirm action items with owners
- [ ] Schedule next meeting

---

## 15. Resources & Further Reading

### Books
- "Crucial Conversations" - Patterson, Grenny, et al. (Conflict resolution)
- "Never Split the Difference" - Chris Voss (Negotiation)
- "The Pyramid Principle" - Barbara Minto (Executive communication)
- "Radical Candor" - Kim Scott (Direct feedback)

### Tools
- **Status Dashboards**: Linear, Jira, Notion
- **Time Tracking**: Toggl, Clockify
- **Demo Videos**: Loom, Vimeo Record
- **Documentation**: Notion, Confluence, Google Docs

### Skills to Practice
1. **Executive summary writing**: Take any project update, rewrite as 1-page top-down summary
2. **Option framing**: For every problem, force yourself to generate 3 solutions before reporting
3. **Time-bound asks**: Never say "need your input" without "by [date]"
4. **Meeting facilitation**: Record yourself, analyze: Did you stay on time? Capture decisions?

---

## Appendix: Communication Style Adapters

### Formal (Legal, Executive, Compliance)
- Subject line: `[Official] [Project X] - [Topic]`
- Salutation: "Dear [Title] [Last Name],"
- Language: "We respectfully request approval for..."
- Close: "Sincerely, [Full Name]"

### Professional (Product Owner, Manager)
- Subject line: `[Project X] - [Topic]`
- Salutation: "Hi [First Name],"
- Language: "Need your decision on..."
- Close: "Best, [First Name]"

### Casual (Designer, Dev Team, QA)
- Subject line: `[Project X] - quick question`
- Salutation: "Hey [Name],"
- Language: "Quick heads up..."
- Close: "Thanks!"

**Rule of Thumb**: Match the recipient's style. If they write formal, reply formal. If they Slack "yo" you, Slack "hey" back.

---

**End of PM Communication Guide**

**Last Updated**: 2026-09-27  
**Maintained By**: Solo Project Development Skill (Module 02)
