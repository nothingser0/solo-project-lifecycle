# Enterprise App Store Optimization (ASO) Pattern

> **Module**: M05 (Architecture & Specs) & M13 (Product Operations & Iteration)  
> **Source**: Adapted from App Store Optimization Toolkit (`dock-aso/aso-optimizer-skill`).  
> **Scope**: Comprehensive iOS and Android App Store Optimization (ASO) workflows, including semantic & competitor keyword research, tier-based keyword categorization, metadata optimization within strict platform character limits (iOS title/subtitle/keywords vs. Google Play short/long description), multi-market localization, and structured spreadsheet tracking outputs.

---

## 1. ASO Workflow & Execution Stages
Every app store optimization project follows a systematic four-stage execution pipeline:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Information Gathering                                    │
│    App features, target audience, platforms, markets/langs  │
├─────────────────────────────────────────────────────────────┤
│ 2. Keyword Discovery & Tiering                              │
│    Semantic analysis, competitor extraction, intent mapping │
├─────────────────────────────────────────────────────────────┤
│ 3. Platform Metadata Optimization                           │
│    iOS (Title 30c, Subtitle 30c, Keywords 100c)             │
│    Google Play (Short 80c, Full 4000c)                      │
├─────────────────────────────────────────────────────────────┤
│ 4. Localization & Tracking Delivery                         │
│    Multi-language adaptation & spreadsheet tracking output   │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Core Operational Guardrails
1. **Strict Platform Limits**: Always validate titles, subtitles, and descriptions against exact iOS and Google Play character constraints.
2. **Multi-Tier Keyword Architecture**: Categorize discovered keywords by search volume, relevance, and conversion potential before assigning them to native metadata fields.
