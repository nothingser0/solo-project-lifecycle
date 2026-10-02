# Project Retrospective Debrief

> **Purpose**: Solo developer self-reflection after project handover to capture lessons learned, improve future project execution, and identify process improvements.

**Project**: [Project Name]  
**Client**: [Client/Company Name]  
**Completion Date**: [YYYY-MM-DD]  
**Retrospective Date**: [YYYY-MM-DD]  
**Duration**: [X weeks/months]  
**Scale**: [Small / Medium / Large / Enterprise]

---

## 1. Project Metrics Summary

### Timeline
- **Planned Duration**: [X weeks]
- **Actual Duration**: [Y weeks]
- **Variance**: [+/- Z weeks] ([reason if >20% variance])

### Budget
- **Contract Value**: Rp [X]
- **Actual Hours**: [Y hours]
- **Effective Rate**: Rp [X/Y per hour]
- **Profitability**: [Good / Acceptable / Low]

### Scope Changes
- **Initial Scope**: [X features/modules]
- **Final Scope**: [Y features/modules]
- **Change Requests**: [N CRs, total +Rp X]
- **Scope Creep**: [None / Minor / Significant]

---

## 2. What Went Well ✅

### Process & Workflow
- [ ] Module flow (00-13) worked smoothly
- [ ] Gates prevented scope creep effectively
- [ ] Templates saved time (which ones?)
- [ ] Client communication clear
- [ ] Technical decisions validated

**Specific Wins**:
1. [Example: "Single PIC enforcement prevented conflicting requirements"]
2. [Example: "Tech stack discovery questionnaire caught budget/scale mismatch early"]
3. [Example: "UAT deemed acceptance clause prevented 2-week delay"]

### Technical Execution
- [ ] Tech stack choice correct for requirements
- [ ] Architecture scaled as expected
- [ ] No major rewrites needed
- [ ] Performance met NFRs
- [ ] Security audit passed

**Best Technical Decisions**:
1. [Example: "PostgreSQL RLS eliminated 200 lines of auth code"]
2. [Example: "Supabase auth saved 1 week vs custom implementation"]

### Client Relationship
- [ ] Client responsive and collaborative
- [ ] Requirements stable (few changes)
- [ ] Payment on time
- [ ] Positive feedback received
- [ ] Referral potential high

---

## 3. What Went Wrong ❌

### Process Issues
- [ ] Module X was unclear/incomplete
- [ ] Template Y didn't fit project type
- [ ] Gate enforcement too strict/too loose
- [ ] Communication breakdown at phase Z
- [ ] Timeline estimation off

**Specific Problems**:
1. [Example: "Module 08 data migration underestimated by 3 days - client data quality poor"]
2. [Example: "No intake checklist led to accepting client with unrealistic timeline"]

### Technical Issues
- [ ] Tech stack mismatch (should have chosen X instead of Y)
- [ ] Architecture bottleneck (where?)
- [ ] Third-party API issues
- [ ] Performance problems
- [ ] Security gap discovered late

**Technical Debt Accrued**:
1. [Example: "Skipped database indexing - will cause slowdown at 10K users"]
2. [Example: "No API versioning - future breaking changes difficult"]

### Client Issues
- [ ] Slow decision making
- [ ] Unclear requirements
- [ ] Late payments
- [ ] Scope creep attempts
- [ ] Multiple decision makers

**Red Flags Missed**:
- [Example: "Client had 'budget TBD' at intake - should have deferred"]

---

## 4. Lessons Learned 📚

### Process Improvements
| What Happened | Root Cause | Prevention Next Time |
|---------------|------------|---------------------|
| Example: UAT delayed 2 weeks | Client didn't allocate testing time | Add UAT calendar block requirement at M03 SOW |
| Example: 5 CRs in 2 weeks | Vague M02 scope definition | Use MoSCoW stricter, add visual mockup sign-off |

### Template Updates Needed
- [ ] Add section X to template Y
- [ ] Remove redundant section Z from template W
- [ ] Create new template for: [recurring gap]

