# Anti-Patterns: When NOT to Use This Framework

> **Purpose**: Prevent misuse of solo-project-lifecycle framework  
> **Audience**: Solo developers evaluating framework fit

---

## Core Anti-Pattern: Wrong Scale Match

### ❌ Anti-Pattern #1: True Micro-Projects (<2 weeks)

**Don't use this framework if**:
- Project duration: <2 minggu
- Budget: <Rp 5 juta
- Features: 1 fitur only (e.g., "landing page with contact form")
- Deliverable: Static site, simple script, single-page app

**Why it fails**:
- Framework overhead (4 jam baca docs) = 10% of total project time
- Templates overkill (PRD untuk landing page?)
- Gates tidak masuk akal (DP untuk Rp 3 juta project?)

**Use instead**:
- No framework, just build
- Or: Single `README.md` with problem, solution, tech stack
- Time saved: 8 jam

**Example**:
```
Bad: "Bikin landing page company profile, pakai framework M00-M13"
Good: "Bikin landing page, 3 hari, Next.js + Tailwind, deploy Vercel"
```

---

### ❌ Anti-Pattern #2: Hobby Projects / Learning Projects

**Don't use this framework if**:
- Purpose: Learn new tech stack (tutorial project)
- Audience: Just you (portfolio piece, no users)
- Timeline: Whenever done (no deadline pressure)
- Commercial: Not for sale, not for client

**Why it fails**:
- Framework enforces commercial discipline (DP gates, SOW) → useless for hobby
- Documentation overhead kills joy of exploration
- Fast-track mode still too formal (3 templates minimum)

**Use instead**:
- Personal project template (single `PROJECT.md` optional)
- Git repo + README sufficient

**Example**:
```
Bad: "Belajar Go, bikin todo app pakai framework M04-M10"
Good: "Belajar Go, bikin todo app, commit ke GitHub, no docs"
```

---

### ❌ Anti-Pattern #3: Enterprise Team Projects (>5 developers)

**Don't use this framework if**:
- Team size: >5 developers
- Roles: Dedicated PM, designer, QA, DevOps
- Process: Already have JIRA/Linear + formal SDLC
- Compliance: SOC2, ISO27001, enterprise audit trail

**Why it fails**:
- Framework optimized for solo dev (informal gates, markdown docs)
- Enterprise needs: Formal approval workflows, audit trails, compliance reports
- Templates too lightweight (enterprise needs heavyweight processes)
- No RACI matrix, no stakeholder management, no governance

**Use instead**:
- PMI PMBOK framework
- Scaled Agile (SAFe)
- Enterprise SDLC (Waterfall, RUP)

**Example**:
```
Bad: "Team 10 orang, pakai solo-project-lifecycle"
Good: "Team 10 orang, pakai JIRA + Confluence + Agile ceremonies"
```

---

## Common Failure Modes

### ❌ Anti-Pattern #4: Client Refuses Formal Process

**Scenario**:
- Framework: "Minta client sign SOW dan bayar DP 30-50%"
- Client: "Nggak perlu kontrak, langsung coding aja, bayar belakangan"
- Developer: "Tapi framework bilang no DP = no code..."

**Why it fails**:
- Framework protection gates butuh client cooperation
- Client reject → gates useless → framework jadi documentation overhead
- Dilema: Skip gates (lose protection) vs follow gates (lose client)

**Solution**:
- **Don't use framework** for clients yang reject formal process
- Accept risk (no DP, no SOW) atau reject project
- Framework tidak bisa enforce client behavior

**Real outcome**:
- 70% developer eventually skip gates → work for free → client not pay
- Framework jadi wasted 8 jam setup time

---

### ❌ Anti-Pattern #5: Scope Will Definitely Change

**Scenario**:
- Project type: R&D, exploration, startup pivot mode
- Requirement: "We'll figure it out as we build"
- Framework: "Lock scope di M02, Out-of-Scope strict"

**Why it fails**:
- Framework assumes scope knowable upfront
- Agile/Lean startup = scope evolves weekly
- Change Request process too heavy (setiap pivot butuh CR formal?)

**Solution**:
- **Don't use Fixed-Price + Scope Lock** (use Time & Materials)
- Or: Skip framework entirely, use Agile sprint planning
- Framework M02 Scope Lock good for fixed-price projects only

**Example**:
```
Bad: "Startup seed stage, scope berubah tiap minggu, pakai framework M02"
Good: "Startup seed stage, pakai Agile sprints 1 minggu, no fixed scope"
```

---

### ❌ Anti-Pattern #6: Solo Dev Has No Time Management

**Scenario**:
- Developer: "Aku nggak pernah selesai project tepat waktu"
- Framework: "Estimasi M06 Development: 29-478 jam"
- Reality: Developer spend 800 jam karena scope creep + procrastination

