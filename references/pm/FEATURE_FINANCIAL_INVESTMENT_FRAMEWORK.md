# Feature Financial Investment Framework

> **Module**: M02 (Discovery Scope) & M13 (Product Operations & Continuous Iteration)  
> **Source**: Adapted from financial product management and ROI modeling frameworks (`deanpeters/Product-Manager-Skills`).  
> **Objective**: Replace arbitrary prioritization scoring (e.g., RICE 14 vs. 16) with disciplined economic modeling, margin preservation, and contribution analysis.

---

## 1. The 4 Revenue Connection Modes

Before estimating effort, determine how the requested feature impacts actual business cash flow:

```text
[ Feature Candidate ]
         │
         ├── 1. Direct Monetization (New Tier / Add-on / Usage-Based Charge)
         ├── 2. Retention Improvement (LTV Lift / Churn Reduction)
         ├── 3. Conversion Acceleration (Trial-to-Paid Velocity Lift)
         └── 4. Expansion Enabler (Seat Upsell / Usage Tiers)
```

### The Math Behind Each Connection:
1. **Direct Monetization**:
   $$\text{Monthly Revenue} = \text{Target Customer Base} \times \text{Expected Adoption Rate (10–20\%)} \times \text{Price}$$
2. **Retention Improvement (The Churn Reducer)**:
   $$\text{LTV Lift} = (\text{Extended Customer Lifespan in Months}) \times \text{Customer Base} \times \text{ARPU} \times \text{Gross Margin \%}$$
3. **Conversion Acceleration**:
   $$\text{Incremental MRR} = \text{Monthly Trial Volume} \times (\Delta\text{ Conversion Rate}) \times \text{ARPU}$$

---

## 2. Cost Structure & The 20% Margin Dilution Gate

Solo developers frequently forget that software features carry recurring infrastructure costs:

* **Development Cost (One-Time)**: Days/weeks of engineering time $\times$ opportunity cost.
* **Cost of Goods Sold (COGS - Recurring)**: Third-party API calls (e.g., LLM tokens, OCR endpoints, WhatsApp API charges), vector database hosting, dedicated worker CPU.
* **Operating Expenses (OpEx - Recurring)**: Customer support ticket volume and ongoing maintenance.

### ⚠️ The Margin Dilution Gate:
> **Hard Rule**: If a proposed feature's recurring COGS exceeds **20% of the associated customer revenue**, the feature is actively **diluting margins**.
>
> *Remedy*: Do not bundle expensive AI/infrastructure capabilities into standard flat-rate tiers. Isolate them into usage-based add-ons or pass-through billing with a minimum 50% contribution margin.

---

## 3. Dissecting "Strategic Value" (The No-Bullshit Filter)

The most dangerous phrase in feature backlogs is: *"The ROI is terrible, but this feature is strategic."*

Without rigorous definitions, "strategic" becomes an excuse to build pet projects and vanity features. A feature is **ONLY** classified as strategically justified if it satisfies at least one of these criteria:

1. **Defensible Moat**: It creates high switching costs or unique programmatic data retention that competitors cannot replicate in 48 hours.
2. **Platform Enabler**: It serves as an architectural prerequisite for at least 3 high-ROI features on the immediate roadmap.
3. **Regulatory / Compliance Shield**: It satisfies mandatory legal obligations (e.g., UU PDP compliance, mandatory e-Faktur integration) where failure to build results in operational shutdown.
