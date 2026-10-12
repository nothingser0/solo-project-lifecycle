# Module 11 Deep Dive: Handover — Training Quota, Credential Vault, Repo Transfer & BAST Signing

> Companion to `docs/modules/11-handover-bast.md` (runbook). This file holds the detailed execution steps; the runbook keeps a condensed summary.

## Step 1 (Detail): User Training Session (Training Quota Management)
To prevent the solo developer from being turned into an indefinite free operational helpdesk:
- **Standard Quota**: Maximum **2 online meeting sessions** (@ 60 minutes via Zoom/Google Meet):
  - *Session 1*: Staff daily operational workflow (Data entry, document creation, approval flow).
  - *Session 2*: Super Admin system management (User management, access permissions, audit trail, data export).
- **Training Assets**: Record the training sessions and deliver the recordings alongside the **`USER_MANUAL.md`** file so future new client staff can onboard independently without contacting the developer again.

## Step 2 (Detail): Credential Handover Protocol (Zero Plaintext Sharing)
Sending server passwords, database master keys, or API secrets via WhatsApp chat or unencrypted plaintext email is strictly prohibited.

**Template**: `templates/07-release-handover/CREDENTIALS_VAULT.md` (1Password/Bitwarden setup guide)

- Use secure one-time channels such as **Bitwarden Send**, **1Password**, or **Yopass** (encrypted links that automatically self-destruct after being opened once).
- **Recommended**: Set up shared vault (1Password/Bitwarden) for permanent credential access during warranty period.
- Summarize the inventory of handed-over accounts in the **`HANDOVER_PROTOCOL.md`** file.

**Credentials to hand over**:
- Production admin login
- Staging admin login
- Database credentials
- API keys (payment, email, storage)
- Hosting/cloud provider access
- Domain/DNS management
- Git repository access

**Best Practice**: Client changes all passwords within 7 days post-handover for security ownership transfer.

## Step 3 (Detail): Git Repository Ownership Transfer
1. Go to GitHub / GitLab project settings:
   - Select **"Transfer Ownership"** → Enter the Client organization account name.
2. Ensure the Client promotes their designated technical Single PIC as the new Owner.
3. Remove your Personal Access Tokens (PAT) from the client's CI/CD settings and replace them with tokens owned by the client organization.

## Step 4 (Detail): Formal BAST Signing
1. Prepare the **`BAST_TEMPLATE.md`** document containing:
   - Breakdown of handed-over deliverables (Git source code, live URL, User manual).
   - Sign-off confirming the system has been properly accepted.
   - Formal statement of the start and end dates of the **Warranty Period (Module 12)**.
2. Affix a physical Rp 10,000 duty stamp (meterai) (or official e-Meterai) and co-sign with the Client Single PIC.

---

## Post-Project Retrospective (Optional — Internal Only)

After handover completion and final payment clearance, conduct internal retrospective using **`templates/08-maintenance-ops/PROJECT_RETROSPECTIVE_TEMPLATE.md`** (10.74 KB):

**Purpose**: Capture lessons learned for continuous skill improvement and process refinement.

**Structure**:
- **What went well**: Successful practices, tools, workflows to repeat
- **What went wrong**: Mistakes, blockers, technical debt sources
- **Lessons learned**: Concrete takeaways and action items
- **Process improvements**: Changes to templates, workflows, or client communication for next project

**Audience**: Internal team only (not client-facing)
**Duration**: 1-2 hours self-reflection or team discussion
**Output**: Retrospective notes stored in project archive for future reference

**When to use**: All scales. Recommended after every project to build systematic improvement habits.

> Summary for the runbook: 2-session training quota (recordings + USER_MANUAL.md), zero-plaintext credential handover via Bitwarden/1Password, Git ownership transfer with PAT rotation, and BAST signing with Rp 10,000 e-Meterai — all gated behind 100% payment confirmation.
