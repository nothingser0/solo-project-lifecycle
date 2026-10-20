# PM User Testing Guide: Best Practices & Common Pitfalls

**Purpose**: Tactical reference for solo PMs/developers conducting iterative user testing that generates actionable insights, not just a validation ritual.

---

## 1. When User Testing is Mandatory vs When It Can Be Skipped

### MANDATORY (Non-Negotiable)
- ✅ **New product/feature** that has never been market-validated
- ✅ **Major redesign** of existing flow (e.g., checkout process)
- ✅ **Complex workflow** (>5 steps, conditional branching)
- ✅ **High-stakes actions** (financial transactions, legal docs, data deletion)
- ✅ **Target user = non-technical** (elderly, low digital literacy)

### CAN SKIP (with conditions)
- ⚠️ **Minor UI polish** (button color, icon style) → Use A/B testing instead
- ⚠️ **Industry-standard patterns** (login form, pagination) → Stick to conventions
- ⚠️ **Internal tool** with <10 power users → Informal feedback loops are sufficient
- ⚠️ **MVP ultra-early stage** → 3-5 informal user interviews (not a full usability test)

---

## 2. Recruiting Participants: Budget & Quality Trade-offs

### Option 1: Professional Panel (UserTesting.com, Respondent.io)
**Pros**: Fast (recruitment within 24 hours), diverse demographics, built-in video recording  
**Cons**: Expensive ($49-200/participant), "professional testers" are sometimes not genuine  
**Best For**: B2C with a broad target, tight timeline

### Option 2: Network Recruitment (LinkedIn, Twitter, Industry Communities)
**Pros**: High-quality participants (real users), lower cost (Rp 150-300k incentive)  
**Cons**: Slow (1-2 weeks), bias toward early adopters  
**Best For**: B2B SaaS, niche industry tools

