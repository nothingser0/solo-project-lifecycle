# Requirement Elicitation Guide

A practical interview guide and targeted question bank for solo developers to uncover real client requirements, dissect hidden complexities, and lock down scope boundaries from day one.

---

## 1. The 5-Pillar Question Bank

### Pillar 1: Business Drivers & KPIs
*Goal: Understand the real motivations behind building the software.*

- *"What operational problem has consumed the most company time or budget over the last 6 months?"*
- *"If this application is a massive success upon go-live, what specific metrics do you want to see move (e.g., operating costs down 30%, order processing time reduced from 2 hours to 5 minutes)?"*
- *"What is the single biggest downside risk to the business if this project fails to deliver on time?"*

### Pillar 2: Daily Workflow & Edge Cases
*Goal: Map actual operational processes, not just theoretical assumptions.*

- *"Can you walk through the scenario from the moment staff opens the system in the morning until the job is completed (End-to-End Happy Path)?"*
- *"What are the worst-case scenarios that frequently occur in the field (e.g., customer cancels an order after payment, internet drops while the cashier inputs a transaction, package lost in transit)?"*
- *"How do staff currently resolve those emergencies manually?"*

### Pillar 3: Operational Volume & Concurrency
*Goal: Establish architectural boundaries and infrastructure sizing.*

- *"What is the estimated volume of transactions, documents, or orders processed daily during the first month?"*
- *"When do peak traffic surges typically occur (e.g., lunch hours, payday, or month-end promotional events)?"*
- *"How many concurrent staff members will be active in this application simultaneously?"*

### Pillar 4: System Ecology & Third-Party Integrations
*Goal: Identify high-risk technical dependencies early.*

- *"Does this system need to exchange data with existing software in the company (e.g., SAP, Accurate, Zahir, Salesforce CRM, or legacy MySQL databases)?"*
- *"Do those systems provide official API documentation (REST/GraphQL/SOAP), and who is the designated technical point of contact if their API experiences issues?"*
- *Solo Dev Note: If the client does not have technical support for their legacy systems, do not commit to automated bidirectional integrations.*

### Pillar 5: Compliance, Security, & Governance
*Goal: Protect the developer from legal risks and regulatory penalties.*

- *"Will sensitive personal data from customers be collected or stored (e.g., national ID photos, medical records, bank account numbers)?"*
- *"Under data privacy regulations (UU PDP No. 27/2022), sensitive data requires encryption and audit trails. Does your company have an established data retention policy before data is permanently purged?"*

---

## 2. Tactical Probes for Solo Developers

### Technique 1: Handling "It's Just a Simple Button"
Clients often assume UI buttons are trivial to implement.
- **Response Pattern**:
  > *"The button appearance is straightforward. However, behind that button, the system must process: (1) concurrent stock validation, (2) payment gateway deductions, (3) verification webhook handling, and (4) audit log entries in the database. To ensure security and prevent financial losses, implementation requires thorough testing."*

### Technique 2: The Feature Trade-Off
When a client introduces new feature requests during discovery interviews without wanting deadlines to slip.
- **Response Pattern**:
  > *"The new feature [A] you suggested is valuable. However, given our fixed 6-week release window, incorporating feature [A] means deciding whether to defer feature [B] or feature [C] to the next release. Which of these is the higher priority for initial operations?"*

### Technique 3: Uncovering Root Problems with the "5 Whys"
Clients frequently ask for the wrong technical solution to their underlying problem (e.g., *"We need native iOS and Android mobile apps"*).
- *Ask*: *"Why do you need mobile apps?"* $\to$ *"So couriers can update delivery statuses on the go."*
- *Ask*: *"Why do couriers need the app store?"* $\to$ *"So they can access it on inexpensive Android phones."*
- *Solo Dev Conclusion*: The true requirement is a lightweight, **Mobile-Responsive Web App / PWA** accessible via phone browsers, avoiding two separate native codebases and duplicate maintenance overhead.

---

## 3. Red Flags During Discovery

| Client Behavior During Discovery | Real Risk to Solo Developer | Mitigation Action |
| :--- | :--- | :--- |
| **Client does not understand their own business processes** | Development stalls mid-flight as client continuously reshuffles workflows. | Require the client to map a manual flowchart before writing code. |
| **Refusal to prioritize (claims all features are P0/Urgent)** | Unrealistic scope explosion leading to burnout. | Enforce boundaries: Maximum 5 core features classified as *Must-Have*. The rest automatically shift to *Should/Could*. |
| **Hiding broken legacy systems** | Client expects developer to clean up and debug messy legacy databases for free. | State in writing: *Data cleaning & database recovery* from legacy systems is billed separately on a daily rate basis. |
| **Designated PIC is perpetually unavailable for interviews** | Decisions are delayed, extending project timelines by months. | Activate the *Dependency SLA* clause: Every 3 business days without meeting attendance or feedback extends the official launch date accordingly. |
