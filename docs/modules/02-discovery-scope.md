# Module 02: Discovery & Scope Definition (Requirements Elicitation & Scope Locking)

> - `references/checklists/MODUL_02_EVALUATION_CHECKLIST.md` (MoSCoW quality check, User Stories INVEST validation, Database Schema validation, Tech Stack validation, NFR realism check, Timeline buffer, Risk completeness, Scope boundaries)
> - `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md` (5-pillar elicitation question bank, Red-flags detection)


This module is the second stage in the software development lifecycle for solo developers. Its purpose is to extract real business requirements from stakeholders/clients, define technical boundaries, and lock **In-Scope vs Out-of-Scope** boundaries into the **`SCOPE_STATEMENT.md`** document before committing to contracts or detailed design.

**Pre-Contract Work**: Modules 00-02 (Discovery phase, 1-4 weeks) typically unpaid for new clients. DP (Down Payment, Termin 1) in Module 03 triggers paid work (Modules 03+ execution). For repeat clients, consider charging discovery fee upfront.

---

## 1. Execution Cycle of Module 02

```text
[ INPUT: IDEA_BRIEF.md Document from Module 01 ]
                      │
                      ▼
[ STEP 1: Targeted Discovery Interview (The 5 Pillars) ]
  • Real Business Objectives & Success Metrics
  • User Persona Mapping & Access Permissions Matrix
                      │
                      ▼
[ STEP 2: Feature Breakdown & MoSCoW Prioritization ]
  • Must-Have (Vital Release Features)
  • Should-Have / Could-Have (Secondary Features)
  • Won't-Have (Rejected / Deferred Features)
                      │
                      ▼
[ STEP 3: Scope Boundary Locking (Scope Defense) ]
  • Explicit List: WHAT IS BUILT vs WHAT IS NOT BUILT
  • Technical Assumptions & Initial Architecture Constraints
                      │
                      ▼
[ STEP 4: Client Dependency Registration (Client Dependencies) ]
  • Master Data, Server Access, Third-Party API Credentials
  • Handover Deadlines (Dependency SLA)
                      │
                      ▼
[ STEP 5: Stakeholder Mapping & Communication ]
  • Power/Interest Matrix (4 Quadrants)
  • Communication Plan & Escalation Path
  • Expectation Management & RACI Matrix
                      │
                      ▼
[ OUTPUT: SCOPE_STATEMENT.md Document + Stakeholder Artifacts ] ──► Ready to Proceed to Module 03: Legal SOW & DP
```

---

## 2. Step-by-Step Execution

### Step 1: Targeted Discovery Interview
Conduct the interview using the guide in `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md`:
1. **Identify Decision Makers**: Ensure the interviewee has final authority to approve features.
2. **Dissect Needs vs Wants**: Distinguish core business needs (*needs*) from cosmetic enhancements (*nice-to-have wishes*).
3. **Map User Roles**: Determine everyone who logs into the system and their specific access permissions (e.g., Super Admin, Cashier, Customer).

### Step 2: Feature Breakdown & MoSCoW Prioritization
Break each module into specific features with priority labels:

**Template**: `templates/01-discovery-commercial/MOSCOW_MATRIX.md` (60-min workshop format, decision tree, examples)

- **Must Have (P0)**: The system fails to function without this feature (e.g., order checkout, login authentication).
  - **Max Must-Haves by Scale**: Small: 3–7 features | Medium: 8–15 features | Large: 16–25 features | Enterprise: 26–40 features
  - If limits are exceeded, downgrade to Should-Have or Phase 2.
- **Should Have (P1)**: Important features with temporary manual workarounds (e.g., export reports to Excel).
- **Could Have (P2)**: Additional features if time and solo dev capacity permit (e.g., WhatsApp notifications).
- **Won't Have (P3)**: Features formally agreed not to be built in this phase (e.g., AI recommendation chatbot).

**MoSCoW Workshop** (Medium/Large projects):
- Run 60-min prioritization workshop with client stakeholders
- Use decision tree: "Can we launch without this?" → Must/Should/Could/Won't
- Document in `docs/pm/MOSCOW_MATRIX.md`
- Reference in SCOPE_STATEMENT.md

### Step 3: Scope Boundary Locking (In-Scope vs Out-of-Scope)
Solo developers must document the **Out-of-Scope** section with aggressive detail. Civil law principle: *"Everything not explicitly stated as In-Scope is outside the developer's responsibility."*

