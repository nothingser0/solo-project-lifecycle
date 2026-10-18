# Enterprise Metadata & SERP Optimization Pattern

> **Module**: M05 (Architecture & Specs) & M13 (Product Operations & Iteration)  
> **Source**: Adapted from Meta Tags Optimizer (`aaron-he-zhu/seo-geo-claude-skills`).  
> **Scope**: High-CTR metadata optimization (Title tags front-loaded with keywords, Meta descriptions with direct answers and CTAs, Open Graph, and Twitter Cards), intent alignment validation (CORE-EEAT checks C01 & C02), and multi-tier metric attribution (*Measured* vs. *User-provided* vs. *Estimated*).

---

## 1. Six-Step Metadata Optimization Workflow
Every page metadata optimization follows a rigorous, evidence-backed sequence:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Gather Page Information                                  │
│    URL, page type, target keywords, audience, value prop     │
├─────────────────────────────────────────────────────────────┤
│ 2. Create Optimized Title Tags                              │
│    50-60 chars, keyword front-loaded, 3 distinct variants   │
├─────────────────────────────────────────────────────────────┤
│ 3. Write Meta Descriptions                                  │
│    150-160 chars, direct answer + CTA, 3 distinct variants  │
├─────────────────────────────────────────────────────────────┤
│ 4. Social & Technical Meta Blocks                           │
│    Open Graph, Twitter Cards, Canonical, Robots, Viewport   │
├─────────────────────────────────────────────────────────────┤
│ 5. CORE-EEAT Alignment Check                                │
│    Verify C01 (Intent Alignment) & C02 (Direct Answer)      │
├─────────────────────────────────────────────────────────────┤
│ 6. CTR & A/B Test Variants                                  │
│    Explain winning elements, trade-offs, and experimentation │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Core Operational Guardrails
1. **Strict Attribution Labeling**: Every metric or claim must be explicitly labeled as **Measured** (tool/export), **User-provided**, or **Estimated** (model inference). Never present estimates as measured data.
2. **Intent & Answer Alignment**: Title and description pairs must pass C01 (Search Intent Alignment) and C02 (Direct Answer Presence) to be approved for deployment.
