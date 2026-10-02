# Idea Brief & Feasibility Scorecard

> Initial idea screening document to validate technical, operational, and commercial feasibility prior to formal specification design.

---

## 1. Project Metadata
- **Idea Name / Project Codename**: [Example: AutoLegalDoc / VaultSign]
- **Initiator / Solo Dev**: [Your Name]
- **Evaluation Date**: [YYYY-MM-DD]
- **Initial Target Scale**: [Small (MVP) / Medium (SaaS) / Large / Enterprise]

---

## 2. Idea Summary (Elevator Pitch)
> **Formula Format**: For **[Target User]** who experience **[Specific Problem]**, **[Product Name]** is a **[Software Category]** solution that delivers **[Core Benefit / Unique Value]**, unlike manual/existing alternatives because **[Differentiating Advantage]**.

- **Elevator Pitch**: 
  *[Write a 1–2 sentence summary following the formula above]*

---

## 3. The 3-Filter Triage

### 3.1 Problem Statement (Real Problem)
- **Primary Problem**: [Explain the user's biggest pain point today]
- **Current Workarounds / Alternatives**: [How do they solve this problem now? Example: Manual Excel, expensive notary services, Google Drive templates]
- **Impact of Non-Resolution**: [Risk of wasted time, sensitive data leaks, legal clause errors]

### 3.2 Core User Loop (3-Step Primary Flow)
1. **Step 1 (Input)**: [Example: User selects NDA template and fills in party details form]
2. **Step 2 (Process)**: [Example: System renders standardized PDF document and generates signature verification link]
3. **Step 3 (Output / Value)**: [Example: Parties execute digital signature, encrypted document automatically stored in secure vault]

### 3.3 Extreme Scope Pruning (The MVP Razor)

| Features in First Release (In-Scope MVP) | Dropped / Deferred Features (Out-of-Scope) |
| :--- | :--- |
| • [Core Feature 1: E.g., NDA & Freelance Contract Templates] | • [Deferred Feature: Automated Invoice Generator] |
| • [Core Feature 2: Canvas signature + audit trail hash] | • [Deferred Feature: Paid e-Meterai / PSrE certified integration] |
| • [Core Feature 3: Basic encrypted S3 storage (AES-256)] | • [Deferred Feature: Multi-team workspace & custom branding] |

---

## 4. Solo Developer Feasibility Scorecard

*Rate each dimension from 1 (Very Poor / Unfeasible) to 5 (Excellent / Highly Feasible)*

| Feasibility Dimension | Score (1–5) | Solo Developer Analysis & Justification |
| :--- | :---: | :--- |
| **1. Technical Feasibility** | [ ] / 5 | [Are tech stacks & libraries mature? Heavy compute bottlenecks?] |
| **2. Bandwidth Feasibility (Solo Effort)** | [ ] / 5 | [Can it be completed solo in 2–8 weeks? Daily maintenance overhead?] |
| **3. Regulatory & Legal Feasibility (Compliance)** | [ ] / 5 | [Violates legal/regulatory requirements? Sensitive data / privacy law compliance?] |
| **4. Commercial Feasibility / Project Value (Economic)**| [ ] / 5 | [Is there willingness to pay? What is the contract value or margin potential?] |
| **AVERAGE TOTAL SCORE** | **[ ] / 5** | *(Total score divided by 4)* |

### Gate Decision
- [ ] **GO (Pass)**: Average score $\ge 3.5$ and no dimension scored $< 3$. Proceed to Module 02.
- [ ] **PIVOT (Adjust)**: Any dimension scored $< 3$ (e.g., regulation too complex). Prune features to restore viability.
- [ ] **KILL (Drop)**: Problem not real, technical barrier too high for solo dev, or severe legal risks.

---

## 5. Assigned Scale Classification Parameters

- **Selected Scale**: `[Small / Medium / Large / Enterprise]`
- **Selection Rationale**: [State rationale for tier selection based on complexity and legal compliance]
- **Target Development Timeline**: [Example: 3 Weeks for MVP]

---

## 6. Next Steps for Module 02: Discovery & Scope
Questions to answer during the upcoming discovery session:
1. [Question 1: Example: Which PDF generation library is most reliable for Node.js?]
2. [Question 2: Example: What is the per-user encryption key management architecture?]
3. [Question 3: Example: Does the signature audit trail format satisfy legal evidentiary requirements?]