Standard Out-of-Scope examples that must be listed:
- Manual data migration from physical books/paper or corrupted database formats.
- Purchasing font licenses, paid stock image assets, or third-party API subscription fees.
- Handling local network issues, damaged scanner hardware, or client office machines infected with malware.

### Step 4: Client Dependency Identification (Client Dependency SLA)
List everything the client must provide to prevent work blockages:
- Sandbox accounts and API secret keys (payment gateways, email service providers, cloud hosting).
- Initial master data in structured digital format (CSV/JSON/Excel).
- Availability of a Single PIC for weekly clarification sessions.

Include the clause: *Any delay in client dependency handover of ≥3 business days automatically pushes back the target release date without penalty to the developer.*

### Step 5: Stakeholder Mapping & Communication

**Stakeholder Identification & Power/Interest Matrix**

Map all stakeholders using the Power/Interest matrix (4 quadrants):

1. **Manage Closely** (High Power, High Interest): Key decision-makers requiring regular updates and consultation for major decisions.
   - *Solo Dev Example*: Direct paying client/owner.
   - *Company Example*: Product Owner, Engineering Lead, CTO.

2. **Keep Satisfied** (High Power, Low Interest): Holds authority but is not involved daily. Needs periodic status updates to avoid approval bottlenecks.
   - *Solo Dev Example*: Client's executive/manager signing invoices.
   - *Company Example*: CFO, Legal, Compliance team.

3. **Keep Informed** (Low Power, High Interest): Actively involved in execution without scope decision authority. Daily/weekly tactical communication.
   - *Solo Dev Example*: Power user/champion providing UI/UX feedback.
   - *Company Example*: Designer, QA, DevOps engineer, Marketing.

4. **Monitor** (Low Power, Low Interest): Passive stakeholders needing only final outcome awareness.
   - *Solo Dev Example*: Client internal staff using the system post-launch.
   - *Company Example*: Sales team, external partners.

Use the template in `templates/01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md` to document this mapping.

**Communication Plan per Stakeholder**

Establish communication cadence based on quadrants:

| Stakeholder Tier | Cadence | Channel | Format |
| :--- | :--- | :--- | :--- |
| **Manage Closely** | Daily/Weekly sync | Slack/Discord + 30-min call | Status dashboard + decision items |
| **Keep Satisfied** | Bi-weekly/Monthly | Email summary | Executive summary (1-page, RAG status) |
| **Keep Informed** | Weekly standup | Slack/Discord + shared doc | Detailed progress update, blockers |
| **Monitor** | Milestone report | Email broadcast | Launch announcement, major release notes |

**Escalation Path**: Define when issues must escalate to a higher tier:
- Blocker ≥3 days unresolved → Escalate to "Keep Satisfied"
- Scope creep request → Escalate to "Manage Closely" for decision
- Budget/Timeline overrun risk → Escalate to CFO/Financial stakeholder

Use the template in `templates/01-discovery-commercial/COMMUNICATION_PLAN_TEMPLATE.md`.

**Expectation Management (Reality vs Promises)**

The key to scope defense is upfront expectation alignment:

1. **Success Criteria Alignment Workshop**: Before kick-off, run a 1-hour session to agree on measurable definitions of "done".
   - *Bad*: "A great, user-friendly dashboard."
   - *Good*: "A dashboard with 5 mandatory widgets (X, Y, Z), response time <2s, mobile-responsive, tested on Chrome/Safari."

2. **Scope Boundary Communication**: Explain **In-Scope vs Out-of-Scope** boundaries in business language, not technical jargon.
   - *Bad*: "We do not support horizontal pod autoscaling in Kubernetes."
   - *Good*: "The system automatically scales for 100-500 concurrent users. If traffic surges past >500 users, a separate infrastructure upgrade is required (estimated cost +$X)."

3. **Timeline Reality Check (Under-Promise, Over-Deliver)**:
   - Solo dev time buffer formula: `Technical estimate × 1.5` (50% buffer for bug fixing, scope clarification, dependency delays).
   - Communicate: *"A conservative timeline is 8 weeks. If everything proceeds smoothly, it may finish by week 6, but we commit to week 8."*

4. **Trade-Off Transparency (Iron Triangle: Scope/Time/Quality)**:
   - If client pushes deadline: "To deliver 2 weeks earlier, we must cut features X and Y, or accept technical debt that slows down Phase 2."
   - If client adds features: "Feature Z adds 10 days of dev time. Should we push the deadline or drop another feature?"

