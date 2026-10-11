# Service Agreement & Statement of Work (SOW)

> Commercial service agreement binding rights, obligations, compensation value, payment terms, project governance, and legal protections between the Client and the Solo Developer.

---

## PART I: PROJECT CHARTER & GOVERNANCE

### 1. Initiation Metadata
- **System / Project Name**: [Application / System Name]
- **Client Party**: [Client Company / Organization Name]
- **Lead Developer / Consultant**: [Your Name]
- **Scale Classification**: [Small (MVP) / Medium / Large / Enterprise]
- **Target Start Date**: [YYYY-MM-DD]
- **Target Go-Live Release Date**: [YYYY-MM-DD]

---

### 2. Business Objectives & Success Metrics
- **Project Background**: [Explain the background and project urgency for the client]
- **Measurable Goals**:
  - [Goal 1: Example: 100% paperless administrative workflow automation]
  - [Goal 2: Example: Order processing cycle time reduced by $\ge 50\%$]

---

### 3. Absolute Client Single PIC Appointment

To prevent conflicting directions and ensure solo developer execution efficiency, the Client appoints:

- **Full Name of PIC**: [Client PIC Name]
- **Official Title**: [Product Owner / IT Manager / Operations Director]
- **Email & WhatsApp Contact**: [email@company.com / +628...]
- **Exclusive Authority of PIC**:
  1. The sole party authorized to provide formal approval for PRD, FSD, and UI/UX design changes.
  2. The sole party authorized to sign UAT test sheets and the Official Acceptance Report (BAST).
  3. Instructions or change requests from other client staff are **NOT RECOGNIZED** until confirmed in writing by the PIC above.
- **Client Response SLA**: The Client PIC is required to provide written feedback or approval within a maximum of **3 (three) business days**. Response delays automatically shift the system release target day-for-day without delay penalties for the developer.
- **Deemed Acceptance (Klausul Klien Diam)**: If the Client fails to provide written feedback, change requests, or defect reports within **7 (seven) calendar days** following a milestone demo submission or UAT delivery, the respective milestone shall be **LEGALLY DEEMED APPROVED AND ACCEPTED IN FULL (DEEMED ACCEPTED)**. The associated milestone invoice shall become immediately due and payable.
- **Revision Limits**:
  - UI/UX Design (M04): Maximum **2 (two) rounds** of minor visual revisions. Fundamental direction changes post-Design Freeze require a paid Change Request.
  - User Acceptance Testing (M09): Maximum **2 (two) test cycles**. UAT approval may NOT be withheld due to low-severity cosmetic defects (S3/S4) which are deferred to warranty.

---

### 4. Milestone Summary & Release Schedule

| Milestone | Key Deliverable | Target Timeline | Associated Payment Status |
| :---: | :--- | :--- | :---: |
| **M-01** | Scope, Charter, & SOW Agreed | T0 (Kickoff) | Milestone 1 (Down Payment Received) |
| **M-02** | UI/UX Prototyping & Architecture (FSD) | T0 + 2 weeks | Prerequisite to Start Coding |
| **M-03** | Core Backend & Alpha Release | T0 + 5 weeks | Milestone 2 (Alpha Settlement) |
| **M-04** | Complete Integration & Staging (SIT Pass) | T0 + 8 weeks | Milestone 3 (Beta Settlement) |
| **M-05** | UAT Pass & Production Go-Live | T0 + 11 weeks | Milestone 4 (100% Final Settlement) |
| **M-06** | Repository Handover & Signed BAST | T0 + 12 weeks | Project Completed / Warranty Active |

---

## PART II: COMMERCIAL AGREEMENT (SOW CONTRACT)

### 1. Identification of Parties

This Agreement is made and entered into on this day, [Day], date [Date], month [Month], year [Year], by and between:

1. **FIRST PARTY (Client)**:
   - Company Name: [Client PT / CV / Organization Name]
   - Address: [Client Full Office Address]
   - Represented by: [Client PIC / Director Name]
   - Title: [Official Title]
   - Hereinafter referred to as the **"Client"**.

