# Enterprise Agentic Customer Service & MCP Multi-Turn Testing Pattern

> **Module**: M05 (Architecture & Specs), M07 (Quality Assurance & SIT), & M13 (Product Operations & Iteration)  
> **Sources**: `murphye/agent-skills-customer-service` (§1–§2 — MCP order/ticket servers, YAML scenarios, three assertion layers) and `akshaykokane/Building-Customer-Service-Agent-with-Skill.md-and-Agent-Framework` (§3–§5 — policy double-encoding, session identity, tool registration).
>
> **Licence**: `murphye` declares `license: MIT` in `SKILL.md` frontmatter but ships no `LICENSE` file; `akshaykokane` ships neither. Everything below is written from observing the behaviour of both implementations; no upstream text is reproduced.  
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

### Split the table by who can decide

A refusal table mixes two kinds of row, and conflating them reintroduces the exact arithmetic the rule above forbids:

| Layer | Content | Who decides |
| :--- | :--- | :--- |
| **Script-decidable** | Money. Partial refund %, restocking fee, goodwill amount, days remaining | The tool returns it as a field — the model never computes it |
| **Language-only** | Wording, the stated reason, the offer to make | The model, verbatim from the table |

**The rule for the money half**: if a row's alternative involves a number, that number is a **tool output field**, not a sentence. The skill calls the tool and renders what it returns.

```json
{ "eligible": false,
  "reason": "Return window has expired (delivered 47 days ago; window is 30).",
  "goodwill_eligible": true,
  "goodwill_amount": 89.99,
  "goodwill_basis": "within 15 days past window" }
```

An agent asked to apply "within 15 days past the window" in prose will apply it inconsistently — and worse, will apply it *confidently*, in a customer-facing message, with no record. If the script does not return `goodwill_eligible`, the agent has no authority to offer a goodwill credit and must escalate instead.

**The rule for the language half**: a refusal without a stated reason and a next step reads as a dead end, and the agent improvises both. Give it the row.

| Rejection reason | What to say (fact filled from the tool) | Alternative — language only |
| :--- | :--- | :--- |
| Past window | "Delivered N days ago; our window is M days." | Goodwill credit **only if the tool returns `goodwill_eligible: true`**; otherwise escalate |
| Final sale | "Purchased during a final sale — noted at checkout." | Help them resell or gift it |
| Used / worn | "Requires unused, in original packaging." | Store credit or partial refund — **amount from the tool** |
| Perishable | "Can't be returned, but tell me about the quality issue." | Full refund, no return needed |
| Custom | "Made specifically for you." | Replacement if defective |

### Reasoning is not an outcome

The same repo separates **eligibility** (may this be returned?) from **cost consequence** (what does it cost if it is?). They are two tables because they answer different questions, and a customer needs a different answer for each:

| Return reason | Restocking fee | Who pays shipping | Note |
| :--- | :--- | :--- | :--- |
| Changed mind | Per policy | Customer | Standard return |
| Doesn't fit | 0% | Merchant | Offer exchange first |
| Not as described | 0% | Merchant | Flag listing for review |
| Defective | 0% | Merchant | Offer replacement before refund |
| Arrived late | 0% | Merchant | Check SLA; discount code if missed |
| Better price elsewhere | Per policy | Customer | Price match if authorized retailer |

**Keep them separate in the skill.** A single table that answers both invites the model to answer the fee question while only being asked the eligibility question — and the customer gets a number nobody computed.

**This split is what makes the language table safe.** It is the highest-value part of the skill and the least likely to be wrong, because no cell contains arithmetic.

---

## 4. Session Identity Comes From the Principal

Observed in the same implementation:

```csharp
// AgentController.cs:32 — every caller gets the same conversation
await foreach (var chunk in _agent.GetStreamingResponseAsync(request.Message, "session-1"))

// Agent.cs:19 — unbounded, keyed on that constant
static Dictionary<string, AgentSession> sessions = new();
```

The agent method already took a `sessionId` parameter — the plumbing was there, and the controller passed a literal instead. Two consequences, both severe:

| Consequence | Why |
| :--- | :--- |
| **Cross-user transcript leakage** | Every customer shares one conversation. Customer A's order number and address appear in customer B's context. |
| **Unbounded growth** | A `static` dictionary with no eviction grows for the life of the process. |

**Two rules:**

**1. Session identity is derived from the authenticated principal, never a constant, never client-supplied.** The controller resolves the identity and passes it down. A literal like `"session-1"`, `"default"`, or `"demo"` reaches production more often than it should — and it is invisible in a demo where only one user is testing.

