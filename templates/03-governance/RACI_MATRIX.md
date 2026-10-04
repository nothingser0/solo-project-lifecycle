# RACI Matrix Template

> **Purpose**: Define roles and responsibilities for Enterprise projects  
> **When**: M02 Discovery or project kickoff  
> **Target**: Enterprise projects with 10+ stakeholders

---

## What is RACI?

**RACI** = **R**esponsible, **A**ccountable, **C**onsulted, **I**nformed

- **R - Responsible**: Does the work
- **A - Accountable**: Final decision maker, owns outcome (only 1 per task)
- **C - Consulted**: Provides input, two-way communication
- **I - Informed**: Kept updated, one-way communication

---

## RACI Matrix

| Task/Deliverable | Project Sponsor | Project Manager | Tech Lead | Backend Dev | Frontend Dev | QA | DevOps | Client PIC | Legal | Finance |
|:-----------------|:----------------|:----------------|:----------|:------------|:-------------|:---|:-------|:-----------|:------|:--------|
| **Approve Project Charter** | A | R | C | I | I | I | I | C | C | I |
| **Define Requirements** | I | A | R | C | C | I | I | R | I | I |
| **Design Architecture** | I | C | A | R | C | I | R | C | I | I |
| **Develop Backend API** | I | I | C | A | R | C | I | I | I | I |
| **Develop Frontend UI** | I | I | C | C | A | R | I | C | I | I |
| **Code Review** | I | I | A | R | R | C | C | I | I | I |
| **QA Testing** | I | I | C | I | I | A | R | C | I | I |
| **Deploy to Production** | C | A | C | C | C | C | R | I | I | I |
| **User Training** | I | R | C | I | I | I | I | A | I | I |
| **Sign-off BAST** | A | R | I | I | I | I | I | R | C | I |

---

## RACI Rules

### Rule 1: One Accountable (A) per Task
**Why**: Prevents "decision by committee"  
**Example**: If 2 people are Accountable, neither takes ownership

### Rule 2: At Least One Responsible (R)
**Why**: Work doesn't happen without someone doing it  
**Example**: Can have multiple Rs (team collaboration)

### Rule 3: Not Everyone Needs a Role
**Why**: Too many Cs/Is creates noise  
**Example**: Finance doesn't need to be Consulted on code reviews

### Rule 4: Accountable Can Also Be Responsible
**Why**: Small teams, person who decides also executes  
**Example**: Tech Lead (A) + writes architecture doc (R)

---

## Sample RACI: Software Development Project

### Project Roles

- **Project Sponsor**: VP Engineering (final budget/scope decisions)
- **Project Manager**: Sarah (day-to-day coordination)
- **Tech Lead**: John (technical decisions)
- **Backend Team**: 3 developers
- **Frontend Team**: 2 developers
- **QA Team**: 2 testers
- **DevOps**: 1 engineer
- **Client PIC**: Client's IT Manager
- **Security**: Security team lead
- **Legal**: Corporate counsel

---

### Phase 1: Discovery & Planning

| Task | Sponsor | PM | Tech Lead | Dev Team | QA | DevOps | Client | Security | Legal |
|:-----|:--------|:---|:----------|:---------|:---|:-------|:-------|:---------|:------|
| Stakeholder interviews | I | A | R | C | I | I | R | I | I |
| Requirements document | C | A | R | C | I | I | R | I | I |
| Project charter | A | R | C | I | I | I | C | I | C |
| Budget approval | A | R | I | I | I | I | I | I | C |
| SOW signing | A | R | I | I | I | I | R | I | A |

**Key**: 
- Sponsor Accountable for budget/charter (owns project success)
- PM Responsible for coordination (does the work)
- Client Responsible for requirements input

---

### Phase 2: Design & Architecture

| Task | Sponsor | PM | Tech Lead | Dev Team | QA | DevOps | Client | Security |
|:-----|:--------|:---|:----------|:---------|:---|:-------|:-------|:---------|
| UI/UX mockups | I | C | C | I | I | I | A | I |
| Architecture design | I | C | A | R | I | C | C | C |
| Database schema | I | I | A | R | I | I | C | C |
| API contracts | I | I | A | R | I | I | C | I |
| Security architecture | C | I | C | I | I | C | I | A |
| Infrastructure plan | I | C | C | I | I | A | R | C |
| Design approval | A | R | I | I | I | I | R | I |

