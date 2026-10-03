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
