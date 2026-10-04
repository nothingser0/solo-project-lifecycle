# Technical & Credential Handover Protocol

> Handover certificate for digital assets, source code repository (*Git Repository*) ownership transfer, and production infrastructure account transfer to the Client.

---

## 1. Handover Metadata
- **System Name**: [Application Name]
- **Client Party**: [Client Company Name]
- **Credential Recipient (Client PIC)**: [Client PIC Name & Official Email]
- **Asset Handover Lead (Lead Developer)**: [Your Name]
- **Execution Date**: [YYYY-MM-DD]

---

## 2. Transferred Digital Asset Inventory

| Asset Category | Service / Account Name | Identifier / URL | Transfer Method | Transfer Status |
| :--- | :--- | :--- | :--- | :---: |
| **Code Repository** | GitHub / GitLab | `github.com/[client-org]/[repo-name]` | Organization Ownership Transfer | [x] COMPLETED |
| **Hosting Server** | Cloudflare / Vercel / VPS | `app.client.com` | Primary Account Owner Invitation | [x] COMPLETED |
| **Database** | Managed PostgreSQL | Host: `prod-db.[client].com` | Encrypted Master Credentials Handover | [x] COMPLETED |
| **Storage Vault** | Cloudflare R2 / AWS S3 | Bucket: `[project-name]-prod` | Bucket IAM Access Rights Transfer | [x] COMPLETED |
| **Payment Gateway** | Midtrans / Stripe / Xendit | Merchant ID: `[MID_12345]` | LIVE Mode Transferred to Client Account | [x] COMPLETED |
| **Email SMTP** | Resend / SendGrid | Domain: `clientdomain.com` | Email Dashboard Ownership Transfer | [x] COMPLETED |

---

## 3. Credential Transmission Security Protocol (Zero Plaintext)

1. All master passwords, API secret keys, and database connection strings **MUST NOT BE TRANSMITTED VIA CHAT OR PLAINTEXT EMAIL**.
2. Credentials are transmitted using end-to-end encrypted one-time links (*End-to-End Encrypted One-Time Link*) via **[Bitwarden Send / 1Password / Yopass]**.
3. The Client has accessed the link and confirmed that all credentials were successfully copied and rotated (*password rotated*) by the Client's internal team.

---

## 4. Developer Access Revocation & Release of Responsibility

Upon completion of the root account handover process above:
- The Developer has revoked all personal access tokens (*Personal Access Tokens*) and developer SSH keys from the repository and production servers.
- The Client assumes full responsibility for password confidentiality and internal staff access management starting from the date of this signing.

| Received by Client Single PIC | Handed over by Solo Developer |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title**: ________________________ | **Title**: Independent Lead Software Engineer |
| **Date**: _________________________ | **Date**: _________________________ |
| **Signature**: | **Signature**: |

---

## 5. Handover Package Checklist

**Required Attachments** (MUST be included with this handover):

- [ ] **WARRANTY_POLICY.pdf** - 30-day bug fix coverage terms
  - Location: `templates/08-maintenance-ops/WARRANTY_POLICY_SMALL.md` (convert to PDF)
  - Purpose: Defines what's covered vs out-of-scope post-handover
  - Client MUST acknowledge receipt and understanding

- [ ] **USER_MANUAL.pdf** (if applicable) - End-user documentation
  - Screenshots of key features
  - Step-by-step usage instructions

- [ ] **ADMIN_GUIDE.pdf** (if applicable) - Admin panel documentation
  - User management procedures
  - System configuration guide

- [ ] **RUNBOOK.md** (if applicable) - Operations manual
  - Deployment procedures
  - Troubleshooting common issues
  - Backup/restore procedures

**Handover Email Template**: For small projects, use `templates/07-release-handover/BAST_EMAIL_SMALL.md` format with warranty policy attached.

**Critical Reminder**: 
- Do NOT send handover email without WARRANTY_POLICY attachment
- Client's acknowledgment of warranty terms prevents post-launch disputes
- Save client's acknowledgment email as PDF for legal records

---

## 6. Post-Handover Support

**Warranty Period**: 30 days from handover date  
**Coverage**: Bug fixes only (see WARRANTY_POLICY.pdf for details)  
**Contact**: [developer-email@example.com]  
**Response SLA**: Per severity (S1: 4h, S2: 24h, S3: 3d, S4: 7d)

**Post-Warranty Options**:
- Pay-per-incident: Quoted per issue
- Monthly retainer: Ongoing support contract
- No support: Client maintains internally
