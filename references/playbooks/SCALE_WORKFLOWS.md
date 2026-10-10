# Scale-Specific Project Workflows

> **Purpose**: Define module sequences, payment gates, and real-world timelines per project scale.

---

## 📊 Scale Classification (Engineering Risk & High-Water Mark)

> ⚖️ **HIGH-WATER MARK RULE**: When dimensions diverge, **THE HIGHEST APPLICABLE TIER DETERMINES THE SCALE**.
> P0 Must-Have features are counted exclusively (P1 Should-Have excluded). Any high blast radius or webhook requirement escalates the tier.

| Scale | P0 Must-Have Features | Blast Radius & Data | External Integrations | SLA & Uptime | Governance / Team | Timeline |
|:------|:----------------------|:--------------------|:----------------------|:-------------|:------------------|:---------|
| **Kecil (Fast-Track MVP)** | **3–7 P0** | Rendah (tidak ada mutasi finansial/rekam medis) | DB terisolasi (tanpa webhook eksternal) | Best-effort | 1 founder / dev | <4 minggu |
| **Menengah (Solo SaaS / Agency)** | **8–15 P0** | Sedang (transaksi langganan, billing pengguna) | Webhook Payment Gateway / SMS / Mailer | 99.0% SLA | 1 founder atau 1 Client PIC | 1–3 bulan |
| **Besar (Platform / Scaled)** | **16–25 P0** | Tinggi (multi-cabang, mutasi finansial massal) | Integrasi multi-vendor, ETL migrasi DB | 99.5% SLA | Tim vendor / multi-divisi | 3–6 bulan |
| **Enterprise (Mission-Critical)** | **>25 P0** | Kritis (perbankan, kesehatan, regulasi ketat) | Core banking, ERP legacy, SSO/SAML | 99.9% 24/7 SLA | Multi-stakeholder, CAB, audit berkala | 6–12+ bulan |

---

### Module Path by Scale:
- **Kecil (Fast-Track MVP)**: `M04 → M05 → M06 → M10 → M12` (5 modul; M01 via `PROJECT_LITE.md`)
- **Solo SaaS (Self-Initiated)**: `M00-lite → M01 → M02 → M04 → M05 → M06 → M07 → M10 → M12 → M13` (10 modul, skip gate klien M03/M11)
- **Menengah (Client Commercial)**: `M01 → M02 → M03 → M04 → M05 → M06 → M07 → M09 → M10 → M11 → M12` (10 modul + gate legal)
- **Besar (Platform)**: `M00 → M01 → M02 → M04 → M05 → M06 → M07 → M08 → M09 → M10 → M12 → M13` (12 modul + M08 migrasi data)
- **Enterprise**: Full `M00 → M13` (14 modul tanpa skip + ekstensi tata kelola RACI, ADR, CAB)

---

---

## 🔵 SKALA KECIL (Solo MVP)

**Characteristics**:
- Solo dev or 2-person team
- Budget <Rp 50M
- Timeline: 1-3 bulan
- No legal complexity (internal project, prototype)
- Lightweight acceptance testing (self-sign-off in M09)

**Module Sequence**: **M01 → M02 → M03 → M04 → M05 → M06 → M07-LITE → [M08-LITE*] → M09 → M10 → M11**

**Note**: *M08-LITE only if client has existing data to migrate (discovered in M02)

**Skipped Modules**:
- ❌ **M00** - Product Discovery (skip: idea validated already)
- ⚠️ **M08** - Full Data Migration (skip if greenfield, use M08-LITE if data exists)
- ❌ **M12** - Warranty Period module (skip: 30-day warranty attached in M11 handover instead)
- ❌ **M13** - Product Ops (skip: no analytics team)

**Required Modules** (executed for Small Scale):
- ✅ **M07-LITE** - Security Baseline Checklist (mandatory: SECURITY_CHECKLIST_SMALL.md)

**Module Count**: 
- Base: 10 modules (M01, M02, M03, M04, M05, M06, M07-LITE, M09, M10, M11)
- +1 if data migration needed: M08-LITE (conditional)
- Full modules skipped: M00, M12 (warranty in M11), M13

---

### Week-by-Week Breakdown (Solo MVP)

#### **Week 1: M02 Discovery + M03 Legal Bypass**

**M02 - Discovery (2-3 hari)**:
- Stakeholder interview (1 person: founder/PIC)
- MoSCoW prioritization (must-have only, 3–7 features max for Small MVP)
- Scope boundary (in/out scope, client dependencies)
- Output: `docs/pm/SCOPE_STATEMENT.md`

**M03 - Legal (1 hari bypass)**:
- Internal project: No SOW/DP needed
- Create `docs/pm/IDEA_BRIEF.md` or `PROJECT_LITE.md` (1 page: scope, timeline, assumptions)
- Single PIC designated (yourself or founder)
- **Gate**: Brief approved → proceed immediately

---

#### **Week 2: M04 Design**

**M04 - UI/UX Design (5-7 hari)**:
- Component discovery (10-20 components for MVP)
- Design style decision (Flat Design recommended for speed)
- Figma mockups (key screens only: landing, login, dashboard, 1-2 CRUD screens)
- Asset requirements (Google Fonts, free icons like Lucide)
- Output: `DESIGN_SYSTEM.md`, Figma prototype
- **Gate**: Design freeze (no CR allowed after this point)

---

#### **Week 3: M05 Architecture**

