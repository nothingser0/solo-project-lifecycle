# Enterprise DevOps & SRE Agent-Ready SKILL.md Pattern

> **Module**: M10 (Deployment & Infrastructure) & M13 (Product Operations & Iteration)  
> **Source**: Adapted from Arie Bregman DevOps & SRE Skills (`bregman-arie/devops-sre-skills`).  
> **Scope**: Agent-ready `SKILL.md` library pattern for SRE and DevOps workflows, safe-by-default execution contracts, structured YAML front matter schemas, read-only vs write-allowed safety gates, and mandatory rollback/undo runbooks.

---

## 1. Agent-Ready Skill Contract Structure
Every DevOps/SRE skill follows a predictable, machine-readable YAML front matter contract combined with deterministic runbook sections:

```yaml
---
id: deploy-kubernetes-manifests
name: Deploy Kubernetes Manifests
description: Use when applying or rolling out Kubernetes manifests to a target cluster.
tags: [kubernetes, deployment, argocd]
maturity: production
inputs:
  cluster_name: string
  namespace: string
outputs:
  deployment_status: string
tools_allowed:
  - shell.read
  - shell.write
safety:
  default_mode: requires_confirmation
  forbidden:
    - kubectl delete namespace
  requires_confirmation_for:
    - kubectl apply --force
---
```

---

## 2. Mandatory SRE Runbook Sections
1. **When to use**: Explicit trigger conditions and operational context.
2. **Preconditions**: Required cluster access, tool versions, and authentication checks.
3. **Procedure**: Step-by-step commands with idempotent flags.
4. **Decision points**: Branching logic for handling degraded health checks or failed rollouts.
5. **Verification**: Post-execution checks (health probes, metric telemetry).
6. **Rollback / Undo**: Deterministic reversion commands to restore previous healthy states.
7. **Escalation**: On-call handoff criteria when automated remediation fails.
