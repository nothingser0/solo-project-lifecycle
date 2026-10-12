# Module 07 Deep Dive: Enterprise Advisory (A04) & SIT Sandbox Walkthrough

> Split from `docs/modules/07_QUALITY_ASSURANCE_SIT.md` (light split). Content below is verbatim from the original module.

---

### 🔴 Enterprise Scale: Routed to Non-Solo Capacity Advisory (Phase A04)

> ⚠️ **SOLO CAPACITY LIMITATION ENFORCEMENT**:  
> Projects classified as **Enterprise Scale** (≥ 26 P0 features, legacy core migrations, or strict regulatory statutory mandates) **EXCEED SOLO DEVELOPER CAPACITY**.  
> Solo developers MUST NOT perform enterprise-scale manual QA, multi-tenant penetration testing, or independent SOC 2 audits single-handedly.  
> Instead, the solo consultant executes **Phase A04 (Security Review, Threat Modeling, & Audit Readiness)** to produce security governance specifications, review vendor test reports, and coordinate certified third-party audit firms.

**Compliance Audit Preparation**:
- `templates/03-governance/SOC2_ISO27001_COMPLIANCE.md` - Trust Service Criteria, evidence collection (6-12 month audit prep)
  - **Covers**: Security controls, access reviews, encryption, change management, monitoring
  - **Evidence needed**: 6 months of logs, access review records, vulnerability scan reports, training completion
  - **Why**: Enterprise clients require SOC 2 Type II before signing (or as contract milestone)

**Incident Response Planning**:
- `templates/03-governance/INCIDENT_RESPONSE_PLAN.md` - Security incident playbook (P0-P4 severity, escalation procedures)
  - **Covers**: Detection, containment, eradication, recovery, post-mortem
  - **Escalation contacts**: Tech Lead, Security Lead, Client PIC, Legal (for breach notification)
  - **Why**: SOC 2 requires documented incident response procedures (tested quarterly)

**Backup & Disaster Recovery**:
- `templates/08-maintenance-ops/BACKUP_RESTORE_PROCEDURES.md` - Daily backups, quarterly restore tests
  - **Covers**: Automated backup schedules, offsite storage, encryption, restore procedures
  - **Testing**: Quarterly restore drill (prove backups work)
  - **Why**: ISO 27001 requires tested backup procedures (not just "we have backups")

**Data Retention & Compliance**:
- `templates/03-governance/DATA_RETENTION_POLICY.md` - Retention periods (7yr financial, 1yr logs, 30 days deleted accounts)
  - **Covers**: GDPR/PDP Law retention rules, automated deletion, legal holds
  - **Why**: Sanksi administratif UU PDP No. 27/2022 Pasal 57 untuk retensi data ilegal (denda hingga 2% pendapatan tahunan)

**Advisory Gate for Enterprise (Phase A04)**:
- Security Architecture Review completed (A02 STRIDE/C4 phase — `docs/modules/A00_ENTERPRISE_ADVISORY_SERIES.md`)
- Third-party penetration testing firm scoped & rules of engagement locked (`PENTEST_SCOPE_TEMPLATE.md`)
- Incident response plan documented & reviewed with client steering committee
- Audit readiness dossier handed over to enterprise compliance team

---

## Verbose Step 2 SIT Sandbox Walkthrough

**IMPORTANT**: SIT is conducted with **dummy/seed data** in the Staging environment. Real client data is **NOT** imported until SIT passes (Module 08).

Test all integration points to third-party services in sandbox environments:
1. **Payment Gateway Sandbox**:
   - Fire a successful payment webhook payload → Ensure order status updates to `PAID` and inventory is locked.
   - Fire an expired/failed payment webhook → Ensure status updates to `CANCELLED`.
2. **Document Vault Storage**:
   - Upload a document file → Ensure file is stored in the storage bucket in encrypted binary format.
   - Retrieve presigned URL → Ensure file can be downloaded and decrypted completely within the 15-minute expiry limit.
3. **Transactional Email**:
   - Test OTP email delivery → Ensure it arrives in the tester's inbox with properly formatted template.

> Summary for the runbook: validate Payment (success/failed webhooks), Vault storage (encrypted upload + presigned URL within 15-min expiry), and Transactional Email (OTP delivery) using dummy/seed data only — real client data is imported in Module 08 after SIT passes.