**M05 - Architecture & Specs (5-7 hari)**:
- Tech stack selection (boring tech: Next.js + Supabase or Laravel + MySQL)
- Database schema (5-10 tables max for MVP)
- API contracts (10-20 endpoints)
- PRD (RBAC matrix, features)
- FSD (SQL DDL, API routes, security)
- Output: `docs/specs/PRD.md`, `docs/specs/FSD.md`
- **Gate**: Stack approved → proceed to coding

---

#### **Week 4-8: M06 Development (4-5 minggu)**

**M06 - Coding Execution**:
- Week 4: Scaffold + DB migrations + seed data
- Week 5: Auth system (login, register, JWT)
- Week 6-7: Core CRUD features (backend API + frontend UI)
- Week 8: Integration (wire UI → API, 5 states per screen)
- Output: Working app on staging URL
- **Gate**: All SITEMAP screens render + API smoke test passes

---

#### **Week 8.5: M07-LITE Security Baseline (1-2 hours)**

**M07-LITE - Security Checklist (NEW)**:
- Template: `templates/06-qa-uat/SECURITY_CHECKLIST_SMALL.md`
- Run 10-item security baseline (1-2 hours)
- Critical checks:
  1. Password hashing (bcrypt/argon2)
  2. HTTPS enforced
  3. SQL injection prevention (parameterized queries)
  4. XSS protection (input sanitization)
  5. CSRF tokens
  6. Env vars for secrets (no hardcoded keys)
  7. Rate limiting (login, API)
  8. Error messages (no stack traces to users)
  9. File upload validation
  10. CORS configured
- Output: Signed `SECURITY_CHECKLIST_SMALL.md`
- **Gate**: No S1/S2 security issues → proceed to M09

**Integration**:
- Added to `TODO_TEMPLATE.md` Phase 7
- Takes 1-2 hours (not days)
- Prevents common vulnerabilities without full pentest

---

#### **[Conditional] M08-LITE: Data Migration (2-3 days)**

**M08-LITE - Lightweight Data Migration (NEW)**:
- **When**: Only if client has existing data (Excel/CSV/old system)
- **Discovered in**: M02 Discovery (question added to `SCOPE_STATEMENT_TEMPLATE.md`)
- **Template**: `templates/05-data-migration/DATA_MIGRATION_LITE.md`
- **Scope**: <1000 rows, simple column mapping

**Process**:
1. **Day 1**: Client exports data, dev analyzes schema
2. **Day 2**: Write migration script (Python/Node), test on staging
3. **Day 3**: Client verifies sample (10-20 rows), production import

**Timeline Impact**: +2-3 days if applicable

**Decision Tree**:
```
M02 Discovery: "Does client have existing data?"
├─ NO → Skip M08-LITE, proceed directly to M09
└─ YES → Add M08-LITE after M07-LITE (before M09)
```

**Gate**: Data reconciliation confirmed (old count = new count)

---

#### **Week 9: M09 Client UAT (Solo Bypass)**

**M09 - Lightweight Acceptance Testing (3-5 hari)**:
- Solo MVP: Self-testing and self-sign-off
- Template: `templates/06-qa-uat/UAT_WORKBOOK_SMALL.md` (15 test cases)
- Manual testing: Login, CRUD, validation, mobile, edge cases
- Bug fixes (S1/S2 only, defer S3 to post-launch)
- Output: `templates/06-qa-uat/UAT_SIGNOFF_SMALL.md` (self sign-off)
- **Gate**: Self sign-off → ready to deploy

---

#### **Week 10: M10 Deployment**

**M10 - Production Deploy (2-3 hari)**:
- Deploy to Vercel/Railway/DigitalOcean
- DNS + SSL setup
- Smoke test production (5-10 critical flows)
- Output: Production URL live
- **Gate**: Production smoke test passes

---

#### **Week 11: M11 Handover (Solo Bypass)**

**M11 - Handover (2-3 hari)**:
- Email BAST: Use `templates/07-release-handover/BAST_EMAIL_SMALL.md`
- Write `README.md` (setup instructions)
- Write `RUNBOOK_PRODUCTION.md` (deployment SOP)
- Warranty policy: Attach `templates/08-maintenance-ops/WARRANTY_POLICY_SMALL.md` (30 days)
- Output: Documentation complete
- **Gate**: Documentation verified

**Handover Package** (from `HANDOVER_PROTOCOL_TEMPLATE.md`):
- [ ] BAST email sent (or skipped if internal project)
- [ ] Warranty policy attached (30-day coverage)
- [ ] Staging credentials sent
- [ ] Production credentials sent (1Password/Bitwarden secure send)
- [ ] Source code repo access granted
- [ ] Admin guide provided

---

### Total Timeline: **10-12 minggu (2.5-3 bulan)**

**Payment Structure (if client work)**:
- Milestone 1 (DP): 50% upfront (design + architecture done)
- Milestone 2 (Final): 50% on production deploy (includes 30-day warranty in M11 handover)

**Deliverables**:
- Source code (Git repo)
- Staging + Production URLs
- Documentation (`README.md`, `RUNBOOK_PRODUCTION.md`)

---

## 🟢 SKALA MENENGAH (Agency Project)

**Characteristics**:
- 3-6 person team (PM, Tech Lead, 2-3 devs, QA)
- Budget: Rp 50-200M
- Timeline: 3-6 bulan (12-24 minggu)
- Client: SME, startup Series A/B
- Payment: 3 milestones (30-30-40%)

**Module Sequence**: **M01 → M02 → M03 → M04 → M05 → M06 → M07 → M09 → M10 → M11**

