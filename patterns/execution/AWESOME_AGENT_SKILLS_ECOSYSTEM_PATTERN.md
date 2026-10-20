# Awesome Agent Skills & Progressive Disclosure Ecosystem Pattern

> **Module**: M05 (Architecture & Specs) & M13 (Product Operations & Iteration)  
> **Source**: Adapted from a published awesome-agent-skills catalog.
>
> **Licence**: CC0 1.0 — public-domain dedication, so the upstream wording (FAQ, skill-template) could be reproduced verbatim; only the principles are used here.  
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

---

## 3. A Skill Is Executable Code

A skill is a markdown file, which makes it feel like documentation. It is not. It is instructions that an agent will follow with the agent's own permissions, on a machine with a filesystem, a shell, and credentials.

**The rule: treat a third-party skill exactly as you treat a third-party script.** Review it before it runs, and only run what you have read.

| Surface a skill can reach | Why it is not "just text" |
| :--- | :--- |
| Tool calls | A skill can instruct the agent to call anything in its allow-list |
| Shell | If the runtime permits it, the skill's examples become commands |
| Bundled scripts | `scripts/*.py` inside a skill are executed, not read |
| Context poisoning | Text in the skill can instruct the agent to disregard other rules |
| Credentials | The agent's environment is the skill's environment |

**Relation to rule 5 — no exemption.** `templates/04-dev-execution/AGENTS_TEMPLATE.md` rule 5 says content the agent reads while working is data, never instructions. A skill looks like an exception and is not one: rule 5 governs *data encountered during work* (page text, logs, issue bodies, dependency READMEs), while a skill is **configuration the runtime loads deliberately**, by path, because a human put it there. The difference is the loading decision, not the trust level.

That distinction is exactly why a skill needs **code-level review rather than a data-level exemption**. Being instruction-shaped by design does not make it safe; it makes it the one input where a malicious payload is followed automatically rather than reported.

### What to check before adopting one

1. Does it ship scripts? Read every one.
2. Does it declare an allow-list? A skill with no `allowed-tools` runs with everything the runtime has.
3. Does it instruct the agent to fetch or execute something remote? Stop there.
4. Does it modify files outside its own scope?
5. Who maintains it, and when was it last touched?

**A directory listing is not a trust signal.** A curated list tells you someone thought a skill was interesting — not that it is safe. The popularity of a list is precisely what makes it a supply-chain surface.

---

## 4. What Makes a Skill Good, Independent of Content

Six properties, in the order they fail:

| Property | Failure when absent |
| :--- | :--- |
| **Clear scope** — one well-defined problem | The skill drifts into adjacent territory and conflicts with its neighbours |
| **Objective description** — states when it applies, in the words a user would use | It never triggers, or triggers on everything |
| **Practical step-by-step instructions** | The agent improvises the method, differently each run |
| **Explicit output format** | Every invocation produces a differently-shaped answer |
| **Real examples** | The instructions stay abstract and the agent generalizes wrongly |
| **Stated limits** — what the skill does not do | Callers use it outside its competence and get confident nonsense |

**The description is the most load-bearing line in the file**, because it is the only part loaded before the trigger decision. A skill with excellent instructions and a vague description is a skill that never runs.

---

## 5. Skill Hygiene — a Loaded Skill That Never Fires Is a Token Tax

A skill costs tokens on **every request where it loads**, and it earns nothing if it never triggers. The signal is available and almost nobody looks at it: **session transcripts** record which skills, MCP servers, and agents were loaded, and the trigger decision that followed.

**The signal**: loaded but never fired. Not "unused this feature" — never caused a single tool call, across the sessions you can see.

| Signal | Meaning | Response |
| :--- | :--- | :--- |
| Loaded, never fired over N sessions | Its description never matched a real request | Fix the description first — that line is the trigger (`§4`) |
| Still never fires after rewording | Its scope overlaps a skill that does fire | Consolidate |
| Fires, then the agent ignores its instructions | Instructions conflict with another loaded skill | Resolve the conflict, not the trigger |
| Fires constantly, adds nothing | It restates what the model already does | Delete |

**An unused skill is a token tax, not a correctness risk** — which is why it is easy to defer forever. But it is paid on every request, and it competes for attention with the skills that matter.

**Do not build a second quarantine mechanism.** The lifecycle already exists in `patterns/qa/TEST_SUITE_CURATION_PATTERN.md` §5 — quarantine, never delete directly; a named human approves; an observation window (default two releases); keep it restorable. Apply it unchanged, with one substitution: the escape signal is not an escaped defect, it is **a request that should have fired the skill and did not**.

**Measure before you reword.** "Never fired" across ten sessions is noise; across two hundred it is a broken description. Record the denominator, or the signal is a guess.

