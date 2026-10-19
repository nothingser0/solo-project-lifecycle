# Riekelt Technical Writer Engineering Writing & Anti-AI-Slop Prose Pattern

> **Module**: M05 (Architecture & Specs), M09 (UAT & Signoff), & M11 (Handover BAST)  
> **Source**: Adapted from Riekelt Technical Writer skills (`riekelt/technical-writer`).  
> **Scope**: Strict engineering documentation house style: bottom-line-up-front (BLUF), claim traceability, zero AI tells/slop, and structured document types (ADRs, design docs, postmortems, runbooks).

---

## 1. Core House Style Rules
1. **BLUF (Bottom Line Up Front)**: State the conclusion or core decision first at every level.
2. **Traceable Claims**: Every technical claim must be backed by a source anchor (code file, test suite, or issue ID) or explicitly marked with confidence levels.
3. **Anti-AI Slop Guardrails**: Strict prohibition of machine tells (negative parallelism, rule of three, importance announcements, and cursed vocabulary like *delve*, *testament*, *seamless*).
4. **One Fact in One Home**: Prevent redundant fragmentation across docs by anchoring each concept in a single source of truth.

---

## 2. Specialized Document Workflows
- **Design Docs & ADRs**: Mandatory Why & What boxes, alternative evaluations, and immutable consequences.
- **Runbooks & Procedures**: ASD-STE100 simplified technical English principles (one instruction per sentence).
- **Postmortems & Issue Tracking**: Root-cause analysis without blame, reproducible steps, and acceptance criteria.

---

## 3. Reviewing Prose: Severity Mapping and the Delivery Gate

A prose review without severity ranks every nit equally, so the author fixes the commas and ships the unsupported claim.

### 3.1 Severity mapping

| Rank | Covers |
| :--- | :--- |
| **BLOCKER** | A claim the cited source does not support, or that traces to nothing. A number with no source. A procedure step with no actor. |
| **WARNING** | A structural defect: conclusion buried, headings that are questions, paragraphs that could be rearranged without loss. |
| **OBS** | Ambiguity, missing polish, anything an attentive author would likely catch themselves. |

**The rule this enforces**: a BLOCKER is not a style opinion, and an OBS never blocks delivery. Collapsing the two teaches the author that review is taste.

### 3.2 The remove-the-name test

Delete the product name from the opening and the summary. Can a stranger who has never heard of this product still tell **what the text is about and what it does**?

If not, the opening is describing the product to someone who already knows it — which is the most common defect in a handover document, and the one the client notices first.

### 3.3 Editing is diagnosis

Every edit names the concrete defect it fixes, and the smallest edit that fixes it wins. **Rewriting natural or approved language without a named defect is itself a defect.**

Before delivering a rewrite, ask three control questions:

1. Which sentence still sounds like a language model?
2. Did the rewrite add or drop a fact, number, date, name, source, or claim?
3. Does the rewrite recreate a removed pattern in a new rhetorical form?

**An addition and a loss both count as errors, even when the text reads better for it.** Never add a fact to finish a sentence — ask, or write a simpler sentence.

This is also the rule that keeps §3.4 from becoming an excuse and §3.1 from becoming a licence: **if you cannot name the defect, leave the text alone.**

### 3.4 What not to flag

The banned-construction list proves nothing by itself; every pattern also occurs in good human writing. Flag only when several signs coincide in the same paragraph.

Polished grammar · one repeated sentence opening · one short sentence for emphasis · formal words that are not on the list · a factual contrast ("the pipeline sets the tag, the developer does not") · a serious alternative the reader would weigh · qualifiers that bound scope or legal risk · a reference to the previous state in a migration doc · a quoted word · metaphor that explains · deliberate awkwardness.

> This list is the prose counterpart of `references/design/AI_WRITING_TELLS.md` §10.1: same rule, different scale — a single hit is not evidence, a cluster is.

### 3.5 The delivery gate (before any document goes out)

Nine checks, all cheap, all mechanical enough to run on every document:

1. **Remove-the-name test** on the opening and summary — §3.2.
2. **Reads cold** — natural to someone who never saw the conversation that produced it. No "as we discussed", no reference to a prior review round.
3. **Reads whole** — one voice throughout; no patchwork seams; no sentence explaining why the document was written this way.
4. **One term per concept**, defined at first use. Two words for one thing is two things to the reader.
5. **Headings name the content** — no question forms, no "What X means", and no heading immediately restated in its first sentence.
6. **Every numeric claim cites a source named in the document** — pairs with `references/design/AI_WRITING_TELLS.md` §8A.
7. **References verified by following them** — chapter numbers, relative links, and file names actually exist.
8. **On a rewrite: no fact, number, date, name or source added or lost** — §3.3.
9. **Read the summary aloud** — no row of fragments, no three sentences with the same opening.

**Why a checklist and not more prose**: items 2 and 3 are the ones a writer cannot see in their own draft, so they only get caught by a fixed list that is run every time. A rule remembered is a rule skipped under deadline.