**Skipped Modules**:
- ❌ **M00** - Product Discovery (client has validated idea)
- ❌ **M08** - Data Migration (greenfield project OR client data clean)
- ❌ **M12** - Warranty (included in retainer contract)
- ❌ **M13** - Product Ops (client handles post-launch)

**Note**: 10 modules executed (M01 + 9 scale-specific), 4 modules skipped.

---

### Real Case Timeline (Agency)

#### **Week 0: Kick-off & Discovery (3-5 hari)**

**Project Manager**:
- Kick-off meeting dengan client (2-3 jam)
- Requirements gathering: fitur, user roles, critical flows
- Project Brief (3-5 halaman):
  - Background & objective
  - Feature list (must/should/nice-to-have)
  - Timeline & milestones
  - Assumptions & risks
- Setup project tracking (Jira/Linear)

**Tech Lead**:
- Technical feasibility review
- Stack decision (Next.js? Laravel? React Native?)
- High-level architecture (monolith vs microservices)
- Estimasi timeline per feature
- Technical Brief (2-3 halaman):
  - Tech stack
  - Deployment plan
  - Third-party integrations
  - Database choice

**Designer** (jika ada):
- User flow sketches
- Low-fidelity wireframes (Figma)
- Design system reference (Shadcn? Material? Custom?)

**Output**:
- `docs/pm/IDEA_BRIEF.md`
- `docs/pm/TECH_BRIEF.md`
- Wireframes (Figma link)
- Jira/Linear board dengan epic/story
- SOW signed + 30% down payment

**Timeline**: 3-5 hari

---

#### **Week 1-2: M02 Discovery + M03 Legal (1-2 minggu)**

**M02 - Discovery**:
- Stakeholder mapping (Power/Interest matrix)
- Targeted discovery interview (business objectives, user personas, pain points, integrations, compliance)
- MoSCoW prioritization (26-40 features untuk agency scale)
- Scope boundary locking (in/out scope, client dependencies, SLA)
- Output: `SCOPE_STATEMENT.md`, `STAKEHOLDER_MAP.md`

**M03 - Legal SOW**:
- Payment structure: 30-30-40% (DP, Alpha, Final)
- Contract model: Fixed-price milestone
- Legal clauses: IP rights, liability cap, CR protocol, Single PIC rule
- DPA (Data Processing Agreement) jika handle PII
- Output: `SOW_CONTRACT.md` (signed), `PROJECT_CHARTER.md`
- **GATE (BLOCKING)**: DP funds received → proceed to design

---

#### **Week 3-4: M04 Design & Prototyping (2 minggu)**

**Designer**:
- High-fidelity mockups (key screens: login, dashboard, 2-3 main features)
- Design system setup (colors, typography, components)
- Client review & revision (1-2 rounds)
- Output: Figma mockups (10-20 screens), interactive prototype

**Tech Lead + Senior Dev**:
- Database schema design (ERD)
- API contract design (10-30 endpoints, OpenAPI optional)
- Output: `DESIGN_SYSTEM.md`, `COMPONENT_REQUIREMENTS.md`
- **GATE**: Design freeze signed by client

---

#### **Week 5-6: M05 Architecture (1-2 minggu)**

**Tech Lead**:
- ARCHITECTURE.md:
  - Directory structure
  - Data flow
  - Auth strategy
  - File upload strategy
  - Error handling pattern
- Setup repo:
  - Scaffold project (create-next-app, laravel new)
  - CI/CD pipeline (GitHub Actions → staging)
  - Staging environment
  - `.env.example`
  - `README.md` (setup instructions)
- Output: `PRD.md`, `FSD.md`, staging URL live (blank app)
- **GATE**: Stack approved → ready to code

---

#### **Week 7-14: M06 Development (2-4 sprints, 4-8 minggu)**

**Sprint Structure** (2-week sprints):

**Sprint Planning** (awal sprint, 2 jam):
- PM + Tech Lead breakdown tasks
- Devs pick tasks sesuai capacity
- Estimasi effort (story points atau jam)

**Daily Standups** (async di Slack atau sync 15 menit):
- What I did yesterday
- What I'll do today
- Blockers

**Development**:
- Backend dev: API implementation
- Frontend dev: UI implementation
- Code review: minimal 1 senior approve sebelum merge
- Git workflow:
  - `main` = production (protected)
  - `staging` = testing environment (auto-deploy)
  - Feature branches: `feat/user-auth`, `feat/inventory-crud`
  - Commit convention: `feat:`, `fix:`, `refactor:`

**Testing** (continuous):
- Dev testing: manual testing setiap feature selesai
- QA testing (jika ada QA): test case document + bug tracking
- Staging deploy: setiap merge ke staging branch
- Client demo: end of sprint (1-2 jam)

**Output per sprint**:
- Working features di staging
- Bug list (Jira/Linear)
- Sprint report (velocity, burndown)

**Timeline**: 4-8 minggu (2-4 sprints)

---

#### **Week 15-16: M07 QA & SIT (1-2 minggu)**

**Internal QA**:
- Regression testing (semua feature)
- Security basic check:
  - SQL injection test (manual atau Burp Suite)
  - XSS test
  - Auth bypass test
  - CORS check
- Performance check:
  - Lighthouse score
  - API response time (<500ms target)
  - Database N+1 query
- Bug fixing sprint

**Output**: `docs/qa/SIT_WORKBOOK.md`, bug list prioritized

---

#### **Week 17-18: M09 UAT (2-3 minggu)**

