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

---

## 3. Programmatic-Page Risk Gate

Generating a page per city, per integration, or per query variation is a legitimate technique and a doorway-page violation depending on **what varies between the pages**. This is a decision rule with a number, not SEO advice.

| Threshold | Action |
| :--- | :--- |
| **30+ location pages** | ⚠️ **Warning.** Every page needs 60%+ unique content: local landmarks/neighbourhoods, location-specific services, local team, genuine local testimonials. |
| **50+ location pages** | 🛑 **Hard stop.** Requires explicit written justification: legitimate business presence in each location, a distinct content strategy per page, local signals (Google Business Profile, local reviews). |

**Doorway signals** — any one of these means the pages are programmatic in the bad sense:

- Only the city/state name changes between pages
- No unique local information
- No local business signals
- Keyword-stuffed URLs

### Safe at scale vs risky at scale

| Safe at scale ✅ | Why |
| :--- | :--- |
| Integration pages | Real setup documentation, unique technical content |
| Template / tool pages | Downloadable asset, unique functionality |
| Glossary pages | 200+ word unique definitions |
| Product pages | Unique specs, images, reviews |
| User profile pages | User-generated unique content |

| Penalty risk ❌ | Why |
| :--- | :--- |
| Location pages with only the city swapped | Doorway pattern |
| Query-variation pages | Scaled content abuse |
| Thin category pages | No unique value per URL |
| Auto-translated pages with no review | Low-effort main content |

**Primary source backing**: Google names *scaled content abuse* (QRG §4.6.5) and *low-effort main content* (§4.6.6). Creating pages per query variation "primarily to manipulate rankings" violates spam policy — the threshold table above is a proxy for that judgement, not a licence to generate 49 pages.

**The rule**: if you cannot state what is genuinely different about page 47 compared to page 1, you do not have 47 pages — you have one page and 46 doorway candidates.

---

## 4. The Eligibility Floor — check this before any GEO advice

GEO advice is meaningless for a site that is not eligible to appear.

**A page must be indexed and eligible to be shown with a snippet in Google Search**, and the site must be **included in Search generative AI features** via the Search Console "Search generative AI" control (include is the default; options are include / exclude / inherit; rolled out worldwide 2026-08-31).

**Audit order**: indexing → snippet eligibility → AI-feature inclusion → then content and citability. Recommending passage structure to a page that is `noindex` is wasted engagement, and it is a common one.

Government or regulated sites sometimes **exclude** themselves from AI features deliberately. Check the setting before reporting AI invisibility as a defect — it may be a policy decision, and telling the client to flip it is advice with legal implications.