**Key**:
- Tech Lead Accountable for technical decisions
- DevOps Accountable for infrastructure
- Client Accountable for UI/UX approval (they use it)

---

### Phase 3: Development

| Task | Sponsor | PM | Tech Lead | Backend | Frontend | QA | DevOps | Client |
|:-----|:--------|:---|:----------|:--------|:---------|:---|:-------|:-------|
| Sprint planning | I | A | R | R | R | R | I | I |
| Backend development | I | I | C | A | R | I | I | I |
| Frontend development | I | I | C | I | A | R | I | C |
| Code review | I | I | A | R | R | C | C | I |
| Unit testing | I | I | C | A | R | R | I | I |
| Integration testing | I | I | C | R | R | A | R | C | I |
| Sprint demo | I | A | R | R | R | R | I | R |

**Key**:
- Developers Accountable for their respective code
- PM Accountable for sprint coordination
- Client Responsible for attending demos (feedback)

---

### Phase 4: Testing & QA

| Task | Sponsor | PM | Tech Lead | Dev Team | QA | DevOps | Client | Security |
|:-----|:--------|:---|:----------|:---------|:---|:-------|:-------|:---------|
| Test plan creation | I | C | C | I | A | R | I | C | I |
| Functional testing | I | I | C | C | A | R | I | I |
| Performance testing | I | I | C | C | A | R | C | I |
| Security testing | I | I | C | C | C | R | I | A | R |
| UAT coordination | I | A | R | I | C | R | C | R | I |
| Bug fixes | I | I | A | R | R | C | I | I |
| UAT sign-off | C | R | I | I | I | C | A | I |

**Key**:
- QA Accountable for testing (owns quality)
- Client Accountable for UAT sign-off (accepts system)
- Security Accountable for security testing

---

### Phase 5: Deployment & Handover

| Task | Sponsor | PM | Tech Lead | Dev Team | QA | DevOps | Client | Legal |
|:-----|:--------|:---|:----------|:---------|:---|:-------|:-------|:------|
| Production deployment | C | A | C | C | C | R | I | I |
| Smoke testing | I | I | C | C | A | R | C | I |
| User training | I | A | R | C | I | I | R | I |
| Documentation | I | R | A | R | I | R | C | I |
| BAST signing | A | R | I | I | I | I | R | C |
| Warranty start | A | R | C | I | I | C | I | C |

**Key**:
- DevOps Accountable for deployment (technical execution)
- PM Accountable for overall coordination
- Client Responsible for BAST sign-off

---

## RACI for Decision-Making

| Decision Type | Sponsor | PM | Tech Lead | Dev Team | Client | Legal |
|:-------------|:--------|:---|:----------|:---------|:-------|:------|
| **Budget increase** | A | R | C | I | C | I |
| **Scope change** | A | R | C | I | R | C |
| **Technology choice** | C | I | A | C | C | I |
| **Timeline extension** | A | R | C | I | C | I |
| **Resource addition** | A | R | C | I | I | I |
| **Go/no-go launch** | A | R | C | I | R | I |
| **Security exception** | A | C | C | I | C | R |
| **Contract amendment** | A | R | I | I | C | A |

---

## RACI for Escalation

**Level 1: Team Level** (PM Accountable)
- Day-to-day issues
- Technical blockers
- Resource conflicts
- Resolution time: <24 hours

**Level 2: Project Level** (Tech Lead Accountable)
- Architecture decisions
- Performance issues
- Technical risks
- Resolution time: <3 days

**Level 3: Executive Level** (Sponsor Accountable)
- Budget overruns
- Major scope changes
- Legal issues
- Timeline delays >2 weeks
- Resolution time: <1 week

---

## Common RACI Mistakes

### Mistake 1: Too Many Accountables
❌ **Wrong**: 3 people marked A for "Deploy to Production"  
✅ **Right**: 1 person A (DevOps), others are R or C

### Mistake 2: No Accountable
❌ **Wrong**: Everyone marked R, no A  
✅ **Right**: One person A (owns decision), others R (do work)

### Mistake 3: Everyone Consulted
❌ **Wrong**: All 20 stakeholders marked C  
✅ **Right**: Only key decision-makers C (3-5 people max)

### Mistake 4: Redundant Informed
❌ **Wrong**: Everyone marked I (creates email noise)  
✅ **Right**: Only those who need updates marked I