**UAT Setup**:
- UAT environment (isolated dari staging)
- Test user accounts (per role: admin, manager, staff)
- UAT guide document (20-30 halaman dengan screenshot)
- Training session (1-2 jam)

**UAT Execution**:
- Client test against acceptance criteria
- Bug submission via Jira/Linear
- P0/P1 bugs wajib fix sebelum deploy
- P2/P3 masuk post-launch backlog
- Sign-off formal: Email/dokumen approval

**Defect Triage Matrix**:
- S1 (Critical): Blocking feature, data loss → Fix immediately
- S2 (High): Major feature broken, workaround exists → Fix before go-live
- S3 (Medium): Minor bug, cosmetic → Fix post-launch or defer
- CR (Change Request): New feature → Formal CR protocol (additional cost)

**Output**: `UAT_WORKBOOK.md`, `UAT_SIGNOFF_REPORT.md` (signed by Client PIC)
**GATE (BLOCKING)**: UAT sign-off received → proceed to deploy

---

#### **Week 19: M10 Deployment (3-5 hari)**

**DevOps/Tech Lead**:
- Production environment setup:
  - Server (AWS, DigitalOcean, Railway, Vercel)
  - Database (production instance, backup setup)
  - Domain + SSL
  - Environment variables
  - CDN jika perlu (Cloudflare)
- Deploy production
- Smoke testing (test 5-10 critical flows)
- Monitoring setup (Sentry, LogRocket, atau simple error logging)

**PM**:
- Handover Document (5-10 halaman):
  - Credentials (server, database, domain, third-party APIs)
  - Deployment guide
  - Common troubleshooting
  - Warranty terms (30-90 hari gratis bug fix)
- Training session dengan client (1-2 jam):
  - Admin panel walkthrough
  - How to manage content/users
  - How to contact support
- Invoice final payment (40% remaining)

**Output**: Production URL live, Handover doc, Client training done
**GATE**: Production smoke test passes → handover

---

#### **Week 20: M11 Handover (1 minggu)**

**Documentation Delivery**:
- `USER_MANUAL.md` (20+ pages)
- `ADMIN_MANUAL.md` (user management, system config)
- `RUNBOOK_PRODUCTION.md` (deployment SOP)
- `API_DOCUMENTATION.md` (Swagger export)

**Source Code Handover**:
- Git repository transfer
- Ownership confirmation

**Credential Handover** (encrypted):
- Bitwarden shared vault
- Credentials: DB password, SSH keys, API keys, SSL cert, admin panel

**Output**: All docs delivered, source code transferred
**GATE**: Final payment (40%) received

---

### Total Timeline: **18-20 minggu (4.5-5 bulan)**

**Payment Structure**:
- Milestone 1 (DP): 30% upfront (contract signing)
- Milestone 2 (Alpha): 30% (backend + basic UI staging demo)
- Milestone 3 (Final): 40% (UAT sign-off, production live)

**Post-Launch**:
- Warranty period: 30-90 hari gratis bug fix
- Support: Bug fixes (gratis), new features (billable CR)

---

## 🟡 SKALA BESAR (Vendor/Large Project)

**Characteristics**:
- 6-12 person team (PM, Scrum Master, Tech Lead, 4-6 devs, 2 QA, DevOps, Designer)
- Budget: Rp 200-500M
- Timeline: 6-12 bulan (24-48 minggu)
- Client: Corporate, government tender, SOE
- Compliance: PDP Law, ISO 27001 (optional)
- Payment: 4 milestones (20-30-30-20%)

**Module Sequence**: **M01 → M02 → M03 → M04 → M05 → M06 → M07 → M08 → M09 → M10 → M11 → M12**

**Skipped Modules**:
- ❌ **M00** - Product Discovery (RFP already defines product)
- ❌ **M13** - Product Ops (client internal analytics team)

**Note**: 12 modules executed (M01 + 11 scale-specific), 2 modules skipped.

---

### Real Case Timeline (Vendor Scale)

*(See user-provided Week 0-9 breakdown for detailed workflow)*

**Key Differences from Agency Scale**:

1. **Pre-Sales (Week 1-2)**: RFP response, budget estimation, risk assessment
2. **Legal Contracts (Week 3)**: SOW + MSA + DPA + NDA (2-3 negotiation rounds)
3. **Design Phase (Week 4-6)**: User research, competitor benchmarking, prototype interaktif
4. **Architecture (Week 7-8)**: C4 model, Infrastructure design (AWS/GCP), Security design (RBAC, encryption)
5. **Development (Week 9-24)**: 8-16 minggu dengan 2-week sprints, daily standups, sprint reviews
6. **QA/Security (Week 25-28)**: Third-party penetration test (mandatory), load testing (10K users)
7. **Data Migration (Week 29-30)**: ETL scripts, reconciliation, client data sign-off
8. **UAT (Week 31-33)**: 2-3 minggu dengan formal UAT workbook (100+ test cases)
9. **Deployment (Week 34)**: CAB approval, blue-green deployment, war room 24 jam
10. **Handover (Week 35-36)**: 4 training sessions (end-user, admin, technical ops, executive)
11. **Warranty (Month 4-6)**: 90 hari warranty, SLA response/resolution times

**Payment Structure (4 Milestones)**:
- Milestone 1 (DP): 20-30% (contract signing)
- Milestone 2 (Alpha): 25-30% (backend + basic UI staging demo)
- Milestone 3 (Beta): 20-25% (SIT passed, ready UAT)
- Milestone 4 (Final): 10-20% (UAT sign-off, pre-BAST)

**Total Timeline**: **32-36 minggu (8-9 bulan)**

