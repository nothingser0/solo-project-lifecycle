# Awesome Agent Skills & Progressive Disclosure Ecosystem Pattern

> **Module**: M05 (Architecture & Specs) & M13 (Product Operations & Iteration)  
> **Source**: Adapted from Kodus Tech Awesome Agent Skills (`kodustech/awesome-agent-skills`).  
> **Scope**: Curated directory of modular, standardized engineering skills for AI coding agents, progressive disclosure architecture (metadata loading first, full instructions loaded only on relevance), separation of concerns between Agent Skills ("how to think and act") and MCP ("how to access tools"), and runtime instruction flexibility vs model fine-tuning rigidity.

---

## 1. Progressive Disclosure Architecture
Agent skills are designed to keep AI coding agents fast, focused, and token-efficient through staged context loading:

```
┌─────────────────────────────────────────────────────────────┐
│ Initial State: Lightweight Metadata                         │
│ (Name, description, and trigger triggers loaded for all skills) │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ Relevance Match & Loading                                   │
│ Agent identifies relevant skill for the current task        │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ Full Execution Context                                      │
│ Full SKILL.md body, instructions, rules, and examples loaded │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Core Architectural Distinctions
1. **Skills vs. Saved Prompts**: Saved prompts are static copy-pasted text. Agent Skills are structured instruction packages containing context, rules, deterministic workflows, and executable scripts.
2. **Skills vs. Fine-Tuning**: Fine-tuning permanently and rigidly alters model behavior at high cost. Agent Skills provide flexible runtime instructions that can be created, versioned, swapped, or removed instantly without model retraining.
3. **Skills vs. MCP (Model Context Protocol)**:
   - **Agent Skills**: Teach the agent *how to work* (workflows, guardrails, best practices, patterns).
   - **MCP**: Provide *access to tools* (APIs, databases, external services). They work together seamlessly.
