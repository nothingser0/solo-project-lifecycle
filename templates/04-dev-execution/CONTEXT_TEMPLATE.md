# CONTEXT.md

> Business context, scope boundaries, and project domain model to guide AI coding agent understanding.

---

## 1. Product Summary & Business Problem
- **Product Name**: [Application Name]
- **Core Problem**: [Brief explanation of the problem faced by users]
- **Core Solution**: [How this application solves that problem]

---

## 2. Core User Loop
1. **Step 1 (Input)**: [Example: Staff logs in, selects template, and fills form variables]
2. **Step 2 (Process)**: [Example: System renders PDF, encrypts to vault, and issues signature link]
3. **Step 3 (Output)**: [Example: Signer places digital signature, document status becomes LOCKED]

---

## 3. User Roles & RBAC Matrix

| Role | Access Rights | Action Restrictions |
| :--- | :--- | :--- |
| **Super Admin** | Full access to all data, audit trail, user management | Prohibited from modifying documents with `SIGNED` status |
| **Manager** | Approve document drafts, send e-sign requests | View data within assigned division only |
| **Staff** | Fill input forms for new document drafts | Cannot approve or issue final documents |
| **Signer (Guest)** | One-time access via secret token for signing | Has no system login account |

---

## 4. Absolute Scope Boundaries

### In-Scope (Mandatory)
- [Feature list per SCOPE_STATEMENT.md]

### Out-of-Scope (PROHIBITED - Do Not Hallucinate)
- AI agents are PROHIBITED from adding features outside the following list without explicit instructions:
  1. Do not build an e-commerce/shopping cart system unless requested.
  2. Do not build an AI recommendation chatbot or complex analytics features.
  3. Do not add multi-language support beyond the primary language specified.
  4. Do not build manual payment systems outside the agreed payment gateway.

---

## 5. Domain Glossary
- **Document Vault**: Isolated cloud storage where PDF files are encrypted using AES-256-GCM.
- **Audit Trail**: Permanent immutable record containing UTC timestamp, IP address, and document SHA-256 hash.
- **Signer Token**: Unique one-time hashed token with a 7-day expiration for signers.