---

## 🔴 SKALA ENTERPRISE

**Characteristics**:
- 12+ person team (PM, Business Analyst, Tech Lead, 6-8 devs, 2-3 QA, Security Auditor, DevOps, UX Researcher, Product Analyst)
- Budget: >Rp 500M
- Timeline: 12-24 bulan (48-96 minggu)
- Client: Banking (OJK), Healthcare (Kemenkes), Telco (Kominfo), Government (LKPP)
- Compliance: **MANDATORY** - PDP Law, ISO 27001, SOC2, OJK regulations
- Payment: 4 milestones (20-30-30-20% atau 30-30-30-10%)

**Module Sequence**: **FULL M00 → M01 → M02 → M03 → M04 → M04B → M05 → M05B → M06 → M06B → M07 → M08 → M09 → M10 → M11 → M12 → M13**

**No Skipped Modules** - Full 14-module lifecycle required for regulatory compliance.

**Module Count**: M00, M01, M02, M03, M04, M04B, M05, M05B, M06, M06B, M07, M08, M09, M10, M11, M12, M13 = 17 total steps (14 major modules + 3 sub-modules B)

> **Note**: M04B, M05B, M06B are **subsections within their parent module files** (`docs/modules/04-uiux-prototyping.md`, `05-architecture-specs.md`, `06-development-execution.md`), not separate module files. They represent Enterprise-specific extensions executed after the base module.

---

### 📋 Enterprise Governance & Compliance Templates

**Compliance & Audit** (SOC 2, ISO 27001, GDPR):
- `templates/03-governance/SOC2_ISO27001_COMPLIANCE.md` - Audit preparation (Trust Service Criteria, evidence collection)
- `templates/03-governance/AUDIT_TRAIL_REQUIREMENTS.md` - Immutable audit logs (auth, data access, config changes)
- `templates/03-governance/DATA_RETENTION_POLICY.md` - GDPR/HIPAA retention periods (7yr financial, 1yr logs)
- `templates/03-governance/DATA_CLASSIFICATION_POLICY.md` - Public/Internal/Confidential/Restricted data handling
- `templates/03-governance/GDPR_COMPLIANCE_CHECKLIST.md` - Right to erasure, data portability, consent management

**Risk & Incident Management**:
- `templates/03-governance/RISK_ASSESSMENT_MATRIX.md` - Risk scoring (Probability × Impact), mitigation tracking
- `templates/03-governance/INCIDENT_RESPONSE_PLAN.md` - Security incident playbook (P0-P4 severity, war room)
- `templates/08-maintenance-ops/BACKUP_RESTORE_PROCEDURES.md` - Daily backups, quarterly restore tests, RTO/RPO
- `templates/08-maintenance-ops/DISASTER_RECOVERY_PLAN.md` - Business continuity (failover, data center redundancy)

**Architecture & Infrastructure**:
- `templates/03-governance/ADR_TEMPLATE.md` - Architecture Decision Records (context, decision, consequences, tradeoffs)
- `templates/04-dev-execution/IAC_GUIDE.md` - Infrastructure as Code (Terraform/Pulumi for AWS/GCP/Azure)
- `templates/08-maintenance-ops/CAPACITY_PLANNING_GUIDE.md` - Scale projections (1K → 10K → 100K users)
- `templates/08-maintenance-ops/SLA_SLO_DEFINITIONS.md` - Service levels (99.9% uptime, <200ms p95 latency)

**Stakeholder Collaboration**:
- `templates/03-governance/RACI_MATRIX.md` - Responsible/Accountable/Consulted/Informed for major decisions
- `templates/03-governance/MEETING_CADENCE_GUIDE.md` - Standups, sprint reviews, steering committee, QBR
- `templates/03-governance/EXECUTIVE_DECK_TEMPLATE.md` - 10-15 slide deck for C-level (traffic light status)
- `templates/03-governance/ESCALATION_MATRIX.md` - Severity levels, response times, escalation paths
- `templates/03-governance/STAKEHOLDER_REGISTER.md` - Power/Interest matrix, communication frequency
- `templates/03-governance/COMMUNICATION_PLAN.md` - Who gets what info, when, via which channel

**Pre-Sales & Vendor Evaluation**:
- `templates/00-pre-sales-enterprise/RFP_RESPONSE_TEMPLATE.md` - Government/corporate tender response (technical + commercial)
- `templates/03-governance/VENDOR_COMPARISON_MATRIX.md` - Weighted scoring for build-vs-buy (features, cost, support)
- `templates/00-pre-sales-enterprise/POC_PLAN_TEMPLATE.md` - Proof-of-concept scope (2-4 weeks, success criteria)

**Change & Release Management**:
- `templates/03-governance/CAB_PROCESS.md` - Change Advisory Board (RFC approval, risk assessment, rollback plan)
- `templates/07-release-handover/RELEASE_APPROVAL_CHECKLIST.md` - 10-section go/no-go gate (code, tests, security, perf, rollback)

**Operations & Training**:
- `templates/07-release-handover/TRAINING_PLAN.md` - End-user, admin, technical ops, executive training sessions
- `templates/02-legal-commercial/FINANCIAL_TRACKING.md` - Budget tracking, burn rate, milestone forecasting

---

### Enterprise Module Extensions

**M00 - Product Discovery & Strategy** (4-6 minggu):
- Market research: TAM/SAM/SOM calculation
- Competitive analysis: 5-10 competitors, SWOT
- User research: 10+ interviews, 50+ survey respondents
- Product strategy: Vision, North Star Metric, Strategic Pillars
- Output: `MARKET_RESEARCH.md`, `COMPETITIVE_LANDSCAPE.md`, `USER_RESEARCH_REPORT.md`, `PRODUCT_STRATEGY.md`

