# Risk Register: [Product Name]

**Project**: [Project Name]  
**Owner**: [PIC Name]  
**Last Updated**: YYYY-MM-DD  
**Review Cadence**: Weekly (top risks), Monthly (full register)

---

## 1. Risk Summary Dashboard

| Risk Category | Total Risks | High Priority (7-9) | Medium (4-6) | Low (1-3) |
| :--- | ---: | ---: | ---: | ---: |
| Technical | 8 | 2 | 4 | 2 |
| Resource | 5 | 1 | 2 | 2 |
| Market | 4 | 0 | 2 | 2 |
| Legal/Compliance | 3 | 1 | 1 | 1 |
| Financial | 4 | 0 | 2 | 2 |
| **TOTAL** | **24** | **4** | **11** | **9** |

**Critical Risks (Score ≥7)**: 4 risks requiring immediate mitigation  
**Monitoring Active**: 11 risks under active watch  
**Accepted Risks**: 9 risks accepted with periodic review

---

## 2. Risk Assessment Matrix

| Likelihood ↓ / Impact → | **Low (1)** | **Medium (2)** | **High (3)** |
| :--- | :---: | :---: | :---: |
| **High (3)** | 3 (Monitor) | 6 (Mitigate) | **9 (Urgent)** |
| **Medium (2)** | 2 (Accept) | 4 (Monitor) | 6 (Mitigate) |
| **Low (1)** | 1 (Accept) | 2 (Accept) | 3 (Monitor) |

**Action Thresholds**:
- **Score 7–9**: Mandatory mitigation plan BEFORE development starts
- **Score 4–6**: Active monitoring, contingency plan prepared
- **Score 1–3**: Accept risk, quarterly review only

---

## 3. Top Priority Risks (Score ≥7)

### Risk ID: R-TECH-001
**Risk**: Main payment gateway (Midtrans) API downtime during public launch

**Category**: Technical  
**Owner**: Developer  
**Identified Date**: 2026-01-10  
**Status**: Mitigation In Progress

**Likelihood**: Medium (2/3) — API uptime historically 99.5%, but outages unpredictable  
**Impact**: High (3/3) — Cannot process payments, revenue loss, user trust damaged  
**Risk Score**: 2 × 3 = **6** (Mitigate)

**Mitigation Strategy**:
1. Integrate backup payment gateway (Xendit) by week 6
2. Implement automatic failover logic (retry Xendit if Midtrans times out after 5s)
3. Test failover with staging environment (simulate Midtrans downtime)
4. Add status page indicator: "Payments temporarily unavailable, retrying..."

**Contingency Plan** (if mitigation fails):
- Manual payment: Display bank transfer instructions, verify via admin panel
- Communicate outage to users via email + banner notification
- Post-incident: Refund any duplicate charges

**Success Criteria** (mitigation complete when):
- [ ] Xendit integration deployed to production
- [ ] Failover tested with 10 mock transactions
- [ ] Downtime < 5 minutes during simulated outage

**Review Date**: 2026-03-15 (2 weeks before launch)  
**Last Reviewed**: 2026-02-10  
**Next Review**: 2026-02-24

---

### Risk ID: R-RES-001
**Risk**: Solo developer burnout or illness during critical sprint

**Category**: Resource  
**Owner**: Founder/Solo Dev  
**Identified Date**: 2026-01-05  
**Status**: Mitigation Active

**Likelihood**: Medium (2/3) — High workload, no backup developer  
**Impact**: High (3/3) — Project delayed, missed deadlines, quality drops  
**Risk Score**: 2 × 3 = **6** (Mitigate)

**Mitigation Strategy**:
1. Enforce max 50 hours/week work limit (no crunch mode)
2. Take 1 full day off per week (no coding on Sundays)
3. Build 10% buffer into all estimates (account for sick days)
4. Document code thoroughly (enable faster onboarding if need to hire)
5. Identify 2 freelance developers for emergency backup (pre-vetted, can start within 48h)

**Contingency Plan**:
- If sick > 3 days: Notify stakeholders immediately, extend timeline by 1 week
- If burnout detected (2 consecutive weeks of low productivity): Take 1-week break, re-scope project

**Success Criteria**:
- [ ] Zero weeks exceeding 50 hours logged
- [ ] All critical code has inline documentation
- [ ] 2 freelancers identified (names, rates, availability confirmed)

