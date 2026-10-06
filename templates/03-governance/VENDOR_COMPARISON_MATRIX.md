# Vendor Comparison Matrix Template

> **Purpose**: Evaluate and compare vendors/tools systematically  
> **When**: M05 Architecture or before major technology decisions  
> **Target**: Enterprise projects requiring build vs buy decisions

---

## When to Use This Template

**Use for**:
- Choosing payment gateway (Stripe vs PayPal vs Adyen)
- Selecting cloud provider (AWS vs GCP vs Azure)
- Picking authentication service (Auth0 vs Cognito vs Okta)
- Evaluating SaaS tools (monitoring, analytics, CRM)

**Don't use for**:
- Internal team decisions (use ADR instead)
- Simple open-source library choices
- One obvious vendor (no comparison needed)

---

## Comparison Framework

### 1. Must-Have Requirements (Pass/Fail)

| Requirement | Vendor A | Vendor B | Vendor C |
|:------------|:---------|:---------|:---------|
| API availability | ✅ Yes | ✅ Yes | ❌ No |
| SOC 2 certified | ✅ Yes | ❌ No | ✅ Yes |
| 99.9% SLA | ✅ Yes | ✅ Yes | ⚠️ 99.5% |
| Multi-region | ✅ Yes | ⚠️ US only | ✅ Yes |

**Result**: Vendor C fails (no API), eliminate

---

### 2. Weighted Scoring (100 points)

| Criteria | Weight | Vendor A | Vendor B |
|:---------|:-------|:---------|:---------|
| **Features** | 30% | 8/10 × 30 = 24 | 9/10 × 30 = 27 |
| **Cost** | 25% | 6/10 × 25 = 15 | 9/10 × 25 = 23 |
| **Reliability** | 20% | 9/10 × 20 = 18 | 8/10 × 20 = 16 |
| **Support** | 15% | 7/10 × 15 = 11 | 6/10 × 15 = 9 |
| **Integration** | 10% | 8/10 × 10 = 8 | 7/10 × 10 = 7 |
| **TOTAL** | 100% | **76/100** | **82/100** |

**Winner**: Vendor B (82 points)

---

## Example: Payment Gateway Comparison

### Must-Have Requirements

| Requirement | Stripe | PayPal | Adyen |
|:------------|:-------|:-------|:------|
| Credit card processing | ✅ | ✅ | ✅ |
| International support | ✅ | ✅ | ✅ |
| PCI-DSS Level 1 | ✅ | ✅ | ✅ |
| Subscription billing | ✅ | ⚠️ Limited | ✅ |
| Webhooks | ✅ | ✅ | ✅ |
| API documentation | ✅ Excellent | ⚠️ Good | ✅ Excellent |

**Result**: All pass, move to weighted scoring

---

### Weighted Scoring

**Weights** (must total 100%):
- Features: 30%
- Cost: 25%
- Developer Experience: 20%
- Support: 15%
- Reliability: 10%

---

#### Features (30%)

| Feature | Stripe | PayPal | Adyen |
|:--------|:-------|:-------|:------|
| Credit cards | ✅ | ✅ | ✅ |
| Digital wallets | ✅ Apple/Google Pay | ✅ PayPal | ✅ All wallets |
| Subscriptions | ✅ Excellent | ⚠️ Basic | ✅ Excellent |
| Invoicing | ✅ | ❌ | ✅ |
| Fraud detection | ✅ Radar | ⚠️ Basic | ✅ Advanced |
| Multi-currency | ✅ 135+ | ✅ 100+ | ✅ 150+ |

**Score**: Stripe 9/10, PayPal 6/10, Adyen 10/10

**Weighted**: Stripe 27, PayPal 18, Adyen 30

---

#### Cost (25%)

| Item | Stripe | PayPal | Adyen |
|:-----|:-------|:-------|:------|
| **Transaction fee** | 2.9% + $0.30 | 2.9% + $0.30 | 2.9% + $0.30 |
| **Monthly fee** | $0 | $0 | $0 |
| **Setup fee** | $0 | $0 | Contact sales |
| **Subscription** | Included | Extra fee | Included |
| **International** | +1% | +1.5% | Negotiable |
| **Volume discount** | Yes (>$1M) | Yes | Yes |

**Monthly Cost Estimate** (100k transactions, $50 avg):
- Stripe: $145,000/mo
- PayPal: $145,000/mo
- Adyen: $145,000/mo (negotiable at enterprise)

**Score**: Stripe 8/10, PayPal 7/10, Adyen 9/10 (better at scale)

**Weighted**: Stripe 20, PayPal 18, Adyen 23

---

#### Developer Experience (20%)

| Aspect | Stripe | PayPal | Adyen |
|:-------|:-------|:-------|:------|
| **Documentation** | ⭐⭐⭐⭐⭐ Excellent | ⭐⭐⭐ Good | ⭐⭐⭐⭐ Very Good |
| **SDKs** | Node, Python, Ruby, etc. | Limited | Comprehensive |
| **Testing** | Full sandbox | Limited sandbox | Full test environment |
| **Dashboard** | Intuitive | Complex | Professional |
| **Error messages** | Clear | Cryptic | Technical |
| **Community** | Large (Stack Overflow) | Medium | Small |

**Score**: Stripe 10/10, PayPal 5/10, Adyen 8/10

**Weighted**: Stripe 20, PayPal 10, Adyen 16

---

#### Support (15%)

| Support Channel | Stripe | PayPal | Adyen |
|:----------------|:-------|:-------|:------|
| **Email** | 24/7 | Business hours | 24/7 |
| **Phone** | ❌ (email only) | ✅ | ✅ |
| **Chat** | ✅ | ❌ | ✅ |
| **Response time** | <24 hours | 1-2 days | <4 hours |
| **Dedicated manager** | Enterprise only | No | Yes (enterprise) |
| **Status page** | ✅ | ✅ | ✅ |