**Why it fails**:
- Framework provides structure, **not** discipline
- Gates dapat dilanggar sendiri (solo dev = no external enforcement)
- Estimasi bergantung pada developer follow plan

**Solution**:
- **Fix time management first** before using framework
- Or: Use accountability buddy (co-founder, mentor, client weekly check-in)
- Framework works IF developer self-disciplined

**Self-assessment**:
```markdown
Do NOT use framework if:
- [ ] Kamu skip deadlines sendiri (no client pressure)
- [ ] Kamu over-engineer everything (perfectionist)
- [ ] Kamu mulai 5 projects, finish 0
```

---

### ❌ Anti-Pattern #7: Developer Hates Documentation

**Scenario**:
- Developer: "Aku tipe coding langsung, males bikin doc"
- Framework: "Isi 3 templates minimum (PROJECT.md, DESIGN.md, DEPLOY.md)"
- Reality: Developer skip templates → framework useless

**Why it fails**:
- Framework **is** documentation-first approach
- Minimal 3 templates untuk fast-track MVP
- If developer allergic to docs → wrong framework

**Solution**:
- **Don't use framework** if kamu refuse documentation
- Use: Personal code comments + Git commit messages only
- Accept: Higher risk of scope creep, rework, forgotten decisions

**Honest self-check**:
```markdown
Use framework only if:
- [x] Aku rela spend 4 jam nulis specs before coding
- [x] Aku percaya docs prevent rework (save time long-term)
- [x] Aku okay dengan read 300 lines QUICK_START_MVP.md
```

---

## Scale Mismatch Matrix

| Project Type | Framework Fit | Why |
|--------------|---------------|-----|
| **Landing page (3 hari)** | ❌ Don't use | Overhead >50% |
| **MVP solo (2-4 minggu)** | ✅ Use fast-track | Overhead 10-15% (acceptable) |
| **Client project (1-3 bulan)** | ✅✅ Perfect fit | Core use case |
| **Enterprise (6+ bulan)** | ⚠️ Use with caution | Need heavyweight process (PMI/PMBOK) |
| **Hobby project** | ❌ Don't use | No commercial protection needed |
| **Team project (>5 dev)** | ❌ Don't use | Need JIRA/Linear workflows |

---

## Economic Anti-Patterns

### ❌ Anti-Pattern #8: Break-Even Impossible

**Scenario**:
- Framework setup: 8 jam × Rp 150K/jam = Rp 1.2 juta opportunity cost
- Project: Rp 5 juta fixed-price
- Framework overhead: 24% of budget
- Profit: Negative after infra costs

**Why it fails**:
- Small budget projects cannot absorb framework overhead
- Break-even: Need project >Rp 20 juta for framework to pay off

**Solution**:
- **Minimum project budget**: Rp 20 juta untuk justify framework
- <Rp 20 juta: Use fast-track or no framework
- Calculate: `(Framework setup time × hourly rate) / project budget < 10%`

**Example**:
```
Bad: Rp 5 juta project → 8 jam setup → 24% overhead → unprofitable
Good: Rp 50 juta project → 8 jam setup → 2.4% overhead → profitable
```

---

### ❌ Anti-Pattern #9: Wrong Pricing Model

**Scenario**:
- Framework: "Fixed-price with milestones (Termin 1-4)"
- Market: Client want Time & Materials (monthly retainer)
- Developer: Force framework pricing model → lose client

**Why it fails**:
- Framework optimized for milestone-based (Alpha/Beta gates)
- Not all projects fit this model
- T&M projects: Gates less relevant

**Solution**:
- **Adapt framework** (use modules, skip gates) or
- **Don't use framework** for pure T&M retainer work
- Framework most effective for fixed-price projects

---

## Technical Anti-Patterns

### ❌ Anti-Pattern #10: Wrong Tech Stack for Framework

**Scenario**:
- Framework: "Boring Tech ladder (Next.js, Laravel, Django)"
- Project: Embedded system (Rust), mobile game (Unity), blockchain dApp
- Developer: Try to fit square peg into round hole

**Why it fails**:
- Framework modules assume CRUD web/mobile app
- M05 DB schema (SQL DDL) useless untuk blockchain
- M06 Backend API useless untuk embedded firmware

**Solution**:
- **Don't use framework** for non-CRUD projects
- Framework scope: Web apps, mobile apps, SaaS, APIs
- Out of scope: Games, embedded, blockchain, ML/AI research