**Review Date**: Weekly (self-check energy levels)  
**Last Reviewed**: 2026-02-10  
**Next Review**: 2026-02-17

---

### Risk ID: R-LEGAL-001
**Risk**: Non-compliance with UU PDP (Indonesia Personal Data Protection Law)

**Category**: Legal/Compliance  
**Owner**: Founder + Legal Consultant  
**Identified Date**: 2026-01-08  
**Status**: Mitigation Planned

**Likelihood**: Low (1/3) — Will implement standard best practices  
**Impact**: High (3/3) — Legal penalties up to IDR 6B, reputational damage, forced shutdown  
**Risk Score**: 1 × 3 = **3** (Monitor)

**Note**: Despite low score, flagged as critical due to severity of impact (legal/financial ruin)

**Mitigation Strategy**:
1. Conduct UU PDP compliance audit (hire consultant for 1-day review, budget: IDR 5M)
2. Implement required practices:
   - User consent for data collection (opt-in checkbox at signup)
   - Data retention policy (auto-delete inactive accounts after 2 years)
   - Encryption at rest (PostgreSQL + S3 server-side encryption)
   - Privacy policy page (clear, accessible language)
3. Add "Delete My Account" feature (user can self-delete all data)
4. Log all data access for audit trail

**Contingency Plan**:
- If audit finds violations: Pause launch until fixed (max 2-week delay acceptable)
- If post-launch violation discovered: Immediate fix + notify affected users

**Success Criteria**:
- [ ] Legal consultant signs off on compliance
- [ ] Privacy policy published and linked in footer
- [ ] "Delete My Account" feature tested
- [ ] Encryption verified (staging + production)

**Review Date**: 2026-02-28 (before public launch)  
**Last Reviewed**: 2026-01-08  
**Next Review**: 2026-02-15

---

### Risk ID: R-TECH-002
**Risk**: Google Vision API quota exceeded (OCR processing)

**Category**: Technical  
**Owner**: Developer  
**Identified Date**: 2026-01-12  
**Status**: Mitigation Complete ✅

**Likelihood**: Medium (2/3) — Free tier only 1000 requests/month  
**Impact**: High (3/3) — Core feature breaks, users cannot process documents  
**Risk Score**: 2 × 3 = **6** (Mitigate)

**Mitigation Strategy** (COMPLETED):
1. ✅ Implement fallback to Tesseract.js (open-source OCR, unlimited)
2. ✅ Add usage monitoring (alert when 80% quota reached)
3. ✅ Upgrade to paid tier if demand exceeds 800 requests/month (budget approved: $100/month)

**Contingency Plan**:
- If both APIs fail: Queue documents, process manually, refund user

**Success Criteria** (ALL MET):
- [x] Tesseract.js integration tested with 10 sample documents
- [x] Monitoring dashboard shows quota usage in real-time
- [x] Paid tier billing details configured

**Review Date**: Monthly (monitor usage trends)  
**Last Reviewed**: 2026-02-10 (quota at 45%, no issues)  
**Next Review**: 2026-03-10

---

## 4. Medium Priority Risks (Score 4–6)

| Risk ID | Description | Category | L×I | Score | Status | Owner | Review Date |
| :--- | :--- | :--- | :--- | ---: | :--- | :--- | :--- |
| R-TECH-003 | Database scaling issues (>10k users) | Technical | 2×2 | 4 | Monitor | Dev | 2026-06-01 |
| R-TECH-004 | AWS S3 storage cost overrun | Technical | 2×2 | 4 | Monitor | Dev | Monthly |
| R-TECH-005 | Third-party API deprecation (Stripe) | Technical | 1×3 | 3 | Accept | Dev | Quarterly |
| R-MKT-001 | Competitor launches similar product | Market | 2×2 | 4 | Monitor | Founder | Monthly |
| R-MKT-002 | Low user adoption (<10 signups/week) | Market | 2×3 | 6 | Mitigate | Founder | Weekly |
| R-FIN-001 | Infrastructure cost exceeds budget | Financial | 2×2 | 4 | Monitor | Founder | Monthly |
| R-FIN-002 | No revenue by month 6 | Financial | 2×3 | 6 | Mitigate | Founder | Monthly |

*(Expand each risk with full detail as needed, following format from Section 3)*

---

## 5. Low Priority Risks (Score 1–3)