2. **SECOND PARTY (Developer)**:
   - Full Name: [Your Name]
   - Address / Domicile: [Your Domicile Address]
   - ID Number (NIK / NPWP / Tax ID): [Identity / Tax Number]
   - Acting as: Independent Software Engineering Professional Consultant
   - Hereinafter referred to as the **"Developer"**.

---

### 2. Scope of Work

1. The Developer is obligated to build the software in accordance with the feature details set forth in the attached document **SCOPE_STATEMENT.md** (Appendix I).
2. Any items not explicitly specified in writing in Appendix I are legally deemed **Out-of-Scope** and cannot be demanded as Developer obligations.

#### Scope Baseline Summary

**Primary In-Scope**:
1. [Module/Feature 1]
2. [Module/Feature 2]
3. [Third-Party Service Integration X]
4. [Staging and Production Deployment]

**Absolute Out-of-Scope**:
1. [Manual data entry of historical physical paper records]
2. [Provision of custom creative assets (paid illustrations/photography)]
3. [Maintenance of client local office network hardware]
4. [On-call support outside agreed business working hours]

---

### 3. Compensation Value & Payment Milestone Schedule

1. **Total Contract Value**: Rp [Numeric Amount] (*[Amount in words in Rupiah]*), exclusive of Value Added Tax (VAT/PPN) and third-party infrastructure subscription fees (servers, cloud storage, paid APIs).
   - **Tax Regulatory Clause**: Applicable taxes (PPN 11% under UU HPP No. 7/2021, and PPh 23 if corporate client) follow statutory tax regulations in force upon invoice issuance.
2. **Payment Milestones (Must sum to exactly 100%)**:
   
   *Standard 3-Phase Schedule (Recommended for Medium Scale 30/40/30)*:
   - **Milestone 1 (Down Payment / DP 30%)**: Rp [Amount], payable upon contract signing as strict prerequisite to commencing design & architecture.
   - **Milestone 2 (Mid-Point Staging Demo 40%)**: Rp [Amount], payable immediately upon successful live staging demonstration of core P0 flows (M06) before entering final UAT.
   - **Milestone 3 (Final Settlement 30%)**: Rp [Amount], payable after UAT pass and prior to DNS production pointing, repository transfer, and BAST handover (M11).
   *(Total: 30% + 40% + 30% = 100%)*

   *Alternative 2-Phase Schedule (For Small Fast-Track 50/50)*:
   - **Milestone 1 (Down Payment 50%)**: Rp [Amount], upon signing before design.
   - **Milestone 2 (Final Settlement 50%)**: Rp [Amount], upon UAT approval prior to BAST handover.
3. **Official Payment Account**:
   - Bank: [Bank Name, e.g., Bank Central Asia]
   - Account Number: [Account Number]
   - Account Holder Name: [Account Holder Name Matching Developer Identity]

---

### 4. Client Dependencies & Execution Schedule

1. The Client is required to deliver all data, account access credentials, and materials listed in the Client Dependency Register in a timely manner.
2. In the event that the Client delays the submission of materials or review feedback exceeding **3 (three) business days**, the project completion target date shall automatically shift by the number of days of delay without penalty to the Developer.

#### Client Dependency Register
| Dep ID | Client Obligation | Target Delivery Date | Impact If Delayed |
|:------:|:------------------|:---------------------|:------------------|
| **DEP-01** | Payment gateway sandbox credentials & SMTP keys | T0 + 7 calendar days | Halts billing and transactional email integration |
| **DEP-02** | Clean master data in agreed CSV/Excel template | T0 + 10 calendar days | Delays database seeding and integration testing |
| **DEP-03** | DNS domain and cloud hosting credentials | T0 + 21 calendar days | Postpones staging SSL and production deployment |
| **DEP-04** | Formal feedback on milestone demos (Single PIC) | Max 3 business days | Shifts go-live date day-for-day without liability |

---

### 5. Change Request (CR) Procedure

1. Should the Client desire feature additions, workflow changes, or design adjustments beyond the initial agreement, the Client must submit a written request to the Developer.
2. The Developer reserves the right to propose additional cost adjustments and timeline extensions (*Change Request Sheet*).
3. Change request work will only be executed after the CR sheet is approved and paid by the Client.

