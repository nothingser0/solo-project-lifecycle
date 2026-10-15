# Solo Product Discovery & Strategy Playbook

> **Scope**: Tactical, battle-tested product discovery patterns for solo founders and small engineering teams. Enforces Teresa Torres's Opportunity Solution Tree (OST), Hamilton Helmer's 7 Powers (solo-adapted), and Riskiest Assumption Testing (RAT) before writing a single line of production code.

---

## 1. The Solo Discovery Dilemma

Big tech product discovery assumes a multi-disciplinary squad: a dedicated PM, UX researcher, data analyst, and product marketing manager running continuous discovery for months.

**As a solo developer, you face unique failure modes:**
1. **The "Builder Trap"**: Writing code immediately because writing code feels like progress, resulting in 4–8 weeks wasted on an unvalidated product nobody wants.
2. **"Hypothetical Feedback" Trap**: Asking friends or Reddit "Would you use an app that does X?" (They answer "yes", but conversion when asked to pay is 0%).
3. **No Moat Vulnerability**: Building a generic wrapper around an LLM or CRUD database that an established competitor replicates within 48 hours.

---

## 2. Opportunity Solution Tree (OST) for Solo Devs

Adapted from Teresa Torres (*Continuous Discovery Habits*). The OST forces you to decouple **business outcomes** from **specific implementation ideas**, preventing premature solution lock-in.

```text
[ Desired Outcome: Measurable Business Result ]
  │
  ├── Opportunity A (Unmet User Pain / Friction Point)
  │     ├── Solution A1 (Lightweight / Low-Code Candidate)
  │     │     └── Assumption Test: 48h Smoke / Concierge Experiment
  │     └── Solution A2 (Full Software Feature Candidate)
  │           └── Assumption Test: Interactive Wireframe / Usability Task
  │
  └── Opportunity B (Alternative User Pain / Friction Point)
        ├── Solution B1
        └── Solution B2
```

### The 4-Step Solo OST Workflow:
1. **Define ONE Desired Outcome**: Frame around user value and economic reality (e.g., *"Indonesian freelance developers save ≥3 hours calculating monthly PPh 21"* — never vanity metrics like *"Get 10,000 signups"*).
2. **Extract Opportunities from Real Past Actions**: Extract pain points strictly from past behavior interviews (The Mom Test). Group verbatim user quotes under distinct Opportunity branches.
3. **Brainstorm ≥2 Competing Solutions per Opportunity**: Never settle for the first feature idea. Compare an automated software approach against an operational low-code alternative.
4. **Run Assumption Tests Before Architecture**: Test the riskiest hypothesis of each solution before touching code.

---

## 3. Riskiest Assumption Testing (RAT) Protocol

A Minimum Viable Product (MVP) often takes weeks. A **Riskiest Assumption Test (RAT)** takes 24–72 hours and isolates the single fatal flaw that could kill the business.

### The 4 Risk Quadrants (Marty Cagan / Strategyzer):

| Risk Dimension | What It Tests | Fatal Threat to Solo Dev | Quickest Validation Technique |
|---|---|---|---|
| **Desirability** | Do real users actually care about this problem? | Zero organic demand; high churn. | **The Mom Test Interviews** (5 respondents) or **Landing Page Waitlist** (≥5% conversion on ≥100 visits). |
| **Viability** | Can we charge enough to sustain infrastructure and gross margin $\ge 70\%$? | Fatal unit economics; CAC > LTV/3. | **Pre-Order Deposit** (≥5 refundable down payments) or **B2B Letter of Intent (LOI)**. |
| **Feasibility** | Can 1 solo developer build and maintain this without burning out? | Technical debt; reliance on unavailable third-party APIs. | **Time-boxed Technical Spike (POC)** in `spike/` folder (max 1–2 days). |
| **Usability** | Can users complete the core JTBD without manual hand-holding? | Support ticket deluge; abandonment. | **Task-Based Usability Test** (5 users watching screen share). |

### Low-Cost Pre-MVP Experiment Types:
- **Fake Door Test**: A high-converting landing page showcasing the value proposition, pricing tiers, and a "Get Started" button that captures an email waitlist.
- **Concierge Test**: Performing the backend service manually (e.g. calculating tax reports by hand in Excel and sending a PDF via WhatsApp) to verify that users value the output before automating it with code.
- **Wizard of Oz**: The frontend appears fully automated to the user, but backend actions are triggered manually by the solo developer behind the scenes.

---

## 4. Hamilton Helmer's 7 Powers (Solo Developer Adaptation)

Most startup ideas fail to survive because they have zero defensibility. Solo developers cannot out-spend incumbents on brand advertising or massive scale economies. You must deliberately engineer at least one of these solo-viable powers into your product architecture:

```text
┌─────────────────────────────────────────────────────────────┐
│ 7 Powers Taxonomy (Ranked by Solo Feasibility)              │
│                                                             │
│ 1. Switching Costs        ★★★★★ (Highest Solo Fit)          │
│ 2. Counter-Positioning    ★★★★★ (Highest Solo Fit)          │
│ 3. Process Power          ★★★★☆ (Lean & Fast Execution)     │
│ 4. Cornered Resource      ★★★☆☆ (Domain Expertise / Data)   │
│ 5. Network Effects        ★★☆☆☆ (Hard to bootstrap solo)    │
│ 6. Branding               ★☆☆☆☆ (Requires capital / time)   │
│ 7. Scale Economies        ★☆☆☆☆ (Requires heavy volume)     │
└─────────────────────────────────────────────────────────────┘
```

### 1. High Switching Costs (Top Solo Moat)
- **Concept**: Once a user embeds their data or daily operational workflow into your tool, leaving for a competitor causes immense pain or data loss.
- **Solo Execution**: 
  - Historical ledger / audit history that accumulates value over time.
  - Deep ecosystem integrations (webhooks, accounting imports, custom schema configurations).
  - Open data export formats (JSON/CSV) that paradoxically build user trust to store more critical data.

### 2. Counter-Positioning (Asymmetric Advantage)
- **Concept**: Offering an opinionated, simplified business model that incumbents cannot copy without destroying their existing high-margin enterprise revenue.
- **Solo Execution**:
  - Incumbents charge Rp 5.000.000+/year with mandatory annual sales demos; you offer flat, self-serve transparent pricing (e.g. Rp 49.000/mo).
  - Incumbents demand cloud lock-in; you offer local-first / self-hostable sync that appeals to privacy-conscious businesses.

### 3. Process Power (Operational DX)
- **Concept**: Embedded proprietary workflows and toolchains that allow you to ship bug fixes and features 10x faster than legacy enterprise development cycles.
- **Solo Execution**:
  - Automated CI/CD pipelines and full gate test suites (`verify-all.sh`).
  - Modular monolith architecture with zero distributed microservice overhead.

---

## 5. Solo Discovery Checklist

Before approving Gate M00 and moving to M01:
- [ ] Primary research conducted with real target users (no fabricated quotes, The Mom Test protocol followed).
- [ ] At least one Desired Outcome mapped to an Opportunity Solution Tree with $\ge 2$ solution branches.
- [ ] Riskiest Assumption identified and tested with a cheap empirical method (Waitlist, Deposit, or Concierge).
- [ ] At least one sustainable Moat identified under the 7 Powers framework (Switching Costs or Counter-Positioning).
- [ ] Unit economics validated: Gross margin $\ge 70\%$, target CAC < LTV/3, tax (PPN + PPh) accounted for.
