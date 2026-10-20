# PaperOrchestra Multi-Agent Automated AI Research Paper Writing Pattern

> **Module**: M06 (Development Execution) & Technical Documentation  
> **Source**: Adapted from the PaperOrchestra framework (arXiv:2604.05018, public implementation).  
> **Scope**: Multi-agent pipeline for transforming unstructured research materials and agent logs into submission-ready LaTeX research papers via pluggable host-agent skills with zero API keys or embedded SDK dependencies.

---

## 1. Five-Agent Research Paper Pipeline

### A. Core Agent Roles & Steps
1. **Outline Agent (Step 1)**: Idea + experimental log + guidelines $\to$ Structured outline JSON (plotting plan, literature review plan, section plan).
2. **Plotting Agent (Step 2)**: Executes plotting plans, renders figures/diagrams, applies VLM critique loops, and captions everything.
3. **Literature Review Agent (Step 3)**: Web-search candidates, Semantic Scholar verification, and Intro/Related Work drafting with $\ge 90\%$ citation integration.
4. **Section Writing Agent (Step 4)**: Multimodal drafting of remaining sections, building experimental tables, and splicing figures.
5. **Content Refinement Agent (Step 5)**: Simulated peer review with strict halt rules and anti-gaming safety constraints.

---

## 2. Research Material Aggregation (`agent-research-aggregator`)

Bridges the gap between scattered AI coding agent history (`.claude/`, `.cursor/`, `.antigravity/`) and structured PaperOrchestra inputs (`idea.md`, `experimental_log.md`):
* **Phase 1 (Discovery)**: Catalogs log files across agent caches.
* **Phase 2 (Extraction)**: Extracts experiment records and strips PII.
* **Phase 3 (Synthesis)**: Merges redundant records into a unified research narrative.
* **Phase 4 (Formatting)**: Outputs clean `idea.md` and `experimental_log.md` ready for the pipeline.
