# OKR (Objectives & Key Results): Q[X] 2026

**Project**: [Product Name]  
**Period**: Q[X] 2026 ([Month] – [Month])  
**Owner**: [PIC / Solo Dev Name]  
**Date Created**: YYYY-MM-DD  
**Status**: Draft / Active / Completed

---

## 1. OKR Framework Overview

**OKR = Objective + Key Results**

- **Objective**: Qualitative, inspiring, directional goal (what you want to achieve)
- **Key Results**: Quantitative, measurable outcomes (how you know you got there)

**Cadence**:
- Set OKRs at start of quarter
- Weekly check-in (update progress)
- Mid-quarter review (week 6–7): Adjust if needed
- End-of-quarter review (week 12–13): Grade and reflect

**Grading Scale**:
- 0.0–0.3: Failed (need post-mortem)
- 0.4–0.6: Progressing (common for stretch goals)
- 0.7–0.9: Achieved (good performance)
- 1.0: Exceeded (may indicate goal was too easy)

**Target**: Aim for 0.7–0.8 average (means goals were ambitious but realistic)

---

## 2. Company/Product-Level OKR

### Objective 1: Launch MVP and Validate Product-Market Fit
*Focus: Get the core product in users' hands and validate demand*

#### Key Result 1.1: Acquire 50 Beta Users by End of Q1
- **Owner**: Solo Dev / Founder
- **Baseline**: 0 beta users (2026-01-01)
- **Target**: 50 beta users (2026-03-31)
- **Metric Definition**: Unique users who completed signup + completed onboarding (verified email + uploaded ≥1 document)
- **Data Source**: PostgreSQL `users` table, `status='active' AND onboarded_at IS NOT NULL`
- **Current Progress**: 12 users (24% of target) as of 2026-02-15
- **On Track?**: 🟡 Behind (expected 25 by mid-Q, need to accelerate user acquisition)
- **Action Items**:
  - Post in 3 relevant subreddits (r/ProductManagement, r/SaaS)
  - Share on LinkedIn with demo video
  - Reach out to 10 warm leads from network