**Specific Changes**:
1. [Example: "Add 'data quality assessment' to M08 migration plan template"]
2. [Example: "Add 'third-party API SLA verification' to M05 FSD checklist"]

### Module Improvements
- [ ] Module X needs: [specific addition]
- [ ] Module Y: skip condition unclear for [scenario]
- [ ] Module Z: timing in pipeline should shift [earlier/later]

### Personal Skill Gaps
- [ ] Technology: [Need to learn X for next project]
- [ ] Domain: [Lacked knowledge of Y industry]
- [ ] Soft skill: [Client negotiation, time estimation, etc.]

---

## 5. Client Feedback (Direct Quotes)

**Positive**:
> "[Paste actual client feedback]"

**Constructive**:
> "[Paste actual client feedback]"

**NPS Score**: [0-10, if collected]

---

## 6. Would I Take This Project Again? 🤔

**Decision**: [ ] Definitely Yes [ ] Yes with conditions [ ] No

**Reasoning**:
[Honest assessment: profitability, stress level, learning value, portfolio value]

**If "No", What Would Need to Change?**:
- Higher budget (minimum Rp X)
- Different client industry
- Different tech stack
- Clearer scope upfront

---

## 7. Action Items for Next Project

### Immediate (Before Next Project)
- [ ] Update [template/module] based on lesson X
- [ ] Add [checklist item] to M01 feasibility
- [ ] Learn [technology/skill]
- [ ] Adjust rate card (if profitability low)

### Process Refinements
- [ ] Enforce stricter intake qualification (see lessons)
- [ ] Add buffer to M08 data migration estimates (+30%)
- [ ] Require design freeze sign-off (prevent late changes)
- [ ] Add [new gate/checkpoint] at Module X

### Client Selection Criteria Updates
- [ ] Add red flag: [specific indicator]
- [ ] Increase minimum budget for [project type]
- [ ] Require [prerequisite] before M00 discovery

---

## 8. Portfolio & Case Study Potential

**Use for Portfolio?** [ ] Yes [ ] No (NDA) [ ] Yes (anonymized)

**Key Highlights for Case Study**:
- Problem solved: [business value delivered]
- Technical challenge: [how you solved it]
- Metrics: [% improvement, time saved, revenue impact]

**Screenshots/Artifacts to Collect**:
- [ ] Before/after metrics
- [ ] Architecture diagram
- [ ] Client testimonial
- [ ] UI screenshots (if allowed)

---

## 9. Financial Analysis

### Revenue
- Contract value: Rp [X]
- Change requests: Rp [Y]
- **Total revenue**: Rp [X+Y]

### Costs
- Software/services: Rp [A]
- Subcontractors: Rp [B]
- **Total costs**: Rp [A+B]

### Net Profit
- **Net**: Rp [Total revenue - Total costs]
- **Margin**: [Net / Revenue × 100]%

### Time Investment
- Billable hours: [X hours]
- Non-billable (admin, rework): [Y hours]
- **Effective rate**: Rp [Net / (X+Y) per hour]

**Profitability Assessment**:
- [ ] Excellent (>70% margin, >Rp 1.5M/hour)
- [ ] Good (50-70% margin, Rp 1-1.5M/hour)
- [ ] Acceptable (30-50% margin, Rp 800K-1M/hour)
- [ ] Poor (<30% margin, <Rp 800K/hour)

**If Poor, Root Causes**:
- [ ] Underestimated timeline
- [ ] Too many unpaid revisions
- [ ] Scope creep without CR charges
- [ ] Rate too low for market
- [ ] Inefficient tech stack choice

---

## 10. Skill & Knowledge Growth

**New Skills Acquired**:
1. [Example: "First time implementing OAuth 2.0 + PKCE flow"]
2. [Example: "Learned Next.js 15 Server Actions"]

**Domain Knowledge Gained**:
- [Example: "Fintech compliance: UU PDP data masking requirements"]
- [Example: "Legal tech: e-signature PSrE regulations"]

