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

## 🔵 SKALA KECIL (Fast-Track MVP / Solo Project)

**Characteristics**:
- Solo developer / 1 developer + 1 stakeholder
- Timeline: <4 minggu (<1 bulan)
- Fitur: 3–7 P0 Must-Have (scope terkunci)
- Database terisolasi, low blast radius (tanpa mutasi finansial rumit / rekam medis)
- Jalur pengiriman default: Solo / Portfolio / Internal Tool

> ⚖️ **LEGACY DATA RE-CLASSIFICATION RULE**:
> Skala Kecil berasumsi *greenfield* (data kosong). Jika proyek membutuhkan migrasi data lama (ETL relasional), proyek **otomatis naik kelas ke Skala Besar** via High-Water Mark rule dan wajib menjalankan M08 penuh.

**Alur 6 Langkah Inti**:
1. **Intake Gate** (5 pertanyaan wajib di `docs/pm/PROJECT_STATE.md`) $
ightarrow$ Klasifikasi skala otomatis.
2. **M04-LITE** (Logo inisial SVG $\ge 50$B boleh, 1 benchmark visual, token anti-slop di `DESIGN.md`).
3. **M05** (Dokumen terpadu `PROJECT_LITE.md` mencakup skema, API, dan Riskiest Assumption Test).
   🛑 **STOP 1**: Tinjau desain & spek sebelum coding.
4. **M06** (Sprint 0 deploy hello-world staging $
ightarrow$ build atomik $
ightarrow$ lint & `tsc --noEmit` $
ightarrow$ `SECURITY_CHECKLIST_SMALL.md`).
5. **M09-LITE** (Uji orang lain: minimal 1 penguji eksternal tercatat di `UAT_SIGNOFF_SMALL.md`).
   🛑 **STOP 2**: Verifikasi fungsi lokal & approval deploy.
6. **M10** (Deploy production, verifikasi HTTP 200, anti-Friday deploy) $
ightarrow$ Operasional mandiri via `RUNBOOK_OPS.md` (M12).

*(Tambahan hanya jika ada klien: **M03 SOW singkat** sebelum desain, dan **M11 serah terima singkat** setelah deploy).*

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

## 🟢 SKALA MENENGAH (Medium / Mid-Tier / Agency)

**Characteristics**:
- 1 Solo Developer + 1 Client Single PIC (or small team 2–3 devs)
- Timeline: 1–3 bulan
- Fitur: 8–15 P0 Must-Have (terkunci formal di `SCOPE_STATEMENT.md`)
- Integrasi eksternal: Webhook Payment Gateway, WhatsApp API, transactional email
- Model pengiriman: Client Commercial (Software House/Freelance) atau Solo SaaS Mandiri

---

### Alur 8 Fase Tangkas (Client Commercial 30/40/30)

```text
[ FASE 1: INTAKE & REGULASI ]
  • Intake 5 pertanyaan + evaluasi sektor (medis/keuangan)
  • Tentukan Delivery: client / solo

[ FASE 2: COMMERCIAL LOCK (M03) ] ──► 🛑 STOP 1 (DP 30% Cair)
  • SOW termin 30/40/30, Single PIC, batas revisi 2x, deemed acceptance 7 hari
  • Akun pihak ketiga atas nama klien, CR framework aktif
  • Invoice termin 1 + e-Meterai / NDA

[ FASE 3: DESIGN & SPEC (M04 + M05) ] ──► 🛑 STOP 2 (Design Freeze & Tech Spec Signoff)
  • M04 spesifikasi risiko (layar kritis 5-state penuh, layar statis ringkas)
  • M05 PRD + FSD + Traceability Matrix + Skema DDL + Rencana Rollback DB
  • Scope terkunci mati (CR log aktif)

[ FASE 4: SPRINT BUILD & DEMO (M06) ] ──► 🛑 STOP 3 (Termin 2: 40% Cair Pasca Demo Staging)
  • Sprint 0: scaffold + staging setup + dummy data seeder realistis
  • Sprint eksekusi: TODO.md ber-Definition of Done per sprint
  • Build, lint, tsc --noEmit, test otomatis
  • DEMO STAGING MILESTONE ke Klien Single PIC ──► Klien bayar Termin 2 (40%)

[ FASE 5: UAT BISNIS & REMEDIASI (M09) ] ──► 🛑 STOP 4 (UAT Signoff Formal)
  • Pengujian skenario bisnis oleh Klien Single PIC di staging
  • Aturan bug: S1/S2 wajib 0; bug S3/S4 dicatat untuk masa garansi (tidak menahan UAT)
  • UAT Signoff Report ditandatangani / Deemed approval 7 hari

[ FASE 6: RILIS TERKONTROL (M10) ]
  • Deploy ke production environment / staging akhir dev (preview domain)
  • Probe curl HTTP 200, tes backup & uji restore nyata
  • Hypercare 1-2 minggu dimulai

[ FASE 7: BAST & HANDOVER LEVERAGE (M11) ] ──► 🛑 STOP 5 (Pelunasan 30% Terakhir)
  • Klien transfer sisa pelunasan 30%
  • TTD BAST (Berita Acara Serah Terima) fisik/digital
  • BARU pindahkan DNS ke domain klien, transfer akun hosting, rotasi kredensial root

[ FASE 8: WARRANTY & RETROSPEKTIF (M12) ]
  • Garansi 30-60 hari aktif (hanya perbaikan bug FSD, tertulis di BAST)
  • Retrospektif solo dev & penutupan time tracking
```

