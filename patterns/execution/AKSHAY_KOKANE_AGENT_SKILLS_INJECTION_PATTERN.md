# Akshay Kokane Agent Framework & Trigger-Based Skill Injection Pattern

> **Module**: M05 (Architecture & Specs) & M06 (Development Execution)  
> **Source**: Adapted from Akshay Kokane Agent Skill Implementation (`akshaykokane/Building-Customer-Service-Agent-with-Skill.md-and-Agent-Framework`).  
> **Scope**: Token-efficient agent architecture, trigger-based dynamic skill injection via front matter classifiers, progressive information delivery through sequential runbook steps, high-density markdown decision tables, and context isolation for conversational AI agents.

---

## 1. Trigger-Based Dynamic Skill Injection Architecture
To prevent system prompt bloat (sending thousands of tokens of domain policies on every greeting or unrelated request), skills are injected dynamically based on lightweight trigger classifiers:

```
┌─────────────────────────────────────────────────────────────┐
│ User Message ("I want to return item X")                    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ FileAgentSkillsProvider / Trigger Matcher                   │
│ Matches incoming text against SKILL.md YAML frontmatter triggers │
└──────┬──────────────────────────────────────────┬───────────┘
       │ (No Match)                               │ (Match Found)
       ▼                                          ▼
┌──────────────────────────────┐   ┌──────────────────────────┐
│ Base System Prompt Only      │   │ Inject SKILL.md Body     │
│ (~150 tokens)                │   │ (+2,000 domain tokens)   │
└──────────────────────────────┘   └──────────────────────────┘
```

---

## 2. Core Architectural Principles
1. **Frontmatter Triggers**: Act as gatekeepers; if no trigger phrases match the user intent, the entire skill body remains unloaded, saving 60-80% token overhead.
2. **Progressive Step-by-Step Delivery**: Once triggered, instructions are organized into sequential runbook steps (e.g., Identify Item → Check Eligibility → Ask Reason → Process Return → Confirm & Summarize) rather than an unstructured wall of text.
3. **High-Density Decision Tables**: Encode complex policies, exception matrices, and thresholds in Markdown tables for maximum token efficiency and precise LLM lookup.
4. **Behavioral Guardrails & Tone**: Domain-specific constraints (e.g., tone guidance, restrictions against upselling during returns) are isolated inside the skill file, ensuring they only fire during relevant contexts.