**RACI Matrix for Core Deliverables**

Define responsibilities per deliverable using a RACI matrix:
- **R (Responsible)**: Who performs the task.
- **A (Accountable)**: Who holds final approval (only 1 person per item).
- **C (Consulted)**: Who is consulted prior to decisions.
- **I (Informed)**: Who is informed of results without direct involvement.

| Deliverable | R | A | C | I |
| :--- | :--- | :--- | :--- | :--- |
| **Scope Statement** | Solo Dev | Client/PO | Designer, QA | Exec |
| **UI/UX Design** | Designer | Client/PO | Solo Dev | Marketing |
| **Backend API** | Solo Dev | Tech Lead | Security Reviewer | QA |
| **Deployment** | Solo Dev/DevOps | CTO | Client PIC | Support Team |

Use the template in `templates/01-discovery-commercial/RACI_MATRIX_TEMPLATE.md`.

**Business Communication Skills for Solo Devs**

5 mandatory communication patterns to master:

1. **Executive Summary (Top-Down, 1-Page Max)**:
   ```
   **Status**: 🟢 Green (on track) / 🟡 Yellow (at risk) / 🔴 Red (blocked)
   **Progress**: 40% complete (Week 4 of 10)
   **Key Wins**: Feature X shipped, API integration done
   **Blockers**: Waiting for client data (3 days overdue)
   **Next Week**: Complete Feature Y, start QA testing
   **Asks**: Need client approval on design mockup by Friday
   ```

2. **Status Report Format (RAG + Blockers + Asks)**:
   - Send every Friday EOD to the "Manage Closely" tier.
   - Structure: What shipped this week → What's next week → Blockers → Explicit asks.

3. **Risk Communication (Early Warning + Mitigation Options)**:
   - *Bad*: "There is an issue with the third-party API." (vague, no action)
   - *Good*: "The third-party API has been down for 2 days. Options: (1) Wait for their fix (ETA unknown), (2) Switch to an alternative provider (+3 days dev), (3) Build a temporary mock API (+2 days). Recommendation: Option 2. Decision needed by tomorrow."

4. **Scope Creep Defense Script**:
   - Client: "Can you add feature X? It's just a small thing."
   - Solo Dev: "Feature X requires Y days. If included in this sprint, we must drop feature Z or extend the deadline. Alternatively, can we defer it to Phase 2 post-launch?"

5. **Handling Difficult Stakeholders**:
   - **The Micromanager**: Send proactive daily updates (morning 09:00) before being asked. Reduces interruption frequency.
   - **The Scope Creeper**: Always respond to feature additions with trade-offs (time/budget). Never say "yes" without negotiation.
   - **The Silent Approver**: Set approval deadlines: "Need design approval by Wednesday EOD, or we proceed under the assumption of approval to keep the timeline on track."

See full guide in `references/pm/PM_COMMUNICATION_GUIDE.md`.

---

## 3. Adaptation Based on Project Scale

| Aspect | Small Scale (MVP / Freelance) | Medium Scale (B2B SaaS / Agency) | Large Scale & Enterprise |
| :--- | :--- | :--- | :--- |
| **Interview Duration** | 1 chat/call session (30–60 min) | 2–3 discovery sessions (1–2 weeks) | Tiered workshops per division (2–4 weeks) |
| **Persona Depth** | 1–2 simple user roles | 3–5 roles with RBAC matrix | Multi-division, department hierarchy, Okta/AD SSO |
| **Scope Document** | 1-page Scope Checklist | Formal Scope Statement & API outline | Full Scope Statement, RTM draft, Compliance scope |
| **Dependencies** | Basic hosting access & payment keys | 2–4 cloud service integrations | Legacy ERP integrations, internal firewall approvals |

---

## 4. Output Artifacts (Deliverables)

### Mandatory Documents (Core Deliverables)

1. **`docs/pm/SCOPE_STATEMENT.md`** (Primary deliverable)
   - Template: `templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md`
   - Contents: In-Scope, Out-of-Scope, MoSCoW prioritization, client dependencies

2. **`docs/pm/STAKEHOLDER_MAP.md`** (Company/team projects)
   - Template: `templates/01-discovery-commercial/STAKEHOLDER_MAP_TEMPLATE.md`
   - Contents: Power/Interest matrix, stakeholder register, influence network
   - **Solo dev projects**: Optional (can be condensed to 1 page if only 1-2 clients)