**Grade (End of Quarter)**: _[Fill after Q1 ends: 0.0–1.0]_  
**Reflection**: _[What worked, what didn't, lessons learned]_

---

#### Key Result 1.2: Achieve 40% Weekly Active User (WAU) Retention by Week 8
- **Owner**: Solo Dev
- **Baseline**: N/A (no users yet at Q start)
- **Target**: 40% of beta users active weekly (visit app + perform ≥1 action) by week 8
- **Metric Definition**: (Weekly Active Users / Total Registered Users) × 100
  - Active = logged in + uploaded OR viewed OR downloaded ≥1 document in past 7 days
- **Data Source**: Custom query: `SELECT COUNT(DISTINCT user_id) FROM activity_logs WHERE timestamp >= NOW() - INTERVAL '7 days'`
- **Current Progress**: 5/12 active users = 42% (week 6) ✅ Ahead of target!
- **On Track?**: ✅ Yes (exceeded early)
- **What's Working**: Onboarding tutorial reduced drop-off, email reminders bringing users back

**Grade (End of Quarter)**: _[Fill after Q1 ends]_  
**Reflection**: _[...]_

---

#### Key Result 1.3: Collect 20 User Feedback Sessions with Actionable Insights
- **Owner**: Solo Dev
- **Baseline**: 0 interviews (2026-01-01)
- **Target**: 20 completed user interviews OR detailed feedback forms
- **Metric Definition**: Actionable = identifies a pain point, feature request, or usability issue with enough detail to act on
- **Data Source**: Notion database "User Feedback Log" (link: `[URL to Notion page]`)
- **Current Progress**: 8 interviews complete (40% of target) as of 2026-02-15
- **On Track?**: 🟡 Slightly behind (expected 10 by mid-Q)
- **Action Items**:
  - Send feedback request email to all active users (offer $10 Amazon gift card incentive)
  - Schedule 2 interviews/week for next 4 weeks
  - Add in-app feedback widget (Canny or Typeform embed)

**Grade (End of Quarter)**: _[Fill after Q1 ends]_  
**Reflection**: _[...]_

---

### Objective 2: Establish Scalable Technical Foundation
*Focus: Build for stability and future growth, avoid tech debt*

#### Key Result 2.1: Achieve API P95 Latency < 500ms for Core Endpoints
- **Owner**: Solo Dev
- **Baseline**: No production traffic yet (Q start)
- **Target**: 95th percentile response time < 500ms for `/api/documents/upload`, `/api/documents/process`, `/api/auth/*`
- **Metric Definition**: P95 latency = 95% of requests complete within this time
- **Data Source**: Vercel Analytics (or custom APM like Sentry Performance)
- **Current Progress**: P95 = 320ms (week 6) ✅ Well under target
- **On Track?**: ✅ Yes
- **Risk**: May degrade with scale (monitor when users > 100)

**Grade (End of Quarter)**: _[...]_  
**Reflection**: _[...]_

---

#### Key Result 2.2: Maintain 99.5% Uptime for Production Environment
- **Owner**: Solo Dev
- **Baseline**: N/A (no prod yet)
- **Target**: 99.5% uptime = max 3.6 hours downtime/month (or 10.8 hours/quarter)
- **Metric Definition**: Uptime measured by Vercel status + custom health check (ping `/api/health` every 5 min)
- **Data Source**: Uptime monitoring tool (UptimeRobot or Better Uptime)
- **Current Progress**: 99.8% uptime (1 outage: 30 min, Vercel incident)
- **On Track?**: ✅ Yes
- **Incidents Log**:
  - 2026-02-10: 30 min downtime (Vercel region outage, beyond control)

**Grade (End of Quarter)**: _[...]_  
**Reflection**: _[...]_

---

#### Key Result 2.3: Achieve 80% Automated Test Coverage for Business Logic
- **Owner**: Solo Dev
- **Baseline**: 0% (no tests at Q start)
- **Target**: 80% line coverage for `/app/api/`, `/lib/`, `/utils/` (excludes UI components)
- **Metric Definition**: Line coverage (not branch), measured by Jest + Istanbul
- **Data Source**: `npm run test:coverage` output
- **Current Progress**: 65% coverage (week 6)
- **On Track?**: 🟡 Behind schedule (need 70% by mid-Q)
- **Action Items**:
  - Write integration tests for auth flow (5 SP)
  - Add unit tests for document processing logic (3 SP)
  - Target: 10% coverage increase/week

**Grade (End of Quarter)**: _[...]_  
**Reflection**: _[...]_

---

## 3. Individual/Team OKR (if applicable)

### Objective 3: Improve Solo Dev Productivity & Avoid Burnout
*Focus: Sustainable pace, skill growth, mental health*

#### Key Result 3.1: Maintain Avg 30 Story Points Velocity per 2-Week Sprint
- **Owner**: Solo Dev
- **Baseline**: Unknown (no sprint history)
- **Target**: Avg 30 SP/sprint (consistent delivery rate)
- **Metric Definition**: Sum of completed story points per sprint / # sprints
- **Data Source**: Backlog tracking (Linear/Jira or manual log in `docs/pm/BACKLOG.md`)
- **Current Progress**:
  - Sprint 1: 28 SP
  - Sprint 2: 32 SP
  - Sprint 3: 26 SP (in progress)
  - **Avg so far**: 30 SP ✅
- **On Track?**: ✅ Yes

**Grade (End of Quarter)**: _[...]_  
**Reflection**: _[...]_

---

#### Key Result 3.2: Complete 3 Learning Milestones (New Skills)
- **Owner**: Solo Dev
- **Baseline**: Current skill gaps: React Server Components, AWS CDK, Stripe webhooks
- **Target**: Ship 1 feature using each new skill (learning-by-doing)
- **Metric Definition**: Deployed to production + passed code review (self-review with checklist)
- **Data Source**: Git commits + deployed features log
- **Current Progress**:
  - ✅ React Server Components (used in dashboard refactor, deployed week 5)
  - 🟡 AWS CDK (in progress, deploying infra as code)
  - ⬜ Stripe webhooks (not started, scheduled for sprint 4)
- **On Track?**: 🟡 Slightly behind (2/3 done)

**Grade (End of Quarter)**: _[...]_  
**Reflection**: _[...]_

---

#### Key Result 3.3: Zero Weeks with >50 Hours Work (Burnout Prevention)
- **Owner**: Solo Dev
- **Baseline**: Unknown (no time tracking yet)
- **Target**: 0 weeks exceeding 50 hours (max 10 hours/day × 5 days)
- **Metric Definition**: Self-reported time log (Toggl or manual spreadsheet)
- **Data Source**: Toggl weekly report or `docs/pm/TIME_LOG.csv`
- **Current Progress**:
  - Week 1–5: All under 45 hours ✅
  - Week 6: 52 hours 🔴 (crunch before beta launch)
- **On Track?**: 🟡 One violation so far (need to manage scope better)
- **Action Items**:
  - Set hard stop at 6pm daily
  - Say no to scope creep (defer features to "Later")

**Grade (End of Quarter)**: _[...]_  
**Reflection**: _[...]_

---

## 4. OKR Progress Tracking (Weekly Check-In)

| Week | Date | O1 Progress | O2 Progress | O3 Progress | Blockers | Action This Week |
| ---: | :--- | :--- | :--- | :--- | :--- | :--- |
| W1 | 2026-01-06 | KR1.1: 2 users | KR2.3: 15% cov | KR3.1: 28 SP | None | Set up beta landing page |
| W2 | 2026-01-13 | KR1.1: 5 users | KR2.3: 30% cov | KR3.1: — | Stripe approval delay | Reach out to 5 leads |
| W3 | 2026-01-20 | KR1.1: 8 users | KR2.3: 45% cov | KR3.1: — | None | Post in subreddits |
| W4 | 2026-01-27 | KR1.1: 10 users | KR2.3: 55% cov | KR3.1: 32 SP (S2 done) | None | User interviews |
| W5 | 2026-02-03 | KR1.1: 12 users | KR2.3: 60% cov | KR3.2: RSC shipped | None | Refactor dashboard |
| W6 | 2026-02-10 | KR1.1: 12 users 🔴 | KR2.3: 65% cov 🟡 | KR3.3: 52h 🔴 | User acq slow | Launch referral program |

**Legend**:
- ✅ On track
- 🟡 At risk
- 🔴 Behind

---

## 5. Mid-Quarter Review (Week 6–7)

**Date**: 2026-02-15  
**Attendees**: Solo Dev (self-review)

**What's Working**:
- WAU retention (42%) exceeded target early (onboarding + email reminders effective)
- API latency well under target (good foundation)
- Velocity stable at 30 SP/sprint

**What's Not Working**:
- User acquisition behind (only 12/50, need 25 by mid-Q)
- Test coverage lagging (65% vs 70% target)
- Worked 52 hours in week 6 (burnout risk)

**Adjustments**:
- **No change to OKR targets** (still achievable with effort)
- **Action**: Launch referral program (incentivize users to invite friends)
- **Action**: Dedicate 20% of each sprint to tests (non-negotiable)
- **Action**: Enforce 50-hour/week limit (defer non-critical features)

---

## 6. End-of-Quarter Review & Grading

**Date**: 2026-04-05 (after Q1 ends)  
**Attendees**: Solo Dev (self-review) + optional advisor/mentor

### Final Grades

| Objective | Key Result | Target | Actual | Grade | Comments |
| :--- | :--- | :--- | :--- | ---: | :--- |
| **O1: Launch MVP** | KR1.1: Beta users | 50 | _[TBD]_ | _[0.0–1.0]_ | _[...]_ |
|  | KR1.2: WAU retention | 40% | _[TBD]_ | _[...]_ | _[...]_ |
|  | KR1.3: Feedback sessions | 20 | _[TBD]_ | _[...]_ | _[...]_ |
| **O2: Technical Foundation** | KR2.1: API latency | <500ms | _[TBD]_ | _[...]_ | _[...]_ |
|  | KR2.2: Uptime | 99.5% | _[TBD]_ | _[...]_ | _[...]_ |
|  | KR2.3: Test coverage | 80% | _[TBD]_ | _[...]_ | _[...]_ |
| **O3: Productivity** | KR3.1: Velocity | 30 SP | _[TBD]_ | _[...]_ | _[...]_ |
|  | KR3.2: Learning | 3 skills | _[TBD]_ | _[...]_ | _[...]_ |
|  | KR3.3: Work hours | 0 weeks >50h | _[TBD]_ | _[...]_ | _[...]_ |

**Overall Grade**: _[Avg of all KR grades]_

**Top Wins**:
1. _[Example: Exceeded retention target, users love the product]_
2. _[Example: Stable velocity, sustainable pace]_

**Top Misses**:
1. _[Example: User acquisition harder than expected, need better marketing]_
2. _[Example: Test coverage fell short, too much rush to ship]_

**Lessons Learned**:
- _[Example: Need to start marketing earlier, not just focus on building]_
- _[Example: Setting ambitious goals (0.7 grade) is good, forces prioritization]_

---

## 7. Carryover to Next Quarter (Q2 2026)

**What's Rolling Over**:
- If KR1.1 (50 users) not achieved, carry shortfall to Q2 (e.g., if reached 40, aim for +30 more in Q2)
- Test coverage target moves to Q2 as KR (priority: reach 90%)

**What's Changing**:
- O1 shifts from "Launch" to "Growth" (focus: paid conversions, revenue)
- O2 adds new KR: Scale to 1000 users without infra changes

---

## 8. OKR Best Practices (Solo Dev Context)

### Do's:
- ✅ **Set 2–3 Objectives max** (focus > quantity)
- ✅ **3–5 Key Results per Objective** (if more, you're tracking tasks, not outcomes)
- ✅ **Make KRs measurable** (use numbers, %, $, not vague terms like "improve")
- ✅ **Ambitious but achievable** (target 0.7 grade, not 1.0)
- ✅ **Review weekly** (15 min check-in, update progress, flag blockers)

### Don'ts:
- ❌ **Don't confuse OKRs with tasks** (OKR = outcome, not "Finish feature X")
- ❌ **Don't set too many OKRs** (solo dev max 3 Objectives = 9–15 KRs total)
- ❌ **Don't change mid-quarter** (unless major pivot, OKRs should be stable)
- ❌ **Don't punish low grades** (0.6 on stretch goal is success, not failure)

### Solo Dev Tips:
- Keep OKRs in a visible place (dashboard widget, weekly review doc)
- Link OKRs to roadmap (every "Now" feature should tie to a KR)
- If a KR feels impossible by mid-Q, adjust scope (better to hit 0.7 on smaller goal than 0.3 on huge goal)

---

## 📌 Quick Reference Links

- **Roadmap**: `docs/pm/PRODUCT_ROADMAP.md`
- **Backlog**: `docs/pm/BACKLOG.md`
- **KPI Dashboard**: _[Link to Metabase/Grafana dashboard]_
- **User Feedback Log**: _[Link to Notion/Airtable]_

---

**🎯 Remember**: OKRs are a tool, not a religion. The goal is to focus effort and measure progress, not to create busywork. If tracking a KR becomes more effort than the value it provides, simplify or drop it.
