# Production Recovery and Rollback Plan

> Complete for the selected platform and data stores before release. Recovery is human-operated. Do not assume application rollback also reverses database or external side effects.

## 1. Release and Ownership

- **Project / release candidate**: [version, commit, artifact]
- **Deployment target**: [provider / environment]
- **Incident commander / rollback owner**: [name and contact method]
- **Human authority to stop or roll back**: [name / role]
- **Communications owner**: [name / role]
- **Runbook / provider instructions**: [link]

## 2. Stop and Recovery Triggers

Define thresholds from the project's SLOs, release risk, and telemetry. Triggers must be measurable and observable. Examples to adapt: critical user flow failure, data integrity issue, elevated error rate, breached latency/error budget, or security incident.

| Signal | Project threshold / condition | Observation window | Data source | Decision owner |
| :--- | :--- | :--- | :--- | :--- |
| [critical flow / metric] | [threshold] | [window] | [dashboard / alert] | [name] |

## 3. Recovery Decision Tree

1. Stop or pause further rollout when a trigger is met; preserve evidence and notify the decision owner.
2. Choose the least risky recovery for the incident: disable a feature flag, halt a canary, redeploy the last known-good artifact, apply a forward fix, or restore data only when necessary.
3. Before any destructive restore or replay, assess writes and side effects since deployment, data loss, idempotency, and external system impact. Obtain the required human authorization.
4. Record the action, operator, timestamps, affected version/data, and decision rationale.

## 4. Platform-Specific Steps

### Application / infrastructure

- **Last known-good artifact and how to restore it**: [provider-specific steps]
- **Traffic / canary reversal**: [steps or N/A]
- **Feature flags / maintenance mode**: [steps or N/A]
- **Infrastructure rollback**: [steps or N/A]

### Database and data

- **Migration type and compatibility**: [expand-contract / reversible / irreversible / N/A]
- **Forward-fix procedure**: [steps]
- **Snapshot / backup location reference**: [secure reference only; no credentials]
- **Restore procedure, expected data loss, and approval**: [steps or N/A]
- **External side effects / reconciliation**: [payments, messages, webhooks, or N/A]

## 5. Recovery Validation

- **Health and critical-flow checks**: [project-specific checks]
- **Data integrity / reconciliation**: [checks or N/A]
- **Monitoring and alert verification**: [checks]
- **Recovery time target**: [project-approved target or none]
- **Tested recovery time and test date**: [result; distinguish tested from estimated]
- **Drill evidence / environment**: [reference]

## 6. Communication and Follow-Up

- **Stakeholders and approved channels**: [list]
- **Status update owner and cadence**: [owner / cadence]
- **Customer impact message**: [approved draft or reference]
- **Incident review owner / due date**: [name / date]
- **Approver and date of plan review**: [human name / date]

This runbook does not authorize an agent to deploy, roll back, restore production data, or communicate with customers. Production actions and incident decisions remain with the named human operators.