3. **`docs/pm/COMMUNICATION_PLAN.md`** (Company/team projects)
   - Template: `templates/01-discovery-commercial/COMMUNICATION_PLAN_TEMPLATE.md`
   - Contents: Cadence per stakeholder, status report schedule, escalation matrix
   - **Solo dev projects**: Simplified version (1-page update schedule + 1 escalation contact)

4. **`docs/pm/RACI_MATRIX.md`** (Company/team projects)
   - Template: `templates/01-discovery-commercial/RACI_MATRIX_TEMPLATE.md`
   - Contents: Responsible/Accountable/Consulted/Informed per deliverable
   - **Solo dev projects**: Optional (typically: Solo Dev = R, Client = A for most items)

### Reference Guide

- **`references/pm/PM_COMMUNICATION_GUIDE.md`**: Business communication skills, status report templates, stakeholder management tactics

> 📁 **ABSOLUTE FILE LOCATION RULE**:
> All PM documents MUST be stored inside the **`docs/pm/`** directory (never in the root directory).
> Storing scope documents in the project root is strictly prohibited.

### Adaptation Based on Context

**Solo Developer (Freelance/Consultant)**:
- **Mandatory**: SCOPE_STATEMENT.md
- **Optional**: STAKEHOLDER_MAP.md (1-page simplified), COMMUNICATION_PLAN.md (1-page), RACI_MATRIX.md (skip if only 2 people)

**Company/Team (Internal or B2B)**:
- **Mandatory**: All 4 documents above
- **Rationale**: Multiple stakeholders, complex approval chains, clear decision-making authority needed

---

## 🛑 [GATE] EXIT & MANDATORY STOP PROTOCOL

After the file `docs/pm/SCOPE_STATEMENT.md` has been written:

### **STEP 0: FILE EXISTENCE VERIFICATION (BLOCKING CHECK)**

**MANDATORY BEFORE CONTENT VALIDATION**:

1. **Verify output file existence** using one of the following methods:
   - PowerShell: `Test-Path -LiteralPath "docs/pm/SCOPE_STATEMENT.md"` → must return `True`
   - Bash/Zsh: `test -f "docs/pm/SCOPE_STATEMENT.md" && echo "True" || echo "False"`
   - Read tool: `read_file('docs/pm/SCOPE_STATEMENT.md')` → must succeed without error

2. **IF FILE DOES NOT EXIST**:
   - ❌ **STOP IMMEDIATELY** - do not proceed to content validation
   - ❌ **DO NOT present summary** to user
   - ❌ **DO NOT prompt for scope confirmation**
   - ✅ **REPORT ERROR** to user:
     ```
     CRITICAL ERROR: SCOPE_STATEMENT.md file was not created.
     Module 02 FAILED - cannot proceed to Module 03 (Legal SOW & Charter).
     
     Possible causes:
     - Write permission denied on docs/pm/ directory
     - Path typo in tool call
     - Disk full
     
     Please investigate this issue before proceeding.
     ```
   - ✅ **END TURN** and wait for user to fix issue

3. **ONLY IF FILE EXISTS**: Proceed to content validation below

---

### **STEP 1: CONTENT VALIDATION & SCOPE CONFIRMATION**

1. **STRICTLY FORBIDDEN to proceed directly or invoke tools for Module 03 within the same turn!**
2. **CONTENT VERIFICATION (Self-Verification Checklist)**:
   - [ ] `read_file('docs/pm/SCOPE_STATEMENT.md')` → Confirm 60+ lines
   - [ ] Must-Have count within scale limits (3-7 Small, 8-15 Medium, etc.)
   - [ ] Out-of-Scope section documented with ≥3 explicit exclusions
   - [ ] Client dependencies listed with SLA timeline
3. Present a scope boundary summary to the user:
   - List of Must-Have (P0) features
   - Explicit list of Out-of-Scope features prohibited from being built
   - Data/access dependencies required from client (Dependency SLA)
4. **END YOUR RESPONSE (END TURN)** and ask for confirmation from the user:
   > *"Document `docs/pm/SCOPE_STATEMENT.md` has been completed with [X] Must-Have features and locked Out-of-Scope boundaries. Are these scope boundaries agreed upon before we proceed to Module 03 (Legal SOW & Project Charter)?"*
5. Wait for explicit approval from user before proceeding to Module 03.
