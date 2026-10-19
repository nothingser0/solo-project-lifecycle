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
8. **Examples**: Parameterized invocation, never a real hostname, account ID, or key.

**A missing section is a missing control.** The section that gets dropped is almost always *Rollback / undo* or *Verification* — the two that make the procedure safe to run and possible to trust.

---

## 3. Name Capabilities, Not Commands

`tools_allowed` is an **allow-list of capabilities**, not a list of literal commands. The runtime maps each capability to concrete tools; the skill never names a binary.

```yaml
tools_allowed:
  - k8s.get        # maps to the runtime's read adapter
  - k8s.logs
  - shell.read
```

| Why capabilities | Why not commands |
| :--- | :--- |
| The same skill runs against kubectl, a client library, or an API | A pinned binary breaks the moment the runtime changes |
| The runtime enforces the boundary; the model does not self-police | A command string is advisory — nothing stops a different one |
| An allow-list is auditable at a glance | A deny-list is only as complete as its author's imagination |

**Default to `read_only`.** A skill that writes must say so explicitly, in both `default_mode` and `requires_confirmation_for`. The absence of a write capability is the safety mechanism; the absence of a *mention* is not.

| `default_mode` | Meaning |
| :--- | :--- |
| `read_only` | Every action inspects. The default for triage and diagnosis. |
| `requires_confirmation` | Writes are permitted after explicit human approval; list them under `requires_confirmation_for`. |
| `write` | Unrestricted writes. Requires a stated reason — this is the exception, not the norm. |

---

## 4. Two Hygiene Rules for Examples

**No real identifiers.** Hostnames, account IDs, bucket names, cluster names, and ARNs in an example get copy-pasted into a real environment. Parameterize them.

**No secrets, ever — including "obviously fake" ones.** An example that shows a token-shaped string teaches the model that tokens belong in examples, and scanners flag the file. Write `<token-from-secret-manager>`, not a plausible key.

---

## 5. Classification Before Remediation

The strongest triage skill in this family does not start with a fix — it starts with **classifying the failure mode**:

1. Identify the failing unit and its restart/error count.
2. Inspect the termination reason, exit code, and recent events.
3. Pull logs for the *previous* instance — the current one may be too young to have any.
4. **Classify** (config, dependency, permissions, resource, application bug).
5. Only then choose the minimal safe remediation.

Exit codes are the highest-value signal and are frequently skipped: `137`/`OOMKilled` is a resource investigation, `1` with a stack trace is almost always configuration, and probe failures point at the probe itself before the application. A procedure that jumps from symptom to fix will "fix" the wrong thing and the symptom will return.
