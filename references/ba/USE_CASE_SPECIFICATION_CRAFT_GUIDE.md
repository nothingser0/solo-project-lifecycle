# Use Case Specification & Functional Craft Guide

> **Module**: M02 (Discovery Scope) & M05 (Architecture & Technical Specs)  
> **Source**: Adapted from Alistair Cockburn (*Writing Effective Use Cases*) and IIBA BABOK standards (`phucnt-bazone-vietnam/use-case-writer`).  
> **Objective**: Eliminate ambiguous, fragmented, or overly technical functional specifications; enforce testable actor-system dialogues and state-based postconditions.

---

## 1. The Supreme Principle: Readability & Separation of Concerns

A functional use case specification describes **WHAT** business interactions occur, never **HOW** the underlying engineering stack executes them.

* ❌ **Prohibited Implementation Pollution (HOW)**:
  > *"System executes an asynchronous `POST /api/v1/invoices` request with a Bearer JWT token, parses the JSON payload, inserts a row into `tbl_invoices`, and triggers React state mutation `setIsSubmitting(false)`."*
* ✅ **Disciplined Functional Interaction (WHAT)**:
  > *"System validates the invoice parameters against Business Rule BR-INV-001, records the confirmed invoice, and displays the Invoice Summary screen with a direct payment link."*

---

## 2. Core Architectural Rules for Use Case Authoring

### Rule 1: The Actor $\leftrightarrow$ System Dialogue Rule
Every interaction step in the Normal Course must alternate strictly between an explicit **Actor Action** and the corresponding **System Response**.
* Do not chain multiple actor actions without showing system feedback (e.g., clicking Submit without describing system confirmation).
* Chained actor actions blind the spec, making it impossible to anchor validation branches or failure exceptions.

### Rule 2: Postcondition as a State, Not an Action
A postcondition defines the verifiable **system state** after successful completion:
* ❌ *Action (Invalid)*: "System sends an email confirmation to the client."
* ✅ *Verifiable State (Valid)*: "Invoice record status is set to `PAID`, customer quota is decremented by 1, and an audit notification email has been delivered to the primary account address."

### Rule 3: Decouple Interaction Flow from Business Rules
Never bury dense logic equations, complex thresholds, or validation limits inside narrative interaction steps:
* ❌ *Burying Logic*: *"Step 4: System checks if customer has active PPh 21 tax status, total revenue < 4.8B, invoice age < 30 days, and valid NPWP format..."*
* ✅ *Clean Reference*: *"Step 4: System validates transaction eligibility according to Business Rule **BR-TAX-004**."* (The exact logic lives in the dedicated Business Rules section).

---

## 3. The 10 Critical Specification Anti-Patterns

| Anti-Pattern | Description | Root Problem | Corrective Action |
| :--- | :--- | :--- | :--- |
| **1. Wireframe Annotation Trap** | Specifying pixel coordinates, colors (`#1E88E5`), or font sizes. | Changes with UI redesigns. | Describe semantic components: *"displays the Confirmation dialog"*. |
| **2. Compound Steps** | Combining two distinct actions with "and" (*"User selects slot and system validates"*). | Obscures validation failure points. | Split into two numbered steps: Actor input followed by System validation. |
| **3. Missing System Feedback** | Listing 5 consecutive user clicks without system reactions. | Lacks clear transaction boundaries. | Insert system state acknowledgment after every user prompt. |
| **4. Embedded Logic Loops** | Writing *"If user is Admin do X, else do Y"* in the main flow. | Clutters the golden path. | Move non-default paths to **Alternative Courses** (AC) or **Exceptions** (EX). |
| **5. Vague Triggers** | *"When user wants to view reports..."* | Unclear entry event. | State observable event: *"User navigates to the Financial Reports tab"*. |
| **6. Action-Based Postcondition** | Stating what the system *did* rather than what is *persisted*. | Cannot be verified by QA. | State database/system state: *"Account status is set to ACTIVE"*. |
| **7. Dual Primary Actors** | Defining two actors simultaneously initiating a single use case. | Violates single responsibility. | Split into two separate use cases (e.g., Self-Enrollment vs. Admin Assignment). |
| **8. Vague Processing Verbs** | Using lazy verbs like *"System handles/processes the data"*. | Zero engineering clarity. | Specify concrete verb: *"Validates, calculates, stores, and renders"*. |
| **9. Summary Duplication** | Repeating the 2-sentence description verbatim across 10 steps. | Narrative bloat. | Keep description a high-level summary; steps are sequential instructions. |
| **10. Ignoring Failure Modes** | Only writing the happy path without defining exceptions. | Leads to unhandled edge crashes. | Systematically map payment timeouts, concurrency conflicts, and invalid inputs. |