**M04B - Design System Foundation** (2-3 minggu):
- Visual inconsistency audit
- Design tokens specification (Style Dictionary)
- Component library (20+ core components)
- Storybook deployed
- Governance model (centralized vs federated)
- Output: `DESIGN_SYSTEM_AUDIT.md`, `tokens/design-tokens.json`, Storybook URL

**M05B - System Design & Infrastructure Scalability** (1-2 minggu):
- Load balancing (L4 + L7)
- Caching strategy (L1 in-memory + L2 Redis Cluster)
- Database scalability (master-slave replication, sharding)
- Async workers (RabbitMQ, Kafka)
- High availability (Multi-AZ, auto-scaling)
- Capacity planning (1K → 10K → 100K MAU projections)
- Output: `SYSTEM_DESIGN_DOC.md`, `CAPACITY_PLANNING.md`, `DISASTER_RECOVERY_PLAN.md`

**M06B - Product Instrumentation & Analytics** (1 minggu):
- Event taxonomy design (verb_noun convention)
- Analytics SDK integration (Mixpanel/Amplitude/GA4)
- AARRR funnel setup
- Error monitoring (Sentry)
- Privacy compliance (GDPR/PDP Law consent banner)
- Output: `EVENT_TAXONOMY.md`, `ANALYTICS_IMPLEMENTATION_PLAN.md`, `DASHBOARD_SPEC.md`

**M12 - Warranty Period** (90 hari):
- Warranty scope: Bug fixes only (not new features)
- Response/Resolution SLA:
  - S1 (Critical): 1 hour response, 4 hour resolution
  - S2 (High): 4 hour response, 24 hour resolution
  - S3 (Medium): 24 hour response, 72 hour resolution
- Warranty boundary defense (bug vs CR)
- Output: `WARRANTY_POLICY.md`, `INCIDENT_LOG.md`

**M12 Transition - SLA Retainer Contract**:
- Monthly retainer: Rp 20M-50M/bulan
- Scope: Bug fixes + feature requests (20-40 hours/month)
- Same SLA as warranty
- Output: `SLA_RETAINER_CONTRACT.md`

**M13 - Product Operations & Continuous Iteration** (ongoing):
- 30-day baseline metrics
- Feedback loop (user surveys, support tickets, session recordings)
- Growth experiments (RICE prioritization)
- Scaling signals (traffic growth >20% MoM)
- Quarterly Business Review (QBR)
- Output: `METRICS_BASELINE_REPORT.md`, `GROWTH_EXPERIMENTS_BACKLOG.md`, `PRODUCT_HEALTH_DASHBOARD.md`

---

### Enterprise Timeline (Full Lifecycle)

**Phase 1: Pre-Sales & Discovery** (4-6 minggu):
- Week 1-2: M00 Product Discovery
  - **Templates**: `RFP_RESPONSE_TEMPLATE.md`, `POC_PLAN_TEMPLATE.md`, `VENDOR_COMPARISON_MATRIX.md`
- Week 3: M01 Idea & Feasibility
- Week 4-5: M02 Discovery & Scope Definition
  - **Templates**: `STAKEHOLDER_REGISTER.md`, `COMMUNICATION_PLAN.md`, `RISK_ASSESSMENT_MATRIX.md`
- Week 6-8: M03 Legal SOW, DP, & Single PIC Agreement
  - **Templates**: `SLA_SLO_DEFINITIONS.md`, `GDPR_COMPLIANCE_CHECKLIST.md`, `DATA_CLASSIFICATION_POLICY.md`

**Phase 2: Design & Architecture** (6-8 minggu):
- Week 9-11: M04B Design System Foundation
- Week 12-13: M04 UI/UX Design & Prototyping
- Week 14-15: M05 Architecture & Technical Specifications (PRD & FSD)
  - **Templates**: `ADR_TEMPLATE.md`, `IAC_GUIDE.md`
- Week 16: M05B System Design & Infrastructure Scalability
  - **Templates**: `CAPACITY_PLANNING_GUIDE.md`, `DISASTER_RECOVERY_PLAN.md`

**Phase 3: Development & Instrumentation** (12-20 minggu):
- Week 17-32: M06 Development Execution
  - **Change Control**: `CAB_PROCESS.md` (production changes require RFC approval)
  - **Governance**: `MEETING_CADENCE_GUIDE.md`, `ESCALATION_MATRIX.md`
  - **Security**: `AUDIT_TRAIL_REQUIREMENTS.md` (log all privileged actions)
- Week 33: M06B Product Instrumentation & Analytics Setup

**Phase 4: Testing & Migration** (4-6 minggu):
- Week 34-36: M07 Quality Assurance & Security Audit
  - **Templates**: `SOC2_ISO27001_COMPLIANCE.md`, `INCIDENT_RESPONSE_PLAN.md`
- Week 37-38: M08 Data Migration & Seeding
  - **Templates**: `BACKUP_RESTORE_PROCEDURES.md`, `DATA_RETENTION_POLICY.md`

**Phase 5: Validation Gate** (2-3 minggu):
- Week 39-41: M09 Client UAT & Sign-Off

**Phase 6: Launch** (1-2 minggu):
- Week 42: M10 Production Deployment & Go-Live
  - **Templates**: `RELEASE_APPROVAL_CHECKLIST.md` (10-section pre-release gate)

