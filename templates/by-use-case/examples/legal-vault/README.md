# Legal Document Vault - Worked Example

> **Note**: This is a complete worked example showing how templates are filled out for a real project. Use these as reference when filling out the generic templates in the main `templates/` directories.

## Project Overview

**Legal Document Vault** is a document signing and secure storage application for Indonesian law firms.

**Core Features:**
- Document upload with AES-256-GCM encryption
- Dynamic form generation from JSON schemas
- PDF rendering with digital signatures
- E-signature canvas (handwritten signatures)
- Multi-party signing workflow
- Audit trail compliance (UU PDP No. 27/2022)

## Example Templates Included

### Development Execution (Module 06)
- `ARCHITECTURE_TEMPLATE.md` - Full-stack architecture with encryption layer
- `ENV_EXAMPLE_TEMPLATE.md` - Environment variables for vault encryption
- `TODO_TEMPLATE.md` - Implementation checklist with signing features
- `RUNBOOK_LOCAL_TEMPLATE.md` - Local development setup with R2 storage
- `VERIFY_LOCAL_TEMPLATE.md` - Verification steps including vault encryption tests

### QA & Testing (Module 06-07)
- `SECURITY_AUDIT_TEMPLATE.md` - Security test cases with IDOR, encryption, PDP compliance
- `SIT_WORKBOOK_TEMPLATE.md` - Integration tests for document flows
- `UAT_WORKBOOK_TEMPLATE.md` - User acceptance test cases

### Release & Operations (Module 07-08)
- `HANDOVER_PROTOCOL_TEMPLATE.md` - Production infrastructure handover
- `ROLLBACK_PLAN_TEMPLATE.md` - Emergency rollback with database restore
- `INCIDENT_RESPONSE_TEMPLATE.md` - Example RCA for slow document queries

## How to Use This Example

1. **Study the patterns**: See how generic placeholders (`[Project Name]`) are replaced with specific values
2. **Adapt for your project**: Copy the structure and replace Legal Vault specifics with your domain
3. **Reference during implementation**: Use as a checklist to ensure completeness

## Generic Templates

For blank templates to fill out, use the files in:
- `templates/04-dev-execution/`
- `templates/06-qa-uat/`
- `templates/07-release-handover/`
- `templates/08-maintenance-ops/`

---

**Created**: 2026-10-03  
**Purpose**: Educational worked example for solo-project-lifecycle