### Mistake 5: Accountable Not Senior Enough
❌ **Wrong**: Junior dev A for architecture  
✅ **Right**: Tech Lead or Architect A

---

## RACI Workshop (2 hours)

### Preparation (Before Workshop)
- [ ] List all major tasks/deliverables
- [ ] List all stakeholders and roles
- [ ] Prepare RACI template (spreadsheet)
- [ ] Book conference room + whiteboard

### During Workshop
**Part 1: Explain RACI (15 min)**
- Define R, A, C, I
- Share examples
- Explain rules

**Part 2: Fill Matrix (60 min)**
- Go through each task
- Ask: "Who is Accountable?" (must have 1 answer)
- Ask: "Who is Responsible?" (can have multiple)
- Ask: "Who should be Consulted?"
- Ask: "Who needs to be Informed?"
- Resolve conflicts (if 2 people think they're A)

**Part 3: Review & Validate (30 min)**
- Check each role has reasonable workload
- Check no one is over-consulted (C in every row)
- Confirm Accountables agree to ownership

**Part 4: Finalize & Distribute (15 min)**
- Document final RACI
- Share with all stakeholders
- Add to project charter

---

## RACI Maintenance

**Update RACI when**:
- Team member changes role
- New stakeholder added
- Project phase changes
- Scope significantly changes

**Review frequency**: Every 4-6 weeks

---

## RACI vs DACI vs RAPID

**RACI** (most common):
- R: Responsible
- A: Accountable
- C: Consulted
- I: Informed

**DACI** (Intuit's framework):
- D: Driver (like R+A combined)
- A: Approver (final decision)
- C: Contributor (provides input)
- I: Informed

**RAPID** (Bain's framework):
- R: Recommend
- A: Agree (must approve)
- P: Perform
- I: Input
- D: Decide

**Recommendation**: Use RACI for most projects (industry standard)

---

## Tools

**RACI Software**:
- Excel/Google Sheets (simplest)
- Confluence (wiki-based)
- Smartsheet (project management)
- Monday.com (visual boards)
- Lucidchart (diagramming)

**Template**: Use this document as starting point

---

## Checklist

Before project starts:
- [ ] RACI workshop scheduled
- [ ] All stakeholders invited
- [ ] Task list prepared
- [ ] Role list prepared

During RACI creation:
- [ ] One Accountable per task (no exceptions)
- [ ] At least one Responsible per task
- [ ] Consulted limited to key decision-makers (max 5)
- [ ] Informed only those who need updates

After RACI finalized:
- [ ] Document shared with all stakeholders
- [ ] Accountables confirm ownership
- [ ] Added to project charter
- [ ] Printed and posted in project room

During project:
- [ ] Refer to RACI when conflicts arise
- [ ] Update when roles/scope changes
- [ ] Review in retrospectives

---

## Example: E-Commerce Platform Project

**Project**: Build e-commerce platform for 100k users  
**Timeline**: 12 months  
**Budget**: $2M  
**Team**: 15 people

### Key Roles:
- **Sponsor**: CEO
- **PM**: Sarah Chen
- **Tech Lead**: John Smith
- **Backend Lead**: Alice Wang (3 devs)
- **Frontend Lead**: Bob Martinez (3 devs)
- **Mobile Lead**: Carol Lee (2 devs)
- **QA Lead**: David Kim (2 testers)
- **DevOps**: Eva Rodriguez
- **Security**: Frank Wilson
- **Client PIC**: Client's CTO

### High-Level RACI:

| Phase | Sponsor | PM | Tech Lead | Dev Leads | QA Lead | DevOps | Security | Client |
|:------|:--------|:---|:----------|:----------|:--------|:-------|:---------|:-------|
| **Requirements** | C | A | R | C | I | I | I | R |
| **Architecture** | I | C | A | R | I | C | C | C |
| **Development** | I | A | C | A (each track) | C | C | I | C |
| **Testing** | I | C | C | C | A | C | C | C |
| **Deployment** | C | A | C | C | C | R | C | I |
| **Training** | I | A | C | I | I | I | I | R |
| **Sign-off** | A | R | I | I | I | I | I | R |

---

## Notes

**RACI prevents**: "I thought you were doing that!" situations

**RACI clarifies**: Who makes final call when team disagrees

**RACI saves time**: Reduces unnecessary meetings (C vs I)

**RACI is living document**: Update as project evolves