**Phase 7: Handover Gate** (1-2 minggu):
- Week 43-44: M11 Training, BAST, & Repository Handover
  - **Templates**: `TRAINING_PLAN.md`

**Phase 8: Post-Launch Support** (90 hari + ongoing):
- Week 45-57: M12 Warranty Period (3 bulan)
- Month 4-12: M13 Product Operations & Continuous Iteration
  - **Templates**: `FINANCIAL_TRACKING.md`, `EXECUTIVE_DECK_TEMPLATE.md` (monthly QBR)

**Total Timeline**: **40-44 minggu (10-11 bulan) untuk full implementation + 3 bulan warranty**

---

## 📋 Module Routing Table

| Module | Kecil | Menengah | Besar | Enterprise | Notes |
|:-------|:-----:|:--------:|:-----:|:----------:|:------|
| **M00** Product Discovery | ❌ | ❌ | ❌ | ✅ | Enterprise only: TAM/SAM, competitive analysis |
| **M01** Idea & Feasibility | ✅ | ✅ | ✅ | ✅ | Universal: 4-dimension feasibility check |
| **M02** Discovery & Scope | ✅ | ✅ | ✅ | ✅ | Universal: MoSCoW prioritization |
| **M03** Legal SOW | 🟡 | ✅ | ✅ | ✅ | Kecil: Bypass (internal), Menengah+: Mandatory |
| **M04** UI/UX Design | ✅ | ✅ | ✅ | ✅ | Universal: Component discovery + mockups |
| **M04B** Design System | ❌ | ❌ | 🟡 | ✅ | Besar: Optional, Enterprise: Mandatory |
| **M05** Architecture | ✅ | ✅ | ✅ | ✅ | Universal: PRD + FSD |
| **M05B** System Design | ❌ | ❌ | 🟡 | ✅ | Besar: Optional (10K+ users), Enterprise: Mandatory |
| **M06** Development | ✅ | ✅ | ✅ | ✅ | Universal: Coding execution |
| **M06B** Analytics | ❌ | ❌ | 🟡 | ✅ | Besar: Optional, Enterprise: Mandatory |
| **M07** QA & Security | ✅ | ✅ | ✅ | ✅ | Universal: Kecil uses M07-LITE, Menengah+ uses full M07 |
| **M08** Data Migration | ❌ | 🟡 | ✅ | ✅ | Kecil: Skip (greenfield), Menengah: If legacy data |
| **M09** Client UAT | ✅ | ✅ | ✅ | ✅ | Universal: User acceptance testing |
| **M10** Deployment | ✅ | ✅ | ✅ | ✅ | Universal: Production go-live |
| **M11** Handover | ✅ | ✅ | ✅ | ✅ | Universal: BAST + credentials transfer |
| **M12** Warranty | ❌ | 🟡 | ✅ | ✅ | Kecil: 30-day in M11 (not separate module), Menengah: Optional, Besar+: Mandatory |
| **M13** Product Ops | ❌ | ❌ | ❌ | ✅ | Enterprise only: Analytics, growth experiments |

Legend:
- ✅ = Mandatory
- 🟡 = Optional (depends on project requirements)
- ❌ = Skip

---

## 🚨 Payment Gate Enforcement

**CRITICAL: NO CODE before DP received (Menengah+ scale)**

### Gate Locations

**M03 Legal Gate (BLOCKING)**:
```
IF scale >= "Menengah" AND client_type == "external":
  REQUIRE:
    - ✅ SOW signed (wet-ink + materai)
    - ✅ Project Charter approved by executives
    - ✅ Single PIC designated with contact info
    - ✅ DP funds received in bank account
    - ✅ DPA signed (if handle PII)
  
  IF gate NOT passed:
    STOP: NOT A SINGLE LINE OF CODE
    Agent MUST wait for user confirm "DP sudah masuk" or "BYPASS" for internal project
```

**M09 UAT Gate (BLOCKING)**:
```
REQUIRE:
  - ✅ UAT passed (all S1/S2 defects fixed, S3 documented)
  - ✅ UAT sign-off signed by Client Single PIC
  - ✅ Milestone payment received (if payment gated)

IF gate NOT passed:
  STOP: NO PRODUCTION DEPLOY
  Agent MUST wait for user confirmation
```

**M11 Handover Gate (BLOCKING)**:
```
REQUIRE:
  - ✅ BAST signed with wet-ink + stamp duty (Rp 10.000 materai)
  - ✅ Final payment (Milestone 4) received in bank account
  - ✅ All training sessions completed (attendance log signed)

IF gate NOT passed:
  STOP: NO CODE/CREDENTIALS TRANSFER
  Agent MUST wait for confirmation
```

---

## 🔄 Warranty Boundary Defense Scripts

**Common scope creep scenarios:**

### Scenario 1: "Small Feature Request"
```
Client: "Can you add export to Excel? It's just small thing."

Response:
"Export to Excel is a new feature (not a bug fix). Under warranty, we cover bug fixes only.

Options:
1. Defer to Phase 2 (post-warranty, separate quote)
2. Add via Change Request: +3 days, +Rp 15M (includes CSV + XLSX formats)
3. Drop feature X to fit within original timeline

Which do you prefer?"
```

### Scenario 2: "UI Tweak"
```
Client: "Can you change button color from blue to green?"

Analysis:
- Original design: Blue button (approved in design freeze)
- Change: Cosmetic tweak (not a bug)

Response:
"This is a design change (not a bug). Original design was approved in Module 04 design freeze.

Options:
1. Include as goodwill (if <10 min effort)
2. Defer to post-warranty (if >10 min or affects multiple screens)
3. Formal CR if requires design system changes (+1 day, +Rp 5M)

Recommend: Option 1 (goodwill this time, future changes billable)."
```