**Tech Stack Fit**:
```markdown
✅ Good fit:
- Web app (React/Vue/Svelte + Node/Laravel/Django)
- Mobile app (React Native/Flutter + REST API)
- SaaS (multi-tenant DB, stripe integration)
- API backend (REST/GraphQL + PostgreSQL)

❌ Poor fit:
- Games (Unity/Unreal)
- Embedded (C/Rust bare metal)
- Blockchain (Solidity smart contracts)
- ML/AI research (Jupyter notebooks)
- Desktop apps (Electron exceptions okay if web-based)
```

---

## Cultural Anti-Patterns

### ❌ Anti-Pattern #11: Client Culture Mismatch

**Scenario**:
- Framework: "Single PIC, email communication, formal BAST"
- Client: "Group chat WhatsApp 15 orang, decisions by voting, no formal docs"
- Developer: "But framework says Single PIC mandatory..."

**Why it fails**:
- Framework assumes professional client (startup/SME with structure)
- UMKM/family business: Informal, group decisions, oral agreements
- Force framework → cultural friction → project stress

**Solution**:
- **Assess client maturity** before using framework
- Informal client → skip M03 SOW (use simple invoice + WhatsApp confirmation)
- Formal client → full framework

**Client Maturity Matrix**:
```markdown
| Client Type | Framework Modules |
|-------------|-------------------|
| UMKM/Warung | Fast-track only (skip M03) |
| SME/Startup | Standard (M01-M13) |
| Corporate | Standard + legal review |
| Enterprise/BUMN | Full + PMI PMBOK overlay |
```

---

### ❌ Anti-Pattern #12: Developer Personality Mismatch

**Framework optimized for**:
- Structured thinkers (love checklists, processes)
- Risk-averse (want contracts, protection gates)
- Long-term mindset (willing to invest upfront time for later payoff)

**Framework poor fit for**:
- Exploratory coders (hate planning, love prototyping)
- Risk-tolerant (okay with working without DP)
- Short-term focus (want results today, not invest for tomorrow)

**Self-assessment**:
```markdown
Framework good fit if you:
- [x] Finish checklists before moving on
- [x] Read manuals before assembling furniture
- [x] Plan vacation itinerary in advance

Framework poor fit if you:
- [ ] Start coding without specs
- [ ] Improvise solutions on the fly
- [ ] Hate reading documentation
```

---

## Success Predictors

### ✅ Use Framework If (High Success Probability)

1. **Project characteristics**:
   - Duration: 1-6 bulan
   - Budget: Rp 20 juta - Rp 500 juta
   - Client: SME/Startup dengan struktur organizational
   - Scope: Knowable upfront (CRUD web/mobile app)

2. **Developer characteristics**:
   - Comfortable dengan documentation
   - Pernah kena scope creep (want protection)
   - Self-disciplined (follow process tanpa external enforcement)

3. **Commercial context**:
   - Fixed-price contract
   - Client willing sign SOW dan pay DP
   - Clear deliverables (bukan R&D exploration)

### ❌ Don't Use Framework If (High Failure Probability)

1. **Project characteristics**:
   - Duration: <2 minggu atau >12 bulan
   - Budget: <Rp 10 juta atau >Rp 1 miliar
   - Client: Informal (UMKM) atau Enterprise (need PMI)
   - Scope: Unknown (R&D, pivot mode)

2. **Developer characteristics**:
   - Hate documentation (allergic to templates)
   - Optimist (think "tidak akan kena scope creep")
   - Undisciplined (sering skip own deadlines)

3. **Commercial context**:
   - Time & Materials (no fixed scope)
   - Client refuse formal process
   - Hobby/learning project (no commercial pressure)

---

## When to Upgrade FROM Framework

**Signals to move beyond framework**:
1. **Team scaling**: Hire developer #2 → need proper JIRA workflows
2. **Enterprise clients**: First BUMN/bank client → need ISO27001 compliance
3. **Funding raised**: Seed round → need investor-grade reporting
4. **Product market fit**: >1000 users → need growth team + data analytics

**Upgrade path**:
- Solo → Small Team: Add JIRA, formal code review, CI/CD automation
- Small Team → Enterprise: Add PMI PMBOK, formal governance, audit trails

---

## Conclusion

**Framework is a tool, not a religion.**

If framework doesn't fit:
- ✅ Use parts that work (modules only, skip gates)
- ✅ Adapt to your context (informal SOW via email okay)
- ✅ Skip entirely if wrong scale

**Success = Framework + Judgment**, not blind following.

**Questions before starting**:
1. Is project >2 minggu dan >Rp 20 juta? (No → skip framework)
2. Will client cooperate dengan formal process? (No → skip M03 gates)
3. Am I willing invest 4-8 jam setup? (No → skip framework)

**If 2/3 answers "No" → Don't use this framework.**

---

**Last Updated**: 2026-10-02  
**Maintainer**: Framework contributors  
**Feedback**: Open issue for additional anti-patterns
