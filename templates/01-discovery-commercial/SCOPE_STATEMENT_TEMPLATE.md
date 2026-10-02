# Scope Statement & Requirements Breakdown

> Initial project scope agreement document resulting from requirements elicitation to lock functional boundaries prior to commercial contract signing and pricing estimation.

---

## 1. Project Metadata
- **Project Name**: [Application / System Name]
- **Client**: [Client Company / Organization]
- **Solo Developer / Consultant**: [Your Name]
- **Document Reference**: IDEA_BRIEF-[ID] v1.0
- **Defined Project Scale**: [Small (MVP) / Medium / Large / Enterprise]
- **Elicitation Completion Date**: [YYYY-MM-DD]

---

## 2. Business Objectives & Measurable Goals
- **Core Problem Solved**: [Brief description of client business problem]
- **Primary Project Goal**: [Example: Automation of invoice issuance workflow and receivables tracking]
- **Business Success Metrics**:
  - [Metric 1: Contract generation time reduced from 3 days to 10 minutes]
  - [Metric 2: 100% of stored documents encrypted in compliance with data privacy regulations]

---

## 3. User Role Matrix (User Roles & RBAC)

| Role Code | Role Name | Responsibility Description | Primary Access Permissions |
| :--- | :--- | :--- | :--- |
| **ROL-01** | Super Admin | Highest internal system administrator | Access all modules, audit trails, user management |
| **ROL-02** | Manager / Reviewer | Operational verifier | Approve documents, view analytics reports |
| **ROL-03** | Operational Staff | Daily data entry operator | Create drafts, send notifications, input data |
| **ROL-04** | Client / External Guest | Third-party end user | Fill public forms, apply signatures |

---

## 4. Functional Scope Breakdown (MoSCoW Breakdown)

| Feature ID | Related Module | Functional Description | Priority | Initial Acceptance Criteria |
| :--- | :--- | :--- | :---: | :--- |
| **F-01** | Authentication | Login using Email & Password / OTP | **Must** | Minimum 8 character password, rate limit after 5 failed attempts |
| **F-02** | Doc Template | Dynamic input form for 2 legal templates | **Must** | Form data validated and neatly mapped to PDF variables |
| **F-03** | PDF Engine | Render standardized A4 PDF documents | **Must** | Document generated in < 3 seconds, standard readable fonts |
| **F-04** | E-Signature | Canvas digital signature + SHA-256 hash | **Must** | Captures coordinates, IP address, user-agent, and timestamp |
| **F-05** | Document Vault | AES-256 encrypted document storage | **Must** | Download links use presigned URLs expiring in 15 minutes |
| **F-06** | Export Excel | Export document history list to .xlsx file | **Should** | Downloaded file contains date, party name, and status columns |
| **F-07** | WA Notif | Status message delivery via WhatsApp gateway | **Could** | If Fonnte/Twilio API integration is completed ahead of schedule |
| **F-08** | Multi-language | Interface in English & Mandarin | **Won't** | Formally deferred to Phase 2 future development |

---

## 5. Strict Scope Boundaries

### 5.1 In-Scope (Work DELIVERED by Developer)
1. Architectural design, database modeling, and responsive web UI for features F-01 through F-06.
2. Integration with encrypted cloud storage (AWS S3 / Cloudflare R2).
3. Provisioning of Staging server for testing and Production server for final release.
4. Compilation of user manual documentation for admins and operational staff.

### 5.2 Out-of-Scope (Work NOT INCLUDED & Cannot Be Demanded)
1. **Manual Data Entry**: Developer is not responsible for manual digitizing or data entry of client's historical physical documents.
2. **Undocumented API Customization**: Any integration into client internal systems lacking an official, documented REST API.
3. **Hardware Provisioning**: Computers, printers, scanners, or client office local network wiring.
4. **Legal Counsel**: Developer solely provides the technological platform; the legal validity and compliance of contract clauses are the sole responsibility of the client's internal legal counsel.
5. **Unlimited Revisions**: Workflow revisions beyond this document fall under billable *Change Request (CR)* agreements.

---

## 6. Client Dependency Register

*Project execution depends on the Client's timely delivery of the following dependencies:*

| Dep Code | Client Requirement | Delivery Deadline | Consequence If Delayed |
| :--- | :--- | :--- | :--- |
| **DEP-01** | Final text copy of legal template clauses (Word format) | Project Day 3 | Postponement of template form module development (F-02) |
| **DEP-02** | Cloud storage (AWS / GCS) & SMTP email credentials | Project Day 7 | Postponement of backend vault & notification setup |
| **DEP-03** | DNS Domain access for system web address configuration | Project Day 14 | Postponement of SSL provisioning and staging deployment |
| **DEP-04** | Written feedback on functional draft review sessions | Max 3 business days | Postponement of go-live target by the number of delayed days |

---

## 7. Initial Technical Assumptions & Constraints
- **Platform**: Modern browser-based web application (Chrome, Safari, Edge, Firefox).
- **Infrastructure**: Managed database and serverless/container environment for operational cost efficiency.
- **Initial Load Capacity**: Designed to handle up to [Example: 1,000 documents/month and 50 concurrent users].

---

## 8. Initial Scope Validation

This document forms the foundation for preparing the **Statement of Work (SOW), Contract Value, and Payment Milestone Schedule (Module 03)**.

- Validated by Solo Developer: **[Your Name]** (Date: [YYYY-MM-DD])
- Validated by Client PIC: **[Client PIC Name]** (Date: [YYYY-MM-DD])