### Scenario 3: "Bug or Feature?"
```
Client: "User can't see deleted items. This is a bug!"

Analysis:
- PRD Scope: User can delete items (✅ implemented)
- PRD Scope: Soft delete with trash bin (❌ NOT in scope)

Response:
"Permanent delete is working as specified in PRD (Module 05).
Soft delete with trash bin was NOT in original scope (check PRD.md Section 3.2).

This is a new feature request, not a bug.

Options:
1. Add via CR: +5 days, +Rp 25M (soft delete + trash bin + restore)
2. Defer to Phase 2
3. Client provides written confirmation: 'I understand trash bin was not in original scope'

Which do you prefer?"
```

---

## 📖 Reference Documents per Scale

| Document | Kecil | Menengah | Besar | Enterprise |
|:---------|:-----:|:--------:|:-----:|:----------:|
| **IDEA_BRIEF.md** (or PROJECT_LITE.md) | ✅ | ✅ | ✅ | ✅ |
| **SCOPE_STATEMENT.md** | 🟡 (or PROJECT_LITE) | ✅ | ✅ | ✅ |
| **SOW_CONTRACT.md** | ❌ | ✅ | ✅ | ✅ |
| **PROJECT_CHARTER.md** | ❌ | 🟡 | ✅ | ✅ |
| **DPA.md** (Data Processing Agreement) | ❌ | 🟡 | ✅ | ✅ |
| **MARKET_RESEARCH.md** (or M00_LITE.md) | ❌ | ✅ (Solo SaaS) | ✅ | ✅ |
| **SYSTEM_DESIGN_DOC.md** | ❌ | ❌ | 🟡 | ✅ |
| **CAPACITY_PLANNING.md** | ❌ | ❌ | 🟡 | ✅ |
| **SECURITY_AUDIT_REPORT.md** | ❌ | 🟡 | ✅ | ✅ |
| **PENETRATION_TEST_REPORT.md** | ❌ | ❌ | ✅ | ✅ |
| **DATA_MIGRATION_PLAN.md** | ❌ | 🟡 | ✅ | ✅ |
| **UAT_WORKBOOK.md** | 🟡 | ✅ | ✅ | ✅ |
| **BAST.md** (signed PDF) | ❌ | ✅ | ✅ | ✅ |
| **WARRANTY_POLICY.md** | ✅ | 🟡 | ✅ | ✅ |
| **SLA_RETAINER_CONTRACT.md** | ❌ | 🟡 | ✅ | ✅ |

> **Note**: Small scale uses `WARRANTY_POLICY_SMALL.md` (30-day warranty included in M11 handover).

---

## 🎯 Quick Decision Tree

**Pre-Routing Note**: Enterprise projects (>Rp 500M, RFP/tender context) start at M00 (Product Discovery) before M01. For all other projects, complete M01 first, then route by scale:

```
START: After completing M01 (Idea & Feasibility), route by scale:

IF scale == "Kecil":
  → Path: M02 → M03(bypass) → M04 → M05 → M06 → M09(self-test) → M10 → M11(bypass)
  → Total lifecycle: M01 + 8 scale-specific = 9 modules
  → Timeline: 10-12 minggu
  → Payment: 50-50% (if external) or no payment (if internal)

ELSE IF scale == "Menengah":
  → Path: M02 → M03(SOW) → M04 → M05 → M06 → M07 → M09(formal UAT) → M10 → M11(BAST)
  → Total lifecycle: M01 + 9 scale-specific = 10 modules
  → Timeline: 18-20 minggu
  → Payment: 30-30-40% (3 milestones)
  → Gates: M03 DP gate, M09 UAT gate, M11 final payment gate

ELSE IF scale == "Besar":
  → Path: M02 → M03(SOW+MSA) → M04 → M05 → M06 → M07(pentest) → M08(migration) → M09(UAT) → M10(CAB) → M11(training+BAST) → M12(warranty)
  → Total lifecycle: M01 + 11 scale-specific = 12 modules
  → Timeline: 32-36 minggu
  → Payment: 20-30-30-20% (4 milestones)
  → Gates: M03 DP gate, M07 pentest gate, M09 UAT gate, M11 final payment gate

END
```

**Enterprise Path (Separate - Pre-M01)**:
```
IF project context == RFP/tender/corporate (>Rp 500M):
  → Start: M00 (Product Discovery) validates RFP requirements
  → M01 performs feasibility check (scale already known from RFP context)
  → Path: M00 → M01 → M02 → ... → M13 (all 14 modules)
  → Total lifecycle: 14 modules (M00 through M13)
  → Timeline: 40-44 minggu + 3 bulan warranty + ongoing M13
  → Payment: 20-30-30-20% (4 milestones)
  → Gates: M00 feasibility gate, M03 DP gate, M04B design system gate, M05B capacity planning gate, M07 pentest gate, M09 UAT gate, M11 BAST gate
```

---

**Next Steps**:
1. User completes M01 feasibility check
2. M01 outputs scale classification (Kecil/Menengah/Besar/Enterprise)
3. Refer to this document → select module path
4. Execute modules in sequence
5. Enforce payment gates (if external client)
6. Defend warranty boundaries (bug vs CR)

**For detailed week-by-week breakdown, see user-provided real case timelines above.**