---

## 🟡🔴 SKALA DI LUAR KAPASITAS SOLO (Large & Enterprise — A-Series Advisory)

> ⛔ **STRICT SOLO CODING PROHIBITION**:
> Proyek dengan **>15 fitur P0**, multi-cabang, mutasi finansial/rekam medis massal, atau regulasi statutori (OJK/BI/UU PDP/ISO 27001) **SECARA FISIK DAN HUKUM TIDAK BISA DIKERJAKAN SOLO**.
> Menjanjikan koding mandiri untuk skala ini adalah anti-pola berbahaya. Skill ini mengalihkan mode solo developer menjadi **Lead Enterprise Architect / Technical Advisor**.

---

### Alur 5 Fase Advisory Korporat (Seri A00 – A04)

```text
[ TENDER / KESEMPATAN ENTERPRISE ]
                │
                ▼
[ FASE A00: Bid/No-Bid, Evaluasi Kelayakan & Kontrak Konsultasi ] ──► 🛑 STOP 1 (Perjanjian Konsultasi)
  • Uji kelayakan administratif tender (PT/CV, NPWP, sertifikasi, modal disetor)
  • Matriks Bid/No-Bid (Kapasitas, margin risiko, larangan penawaran gratis tak terbatas)
  • Kontrak: CONSULTING_AGREEMENT_TEMPLATE.md (Termin Net 30, limit liabilitas, pakta anti-konflik)
                │
                ▼
[ FASE A01: WBS, Dekomposisi Domain & Isolasi Legacy ]
  • Dekomposisi Scope: Memecah >15 P0 menjadi 2-3 paket Skala Menengah mandiri
  • Uji Kelayakan Pecahan: Setiap paket wajib diuji lolos Scale: medium via classify-scale.sh
  • Isolasi Legacy: Konektor core banking/ERP warisan dipisahkan menjadi paket spike khusus
  • Output: WBS_PHASING_PLAN.md
                │
                ▼
[ FASE A02: Arsitektur C4, STRIDE & Skenario Kualitas Terukur ] ──► 🛑 STOP 2 (Sign-Off Arsitektur)
  • C4 Model (Context, Containers, Components) + ADR Suite
  • Pemodelan Ancaman (STRIDE): Mitigasi konkret per container
  • Skenario Kualitas ATAM: Latensi konkret, throughput TPS terukur, RPO <15m, RTO <1h
  • Residensi Data Lokal: ADR penguncian region lokal (AWS Jakarta ap-southeast-3 / on-premise)
  • Pemetaan Kepatuhan: UU PDP No. 27/2022, POJK Siber, PBI, Kemenkes SatuSehat
  • Output: ENTERPRISE_ARCHITECTURE_BLUEPRINT.md, ADR_SUITE.md, THREAT_MODEL_STRIDE.md
                │
                ▼
[ FASE A03: Pengadaan Vendor, Build-vs-Buy & Strategi Anti-Lock-In ]
  • Penyusunan Spesifikasi Teknis Pengadaan (Lampiran Teknis RFP Korporat)
  • Analisis Build-vs-Buy untuk komponen komoditas (Auth IAM, Payment Gateway, CMS)
  • Matriks Evaluasi Vendor Terbobot (Objektif, tanpa konflik kepentingan advisor)
  • Strategi Anti-Lock-In: Skema DDL terbuka dan skrip portabilitas data keluar
  • Output: VENDOR_PROCUREMENT_SCHEDULE.md, VENDOR_COMPARISON_MATRIX.md
                │
                ▼
[ FASE A04: Serah Terima Tata Kelola & Retainer Keselarasan Arsitektur ] ──► 🛑 STOP 3 (Sign-Off Final)
  • RACI Matrix Korporat: Penanggung jawab keputusan multi-divisi
  • Protokol CAB & Checklist Rilis: Template resmi yang diserahkan untuk dijalankan tim klien
  • Cetak Biru Disaster Recovery: Topologi failover & protokol latihan restore berkala
  • Retainer Keselarasan Arsitektur: Hak review arsitektur per sprint milestone vendor
  • Output: GOVERNANCE_HANDOVER_PACK.md (Setara BAST Advisory)
```

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
- `templates/03-governance/INCIDENT_RESPONSE_PLAN.md` - Security incident playbook (P0-P4 severity, escalation playbook)
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

**Pre-Routing Note**: Enterprise projects (statutory/regulated, RFP/tender context) start at M00 (Product Discovery) before M01. For all other projects, complete M01 first, then route by scale:

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
IF project context == RFP/tender/corporate/regulated (statutory audit constraints):
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
