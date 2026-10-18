# AI Full-Stack Delivery Workflow & Multi-Role Dispatch Pattern

> **Module**: M06 (Development Execution), M07 (Quality Assurance), & M10 (Deployment)  
> **Source**: Adapted from `zhaoxuya520/AI-Fullstack-Delivery-Workflow` (AI Full-stack Delivery Workflow Master Control System).  
> **Scope**: Multi-role AI orchestration framework featuring 17 distinct technical roles (Product Manager, PM, UI/UX, API Designer, Frontend, Backend, Fullstack, DB, QA, Automation QA, DevOps, SRE, Security, Reverse/Pentest, Data Analyst, AI/ML, Tech Writer), routing tables, self-evolution protocols, and field-journal experience capture.

---

## 1. Multi-Role Master Control Architecture

When executing complex end-to-end software delivery, tasks are never handled by a monolithic AI prompt. Instead, they follow a strict **Master Control Routing System**:

### A. Standard Execution Pipeline
```
Input → Classify → Route → Execute → Verify → Document → Learn
```

1. **Intake & Classification**: Receive task input, check completeness, and identify missing prerequisites.
2. **Master Control Routing (`routing.md`)**: Match task intent/keywords to the appropriate technical role workflow (`workflows/<role>/WORKFLOW.md`).
3. **Role Check-in**: Declare role identity in first-person ("Product Manager reporting", "Backend Engineer reporting").
4. **Field-Journal Query**: Check past project experience (`field-journal/`) for reusable patterns or known pitfalls.
5. **Tool & Environment Bootstrap**: Verify tool requirements against `tool-index.json` / `tool-index.md` and bootstrap if missing.
6. **Execution & Collaboration**: Execute design, coding, testing, or deployment. Cross-role handoffs use explicit `@role` tagging.
7. **Acceptance & Self-Evolution**: Validate against delivery criteria (`templates/delivery-acceptance-criteria.md`), write completion reports, and feed insights back into `EVOLUTION.md` and `field-journal/`.

---

## 2. 17 Specialized Technical Workflows

| Role Workflow | Focus & Deliverables |
| :--- | :--- |
| **Product Manager** | PRD, user stories, feature triage, acceptance criteria. |
| **Project Manager** | Sprint planning, risk tracking, milestone breakdown. |
| **UI/UX Designer** | Wireframes, design systems, accessibility checks. |
| **API Designer** | OpenAPI/Swagger specs, RESTful resource modeling. |
| **Frontend Engineer** | Component architecture, responsive UI, client state. |
| **Backend Engineer** | Server business logic, ORM/DB queries, controllers. |
| **Fullstack Engineer** | End-to-end integration, API-to-UI wiring. |
| **Database Engineer** | Schema DDL, indexes, migrations, query tuning. |
| **QA Engineer** | Test cases, SIT validation, regression testing. |
| **Automation QA** | Playwright/Vitest E2E test scripts. |
| **DevOps Engineer** | CI/CD pipelines, Dockerfiles, GitHub Actions. |
| **SRE / Operations** | Monitoring, logging, uptime probes, alerting. |
| **Security Engineer** | Vulnerability scanning, auth audits, OWASP top 10. |
| **Reverse / Pentest** | Security probing, CTF analysis, penetration testing. |
| **Data Analyst** | ETL pipelines, SQL queries, metric dashboards. |
| **AI / ML Engineer** | LLM prompt engineering, RAG pipelines, API integration. |
| **Technical Writer** | System documentation, API references, runbooks. |

---

## 3. Strict Collaboration & Handoff Rules
* **No Premature Execution**: Never start executing without complete input; ask clarifying questions if requirements are ambiguous.
* **No Silent Failures**: If a command or tool fails twice, immediately pivot strategies and notify the user.
* **Mandatory Handoff**: Feature development flows sequentially: `Product Manager` → `Project Manager` → `UI/UX` → `API Designer` → `Database` → `Backend` → `Frontend` → `QA` → `DevOps` → `Tech Writer`.
