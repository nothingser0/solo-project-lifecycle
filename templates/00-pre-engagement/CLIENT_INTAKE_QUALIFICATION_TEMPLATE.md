# Client Intake & Qualification Checklist

> **Purpose**: Filter high-risk clients and unqualified projects BEFORE investing time in Module 00/01 discovery. Protect solo developer bandwidth from tire-kickers, budget mismatches, and red-flag clients.

---

## 1. Initial Contact Screening (5 Minutes)

### Contact Information
- [ ] Client name and role (decision maker or intermediary?)
- [ ] Company/organization name and industry
- [ ] Contact method (email, WhatsApp, LinkedIn)
- [ ] Referral source (existing client, cold outreach, marketplace)

### Project Quick Snapshot
```
Project type: [ ] Web App [ ] Mobile App [ ] Desktop [ ] API [ ] Other: _______
Timeline expectation: [ ] <1 month [ ] 1-3 months [ ] 3-6 months [ ] >6 months
Budget indication: [ ] <Rp 10 million [ ] Rp 10-50 million [ ] Rp 50-100 million [ ] >Rp 100 million
Current status: [ ] Idea [ ] Requirements doc [ ] Design mockup [ ] Existing codebase
```

---

## 2. Red Flag Detection Matrix (STOP/PROCEED Decision)

| Red Flag | Indicator | Risk Level | Action |
|----------|-----------|------------|--------|
| **No budget transparency** | "How much does it cost?" with no scope info | 🔴 Critical | STOP: Require budget range before discovery |
| **Unrealistic timeline** | "Can it be done next week?" for a complex app | 🔴 Critical | STOP: Educate realistic timeline or decline |
| **Multiple decision makers** | "Need to ask boss/team first" at every step | 🟡 High | PROCEED with caution: Enforce Single PIC at M03 |
| **Scope ambiguity** | "I don't know what I want yet, but I need it soon" | 🟡 High | STOP: Require basic requirements doc before M00 |
| **Comparison shopping** | "Another developer quoted Rp X, can you do cheaper?" | 🟡 High | PROCEED: Clarify value-based pricing vs hourly |
| **Payment hesitancy** | "Can we pay after launch?" | 🔴 Critical | STOP: Enforce DP requirement (M03) |
| **Unrealistic feature density** | "Clone Gojek with a Rp 20 million budget" | 🟡 High | PROCEED: Educate MVP scope or decline |
| **Hostile tone** | Aggressive, rude, or demanding at first contact | 🔴 Critical | STOP: Decline politely |
| **Industry compliance unknown** | Fintech/healthtech with zero regulatory awareness | 🟡 High | PROCEED: Flag legal/compliance audit in M01 |

**Decision Rule**:
- **2+ Critical (🔴) flags**: DECLINE project immediately
- **3+ High (🟡) flags**: DECLINE or require pre-paid discovery retainer
- **1-2 High (🟡) flags**: PROCEED with enforced contracts and gates

---

## 3. Budget-Timeline-Scope Triangle Validation

### Quick Qualification Formula
```
Estimated Effort (Person-Days) = [Feature Count × 2] + [Integration Count × 3] + [Compliance × 5]

Solo Dev Rate Benchmark (2026):
- Junior (1-2 years): Rp 500K - 800K/day
- Mid (3-5 years): Rp 800K - 1.5 million/day  
- Senior (5+ years): Rp 1.5 million - 3 million/day

Minimum Project Value = Effort × Rate × 1.3 (risk buffer)
```

**Example**:
- Client budget: Rp 30 million
- Estimated effort: 25 person-days
- Minimum viable: 25 × Rp 1 million × 1.3 = Rp 32.5 million
- **Assessment**: Budget too low → NEGOTIATE scope reduction OR DECLINE

### Timeline Reality Check
| Project Scale | Realistic Timeline | Client Expectation | Action |
|---------------|-------------------|-------------------|--------|
| Small (MVP) | 3-6 weeks | <2 weeks | Educate or decline |
| Medium | 2-4 months | <1 month | Decline |
| Large | 4-8 months | <3 months | Decline |
| Enterprise | 6-12 months | <6 months | Decline or bring partner |

---

## 4. Client Capability Assessment

### Technical Readiness
- [ ] **Domain & Hosting**: Client has domain? Access to hosting/cloud account?
- [ ] **API Keys**: Third-party APIs (payment, email, storage) already registered?
- [ ] **Content/Data**: Legacy data or content ready? (M08 dependency)
- [ ] **Decision Authority**: Single PIC can make technical decisions without escalation?

### Collaboration Readiness
- [ ] **Communication**: Client responsive (reply <24 hours)?
- [ ] **Availability**: Client can attend weekly sync (30 minutes)?
- [ ] **Feedback Cycle**: Client can review deliverables within 3-5 days?
- [ ] **Payment Process**: Client has invoicing/payment system (<7 days transfer)?

