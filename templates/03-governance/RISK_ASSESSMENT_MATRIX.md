# Risk Assessment Matrix Template

> **Purpose**: Score and prioritize project risks systematically  
> **When**: M02 Discovery (project kickoff) + ongoing updates  
> **Target**: Enterprise projects requiring formal risk management

---

## Risk Assessment Framework

### Risk = Probability × Impact

**Formula**: Risk Score = Probability (1-5) × Impact (1-5)

**Score Range**: 1-25

**Priority**:
- **25-20**: Critical (immediate action)
- **19-12**: High (action within 1 week)
- **11-6**: Medium (monitor closely)
- **5-1**: Low (accept or monitor)

---

## Risk Matrix

| Impact → | **1 Minimal** | **2 Minor** | **3 Moderate** | **4 Major** | **5 Critical** |
|:---------|:--------------|:------------|:---------------|:------------|:---------------|
| **5 Very Likely** | 5 🟡 | 10 🟡 | 15 🟠 | 20 🔴 | 25 🔴 |
| **4 Likely** | 4 🟡 | 8 🟡 | 12 🟠 | 16 🔴 | 20 🔴 |
| **3 Possible** | 3 🟢 | 6 🟡 | 9 🟡 | 12 🟠 | 15 🟠 |
| **2 Unlikely** | 2 🟢 | 4 🟢 | 6 🟡 | 8 🟡 | 10 🟡 |
| **1 Rare** | 1 🟢 | 2 🟢 | 3 🟢 | 4 🟢 | 5 🟡 |

**Legend**:
- 🔴 Critical/High (20-25): Immediate action required
- 🟠 Medium-High (12-19): Action within 1 week
- 🟡 Medium (6-11): Monitor closely
- 🟢 Low (1-5): Accept or monitor

---

## Probability Scale (1-5)

| Score | Label | Definition | Likelihood |
|:------|:------|:-----------|:-----------|
| **5** | Very Likely | Expected to occur | >70% |
| **4** | Likely | Probably will occur | 50-70% |
| **3** | Possible | May occur | 30-50% |
| **2** | Unlikely | Probably won't occur | 10-30% |
| **1** | Rare | Very unlikely to occur | <10% |

---

## Impact Scale (1-5)

| Score | Label | Timeline Impact | Budget Impact | Quality Impact |
|:------|:------|:----------------|:--------------|:---------------|
| **5** | Critical | >4 weeks delay | >25% overrun | System unusable |
| **4** | Major | 2-4 weeks delay | 15-25% overrun | Major features broken |
| **3** | Moderate | 1-2 weeks delay | 10-15% overrun | Minor features broken |
| **2** | Minor | <1 week delay | <10% overrun | Cosmetic issues |
| **1** | Minimal | No delay | No overrun | No user impact |

---

## Risk Register Template

### Risk ID: R-001

**Risk Name**: Database Migration Failure

**Category**: Technical

**Description**: 
Migration from MySQL to PostgreSQL may fail, causing data loss or corruption.

---

**Probability**: 3 (Possible)  
**Impact**: 5 (Critical)  
**Risk Score**: 15 🟠 (Medium-High)

**Justification**:
- Probability: Database has 2TB data, complex schema, no prior migration experience
- Impact: Data loss would halt project, require complete rebuild

---

**Triggers** (Warning Signs):
- Test migrations fail repeatedly
- Data validation errors during testing
- Schema incompatibilities discovered

---

**Mitigation Strategy**:
- Hire database migration expert ($10k)
- Test migration on staging (3 times before production)
- Create detailed rollback plan
- Schedule migration during low-traffic window
- Keep MySQL running for 7 days (parallel systems)

**Cost**: $10k (expert) + $2k (extra infrastructure)

---

**Contingency Plan** (If Risk Occurs):
1. Immediately rollback to MySQL (5 minutes)
2. Analyze failure cause
3. Fix issues
4. Re-test migration
5. Re-schedule migration

**Rollback Time**: 5 minutes

---

**Owner**: Tech Lead (John Smith)

**Status**: 🟠 Open  
**Last Updated**: 2024-10-04  
**Review Date**: 2024-10-11

---

## Example Risks by Category

### Technical Risks

**R-001: Technology Stack Unfamiliar**
- Probability: 4 (Likely) - Team hasn't used React Native before
- Impact: 3 (Moderate) - May slow development
- Score: 12 🟠
- Mitigation: Training course ($2k), hire React Native consultant

**R-002: Third-Party API Downtime**
- Probability: 2 (Unlikely) - Stripe has 99.99% uptime SLA
- Impact: 5 (Critical) - Payment processing broken
- Score: 10 🟡
- Mitigation: Circuit breaker, fallback to backup provider

**R-003: Performance at Scale**
- Probability: 3 (Possible) - Not load tested yet
- Impact: 4 (Major) - Slow system = user churn
- Score: 12 🟠
- Mitigation: Load testing with k6, CDN, caching

---

### Schedule Risks

**R-010: Key Developer Leaves**
- Probability: 2 (Unlikely) - Team is stable
- Impact: 4 (Major) - Lose domain knowledge, 2-4 week delay
- Score: 8 🟡
- Mitigation: Documentation, knowledge sharing, backup resources

**R-011: Scope Creep**
- Probability: 4 (Likely) - Client requests frequent changes
- Impact: 4 (Major) - Timeline slips
- Score: 16 🔴
- Mitigation: Change request process, scope freeze after design

