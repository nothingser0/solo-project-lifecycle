# Production Deployment Protocol

> Project-specific M10 runbook. Adapt to the chosen platform and remove non-applicable checks with a reason. Production access stays with the human operator; never paste credentials or secret values into this file.

## 1. Release

- **Project / version**: [name / version or provider release ID]
- **Source branch, commit, artifact**: [immutable identifiers]
- **Target platform / environment**: [provider and environment]
- **Release owner / human operator**: [name]
- **Approved window and timezone**: [window]
- **Release freeze rule / approved exception**: [reference]
- **M09 UAT decision**: [reference or N/A with reason]
- **CI / build / security checks required by project policy**: [checks and links]
- **Release notes / changelog**: [link]
- **Human Go/No-Go**: [decision maker, GO/NO-GO, date]

## 2. Production Access Inputs (gate-enforced)

`validate-gate.sh M10` checks that production access inputs were received by the human operator. The agent must not request, hold, copy, or use production credentials.

Inputs-Received: [access handed over] from [human PIC] on [YYYY-MM-DD]
- **Credentials**: [held by named human in approved secret manager; reference only]
- **DNS / domain / platform access owner**: [name or role]
- **Payment / third-party production mode**: [owner and verification method, if applicable]
- **Production action executed by**: [human name]

## 3. Preflight

- [ ] Required UAT and release approvals are recorded.
- [ ] CI/build and required security checks meet project policy; exceptions name approver and rationale.
- [ ] Release commit/artifact is immutable and matches the approved candidate.
- [ ] Production secrets are configured through the approved secret manager and verified without exposing values.
- [ ] Backup/snapshot and recovery procedure are ready when data or infrastructure changes require them.
- [ ] DNS, TLS, billing, and provider-specific prerequisites are checked when applicable.
- [ ] Freeze exceptions and expected user impact are communicated to the responsible stakeholders.

## 4. Deploy (Human Operator)

Record provider-specific instructions here. The human operator runs the approved workflow and performs production deployment, merge/tag/push, DNS cutover, and any real financial transaction. Do not paste access tokens, connection strings, or secret-bearing commands into this document.

- **Workflow / provider run reference**: [link]
- **Migration / data-change sequence**: [steps or N/A]
- **Deployment sequence**: [steps]
- **Traffic / cohort progression**: [standard / staged / canary / blue-green / mobile store / other]
- **Observation period**: [project-defined]
- **Stop and rollback triggers**: [measurable thresholds]
- **Rollback owner and procedure**: [person / runbook]

Use a progressive rollout only when the platform supports it and the project has suitable telemetry and a safe abort path. For mobile, record platform review/distribution status and staged rollout evidence as applicable.

## 5. Post-Deployment Verification

Run safe, authorized smoke/PVT checks against the deployed artifact. Use synthetic or designated test data. Real charges require explicit human authorization and a documented refund/reversal path.

| Check ID | Critical flow / system check | Expected project result | Actual result | Status (PASS / FAIL / BLOCKED / N/A) | Evidence |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [ID] | [applicable check] | [target] | [observation] | [status + reason] | [link] |

## 6. Observability

- **Error tracking, logs, metrics**: [tool and evidence, or N/A]
- **Health / uptime checks**: [target, project-defined interval, result, or N/A]
- **Alert verification**: [safe test alert and receipt evidence]
- **Observation window and service objectives**: [project-defined targets and result]
- **Known risks / exceptions and owner**: [items or none]

## 7. Release Record

- **Release notes / documentation updated**: [links or N/A with reason]
- **Final status**: [LIVE / NOT LIVE / DEGRADED / ROLLED BACK]
- **GO/NO-GO decision and human approver**: [name, decision, date]
- **GO_LIVE_REPORT.md**: [path]
- **Rollback plan**: [path or N/A with reason]

The agent may draft this protocol and summarize evidence but must not perform production deployment, make the Go/No-Go decision, or claim human checks/sign-offs as completed.