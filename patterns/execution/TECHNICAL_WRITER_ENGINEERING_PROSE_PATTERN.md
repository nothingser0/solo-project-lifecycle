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
