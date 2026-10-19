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

---

## 3. Policy Encoded Twice Will Diverge

A customer-service skill carries policy in two places: **tables in the prompt** and **logic in a tool script**. The model reads the table; it calls the script. When they disagree, the agent confidently tells the customer one thing and the tool does another — and nobody notices until a customer complains about a refund amount.

**Observed in a real implementation** (`returns-refunds` skill):

| Rule | In `SKILL.md` | In `check_return_eligibility.py` |
| :--- | :--- | :--- |
| Category return windows | Table: 30 / 15 / 0 days | `CATEGORY_POLICIES` — matches |
| Restocking fee | Table: 0% / 15% | `restocking_fee_percent` — matches |
| **Holiday extended returns** (1 Nov–31 Dec → 31 Jan) | Documented with a rule | **Absent — zero occurrences** |
| **Goodwill credit** (within 15 days past window) | Documented as an alternative | **Absent** |

The two sources drift in one direction only: **the prose grows, the script does not.** A policy change is usually requested by someone who edits the document, not the code.

### The rule

**One policy, one executable source.** Either the script is authoritative and the document only explains it, or the table is authoritative and a test asserts the script matches it.

| Approach | How |
| :--- | :--- |
| Script authoritative | The skill says "call `check_return_eligibility`; do not compute eligibility yourself from this table" |
| Table authoritative | A unit test loads the table and asserts every row against the script's output |
| Neither (worst) | Two descriptions of the same rule, no test — what both implementations above actually do |

**Never let the model do policy arithmetic in prose.** The moment a skill says "calculate days since delivery" and the agent computes it in the prompt instead of calling the tool, the tool's tested logic is bypassed and the answer is unverifiable.

### The decision table still earns its place

Tables are not the problem — duplicated *logic* is. A table of **reason → what to say → alternative to offer** is prompt-only material that has no script equivalent and does not need one:

| Rejection reason | What to say | Alternative |
| :--- | :--- | :--- |
| Past window | "Delivered N days ago; our window is M days." | Goodwill credit if within 15 days past |
| Final sale | "Purchased during a final sale — noted at checkout." | Help them resell or gift |
| Used / worn | "Requires unused with original packaging." | Partial refund or store credit |
| Perishable | "Can't be returned, but tell me about the quality issue." | Full refund, no return needed |
| Custom | "Made specifically for you." | Replacement if defective |

**This table is the highest-value part of the skill and the least likely to be wrong**, because it contains no arithmetic — it is language, and language has no second implementation to drift from.