**R-012: Holiday Season Impact**
- Probability: 5 (Very Likely) - Dec holidays are certain
- Impact: 2 (Minor) - Reduced team availability
- Score: 10 🟡
- Mitigation: Plan around holidays, buffer time

---

### Budget Risks

**R-020: Infrastructure Costs Higher Than Expected**
- Probability: 3 (Possible) - AWS cost estimates are rough
- Impact: 3 (Moderate) - 10-15% budget overrun
- Score: 9 🟡
- Mitigation: Use cost calculator, monitor daily, right-size instances

**R-021: Client Delays Payment**
- Probability: 2 (Unlikely) - Client is established company
- Impact: 4 (Major) - Cash flow issues, team morale
- Score: 8 🟡
- Mitigation: Clear payment terms in contract, follow up weekly

---

### External Risks

**R-030: GDPR Regulation Changes**
- Probability: 2 (Unlikely) - Major changes rare
- Impact: 3 (Moderate) - May require rework
- Score: 6 🟡
- Mitigation: Monitor regulatory changes, build compliant from start

**R-031: Competitor Launches Similar Product**
- Probability: 3 (Possible) - Competitive market
- Impact: 3 (Moderate) - Reduced differentiation
- Score: 9 🟡
- Mitigation: Speed to market, unique features

---

## Risk Response Strategies

### 1. Avoid (Eliminate the Risk)
**When**: High impact, controllable risk

**Example**: 
- Risk: Database migration failure
- Avoid: Don't migrate, stay on current database
- Pro: No risk
- Con: Miss benefits of new database

---

### 2. Mitigate (Reduce Probability or Impact)
**When**: Most common strategy

**Example**:
- Risk: Third-party API downtime
- Mitigate: Implement circuit breaker, retry logic, fallback
- Result: Reduces impact from Critical to Minor

---

### 3. Transfer (Shift Risk to Third Party)
**When**: Risk can be insured or outsourced

**Example**:
- Risk: Security breach
- Transfer: Buy cyber insurance ($10k/year)
- Result: Financial impact transferred to insurer

---

### 4. Accept (Do Nothing)
**When**: Low risk score (<6) or cost of mitigation > cost of risk

**Example**:
- Risk: Office power outage
- Accept: Rare (1) × Minor (2) = Score 2
- Justification: Cloud infrastructure unaffected, team can work from home

---

## Risk Monitoring

### Weekly Risk Review

**Attendees**: PM + Tech Lead

**Agenda**:
1. Review top 5 risks (score ≥12)
2. Update probability/impact (any changes?)
3. Check mitigation progress
4. Identify new risks

**Duration**: 15 minutes

---

### Monthly Risk Report

**To**: Project Sponsor, Steering Committee

**Contents**:
- Top 5 risks (score ≥12)
- Risks realized this month (what happened)
- New risks identified
- Risks closed (no longer a concern)

---

### Risk Escalation

**Trigger**: Risk score ≥20 (Critical)

**Action**:
1. Immediate notification to Project Sponsor
2. Emergency meeting within 24 hours
3. Develop action plan
4. Daily updates until resolved

---

## Risk Register (Table Format)

| ID | Risk | Prob | Impact | Score | Status | Owner | Mitigation |
|:---|:-----|:-----|:-------|:------|:-------|:------|:-----------|
| R-001 | Database migration failure | 3 | 5 | 15 🟠 | Open | John | Hire expert, test 3x |
| R-002 | API downtime | 2 | 5 | 10 🟡 | Open | Sarah | Circuit breaker |
| R-003 | Performance issues | 3 | 4 | 12 🟠 | Open | Mike | Load testing |
| R-011 | Scope creep | 4 | 4 | 16 🔴 | Open | PM | Change control |
| R-012 | Holiday delays | 5 | 2 | 10 🟡 | Accept | PM | Buffer time |

---

## Risk Trend Analysis

**Track Over Time**:
- Total risk score (sum of all risks)
- Number of high risks (score ≥12)
- Number of risks realized

**Example**:
```
Month 1: 15 risks, total score 180, 5 high risks
Month 2: 12 risks, total score 145, 3 high risks ✅ Improving
Month 3: 10 risks, total score 120, 2 high risks ✅ Improving
```

**Goal**: Total risk score decreases as project progresses

---

## Realized Risk Log

**When Risk Occurs**:
1. Document what happened
2. Compare to predicted impact
3. Evaluate effectiveness of mitigation
4. Lessons learned

**Example**:
```
Risk R-002: API Downtime (Realized)
Date: 2024-10-15
Duration: 30 minutes
Actual Impact: Minor (Score 2, predicted 5)
Mitigation Worked: Yes (circuit breaker prevented user-facing errors)
Lesson: Circuit breaker strategy effective
```

---

## Checklist

**Project Kickoff**:
- [ ] Identify all potential risks (brainstorming session)
- [ ] Score each risk (probability × impact)
- [ ] Prioritize top 10 risks
- [ ] Assign owner to each risk
- [ ] Develop mitigation plans for high risks (score ≥12)

**Weekly**:
- [ ] Review top 5 risks
- [ ] Update scores if circumstances change
- [ ] Check mitigation progress
- [ ] Identify new risks

**Monthly**:
- [ ] Generate risk report
- [ ] Present to stakeholders
- [ ] Close resolved risks
- [ ] Escalate critical risks (score ≥20)

---

## Notes

**Risk management is proactive**: Identify and mitigate BEFORE problems occur

**Re-assess regularly**: Risk scores change as project progresses

**Focus on top risks**: Can't mitigate everything, prioritize high scores

**Document realized risks**: Learn from what actually happened
