# Solo Developer Feasibility Criteria Guide

This document is an objective reference rubric for evaluating the feasibility of a software idea for solo developers before agreeing to commitments or writing code.

---

## 1. Four Dimensions of Solo Developer Feasibility

### 1.1 Technical Feasibility
As a solo developer, your margin for technical failure is razor-thin. Avoid the "Research & Development (R&D) Trap".

* **Score 5 (Highly Feasible)**: Uses a proven stack (Boring Tech), popular open-source libraries (>5k GitHub stars), and third-party APIs with official documentation (OpenAPI/Swagger) and stable SDKs.
* **Score 3 (Feasible with Reservations)**: Requires integrating third-party systems with minimal documentation, or background workers requiring careful failover handling.
* **Score 1 (Red Flag / Infeasible)**: Requires training AI models from scratch, reverse-engineering private/closed APIs without authorization, custom hardware integration without simulators, or unstable dependencies.

### 1.2 Solo Bandwidth & Operational Feasibility
A solo developer has an average productive capacity of **120–160 productive hours per month**.

* **Score 5 (Highly Feasible)**:
  - Architecture based on PaaS/Serverless (Vercel, Supabase, Cloudflare, Railway) with zero server maintenance.
  - Automated business workflows without daily manual developer intervention (self-service).
* **Score 3 (Feasible with Reservations)**:
  - Requires self-managed VPS setup (Docker, Nginx, cron backups) needing weekly monitoring.
* **Score 1 (Red Flag / Infeasible)**:
  - Requires 24/7 manual operational support tickets.
  - Fragmented microservice architectures that burden local debugging.

### 1.3 Compliance & Legal Feasibility
Regulatory violations in Indonesia can lead to administrative sanctions and criminal liability.

* **Personal Data Protection (UU PDP No. 27/2022)**:
  - *Rule*: If the application collects national ID (KTP) data, health data, financial data, or children's data, encryption in transit and at rest, explicit consent, and data deletion mechanisms are mandatory.
* **Electronic Signature Regulations (UU ITE & PP 71/2019)**:
  - *Uncertified Signatures* (Canvas/Email OTP): Legally valid under UU ITE No. 19/2016 Article 5 jo. PP 71/2019 (supersedes Civil Code 1865/1866 for electronic transactions), but carry weaker evidentiary weight in court if contested.
  - *Certified Signatures (PSrE)*: Mandatory to use Kominfo-licensed providers (Privy, VIDA, Peruri) when handling high-stakes legal or banking documents.
* **Financial Regulations (Bank Indonesia / OJK)**:
  - Solo developers are **STRICTLY PROHIBITED** from storing raw credit card details in databases. Always use licensed Payment Gateways (Midtrans, Xendit, Doku) with PCI-DSS Level 1 certification.
* **Mandatory Disclaimer Clauses**:
  - For legal-tech/health-tech products: Applications must prominently display disclaimers stating that the system is a supporting technology provider, not a substitute for licensed attorneys or doctors.

### 1.4 Economic & Project Value Feasibility
* **For Independent Products (SaaS/Micro-app)**:
  - *Willingness to Pay Test*: Are prospective users already spending money to solve this problem today? If they currently rely on free workarounds and are unwilling to pay, the idea carries high financial risk.
* **For Client Projects**:
  - *Value-to-Time Ratio*: Contract value divided by estimated working hours must meet your minimum professional hourly rate.
  - If a client demands enterprise-scale scope on a shoestring budget, the project must be rejected or trimmed down to a basic MVP.

---

## 2. Automatic "Kill Switch" Red Flags

If any of the following conditions are encountered, **ABORT THE PROJECT OR PIVOT DECISIVELY**:

1. **Bypassing / Illegal Scraping**: The client requests building a bot/scraper to extract data from third-party platforms that explicitly prohibit automated scraping in their Terms of Service.
2. **Unauthorized API Dependencies**: The core business relies on an undocumented/private API of another platform that could be shut down at any moment.
3. **Large Team Expectations at Solo Rates**: The client demands 24/7 support availability and 99.99% uptime SLAs without paying infrastructure surcharges and monthly retainers.
4. **Lack of Authorized Decision Maker**: The client cannot designate a Single PIC, causing project requirements to change direction at every meeting.
