# Enterprise AI Search & Technical SEO Optimization Pattern

> **Module**: M05 (Architecture & Specs), M07 (Quality Assurance & SIT), & M13 (Product Operations & Iteration)  
> **Source**: Adapted from Universal SEO Skill (`AgriciDaniel/claude-seo`).  
> **Scope**: Generative Engine Optimization (GEO/AEO), parallel sub-agent task orchestration, passage citability scoring, schema validation, agent readiness evaluation (Lighthouse Agentic Browsing, `llms.txt`, WebMCP, IPTC TrainedAlgorithmicMedia), technical SEO auditing, and tiered Google API reporting.

---

## 1. Parallel Sub-Agent SEO Orchestration Architecture
Comprehensive audits fan out across specialized sub-skills and sub-agents to generate prioritized, testable recommendations grounded in primary search engine documentation:

```
┌─────────────────────────────────────────────────────────────┐
│ Orchestrator Command (`/seo audit <url>`)                   │
└──────────────────────────────┬──────────────────────────────┘
                               │
            ┌──────────────────┼──────────────────┐
            ▼                  ▼                  ▼
┌──────────────────────┐ ┌───────────────┐ ┌──────────────────┐
│ Technical SEO Agent  │ │ E-E-A-T Agent │ │ GEO / AEO Agent  │
│ (Speed, Indexing, CWV)│ │ (Content, Auth)│ │ (Passage Citability)│
└──────────────────────┘ └───────────────┘ └──────────────────┘
```

---

## 2. Core Optimization Principles
1. **Generative Engine Optimization (GEO/AEO)**: Treat AI Overviews and AI Search as extensions of classic search indexation. Score passage citability (self-contained answer blocks), question-based heading structures, attribution density, and entity presence across authoritative platforms.
2. **Agent Readiness**: Audit for modern AI agent discovery standards (`llms.txt`, WebMCP, semantic Markdown rendering, and IPTC `TrainedAlgorithmicMedia` compliance for AI-generated product images).
3. **Tiered Data Integration**: Fully functional with zero API keys for core heuristics, with an optional multi-tier credential hierarchy (PageSpeed, Search Console, Indexing, GA4, Ads) for live metrics.
