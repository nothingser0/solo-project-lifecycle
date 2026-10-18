# Enterprise Agentic Customer Service & MCP Multi-Turn Testing Pattern

> **Module**: M05 (Architecture & Specs), M07 (Quality Assurance & SIT), & M13 (Product Operations & Iteration)  
> **Source**: Adapted from Agent Skills Customer Service Demo (`murphye/agent-skills-customer-service`).  
> **Scope**: Portable multi-step agent workflows defined purely in Markdown (`SKILL.md`), Model Context Protocol (MCP) server integration (`orders` and `tickets` APIs), multi-turn conversation test harnesses with YAML scenarios, tool-call pattern assertion, outcome validation, and LLM-as-a-judge quality checks.

---

## 1. Portable Markdown Agent Skill & MCP Architecture
Complex domain logic, 10-step deterministic workflows, confidence routing, policy enforcement, and response templates are authored directly in Markdown (`SKILL.md`) without complex state graph code or conditional edge wiring.

```
┌─────────────────────────────────────────────────────────────┐
│ Platform-Agnostic SKILL.md & Policies                       │
│ (Intake → Classify → Resolve → Confidence Check → Close)    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ Model Context Protocol (MCP) Servers                        │
│ ├── Orders API (`lookup_customer`, `get_order`, `refund`)   │
│ └── Tickets API (`create_ticket`, `escalate_ticket`, etc.)  │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Core Architectural & Testing Principles
1. **Low-Code Agentic Workflows**: Replacing traditional graph code with structured Markdown runbooks makes business logic changes simple text edits rather than code refactors.
2. **MCP Integration**: Decouples tool execution from agent reasoning via standardized FastMCP servers (`orders` and `tickets`), enabling portability across Claude Code, LangGraph, and other agent runtimes.
3. **Automated Multi-Turn Conversation Testing**: YAML-driven test scenarios (`scenarios/`) validate complex interactions (happy paths, auto-approved refunds, billing escalations, max-retry limits) using three assertion layers:
   - **Tool-call patterns**: Regex matching on MCP invocations.
   - **Outcome checks**: Boolean/string assertions on transcripts.
   - **Quality checks**: LLM-as-a-judge evaluation of response phrasing and tone.
