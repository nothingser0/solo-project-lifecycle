# Go-Live Verification Report (PVT & Production Cutover)

> **Purpose**: Record release identity, human decision, deployment evidence, post-deployment checks, telemetry, and recovery readiness.
> **Module**: M10 — Production Deployment
> **Status**: PENDING — complete only after human-led deployment and verification.

## 1. Release and Environment

| Attribute | Value / evidence |
| :--- | :--- |
| Project / release | [name and version or provider release ID] |
| Source commit / artifact ID | [immutable identifier] |
| Deployment target / environment | [provider, project, environment] |
| Release owner / human operator | [name] |
| Deployment window / timezone | [date, start/end, timezone] |
| CI / build result | [run/build URL and result] |
| Production URL | [URL, if public; otherwise N/A with reason] |
| Domain / TLS result | [evidence or N/A with reason] |

## 2. Release Decision and Change Controls

Human decision: [GO / NO-GO / PENDING]
Decision maker and date: [name / date]
- **M09 UAT decision**: [reference or N/A with reason]
- **Release freeze / exception**: [policy and approved exception, or N/A]
- **Release notes / changelog**: [link or N/A with reason]
- **Outstanding risks / exceptions**: [owner, mitigation, approval, or none]

## 3. Rollout

- **Strategy**: [standard / staged / canary / blue-green / mobile store / other]
- **Steps and observation period**: [project-specific plan]
- **Stop / abort triggers**: [measurable project-defined criteria]
- **Rollout result**: [completed / paused / aborted / rolled back]
- **Traffic or cohort progression**: [evidence or N/A]

## 4. Post-Deployment Verification (PVT)

Use safe, authorized test data. Do not record credentials, tokens, or sensitive personal data. A real payment is not a default test; if explicitly authorized, record the approval and refund/reversal plan.

| Test ID | Critical flow / check | Expected result | Actual result | Status (PASS / FAIL / BLOCKED / N/A) | Evidence / build |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [PVT-ID] | [applicable user flow or check] | [project target] | [observed result] | [status + reason] | [link/reference] |

## 5. Monitoring and Recovery

- **Error tracking / logs / metrics**: [tool, environment, evidence or N/A]
- **Health / uptime checks**: [check, target, result or N/A]
- **Alert path**: [safe test alert and receipt evidence or N/A]
- **Observation period and service targets**: [project-defined values and result]
- **Rollback / recovery runbook**: [path or N/A with reason]
- **Recovery triggers and owner**: [criteria / person]
- **Recovery time**: [tested result and date; no assumed universal target]
- **Backup / restore and data migration limits**: [evidence, risks, approved plan or N/A]

## 6. Verification Attestation

Release status: [LIVE / NOT LIVE / DEGRADED / ROLLED BACK]
Verification performed by: [human name]
- **Date**: [YYYY-MM-DD]
- **Summary and evidence references**: [links]

This report records evidence; it does not delegate production deployment or release approval to an agent. Continue to handover or operations only after the responsible human confirms the next step.