**Gate**: Minimum 6/8 checkboxes must be YES. If <6, flag as HIGH-DEPENDENCY CLIENT → increase project buffer 30%.

---

## 5. Intake Conversation Script

### Opening (Qualification)
> *"Thank you for reaching out. Before we dive into details, could you share:*
> 1. *What business problem are you looking to solve with this software?*
> 2. *What budget range has been allocated? (Rp 10-20 million / Rp 50-100 million / no budget yet)*
> 3. *When is the target launch date? Are there any hard business deadlines (event, tender, contract)?*
> 4. *Who will be the primary decision-maker for this project (PIC)?*"

### Budget Mismatch Response
> *"Thank you for the information. Based on the scope you described, estimated effort is around [X] person-days with a minimum budget of Rp [Y]. If the current budget is Rp [Z], I can help reduce scope by prioritizing MVP features. Would you be interested in discussing the MVP scope further, or would you prefer finding a developer with a lower rate?"*

### Unrealistic Timeline Response
> *"A timeline of [X weeks] for a project of this scale is quite tight. Based on experience, an application with [Y features] + [Z integrations] typically requires at least [N months]. I can help with a Fast-Track MVP (core features only) if the deadline cannot move. Alternatively, we can extend the timeline to [realistic timeline]. Which better aligns with your business priorities?"*

### Decline Script (Polite)
> *"Thank you for sharing your project. After reviewing it, I feel this project does not align with my current capacity and specialization [or: timeline/budget expectations are not aligned]. I would be happy to recommend [referral to another developer/agency] if you'd like. Wishing you the best of success with your project!"*

---

## 6. Intake Decision Matrix

| Score | Criteria | Decision |
|-------|----------|----------|
| **PASS (Proceed to M00/M01)** | 0-1 red flags, budget-timeline aligned, client responsive | Schedule M01 Feasibility meeting |
| **CONDITIONAL PASS** | 2-3 yellow flags, budget slightly low | Require pre-paid discovery retainer (Rp 2-5 million) to proceed to M00 |
| **DEFER** | Budget TBD, timeline flexible | Put on waitlist, revisit in 1-2 months |
| **DECLINE** | 2+ red flags, misaligned expectations | Politely decline with referral |

---

## 7. Intake Output Artifacts

After qualification PASS:

1. **`docs/pm/CLIENT_INTAKE_SUMMARY.md`**:
```markdown
## Client Intake Summary

**Client**: [Company Name]  
**PIC**: [Name + Role + Contact]  
**Project**: [Project Name]  
**Intake Date**: [YYYY-MM-DD]

### Qualification Score
- Red Flags: 0 🟢
- Budget Alignment: MATCH ✅
- Timeline Realism: REALISTIC ✅
- Client Readiness: 7/8 ✅

### Next Steps
- [x] Intake qualification PASS
- [ ] Schedule M01 Feasibility meeting (target: [date])
- [ ] Send discovery questionnaire
- [ ] NDA signing (if needed)

### Risk Notes
- Client does not have domain yet (medium risk - add 3 days to timeline)
- PIC still needs CFO approval for DP (track closely at M03)
```

2. **Decision**: PROCEED → M00 (optional) or M01 (mandatory)

---

## 8. Integration with Module 01

**Before Module 01 starts**:
- [ ] Client intake checklist completed
- [ ] Budget range confirmed (minimum threshold met)
- [ ] Single PIC identified
- [ ] Basic requirements document received (1-2 pages sufficient)
- [ ] Client aware of milestone payment structure (DP required)

**If intake NOT completed**: STOP - do not proceed to M01 Feasibility without qualifying the client first.

---

## Appendix: Client Qualification Rubric (Scoring)

| Dimension | Score 1 (Poor) | Score 3 (Acceptable) | Score 5 (Excellent) |
|-----------|----------------|---------------------|-------------------|
| **Budget Transparency** | No budget info | Range provided | Exact budget + approved PO |
| **Timeline Realism** | Unrealistic (<50% actual) | Tight but negotiable | Realistic + buffer |
| **Decision Authority** | Multiple approvers | Single PIC + escalation | Single PIC full authority |
| **Communication** | Slow (>3 days) | Normal (1-2 days) | Fast (<24 hours) |
| **Technical Readiness** | No infrastructure | Partial (domain only) | Full (domain, API, data ready) |
| **Scope Clarity** | "Don't know yet" | Basic feature list | Detailed requirements doc |

**Total Score**: ___/30

- **24-30**: IDEAL CLIENT → Proceed immediately
- **18-23**: GOOD CLIENT → Proceed with standard process  
- **12-17**: RISKY CLIENT → Conditional proceed (pre-paid discovery or enforce strict gates)
- **<12**: DECLINE → Not worth the risk

---

**Created**: 2026-10-02  
**Version**: 1.0  
**Owner**: Solo Project Lifecycle Framework
