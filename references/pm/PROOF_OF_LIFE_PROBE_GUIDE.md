# Proof of Life (PoL) Probe Guide

> **Module**: M01 (Idea Feasibility) & M02 (Discovery Scope)  
> **Source**: Adapted from pre-MVP de-risking frameworks (`deanpeters/Product-Manager-Skills`).  
> **Objective**: Surface harsh operational truths cheaply before spending weeks building production software; eliminate prototype theater.

---

## 1. PoL Probe vs. Prototype Theater

Jeff Patton's foundational law states: *"The most expensive way to test your idea is to build production-quality software."*

Solo developers frequently fall into **Prototype Theater**: spending 2 to 4 weeks polishing UI transitions, setting up complex databases, and writing production tests for an idea that ultimately nobody wants to pay for. Because so much effort was invested, the developer falls victim to the **sunk-cost fallacy** and refuses to abandon the failing premise.

### The Contrast:
* **Prototype Theater**: An impressive, polished demo designed to win praise from peers, yet teaches zero validated market truths.
* **Proof of Life (PoL) Probe**: A rapid, intentionally disposable reconnaissance mission designed to answer **one fatal question** in 24 to 72 hours. It is explicitly engineered to be deleted, never scaled.

> **Golden Rule**: *"Use the cheapest prototype that tells the harshest truth. If it doesn't sting, it's probably just theater."*

---

## 2. The 5 Prototype Flavors

Select the prototype archetype that targets your specific uncertainty, rather than relying on familiar engineering tools:

| Flavor | Core Question | Speed | Tools / Method | When to Deploy |
| :--- | :--- | :---: | :--- | :--- |
| **1. Feasibility Spike** | *"Can our architecture actually compute this?"* | 1–2 days | Throwaway prompt chains, raw CLI scripts, isolated API latency probes. | Technical capability or third-party API stability is unknown. |
| **2. Task-Focused Test** | *"Can a user complete the core job without friction?"* | 1–3 days | Figma/v0 click-throughs, un-styled form inputs, Loom recordings. | Testing critical conversion moments, form friction, or checkout drop-off. |
| **3. Narrative Storyboard** | *"Does this outcome earn customer commitment?"* | 1–2 days | 2-minute Loom walkthrough, slide teardown, or static screenshot sequence. | Pre-selling enterprise integrations or validating willingness-to-pay. |
| **4. Synthetic Simulation** | *"How does the system behave under stress or volume?"* | 2–3 days | Generated mock data, automated faker scripts, synthetic edge-case tests. | Surfacing unknown edge cases before handling sensitive customer records. |
| **5. Frankensoft PoL** | *"Will users adopt this continuous workflow daily?"* | 2–3 days | No-code glue (Airtable + WhatsApp bot + Webhook script). | Testing complete operational workflows before building custom backend code. |

---

## 3. The 5 Essential PoL Probe Criteria

Every probe must pass this checklist before touching a single line of code:

1. **Lightweight**: Resource investment is strictly capped at **$\le 72$ hours**.
2. **Disposable**: The codebase or asset is planned for deletion immediately after the learning is captured.
3. **Single Risk Isolation**: Tests exactly one hypothesis (e.g., *"Will agencies upload their bank statements?"*), never multi-variable scope.
4. **Brutally Honest**: Measures binary, observable actions (e.g., credit card deposit, raw CSV upload), never polite verbal validation (*"Looks cool!"*).
5. **Pre-MVP Gate**: If the probe fails, the product idea is killed or pivoted immediately before entering M05 Architecture.