**2. The session store needs a bounded lifetime.** An idle timeout and a maximum size, or a backing store that has one. "It's just a cache" is the reasoning that makes it a leak.

**Why this is a security finding and not a bug**: for a customer-service agent, the transcript *is* the customer's personal data. Sharing it is a data disclosure that no amount of prompt-level guardrail can undo.

**A test that would have caught it**: two concurrent conversations with different principals, asserting that neither response contains the other's order ID. One test, and it fails on the literal.

---

## 5. Every Declared Step Needs a Registered Tool

The same skill instructs the agent to *"initiate the return"* and *"calculate the refund amount"*, and ships two scripts — `lookup_order.py` and `check_return_eligibility.py`. The runtime registers exactly one function:

```csharp
Tools = [
    AIFunctionFactory.Create(GetOrderDetails, "get_order_details", ...)
]
```

`InitiateReturn` is **declared and never added to `Tools`**. Neither Python script is invoked from any C# file. So the agent is told to perform three actions and given the capability for one — and its own instructions say *"Don't make up any information."*

**It will improvise.** A return ID and a refund amount, invented confidently, addressed to a customer.

### The check

Before shipping any agent skill, map every imperative verb in the procedure to a registered capability:

| Declared step | Registered tool | Verdict |
| :--- | :--- | :--- |
| Look up the order | `get_order_details` | Reachable |
| Check eligibility | *(none)* | **Dead** — script exists, never called |
| Initiate the return | `InitiateReturn` declared, not registered | **Dead** |
| Calculate refund | *(none)* | **Dead** |

**An unregistered script is dead code, not a capability.** The file's presence in `Assets/` proves nothing; what matters is whether the runtime can call it.

**Grep is enough to find this**: list every `AIFunctionFactory.Create` / tool registration, list every numbered instruction in the skill, and diff. A step with no tool is either a language task (say so explicitly) or a hallucination generator.

---

## 6. An Agent Loop Needs Named State

A loop written as prose ("keep track of what the customer told you") degrades exactly when the conversation gets long — which is when it matters. Name the state.

| Variable | Initial | Reset when |
| :--- | :--- | :--- |
| `CUSTOMER` | null | New customer interaction |
| `INTENT` | null | New issue raised by the same customer |
| `ORDER` | null | Intent changes to an order-scoped category |
| `TICKET_ID` | null | Never mid-interaction; set once a ticket exists |
| `CONFIDENCE` | null | Re-evaluated after every new fact |
| `RETRY_COUNT` | 0 | New issue raised mid-conversation |

**The reset rules carry the weight.** Two are routinely missed:

- **A new, unrelated issue mid-conversation resets `INTENT`, `ORDER`, `CONFIDENCE`, and `RETRY_COUNT` — but keeps `CUSTOMER`.** Without this, the second issue inherits the first issue's retry budget and diagnoses the wrong problem with the right data.
- **`RETRY_COUNT` resets on a new issue**, or the third question in a long session inherits an exhausted budget and escalates immediately.

**`CONFIDENCE` must be set by a rule, not a feeling.** The version that works: `LOW` if the data is incomplete or contradictory, if the action exceeds the auto-approve threshold, or if the issue matches any escalation criterion. `HIGH` otherwise. Three conditions, all checkable.

---

## 7. The Retry Gate

An agent that retries a failing resolution will retry forever — the customer says "no", the agent tries again, and there is no state that ever says stop.

```
RETRY_COUNT += 1
if RETRY_COUNT < 3:  → retry with the new context
if RETRY_COUNT >= 3: → CONFIDENCE = LOW; escalate; note the count on the ticket
```

**Two details make it work:**

| Detail | Why |
| :--- | :--- |
| The increment happens in a dedicated gate step, not inside the retry | Otherwise the budget is re-entered or skipped depending on which branch ran |
| Escalation writes `RETRY_COUNT` onto the ticket | The human receives the count; "customer is unhappy" without "we tried three times" loses the context |

**Every loop needs a bound.** A retry gate, a turn limit, or a token budget — the name matters less than its existence. An unbounded agent loop in production is a cost incident with a customer on the other end.

---

## 8. Three Assertion Layers, Not One

A scenario file that only checks the transcript passes an agent that did the wrong thing politely. This repo's format asserts three independent layers:

```yaml
expected_tool_calls:
  must_include:
    - pattern: "mcp__orders__lookup_customer.*email=alice@example\\.com"
    - pattern: "mcp__tickets__escalate_ticket"
  must_not_include:
    - pattern: "mcp__orders__refund"        # escalation must NOT refund

expected_outcomes:
  customer_identified: "C-1001"
  escalated: true
  refund_processed: false

quality_checks:
  - "Agent greeted the customer by first name (Alice)"
  - "Agent provided a ticket ID for reference"
```

| Layer | Catches | Deterministic? |
| :--- | :--- | :--- |
| **Tool calls** | The agent taking a forbidden action, or skipping a required one | Yes — regex, byte-stable |
| **Outcomes** | The wrong end state, even when the path looked right | Yes |
| **LLM-as-judge** | Tone, phrasing, whether the customer's question was actually answered | No — a signal, never a gate |

**The `must_not_include` assertion is the highest-value line in the file.** For a billing dispute, "escalated" and "refunded" are both plausible resolutions and only one is correct. An outcome check alone would pass the wrong one; the negative tool assertion is what pins it.

**Judge output must never block a merge. The upstream harness does exactly that — here is the violation.**

`run_test.py:634` sets `result.passed = False` when a quality check fails, and `:741` exits `1`. So an LLM's opinion gates the build. Worse, `:452-462` fails any check the judge did not evaluate:

```python
results.append({
    "check": f"quality: {check}",
    "passed": False,
    "detail": "judge did not evaluate this check",
})
```

A **judge timeout, a malformed response, or a skipped check is now indistinguishable from a quality failure.** The run reports a red quality gate when the truth is "the judge did not answer". Nobody investigating that has a signal pointing at the judge.

**The rule:** three verdicts, not two.

| Verdict | Meaning | Effect on the run |
| :--- | :--- | :--- |
| `passed` | The judge evaluated the check and it passed | Informational |
| `failed` | The judge evaluated the check and it failed | Reported; blocks only if the team chose to gate on it |
| **`unparseable`** | The judge did not evaluate this check (timeout, error, malformed output, skipped) | **Never** a failure — report it as a harness gap |

A judge error is a harness defect, not a product defect. Conflating them means a flaky judge teaches the team to ignore quality output entirely — which is worse than not having it.

**Assert deterministically, judge advisory.**

**One scenario per failure mode.** The five scenarios that matter for a support agent: happy path · auto-approved action · escalation because the amount exceeds the limit · escalation because retries ran out · a new issue raised mid-conversation. That last one is the one nobody writes, and it is where the state-reset bug lives.

---

## 9. The Harness Itself Is Part of the Attack Surface

Running an agent test suite means running an agent. The upstream harness passes `--dangerously-skip-permissions` in three places (line 124, the judge at 401, the reset call at 484) and never passes an `--allowedTools` list.

**Skipping permission prompts removes the only enforcement of the skill's own allow-list.** The frontmatter declares `allowed-tools: mcp__orders__* mcp__tickets__* Read`; with prompts skipped, nothing mechanically verifies the agent stays inside it. The allow-list becomes documentation.

| Risk | Consequence | Mitigation |
| :--- | :--- | :--- |
| Permissions skipped in CI | The declared allow-list is unenforced; an agent that reaches for a file or a shell succeeds | Assert the boundary in the suite itself — the negative tool assertion is now the *only* enforcement |
| Judge runs with the same credentials, unsandboxed | A judge prompt influenced by the transcript under test can act with the harness's authority | Judge gets its own model, its own credential, no tools |
| `--max-turns 1` with no tool allow-list | The judge *can* still use tools; nothing limits it | Pass an empty allow-list explicitly, not implicitly |

**This is why the `must_not_include` assertion is load-bearing and not belt-and-braces.** Remove it and the escalation scenario asserts only that *something* happened.

### Reset state between tests, or the suite is order-dependent

The harness calls `mcp__orders__reset_state` and `mcp__tickets__reset_state` before each scenario. Without that, test N-1's refund satisfies test N's assertion that a refund occurred — the suite passes in one order and fails in another, and the failure looks like flakiness.

**Every suite that mutates shared external state needs a reset step, and the reset must be verified.** A reset call that silently fails (wrong tool name, stale connection) turns the suite into a random pass generator. Assert post-reset state, or reset by construction.

**Order-independence is a property to test**: run the scenarios in reverse. If the result changes, the reset is incomplete.

### The good half worth citing

`_clean_env()` (line 409) scrubs the environment before spawning the judge. That is the right instinct — the judge should not inherit the harness's full environment — and it is the piece most implementations omit entirely. Add an empty tool allow-list and a separate credential to it and the judge call is defensible.