**Score**: Stripe 7/10, PayPal 5/10, Adyen 9/10

**Weighted**: Stripe 11, PayPal 8, Adyen 14

---

#### Reliability (10%)

| Metric | Stripe | PayPal | Adyen |
|:-------|:-------|:-------|:------|
| **SLA** | 99.99% | 99.9% | 99.99% |
| **Uptime (actual)** | 99.99% | 99.8% | 99.99% |
| **Downtime last year** | 52 min | 17 hours | 52 min |
| **Major incidents** | 0 | 2 | 0 |
| **Latency (p95)** | <200ms | <300ms | <150ms |

**Score**: Stripe 9/10, PayPal 7/10, Adyen 10/10

**Weighted**: Stripe 9, PayPal 7, Adyen 10

---

### Final Scores

| Vendor | Features (30%) | Cost (25%) | Dev Experience (20%) | Support (15%) | Reliability (10%) | **Total** |
|:-------|:--------------|:-----------|:---------------------|:--------------|:------------------|:----------|
| **Stripe** | 27 | 20 | 20 | 11 | 9 | **87/100** |
| **PayPal** | 18 | 18 | 10 | 8 | 7 | **61/100** |
| **Adyen** | 30 | 23 | 16 | 14 | 10 | **93/100** |

**Winner**: Adyen (93 points)

**Recommendation**: Choose Adyen for enterprise scale, Stripe for faster time-to-market

---

## Qualitative Comparison

### Pros & Cons

**Stripe**:
- ✅ Best developer experience (excellent docs)
- ✅ Fast integration (2-3 days)
- ✅ Great for startups (no setup fee)
- ❌ No phone support
- ❌ Pricing not negotiable

**PayPal**:
- ✅ Brand recognition (users trust it)
- ✅ Checkout button (one-click)
- ❌ Poor developer experience
- ❌ Limited subscription features
- ❌ Slower support

**Adyen**:
- ✅ Enterprise-grade (scales to billions)
- ✅ Best reliability (99.99% uptime)
- ✅ Negotiable pricing at scale
- ❌ Complex setup (1-2 weeks)
- ❌ Overkill for small projects

---

## Cost Analysis (3-Year TCO)

**Assumptions**:
- Year 1: 100k transactions/month
- Year 2: 300k transactions/month
- Year 3: 500k transactions/month
- Average transaction: $50

### Total Cost of Ownership

| Vendor | Year 1 | Year 2 | Year 3 | **3-Year Total** |
|:-------|:-------|:-------|:-------|:-----------------|
| **Stripe** | $1.74M | $5.22M | $8.70M | **$15.66M** |
| **PayPal** | $1.74M | $5.22M | $8.70M | **$15.66M** |
| **Adyen** | $1.74M | $4.80M | $7.83M | **$14.37M** |

**Winner**: Adyen saves $1.29M over 3 years (better volume discount)

---

## Risk Assessment

| Risk | Stripe | PayPal | Adyen |
|:-----|:-------|:-------|:------|
| **Vendor lock-in** | Medium | High | Medium |
| **API changes** | Low (stable) | Medium | Low |
| **Company stability** | High (IPO) | High (eBay) | High (Nasdaq) |
| **Compliance** | PCI-DSS L1 | PCI-DSS L1 | PCI-DSS L1 |
| **Data breach history** | None | None | None |

---

## Decision Matrix

### Decision Criteria

**Choose Stripe if**:
- ✅ Fast time-to-market (days, not weeks)
- ✅ Developer experience priority
- ✅ Budget <$1M/year
- ✅ Need quick MVP/prototype

**Choose PayPal if**:
- ✅ Brand recognition important
- ✅ Customers expect PayPal button
- ⚠️ Not recommended for new projects (poor dev experience)

**Choose Adyen if**:
- ✅ Enterprise scale (>$5M revenue)
- ✅ Reliability critical (99.99% uptime)
- ✅ Volume discounts matter
- ✅ Need dedicated account manager

---

## Recommendation

**Primary Recommendation**: Adyen

**Rationale**:
- Highest score (93/100)
- Best reliability (99.99%)
- Lowest 3-year TCO ($14.37M vs $15.66M)
- Enterprise-grade features
- Scales to billions

**Backup Option**: Stripe

**Rationale**:
- Faster integration (if timeline tight)
- Better developer experience
- Good for MVP/prototype

**Not Recommended**: PayPal (poor dev experience, limited features)

---

## Vendor Comparison Checklist

**Before Evaluation**:
- [ ] Define must-have requirements (pass/fail)
- [ ] Define weighted criteria (must total 100%)
- [ ] Identify 3-5 vendors to compare
- [ ] Set evaluation timeline (1-2 weeks)

**During Evaluation**:
- [ ] Request demos from all vendors
- [ ] Build POC with top 2 vendors
- [ ] Compare pricing (3-year TCO)
- [ ] Check references (talk to existing customers)
- [ ] Review contracts (pricing, SLA, lock-in)

**After Selection**:
- [ ] Document decision (ADR)
- [ ] Negotiate contract (enterprise discounts)
- [ ] Plan implementation (timeline, resources)
- [ ] Set up monitoring (track SLA compliance)

---

## Notes

**Don't just pick the highest score**: Consider qualitative factors (team familiarity, implementation timeline)

**POC is critical**: Build prototype with top 2 vendors (don't just trust marketing)

**Negotiate**: Enterprise pricing is always negotiable

**Avoid vendor lock-in**: Use abstraction layer (swap vendors if needed)
