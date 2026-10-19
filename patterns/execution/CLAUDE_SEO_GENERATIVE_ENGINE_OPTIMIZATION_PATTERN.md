# Enterprise AI Search & Technical SEO Optimization Pattern

> **Module**: M05 (Architecture & Specs), M07 (Quality Assurance & SIT), & M13 (Product Operations & Iteration)  
> **Source**: Adapted from Universal SEO Skill (`AgriciDaniel/claude-seo`).  
> **Scope**: Generative Engine Optimization (GEO/AEO) as SEO fundamentals applied to AI-search surfaces, parallel sub-agent task orchestration, passage citability scoring, schema validation, agent-readiness claims separated from Google crawl signals (`llms.txt`, WebMCP, IPTC TrainedAlgorithmicMedia), technical SEO auditing, and tiered Google API reporting.

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
2. **Agent Readiness — and what Google actually crawls**: Separate the standards that affect Google from the ones that only affect non-Google agents.

   | Claim | Status | Action |
   | :--- | :--- | :--- |
   | `llms.txt` | **Vendor proposal, not a Google crawl signal.** Google's own AI optimization guide lists it under claims you do NOT need. | Do not spend client budget on it. If a client asks, cite the guide; if a non-Google agent vendor requires it, that is a vendor integration, not SEO. |
   | WebMCP | Emerging agent-interaction proposal | Track it. Do not present it as a ranking or crawl requirement. |
   | "Chunking" content, AI-specific phrasings, inauthentic mention-farming | Rejected by Google's guidance | Do not recommend. Commodity content rewritten for machines is still commodity. |
   | Structured data | Helps classic rich results; over-investing *specifically for AI features* is not warranted | Keep schema for the features it already serves |
   | IPTC `TrainedAlgorithmicMedia` on AI-generated images | Genuine metadata compliance, useful for provenance | Keep — but it is provenance, not visibility |
   | Semantic Markdown rendering, clean passage structure, unique first-hand content | **What actually matters** | Invest here |

   **Google's position, stated plainly**: "optimizing for generative AI search is optimizing for the search experience, and thus still SEO." GEO is not a separate discipline, and a report that presents it as one is selling novelty.
3. **Tiered Data Integration**: Fully functional with zero API keys for core heuristics, with an optional multi-tier credential hierarchy (PageSpeed, Search Console, Indexing, GA4, Ads) for live metrics.
