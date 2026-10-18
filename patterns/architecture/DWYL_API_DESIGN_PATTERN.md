# Dwyl Learn API Design & Product-First API Principles Pattern

> **Module**: M01 (Idea Feasibility) & M05 (Architecture Specs)  
> **Source**: Adapted from `dwyl/learn-api-design` (API-as-a-Product philosophy, Joshua Bloch & Kevin Lacker API design laws).  
> **Scope**: Core mindset and architectural principles for treating APIs as first-class digital products, optimizing for learnability, preventing breaking API debt, and ensuring non-surprising developer experiences.

---

## 1. The API-as-a-Product Philosophy

### A. The "Golden Ticket" Mindset
* Starting a project from scratch is rare and precious. Never treat API design as an afterthought or a byproduct of the database schema.
* **The API is the Product**: A massive percentage of users (automations, voice assistants, data analysts, mobile apps) interact directly with the API. A bad API is among a company's greatest liabilities and cannot be easily changed once released.

### B. Core Laws of API Design (Bloch & Lacker Principles)
1. **Appeal to Laziness**: Make the intuitive path the correct path. Good APIs require minimal mental overhead.
2. **Be Opinionated**: Provide clear, enforced conventions even when multiple design choices are technically valid (removes decision fatigue for consumers).
3. **Never Surprise the User**: Predictability trumps clever performance tricks. If a resource list returns sorted by date, never randomly mutate sorting behavior.
4. **Hard to Misuse**: Write rigorous validation and tests for undesirable or edge-case client behavior.

---

## 2. Characteristics of a Good API
* **Learnable & Intuitive**: Can be used effectively even with minimal documentation.
* **Readable Code**: Code that consumes or interacts with the API remains clean and maintainable.
* **Evolvable**: Designed simply at inception so it can gracefully absorb future business requirement changes without breaking clients.
