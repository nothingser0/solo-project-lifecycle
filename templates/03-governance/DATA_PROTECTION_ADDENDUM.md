# Data Protection Addendum (DPA) Template

> **Purpose**: Bind the controller/processor split, security duties, and breach-notification deadlines into the commercial contract whenever the project processes personal data.
> **When**: M03 Legal SOW & Charter — signed together with the SOW (Medium+) or MSA (Large), **before** the Developer touches live personal data.
> **Target**: Client delivery handling personal data; mandatory under **UU PDP No. 27/2022**. Enterprise / regulated clients pair it with `DATA_CLASSIFICATION_POLICY.md`, `DATA_RETENTION_POLICY.md`, and `SLA_SLO_DEFINITIONS.md`.
> **Target file location**: `contracts/DATA_PROTECTION_ADDENDUM.md` (or `docs/pm/DATA_PROTECTION_ADDENDUM.md`) — recorded in the SOW's M03 Gate Confirmation Log.

> ⚠️ **LEGAL DISCLAIMER**: This is an operational engineering draft, NOT legal advice. It requires professional legal review before signature, especially for regulated data (health, finance, minors).

---

## 1. Roles & Scope

| Item | Entry |
| :--- | :--- |
| **Client (Controller)** | [Client Company / PT / CV Name] |
| **Developer (Processor)** | [Your Name / Independent Software Consultant], acting as a data processor acting on documented instructions only |
| **Sub-processors** | e.g., cloud hosting (AWS/Vercel), database (Supabase/Neon), email (Resend/SendGrid), payments (Midtrans/Xendit) — all under the **Client's** corporate account |
| **Categories of Data Subjects** | e.g., end customers, employees, agents |
| **Categories of Personal Data** | e.g., name, phone/WhatsApp, email, address, transaction history |
| **Special-category data** | [none / health / biometric / financial detail — restricted processing] |
| **Processing purpose** | Build, run, and maintain the application described in `SCOPE_STATEMENT.md` / `FSD.md` |
| **Processing duration** | Project term + warranty period; data is returned/deleted per §5 |

---

## 2. Controller Obligations (Client)

1. The Client is the **controller**: it determines the purpose and lawful basis for processing.
2. The Client warrants it has a lawful basis (consent / contract / legal obligation) and has issued the required privacy notice to data subjects.
3. The Client supplies data only to the extent necessary, minimised and accurate.
4. The Client owns the third-party accounts (hosting, database, gateway) — the Developer is never the account owner of record.

---

## 3. Processor Obligations (Developer)

1. Process personal data **only** on the Client's documented instructions and only for the purposes in §1.
2. Ensure staff/agents with access are bound by confidentiality.
3. Implement appropriate technical and organisational security measures (see §4).
4. Do **not** engage a new sub-processor or transfer data cross-border without the Client's prior written authorisation.
5. Assist the Client in responding to data-subject requests (access, correction, deletion, objection) within the agreed SLA.
6. Do **not** use personal data for the Developer's own purposes, marketing, or model training. Portfolio/screenshot rights cover sanitised, non-personal project descriptions only.

---

## 4. Security Measures (Minimum Baseline)

- Encryption in transit (TLS 1.2+) and at rest for databases/backups.
- Least-privilege, per-role access control; MFA on all infrastructure accounts.
- **Zero secrets in source control**: credentials live in `.env.local` / a managed secret store, never in git-tracked files.
- Audit logging of administrative actions; log retention per `DATA_RETENTION_POLICY.md`.
- Secure SDLC: TDD + the M07 security baseline (`SECURITY_AUDIT.md`) before production.
- Encrypted, tested backups with documented restore drill.

---

## 5. Data Subject Rights, Retention & Deletion

1. The Developer supports data-subject requests within **[5] business days** of a Client request.
2. Retention follows `DATA_RETENTION_POLICY.md` ("no longer than the processing purpose requires").
3. On termination, the Developer returns or irrevocably deletes personal data within **[30] calendar days**, except where law requires longer retention, then certifies deletion in writing.

---

## 6. Personal Data Breach Notification

> **UU PDP Article 46 / PP 71/2019**: the controller notifies affected data subjects and the authority within **3×24 hours (72 hours)** of becoming aware.

1. The Developer notifies the Client **without undue delay and no later than 24 hours** after becoming aware of a breach — hours earlier than the statutory clock, so the Client can meet its own 72-hour duty.
2. The notification states: nature of the breach, categories and approximate number of data subjects/records, likely consequences, and measures taken or proposed.
3. The Developer cooperates with the Client's investigation, remediation, and any authority/regulator communication, at no extra fee for breaches caused by Developer negligence.
4. Root-cause review and remediation log recorded in `templates/03-governance/INCIDENT_RESPONSE_PLAN.md`.

---

## 7. Liability, Governing Law & Execution

1. This DPA forms part of the SOW/MSA and is governed by the law of **the Republic of Indonesia**, including UU PDP No. 27/2022.
2. On conflict, the **MSA > SOW > this DPA > NDA** order applies for legal principles; for data-protection terms, this DPA prevails over the SOW.
3. Liability is capped in line with the SOW's Limitation of Liability clause.
4. The Developer's liability does not extend to breaches caused by the Client's own handling of credentials or its lawful-basis failure.

> ℹ️ Electronic signatures and e-Meterai are recognised under UU ITE No. 19/2016 Art. 5 jo. PP 71/2019.

| FIRST PARTY (Client / Controller) | SECOND PARTY (Developer / Processor) |
| :---: | :---: |
| [Client Company Name] | Independent Software Consultant |
| **Name**: [Client PIC Name] | **Name**: [Your Name] |
| **Title**: [Client Title] | **Title**: Independent Lead Engineer |
| Date: _____________________ | Date: _____________________ |

---

## Checklist (before signature)

- [ ] Roles (controller/processor) and sub-processors listed
- [ ] Categories of data subjects and personal data recorded
- [ ] Security baseline accepted (§4)
- [ ] Breach notification deadline (≤24h to Client / 72h statutory) accepted
- [ ] Retention + deletion schedule cross-checked against `DATA_RETENTION_POLICY.md`
- [ ] Professional legal review completed for regulated/special-category data
- [ ] Recorded in the SOW's **M03 Gate Confirmation Log** (`DPA signed`)