**Portfolio Value**:
- [ ] High (unique project type, impressive tech, great results)
- [ ] Medium (solid execution, common project type)
- [ ] Low (routine work, NDA prevents showcase)

---

## 11. Referral & Relationship Outcome

**Client Satisfaction**: [1-5 stars] ⭐⭐⭐⭐⭐

**Referral Received?** [ ] Yes [ ] No

**Relationship Status**:
- [ ] Ended (one-off project, no ongoing)
- [ ] Retainer signed (monthly maintenance)
- [ ] Warm lead (future projects likely)
- [ ] Cold (completed, no future plans)

**LinkedIn Recommendation Requested?** [ ] Yes [ ] No

---

## 12. Process Scorecard (Self-Assessment)

Rate your execution of each module (1-5):

| Module | Score | Notes |
|--------|-------|-------|
| M00 Discovery | [1-5] | [What went well/wrong] |
| M01 Feasibility | [1-5] | [What went well/wrong] |
| M02 Scope | [1-5] | [What went well/wrong] |
| M03 Legal SOW | [1-5] | [What went well/wrong] |
| M04 Design | [1-5] | [What went well/wrong] |
| M05 Architecture | [1-5] | [What went well/wrong] |
| M06 Development | [1-5] | [What went well/wrong] |
| M07 QA | [1-5] | [What went well/wrong] |
| M08 Data Migration | [1-5] | [What went well/wrong] |
| M09 UAT | [1-5] | [What went well/wrong] |
| M10 Deployment | [1-5] | [What went well/wrong] |
| M11 Handover | [1-5] | [What went well/wrong] |
| M12 Warranty | [1-5] | [What went well/wrong] |

**Average Score**: [Sum / 13] → Target: ≥4.0

**Lowest Scoring Modules** (need improvement):
1. [Module X: score Y - specific issue]

---

## 13. Future Framework Updates

**Submit to Framework Maintainer** (if using solo-project-lifecycle skill):

- [ ] Bug report: [Module X step Y unclear]
- [ ] Enhancement: [Add Z to template W]
- [ ] New template: [For recurring gap]
- [ ] Module sequence: [M-X should come before M-Y]

**Framework Version Used**: [1.0, 1.1, etc.]

---

## 14. Personal Reflection

### Stress Level During Project
- [ ] Low (smooth, enjoyable)
- [ ] Medium (normal challenges)
- [ ] High (frequent issues, demanding client)
- [ ] Burnout risk (unsustainable, need boundaries)

### Work-Life Balance
- [ ] Maintained boundaries
- [ ] Minor encroachment (few late nights)
- [ ] Significant encroachment (weekends worked)
- [ ] Unsustainable (need to adjust pricing/scope)

### Would I Recommend This Client to Peer Devs?
- [ ] Absolutely (great to work with)
- [ ] Yes with caveats (list them)
- [ ] No (explain why)

---

## 15. Commitments for Next Project

Based on this retrospective, I commit to:

1. [Example: "Use client intake checklist - no exceptions"]
2. [Example: "Add 20% buffer to all timeline estimates"]
3. [Example: "Enforce design freeze - no UI changes after M04"]
4. [Example: "Decline projects with budget <Rp 30 million for Medium scale"]
5. [Example: "Learn Tailwind CSS advanced patterns before next frontend project"]

**Review Date**: [Schedule quarterly review of all retrospectives to identify patterns]

---

**Retrospective Completed By**: [Your Name]  
**Date**: [YYYY-MM-DD]  
**Next Review**: [Date to review this retrospective + action items]

---

## Appendix: Retrospective Schedule

**When to Conduct**:
- **Timing**: 1-2 weeks after M11 BAST sign-off (while details fresh, but emotions settled)
- **Duration**: 60-90 minutes (block calendar, no interruptions)
- **Format**: Solo written reflection (this template) + optional voice recording for context

**Quarterly Review**:
- Review all project retrospectives every 3 months
- Identify patterns across projects
- Update framework/templates/intake criteria
- Adjust pricing/positioning based on profitability trends