### Option 3: Existing User Base
**Pros**: Most authentic feedback, zero recruitment cost  
**Cons**: Bias towards satisfied users (churned users won't participate)  
**Best For**: Iteration testing post-launch

### Option 4: Friends & Family (LAST RESORT)
**Pros**: Free, fast  
**Cons**: Confirmation bias, does not represent real users, tends to be "too nice"  
**Only Valid If**: User persona = "general public" (e.g., consumer social app)

---

## 3. The Nielsen Norman 5-User Rule: When It Works & When It Fails

**The Claim**: 5 users uncover 85% of usability problems (Nielsen, 1993).

**When It Works**:
- ✅ Single user persona (homogenous group)
- ✅ Task-based testing (5-10 specific scenarios)
- ✅ Mature design (2nd or 3rd iteration)

**When You Need More**:
- ❌ **Multiple personas** (admin vs end-user) → 5 per persona = 10 total
- ❌ **Quantitative validation** (e.g., "70% of users can complete the task") → Minimum 30 users
- ❌ **A/B test hypothesis** → See statistical power calculation (typical: 200-500 per variant)

**Practical Guideline**:
- **Iteration 1**: 5 users (discovery blockers)
- **Iteration 2**: 5 users (validate fixes)
- **Pre-launch validation**: 8-10 users (confidence boost)

---

## 4. Think-Aloud Protocol: Dos & Don'ts

### ✅ DO
- **Explain upfront**: "Say whatever you are thinking, as if I'm not in the room."
- **Use neutral prompts**:
  - "What are you looking for right now?"
  - "Describe what you see on this screen."
  - "What do you expect to happen after clicking this button?"
- **Observe silence**: Let the user get stuck for 30-60 seconds before intervening (that's the data!)
- **Record verbatim quotes**: Note down exact quoted words for the report ("Where is the save button?")

### ❌ DON'T
- **No leading questions**: "Is this button clear enough?" → Biases towards "Yes"
- **Don't teach the UI**: "Try clicking the left menu" → You corrupt test validity
- **Don't be defensive**: User says "this is confusing" → DO NOT reply "but there is a tooltip right there"
- **Don't interrupt**: User is thinking hard → don't immediately prompt "why are you silent?"

### Red Flags (Signs of Bad Moderator)
- User asks "is this right?" and moderator answers "yes, continue" (should be: "there is no right or wrong, just proceed as you normally would")
- Moderator explains features before user explores them independently
- User completes all tasks with 100% success rate (likely guided)

---

## 5. SUS Score Interpretation: Beyond the Number

### SUS Score Ranges (Industry Consensus)
- **<50**: Unusable (broken navigation, critical bugs)
- **50-60**: Poor (D grade) — Major usability debt
- **60-69**: Marginal (D+ grade) — Needs significant work
- **70-79**: Acceptable (C grade) — **MINIMUM M04 GATE**
- **80-89**: Good (B grade) — Competitive product
- **≥90**: Excellent (A grade) — Top 10% products (Gmail, Google Search level)

### Common Misinterpretations

❌ **WRONG**: "SUS 75 means 75% users are satisfied"  
✅ **RIGHT**: SUS is **percentile rank**, not percentage. SUS 75 = 60th percentile (beats 60% of products).

❌ **WRONG**: "Target SUS 100 for our MVP"  
✅ **RIGHT**: SUS 100 is virtually impossible (even Apple.com ~85-90). Target 70-80 for MVP.

❌ **WRONG**: "SUS 68 vs 72 → B is winner"  
✅ **RIGHT**: Difference <5 points = margin of error. Need A/B test with n≥30 per group for confidence.

### What SUS DOESN'T Tell You
- **Which specific features** are broken (need qualitative data)
- **Why** users struggle (need think-aloud observation)
- **Business impact** (low SUS doesn't always = low revenue; e.g., enterprise tools with lock-in)

**Actionable Framework**: Pair SUS with **Task Completion Rate**:
| SUS | Task Success | Interpretation | Action |
| :--- | :--- | :--- | :--- |
| <70 | <70% | Critical issues | Full redesign cycle |
| <70 | >80% | Users succeed but frustrated | Polish flow, improve feedback |
| >80 | <70% | Good UX, wrong features | Re-validate product-market fit |
| >80 | >80% | Ship it | Monitor post-launch metrics |

---

## 6. Accessibility Testing: WCAG Compliance Shortcuts for Solo Devs

**Reality Check**: Full WCAG audit = 40+ hours. Solo devs need triage.

### Tier 1: Automated Scanners (30 minutes, catch 30-40% issues)
- **Chrome Lighthouse** (Accessibility tab): Target score ≥90
- **axe DevTools** browser extension: Zero critical/serious issues
- **WAVE** (WebAIM): Visual overlay for contrast + structure problems

**Typical Catches**: Missing alt text, low contrast, missing form labels, broken heading hierarchy.

### Tier 2: Keyboard Navigation (60 minutes, critical)
Manual test:
1. Unplug mouse. Navigate entire app with **Tab/Shift+Tab/Enter/Esc/Arrow keys**
2. Checklist:
   - [ ] Can reach every interactive element (buttons, links, form inputs)
   - [ ] Focus indicator visible (outline 2px minimum)
   - [ ] Modals/dropdowns can be closed with Esc
   - [ ] No keyboard traps (can Tab out of every component)

**Common Failure**: `<div onclick>` without `tabindex="0"` + `role="button"` (unreachable via keyboard).

### Tier 3: Screen Reader Spot Check (90 minutes, high-impact)
Test **3 critical paths** with a screen reader:
- **Windows**: NVDA (free) or JAWS (paid)
- **Mac**: VoiceOver (built-in, Cmd+F5)
- **Mobile**: TalkBack (Android) / VoiceOver (iOS)

**Minimal Test Scenarios**:
1. Login flow (input labels announced correctly?)
2. Form submission (are validation errors read aloud?)
3. Navigation (landmark roles: `<nav>`, `<main>`, `<aside>` detected?)

**Common Failure**: Error messages displayed visually (`color: red`) but not programmatically linked (`aria-describedby`).

### Tier 4: Professional Audit (Only If Legally Required)
B2G (government contracts), large enterprise clients, or publicly-traded companies → hire WCAG auditor ($3k-10k).

---

## 7. Remote vs In-Person Testing: Trade-offs

| Aspect | Remote (Unmoderated) | Remote (Moderated) | In-Person |
| :--- | :--- | :--- | :--- |
| **Cost** | Lowest (tools $0-50/mo) | Medium ($49/video) | Highest (venue, travel) |
| **Time** | Fastest (async, 24-48hr) | Medium (scheduling) | Slowest (1-2 weeks setup) |
| **Sample Size** | Large (50+ easy) | Small (5-10 realistic) | Very Small (3-5 typical) |
| **Data Depth** | Shallow (task metrics only) | Deep (think-aloud, probing) | Deepest (body language, emotion) |
| **Best For** | Quantitative validation, A/B test | Standard usability testing | Medical/financial (sensitive data), elderly users |

**Solo Dev Recommendation**: **Remote Moderated** via Zoom (sweet spot: cost-effective + qualitative depth).

---

## 8. Anti-Patterns: What Kills User Testing ROI

### ❌ Testing Too Late (After Code Complete)
**Symptom**: "We built everything, now let's validate with users."  
**Problem**: Design flaws become expensive to fix (backend + frontend rework).  
**Fix**: Test clickable prototype (Figma / interactive prototype) BEFORE Module 05.

### ❌ Confirmation Bias Testing
**Symptom**: "Users love the new dashboard!" (selective memory from positive feedback).  
**Problem**: Ignore pain points, ship broken UX.  
**Fix**: Document EVERY negative observation. Count failure rate, not just success stories.

### ❌ No Actionable Prioritization
**Symptom**: Report contains 47 bullet points of "users struggle with X" without ranking.  
**Problem**: Designer/developer overwhelmed, nothing gets fixed.  
**Fix**: Triage **P0 (blockers: <70% task success) → P1 (friction: <85%) → P2 (polish)**.

### ❌ Testing Without Real Tasks
**Symptom**: "Just browse around and give feedback."  
**Problem**: Users give generic opinions ("looks nice"), not behavioral insights.  
**Fix**: Specific scenarios: "Imagine you need X, try doing Y."

### ❌ Single Iteration Testing
**Symptom**: "We tested once, SUS 65, we'll fix it later."  
**Problem**: Never gets fixed, ships broken.  
**Fix**: MINIMUM 2 iterations (test → fix → re-test) before M05 gate.

---

## 9. Case Study: Iterative Testing Done Right

**Project**: B2B HR SaaS — Employee Onboarding Module  
**Timeline**: 3 weeks testing (2 iterations), before development started

### Iteration 1 (Week 1)
- **Participants**: 5 HR managers (companies with 100-300 employees)
- **Key Findings**:
  - Task 1 "Add new employee": 2/5 failed (couldn't find "Add Employee" button, buried in submenu)
  - Task 2 "Bulk upload via Excel": 5/5 complained "no template link visible"
  - SUS Score: **62** (Poor)
- **Changes Made**:
  - Moved "Add Employee" to primary CTA (top-right, green button)
  - Added "Download Template" link above upload area
  - Simplified 3-step wizard to 1 long form (users preferred scrolling over pagination)

### Iteration 2 (Week 3)
- **Participants**: 5 NEW HR managers (different from Iteration 1, prevent learning effect)
- **Key Findings**:
  - Task 1: 5/5 success (<2 minutes)
  - Task 2: 4/5 success (1 user confused by Excel column names, minor documentation issue)
  - SUS Score: **78** (Acceptable)
- **Decision**: Proceed to M05 (hit 70 threshold)

**ROI**: Pre-launch testing prevented 2 support-heavy issues:
- Estimated saved support tickets: 200+/month (20% of expected volume)
- Estimated engineering rework avoided: 40 hours (post-launch fix = 3x cost)

---

## 10. Quick Reference: Testing Budget Guide

| Project Scale | Participants | Tools | Total Cost (USD) | Time Investment |
| :--- | ---: | :--- | ---: | :--- |
| **MVP/Freelance** | 5 (2 iterations) | Maze Free + Google Forms | $0 | 20 hours |
| **Startup/SMB** | 10 (2 iterations) | UserTesting.com | $500 | 30 hours |
| **Scale-up** | 15 (3 iterations) | Maze Pro + Hotjar | $150/mo | 40 hours |
| **Enterprise** | 30 + Accessibility Audit | UserTesting + WCAG Auditor | $5,000 | 80 hours |

**Rule of Thumb**: Allocate **10-15% of total design+dev budget** for user research & testing.

---

## 11. Checklist: Ready to Run Your First Test?

- [ ] Test objectives defined (3-5 specific hypotheses)
- [ ] Participants recruited (min 5, screened for target persona)
- [ ] Task scenarios written (intent-based, not UI instructions)
- [ ] SUS questionnaire prepared (10 questions + scoring sheet)
- [ ] Recording setup tested (screen + audio consent)
- [ ] Moderator trained (read Section 4 Think-Aloud Dos/Don'ts)
- [ ] Observation template ready (Task success, time, errors, quotes)
- [ ] Incentives purchased (e-vouchers ready to send post-test)
- [ ] Follow-up iteration plan drafted (what threshold triggers redesign?)

---

## 12. Further Reading (External Resources)

- **Nielsen Norman Group**: [Usability Testing 101](https://www.nngroup.com/articles/usability-testing-101/) — Gold standard methodology
- **Jeff Sauro**: [Measuring Usability](https://measuringu.com/) — SUS statistics deep dive
- **WebAIM**: [Screen Reader User Survey](https://webaim.org/projects/screenreadersurvey9/) — Understand real assistive tech usage
- **GOV.UK Design System**: [Accessibility Guidance](https://design-system.service.gov.uk/accessibility/) — Pragmatic WCAG compliance examples

---

**Last Updated**: 2026-09-27  
**Maintained By**: Solo Project Lifecycle Framework
