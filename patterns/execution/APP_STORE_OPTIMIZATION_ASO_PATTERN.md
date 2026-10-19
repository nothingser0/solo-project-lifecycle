# Enterprise App Store Optimization (ASO) Pattern

> **Module**: M05 (Architecture & Specs) & M13 (Product Operations & Iteration)  
> **Source**: `dock-aso/aso-optimizer-skill` (`aso-optimizer/SKILL.md` + `references/store-guidelines.md`, `keyword-strategies.md`).
>
> **Licence**: MIT (upstream `LICENSE`, Copyright (c) 2025 ASO Optimizer Contributors).  
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

---

## 3. What Is Indexed and What Is Not

The single most expensive ASO mistake is optimising text the store does not index. Every character spent on an unindexed field is a character not spent on a ranking one.

| Field | Limit | Indexed for search? | Consequence |
| :--- | ---: | :---: | :--- |
| iOS App Name | 30 | **Yes** — highest weight | Primary keyword belongs here |
| iOS Subtitle | 30 | **Yes** | Secondary keyword |
| iOS Keyword Field | 100 | **Yes** — hidden from users | The only place to place keywords not already in name/subtitle |
| iOS Promotional Text | 170 | **No** | Announcements only; never a ranking play |
| iOS Description | 4000 | **No** | Conversion copy only — first 2–3 lines matter, the rest does not affect ranking |
| Google Play Title | 30 | **Yes** | Primary keyword |
| Google Play Short Description | 80 | **Yes** | Primary keywords, written to earn the click |
| Google Play Long Description | 4000 | **Yes** | First 250 characters visible; the whole field is indexed — unlike iOS |

**The asymmetry that catches people**: the iOS description is *not* indexed while the Google Play long description *is*. A copy-paste of the iOS description into Play leaves ranking value on the table, and copying the Play description into iOS spends effort on nothing.

### The keyword field has three rules people skip

- Comma-separated, **no spaces after commas** — spaces waste characters from the 100-char budget
- **No repeated words** already present in the app name or subtitle — repetition earns nothing and costs characters
- **Plurals are usually unnecessary** — iOS matches them automatically

---

## 4. Score a Keyword Before You Place It

Assignment without scoring is taste. Score four dimensions 1–10, then compute:

```
Score = (Relevance × 0.4) + (Volume × 0.2) + (Competition × 0.2) + (Conversion × 0.2)
```

| Dimension | What a 1 means | What a 10 means |
| :--- | :--- | :--- |
| **Relevance** | Keyword describes a feature the app does not have | The keyword names the core capability |
| **Volume** | No measurable searches | High and sustained |
| **Competition** (inverse) | Dominated by apps with far more ratings | Achievable for a new app |
| **Conversion potential** | Attracts browsers, not installers | The searcher is ready to install |

| Tier | Score | Placement |
| :--- | :--- | :--- |
| **Tier 1** | 8–10 | Title / subtitle |
| **Tier 2** | 6–7.9 | Keyword field |
| **Tier 3** | 4–5.9 | Long description (Play only — remember iOS does not index it) |

**Relevance is weighted 0.4 for a reason.** A high-volume keyword the app cannot satisfy wins an install and loses a user — the review that follows costs more than the install was worth.

**Tier 3 has no home on iOS.** With the description unindexed and a 100-character field already full, a Tier 3 keyword on iOS is not optimised — it is absent. Decide that deliberately rather than assuming it landed somewhere.

---

## 5. Keyword Hygiene

| Good | Bad |
| :--- | :--- |
| Specific and descriptive | Generic: "app", "good", "best" |
| Matches how users actually search | Competitor brand names (a policy violation on both stores) |
| Relevant to shipped functionality | Features the app does not have |
| Has measurable volume | No volume |
| Competition the app can win | Unwinnable for its rating count |

**Localisation is not translation.** Three approaches, in increasing effort: direct translation (universal features), localised search behaviour (how locals actually search), cultural adaptation (different categories matter in different markets). Start with direct translation, then measure per locale — a translated keyword list is a hypothesis until the per-locale data arrives.