| Risk ID | Description | Category | L×I | Score | Status | Review |
| :--- | :--- | :--- | :--- | ---: | :--- | :--- |
| R-TECH-006 | Minor UI bugs in edge cases | Technical | 1×2 | 2 | Accept | Quarterly |
| R-RES-002 | Laptop hardware failure | Resource | 1×2 | 2 | Accept | Quarterly |
| R-LEGAL-002 | Trademark conflict (low probability) | Legal | 1×2 | 2 | Accept | Quarterly |
| R-MKT-003 | Negative social media review | Market | 1×1 | 1 | Accept | Quarterly |

---

## 6. Risks by Lifecycle Phase

### Phase 1: MVP Development (Week 1–8)
**Active Risks**: R-TECH-001, R-TECH-002, R-RES-001, R-LEGAL-001  
**Focus**: Avoid technical blockers, prevent burnout, ensure compliance

### Phase 2: Beta Testing (Week 9–12)
**Active Risks**: R-MKT-002 (user adoption), R-TECH-003 (scaling)  
**Focus**: Validate demand, monitor performance under load

### Phase 3: Public Launch (Week 13+)
**Active Risks**: R-TECH-001 (payment downtime), R-FIN-002 (revenue), R-MKT-001 (competition)  
**Focus**: Revenue generation, market positioning

---

## 7. Risk Escalation Protocol

| Risk Score Change | Trigger | Action | Owner |
| :--- | :--- | :--- | :--- |
| +2 points in 1 week | Likelihood or impact increased | Emergency review meeting (same day) | PIC/Founder |
| Score reaches 7+ | New high-priority risk | Add to weekly standup, assign mitigation owner | PIC |
| Score drops to ≤3 | Mitigation successful | Move to "Accepted" category, review quarterly | PIC |

**Escalation Chain**:
1. Developer identifies risk change → Update register immediately
2. Developer notifies Founder/PIC if score ≥7
3. Founder reviews and approves mitigation plan within 24 hours
4. Developer executes mitigation, reports progress weekly

---

## 8. Risk Review Checklist (Weekly for Top Risks)

**Date**: [YYYY-MM-DD]  
**Reviewer**: [Name]

- [ ] Review all risks with score ≥7 (update status, likelihood, impact)
- [ ] Check mitigation progress (on track / delayed / blocked)
- [ ] Update contingency plans if new information available
- [ ] Log any new risks identified this week (add to register)
- [ ] Escalate if any risk score increased by ≥2 points
- [ ] Archive risks that are no longer relevant (status: Closed)

**Notes from this review**: _[Add any observations, changes, or decisions]_

---

## 9. Risk Closure Log

| Risk ID | Description | Date Closed | Reason | Final Outcome |
| :--- | :--- | :--- | :--- | :--- |
| R-TECH-002 | Google Vision API quota | 2026-02-10 | Mitigation complete | Fallback working, no issues |
| — | — | — | — | — |

---

## 10. Lessons Learned (Post-Incident)

**Incident**: [Brief description]  
**Date**: [YYYY-MM-DD]  
**Risk ID**: [If tracked, or "Not anticipated"]  
**Impact**: [What actually happened]  
**Root Cause**: [Why it happened]  
**Prevention**: [What to do differently next time]

---

## 📌 Quick Reference

**Risk Severity Guide**:
- **9 (Critical)**: Immediate threat to project success, act now
- **6 (High)**: Significant impact, needs mitigation plan
- **4 (Medium)**: Monitor closely, prepare contingency
- **2 (Low)**: Accept and review periodically

**5 Categories**: Technical, Resource, Market, Legal/Compliance, Financial

**Review Cadence**:
- Daily: Check critical risks (score 9) if any exist
- Weekly: Review all high-priority risks (score 7–9)
- Monthly: Full register review (re-assess all risks)
- Quarterly: Prune irrelevant risks, add new strategic risks

---

**💡 Solo Dev Risk Management Tips**:
- **Be paranoid early**: Better to over-identify risks than miss a big one
- **Quantify uncertainty**: Force yourself to pick likelihood/impact numbers (prevents vague "might be risky" thinking)
- **Mitigation ≠ Elimination**: You can't remove all risks, just reduce them to acceptable levels
- **Document assumptions**: Most risks stem from wrong assumptions (write them down, test them)
- **Review after every incident**: Turn surprises into lessons, update register