---

### 5.1 Third-Party Subscriptions & Infrastructure Costs
1. All recurring costs for third-party services—including but not limited to domain registration, cloud hosting/VPS (AWS/Vercel/DigitalOcean), transactional email (Resend/SendGrid), WhatsApp Gateway API (Fonnte/Wablas), database services, and payment gateway transaction fees—are **the sole financial responsibility of the Client**.
2. All third-party accounts and subscriptions **MUST be registered under the Client corporate name and billed directly to the Client credit card**. The Developer shall never front or absorb third-party operational costs.

### 5.2 Project Suspension, Kill Fee & Termination
1. **Late Payment Penalty**: Invoices overdue by more than 7 (seven) calendar days will incur a late interest charge of **1% per calendar week**.
2. **Project Pause**: The Developer reserves the right to suspend development and staging server access if client dependency submission or payment is overdue by more than 10 calendar days. Resuming a paused project requires an administrative restart fee of 5% of total contract value.
3. **Client Termination & Kill Fee**: Should the Client terminate this agreement without Developer breach:
   - The 30% Down Payment is strictly non-refundable.
   - Work completed beyond the latest paid milestone will be billed prorata based on completed TODO.md sprint tasks.

### 5.3 Developer Portfolio & Legal Review Disclaimer
1. **Portfolio Rights**: The Developer retains the irrevocable right to showcase screenshots, sanitized architecture case studies, and non-confidential project descriptions in professional portfolios and marketing materials unless expressly prohibited via a signed separate NDA.
2. **Legal Review Disclaimer**: This document is an operational engineering contract drafted by an independent technical consultant. Both parties acknowledge that independent legal counsel review is recommended.

### 6. Intellectual Property Rights

1. All source code, architectural designs, and software digital assets remain the intellectual property of the Developer until the full project compensation value (100%) has been paid in full by the Client.
2. The transfer of usage rights (license) or full ownership to the Client shall only take effect from the date of signing the **Official Handover Report (BAST)** after full payment has been settled.

---

### 7. Limitation of Liability

1. The Developer warrants that the software is built using industry-standard software engineering practices and is free of malicious code.
2. The Developer shall not be liable for indirect business losses, lost profits, operational disruptions, or regulatory fines incurred by the Client arising from the use of this software.
3. The maximum total legal liability and financial indemnification of the Developer to the Client under any circumstances is strictly limited to the **total amount of money received by the Developer** under this agreement.

---

### 8. Data Confidentiality & Privacy Compliance (UU PDP)

The Parties agree to maintain the confidentiality of business information, technical data, and personal data in accordance with applicable data protection laws (such as Law No. 27 of 2022 on Personal Data Protection - UU PDP). Confidential information must not be disclosed to third parties without prior written consent from the data owner.

---

### 9. Warranty Period

1. The Developer provides a bug fixing warranty period for **[30 / 60 / 90] calendar days** commencing from the signing of the BAST.
2. The warranty applies exclusively to genuine errors/bugs where the system does not perform in accordance with agreed FSD/PRD documents.
3. The warranty is void if source code is modified by third parties without the Developer's consent, or if issues arise from abrupt third-party API changes.

---

### 10. Execution of Agreement

This Agreement is executed in duplicate (2 copies), sufficiently stamped with legal duty stamp (Rp 10,000 per Law No. 10/2020 Article 3 paragraph 1, verified current), and holds equal legal force for both parties.

> ℹ️ **Legal Note**: Electronic signatures and electronic duty stamps (e-Meterai via official provider Pos Fin / Peruri) are recognized as legally binding under UU ITE No. 19/2016 Article 5 jo. PP 71/2019.

| FIRST PARTY (Client) | SECOND PARTY (Developer) |
| :---: | :---: |
| [Client Company Name] | Independent Software Consultant |
| *(e-Meterai / Duty Stamp Rp 10,000)* | *(e-Meterai / Duty Stamp Rp 10,000)* |
| **Name**: [Client PIC Name] | **Name**: [Your Name] |
| **Title**: [Client Title] | **Title**: Independent Lead Engineer |
| Date: _____________________ | Date: _____________________ |
