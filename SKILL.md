---
name: solo-project-lifecycle
description: End-to-end software development lifecycle (SDLC) orchestrator for solo developers and technical consultants executing projects from Small (MVP) to Enterprise scale. Covers the full 12-stage pipeline from raw idea triage, feasibility evaluation, discovery, contract gating, UI/UX, architecture/FSD, development, QA/SIT, data migration, UAT sign-off, production deployment, to BAST handover and maintenance. Trigger whenever proposing a new app idea, scoping a project, qualifying clients, drafting PRD/FSD, planning architectures, or closing projects.
---

# Solo Software Lifecycle Orchestrator

Framework operasional perangkat lunak untuk solo developer dan konsultan teknis dalam mengeksekusi proyek dari skala Kecil (MVP) hingga Enterprise dengan proteksi batas kerja, otomasi AI, dan gerbang kualitas berjenjang.

> 🚀 **PANDUAN INISIASI CEPAT (ANTI-CONFLICT PROTOCOL)**:
> Sebelum memulai koding atau membuat folder proyek, baca panduan Quickstart di **`README.md`**.
> Jangan pernah menyalin berkas harness (`AGENTS.md`, `TODO.md`, dll.) ke folder kosong **sebelum** menjalankan scaffolding framework bahasa Anda (`create-next-app`, `poetry init`, `composer`, `dotnet new`, `flutter create`, dll.) agar tidak terkena penolakan CLI (*directory conflict*).

---

## 1. Peta 12 Rantai Alur Kerja (The 12-Stage Pipeline)

```text
FASE INISIASI & DISCOVERY:
  00. Product Discovery & Strategy (Riset Pasar, Kompetitor, & Pengguna) ──► modules/00-product-discovery-strategy.md
  01. Idea & Feasibility (Saringan 3 Lapis & Skor Kelayakan) ──► modules/01-idea-feasibility.md
  02. Discovery & Scope Definition (Elisitasi Kebutuhan Bisnis)
  03. [GATE KOMERSIAL] Legal SOW, DP, & Single PIC Agreement

FASE PERANCANGAN & SPESIFIKASI:
  04A. Design System Foundation & Implementation (Token System, Component Library, Governance) ──► modules/04A-design-system-foundation.md
  04. UI/UX Design & Prototyping (Design System & User Flow)
  05. Arsitektur & Spesifikasi Teknis (PRD, FSD, & Skema DB)
    05B. System Design & Infrastructure Scalability (High Availability, Capacity Planning, Caching) ──► modules/05B-system-design-infrastructure.md

FASE EKSEKUSI & VALIDASI:
  06. Development (Backend, Frontend, Integrasi API)
  06B. Product Instrumentation & Analytics Setup (Mixpanel, Event Taxonomy, Dashboards)
  07. Quality Assurance (Unit Test, SIT, & Security Audit)
  08. Data Migration & Seeding (Pembersihan & Transformasi Data)
  09. [GATE VALIDASI] UAT & Sign-Off Klien di Staging

FASE RILIS & PENUTUPAN:
  10. Deployment & Production Go-Live (CI/CD, DNS, SSL)
  11. [GATE PENYERAHAN] Pelunasan 100%, Training, BAST, & Handover Repositori
  12. Masa Garansi (Bug Fix) ──► Transisi ke Monthly Retainer / SLA
  13. Product Operations & Continuous Iteration (Baseline Metrik, RICE, Feedback Loop) ──► modules/13-product-operations-iteration.md
```

**CRITICAL: Progressive Loading Protocol**
- **DO NOT load all 17 modules at once** (total ~100K tokens)
- Load specific module ONLY when entering that phase
- Example: "Load modules/03-legal-sow-charter.md" when at Module 03
- Reduces context pollution and improves response quality

---

## 2. Prinsip Pertahanan Solo Developer (Core Solo Rules)

1. **Defensif terhadap Lingkup (Scope Protection)**: Solo dev tidak memiliki tim pengganti. Setiap penambahan fitur tanpa dokumen resmi adalah beban cuma-cuma (*unpaid work*).
2. **Aturan Single PIC**: Pada proyek Menengah ke atas, Klien wajib menetapkan satu penanggung jawab mutlak untuk mencegah konflik internal klien membebani developer.
3. **Ketergantungan Klien Terkunci (Client Dependency SLA)**: Jadwal rilis terikat pada kecepatan klien menyediakan data, akses, dan approval. Keterlambatan klien otomatis menggeser timeline.
4. **Gerbang Tanpa Kompromi (Gated Delivery)**:
   - Tidak ada koding tanpa DP & kesepakatan tertulis.
   - Tidak ada pointing domain produksi tanpa UAT Pass.
   - Tidak ada serah terima source code/kredensial root tanpa pelunasan 100% dan penandatanganan BAST.
5. **Wajib Berhenti di Setiap Gerbang (Mandatory Turn-Stopping at Gates)**:
   - **SETIAP KALI SATU MODUL SELESAI, AGEN WAJIB BERHENTI (END TURN)**.
   - DILARANG KERAS memborong banyak modul secara otomatis dalam satu giliran interaksi.
   - Izin pengguna seperti *"isi dulu nanti saya review"* HANYA berlaku untuk satu modul yang sedang aktif, BUKAN tiket kosong untuk mengeksekusi modul-modul berikutnya tanpa henti.
   - Agen WAJIB menampilkan ringkasan artefak modul yang baru selesai dan meminta persetujuan eksplisit pengguna sebelum melangkah ke modul berikutnya.

---

## 3. Matriks Skala Proyek & Fast-Track Mode

| Skala | Batasan Karakteristik | Modul 01: Ideation & Feasibility | Modul 02–05: Specs & Design | Modul 06–09: QA & UAT | Modul 10–12: Rilis & BAST |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Kecil (MVP / Fast-Track)** | 1–4 minggu, 1–3 fitur, solo user | **Fast-Track Protocol**: Gunakan 1 berkas `PROJECT_LITE.md` (Gabungan Modul 01, 02, 03, 05). **Modul 04 (Google Stitch UI/UX) TETAP WAJIB** untuk Web/Mobile/Desktop GUI agar tidak AI-slop. **Modul 04 SKIP** hanya untuk: CLI tool, API-only backend, cron job, automation script tanpa UI | Unit test logika inti + Smoke test lokal, UAT langsung ke pemilik bisnis | Deploy PaaS/Store langsung, BAST format ringkas via email |
| **Menengah** | 1–3 bulan, Auth, DB, Payment/API | Feasibility 4 Dimensi, Validasi Pasar | PRD modular, Google Stitch Design System, FSD, API Contract | Automated test API, SIT, UAT PIC bertanda tangan | CI/CD pipeline, BAST bermeterai, garansi 30–60 hari |
| **Besar** | 3–6 bulan, integrasi multi-sistem | Audit Arsitektur Awal, Risk Analysis | PRD formal, FSD mendalam, Context Map, WBS level 3 | Full test pyramid, Pentest dasar, UAT formal bertahap | Zero-downtime deploy, BAST fisik/digital, garansi 90 hari |
| **Enterprise** | > 6 bulan, kepatuhan hukum, bank/BUMN | Audit UU PDP, Compliance, Security Gate | Business Case, Formal Charter, PRD, FSD, RTM, DPA | Third-party Pentest, Disaster recovery drill, Formal UAT | CAB Approval, scheduled maintenance window, BAST hukum, SLA |

---

## 4. Status Modul Eksekusi

- [x] **Modul 00: Product Discovery & Strategy**: `modules/00-product-discovery-strategy.md` — Riset pasar (TAM/SAM/SOM), analisis kompetitor, riset wawancara pengguna (JTBD), penentuan North Star Metric, dan Value Proposition Canvas. **SKIP jika**: Fast-Track MVP dengan deadline ketat.
- [x] **Modul 01: Idea & Feasibility**: `modules/01-idea-feasibility.md` — Saringan ide 3 lapis, uji kelayakan 4 dimensi, pemotongan fitur ekstrem, penentuan skala awal.
- [x] **Modul 02: Discovery & Scope Definition**: `modules/02-discovery-scope.md` — Elisitasi kebutuhan stakeholder, pemetaan peran pengguna, breakdown MoSCoW, penguncian In-Scope vs Out-of-Scope, dan pendaftaran dependensi klien.
- [x] **Modul 03: [GATE KOMERSIAL] Legal SOW, DP, & Single PIC Agreement**: `modules/03-legal-sow-charter.md` — Penentuan model kontrak, termin pembayaran milestone, pengikatan mutlak Single PIC, protokol Change Request, dan pengamanan Down Payment.
- [x] **Modul 04A: Design System Foundation & Implementation**: `modules/04A-design-system-foundation.md` — Terminologi DS (Design System vs Design Language vs Component Library), audit inkonsistensi visual, design tokens (primitive + semantic layers), core components (20 essentials), Figma setup & plugins, tooling workflow (Style Dictionary, Storybook, Chromatic), governance model (centralized vs federated), adoption metrics, dan product management untuk DS. **SKIP jika**: MVP solo dev <4 minggu, API-only backend, CLI tool. **WAJIB jika**: Proyek Besar/Enterprise dengan multi-platform (Web+iOS+Android), white-label requirements, atau tim 3+ engineer.
- **Modul 04: UI/UX Design & Specification**: `modules/04-uiux-prototyping.md` — Menghasilkan `DESIGN.md`, `docs/specs/DESIGN_SPEC.md`, dan `docs/design/DESIGN_REFERENCES.md`; mencakup arsitektur informasi, sitemap & page inventory berbasis scope, shared component standards, states, responsive behavior, accessibility, asset needs, dan Design Freeze. Google Stitch/prototype hanya opsional jika dipilih user dan lolos review.
- [x] **Modul 05: Arsitektur & Spesifikasi Teknis (PRD & FSD)**: `modules/05-architecture-specs.md` — Pemilihan tech stack (Boring Tech ladder), skema basis data SQL DDL, kontrak API & matriks error, arsitektur keamanan (UU PDP/AES-256), dan pengesahan FSD.
- [x] **Modul 05B: System Design & Infrastructure Scalability**: `modules/05B-system-design-infrastructure.md` — Skalabilitas infrastruktur, load balancing, caching layer (Redis), database replication/sharding, asynchronous worker/queues, high availability (Multi-AZ), dan capacity planning. **SKIP jika**: Proyek Kecil (MVP).
- [x] **Modul 06: Development (Backend, Frontend, Integrasi API)**: `modules/06-development-execution.md` — Setup repo & tooling, migrasi DB & seeding lokal, implementasi API Zod-gated, perakitan UI Stitch, enkripsi streaming AES-256, dan self-smoke test.
- [x] **Modul 06B: Product Instrumentation & Analytics Setup**: `modules/06B-product-instrumentation.md` — Integrasi Mixpanel/Amplitude/GA4, event taxonomy `verb_noun`, funnel tracking AARRR, A/B testing infrastructure, dashboard North Star Metric, error monitoring Sentry, dan privacy compliance GDPR/UU PDP.
- [x] **Modul 07: Quality Assurance (Unit Test, SIT, & Security Audit)**: `modules/07-quality-assurance-sit.md` — Piramida pengujian solo dev, SIT sandbox pihak ketiga (Payment/Storage/Email), audit keamanan OWASP/UU PDP, uji beban k6, dan rilis staging.
- [x] **Modul 08: Data Migration & Seeding**: `modules/08-data-migration-seeding.md` — Protokol data hygiene (Clean-In/Clean-Out), pemetaan kolom sumber-ke-target, sanitasi masking PII Staging, skrip batch ETL atomik, dan rekonsiliasi data sign-off.
- [x] **Modul 09: [GATE VALIDASI] UAT & Sign-Off Klien di Staging**: `modules/09-uat-client-signoff.md` — Pengujian pengguna di Staging, matriks triase cacat (Severity 1/2/3/CR), penangkisan scope creep, klausul deemed acceptance, dan Berita Acara UAT bertandatangan.
- [x] **Modul 10: Deployment & Production Go-Live**: `modules/10-deployment-production.md` — Checklist pra-rilis (No Friday Deploy), git merge tagging SemVer, konfigurasi DNS/SSL TLS 1.3, rilis mobile Android Keystore & iOS TestFlight, migrasi DB zero-downtime, dan PVT.
- [x] **Modul 11: [GATE PENYERAHAN] Pelunasan, Training, BAST, & Handover Repositori**: `modules/11-handover-bast.md` — Penagihan invoice final, jatah kuota training (1–2 sesi), transfer repo Git & kredensial terenkripsi (Bitwarden Send), dan penandatanganan BAST sah bermeterai.
- [x] **Modul 12: Masa Garansi & Transisi ke Monthly Retainer / SLA**: `modules/12-warranty-sla-retainer.md` — Penegakan batas masa garansi bug-fix murni, matriks SLA respon/resolusi, penanganan darurat insiden post-mortem, dan konversi ke kontrak retainer bulanan berulang.
- [x] **Modul 13: Product Operations & Continuous Iteration**: `modules/13-product-operations-iteration.md` — Pengumpulan baseline metrik 30 hari pasca-rilis, otomasi feedback loop & NPS, cohort retention analysis, prioritas eksperimen pertumbuhan (RICE), dan pemantauan scaling signals.

---

## 5. Direktori Template & Struktur Penempatan Berkas

> 📁 **ATURAN DISTRIBUSI BERKAS MUTLAK (FOLDER HYGIENE)**:
> - **Folder `docs/pm/`**: Khusus dokumen inisiasi, lingkup, hukum, dan tata kelola (`IDEA_BRIEF.md`, `SCOPE_STATEMENT.md`, `PROJECT_CHARTER.md`, `SOW_CONTRACT.md`, `BAST.md`, dll.).
> - **Folder `docs/specs/`**: Khusus dokumen spesifikasi teknis dan antarmuka (`PRD.md`, `FSD.md`, `DESIGN_SPEC.md`).
> - **Root Direktori (`./`)**: DICADANGKAN SECARA EKSKLUSIF HANYA UNTUK 7 BERKAS HARNESS AI (`AGENTS.md`, `CONTEXT.md`, `ARCHITECTURE.md`, `DESIGN.md`, `CONVENTIONS.md`, `.env.example`, `TODO.md`), `README.md`, dan konfigurasi framework. **Dilarang menaruh dokumen perencanaan di root!**

### Jalur Cepat (Fast-Track Mode)
- `templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md`: Template spesifikasi ramping terpadu (Ide + Scope + Komersial + Skema DB) untuk proyek MVP 1–4 minggu. Disimpan di root (`./PROJECT_LITE.md`). *(Catatan: Modul 04 Google Stitch tetap wajib untuk Web/Mobile).*

### Modul 00 (Aktif)
- `templates/01-discovery-commercial/MARKET_RESEARCH_TEMPLATE.md`: Disimpan ke **`docs/pm/MARKET_RESEARCH.md`** (Hasil TAM/SAM/SOM, industry trends, regulatory landscape).
- `templates/01-discovery-commercial/COMPETITIVE_LANDSCAPE_TEMPLATE.md`: Disimpan ke **`docs/pm/COMPETITIVE_LANDSCAPE.md`** (Analisis 5-10 kompetitor, feature matrix, SWOT, positioning map).
- `templates/01-discovery-commercial/USER_RESEARCH_REPORT_TEMPLATE.md`: Disimpan ke **`docs/pm/USER_RESEARCH_REPORT.md`** (Rangkuman interview/survey, persona JTBD, user journey, pain matrix).
- `templates/01-discovery-commercial/PRODUCT_STRATEGY_TEMPLATE.md`: Disimpan ke **`docs/pm/PRODUCT_STRATEGY.md`** (Vision/Mission, North Star Metric, Value Prop Canvas, Strategic Pillars).

### Modul 01 (Aktif)
- `templates/01-discovery-commercial/IDEA_BRIEF_TEMPLATE.md`: Disimpan ke **`docs/pm/IDEA_BRIEF.md`** (Ringkasan ide, elevator pitch, 3-filter triage, skor kelayakan).

### Modul 02 (Aktif)
- `templates/01-discovery-commercial/SCOPE_STATEMENT_TEMPLATE.md`: Disimpan ke **`docs/pm/SCOPE_STATEMENT.md`** (Kesepakatan lingkup MoSCoW, RBAC, batas Out-of-Scope, dependensi SLA).

### Modul 03 (Aktif)
- `templates/archive/commercial/PROJECT_CHARTER_TEMPLATE.md`: Disimpan ke **`docs/pm/PROJECT_CHARTER.md`** (Wewenang Single PIC, objektif bisnis, milestone global). *(Wajib dibuat juga untuk solo dev product)*.
- `templates/archive/commercial/SOW_CONTRACT_TEMPLATE.md`: Disimpan ke **`docs/pm/SOW_CONTRACT.md`** (Perjanjian komersial legal, termin pembayaran, liability cap).

### Modul 04A (Aktif)
- `templates/02-design/DESIGN_SYSTEM_AUDIT_TEMPLATE.md`: Template audit inkonsistensi visual (color inventory, typography, spacing, component duplication). Disimpan ke **`docs/design/DESIGN_SYSTEM_AUDIT.md`**.
- `templates/02-design/DESIGN_TOKENS_SPEC_TEMPLATE.md`: Template spesifikasi design tokens (primitive + semantic, color/typography/spacing/shadow/motion, platform outputs CSS/iOS/Android/Flutter). Disimpan ke **`tokens/design-tokens.json`** + generated **`dist/css/variables.css`**.
- `templates/02-design/COMPONENT_API_SPEC_TEMPLATE.md`: Template dokumentasi komponen (props, variants, states, accessibility checklist, usage examples, migration guide). Disimpan ke **`docs/design/COMPONENT_API_SPEC.md`** per komponen.

**Modul 04 (Aktif)**
- `templates/02-design/DESIGN_MD_TEMPLATE.md`: Disimpan ke root (**`./DESIGN.md`**) sebagai source of truth design tokens dan component standards.
- `templates/02-design/DESIGN_SPEC_TEMPLATE.md`: Disimpan ke **`docs/specs/DESIGN_SPEC.md`** (Arsitektur informasi, rute URL, page/sub-page inventory berbasis scope, states, responsive behavior, dan lembar Design Freeze).
- `docs/design/DESIGN_REFERENCES.md`: Dibuat dari keyword pencarian visual untuk Pinterest, Behance, dan Dribbble. Jangan menyalin karya referensi.

### Modul 05 (Aktif)
- `templates/03-architecture-specs/PRD_FINAL_TEMPLATE.md`: Disimpan ke **`docs/specs/PRD.md`** (Spesifikasi produk resmi, matriks RBAC, metrik KPI, batasan NFR).
- `templates/03-architecture-specs/FSD_TECHNICAL_TEMPLATE.md`: Disimpan ke **`docs/specs/FSD.md`** (Spesifikasi teknis arsitektur, ERD, SQL DDL baku, kontrak API JSON, security blueprint).

### Modul 05B (Aktif)
- `templates/03-architecture-specs/SYSTEM_DESIGN_DOC_TEMPLATE.md`: Disimpan ke **`docs/specs/SYSTEM_DESIGN_DOC.md`** (Spesifikasi arsitektur sistem skala besar, load balancing, caching, DB partitioning/sharding).
- `templates/03-architecture-specs/CAPACITY_PLANNING_TEMPLATE.md`: Disimpan ke **`docs/specs/CAPACITY_PLANNING.md`** (Proyeksi traffic MAU/RPS, utilisasi CPU/Memory, dan kebutuhan resource server/DB/Redis).
- `templates/03-architecture-specs/DISASTER_RECOVERY_PLAN_TEMPLATE.md`: Disimpan ke **`docs/specs/DISASTER_RECOVERY_PLAN.md`** (SOP mitigasi bencana RPO/RTO, skenario failover Multi-AZ, dan prosedur recovery).
- `templates/03-architecture-specs/DESIGN_PATTERN_DECISION_TREE_TEMPLATE.md`: Disimpan ke **`docs/specs/DESIGN_PATTERN_DECISION_TREE.md`** (Pohon keputusan pemilihan software design patterns).
- `templates/03-architecture-specs/CODE_REVIEW_PATTERN_CHECKLIST_TEMPLATE.md`: Disimpan ke **`docs/specs/CODE_REVIEW_PATTERN_CHECKLIST.md`** (Checklist evaluasi pattern dan anti-pattern review).

### Modul 06 (Aktif - 7 Root Harness Files)
- `templates/04-dev-execution/AGENTS_TEMPLATE.md`: Disimpan ke root (**`./AGENTS.md`**) — *WAJIB MENIMPA AGENTS.md bawaan framework (seperti Next.js 15), dilarang di-skip!*
- `templates/04-dev-execution/CONTEXT_TEMPLATE.md`: Disimpan ke root (**`./CONTEXT.md`**) — Ringkasan bisnis & batasan Out-of-Scope.
- `templates/04-dev-execution/ARCHITECTURE_TEMPLATE.md`: Disimpan ke root (**`./ARCHITECTURE.md`**) — Ringkasan FSD teknis untuk konsumsi AI.
- `templates/04-dev-execution/CONVENTIONS_TEMPLATE.md`: Disimpan ke root (**`./CONVENTIONS.md`**) — Konvensi gaya kode (kebab-case, Server Components, no barrel).
- `templates/04-dev-execution/ENV_EXAMPLE_TEMPLATE.md`: Disimpan ke root (**`./.env.example`**) — Kamus variabel lingkungan baku.
- `templates/04-dev-execution/TODO_TEMPLATE.md`: Disimpan ke root (**`./TODO.md`**) — Antrean tugas koding atomik AI berurutan.
- `templates/04-dev-execution/RUNBOOK_LOCAL_TEMPLATE.md`: Disimpan ke **`docs/RUNBOOK_LOCAL.md`** atau root.
- `templates/04-dev-execution/VERIFY_LOCAL_TEMPLATE.md`: Disimpan ke **`docs/VERIFY_LOCAL.md`** atau root.

### Modul 06B (Aktif)
- `templates/09-product-growth/EVENT_TAXONOMY_TEMPLATE.md`: Template taksonomi event tracking dengan konvensi `verb_noun`, user properties, dan super properties. Disimpan ke **`docs/analytics/EVENT_TAXONOMY.md`**.
- `templates/09-product-growth/ANALYTICS_IMPLEMENTATION_PLAN_TEMPLATE.md`: Template rencana implementasi SDK Mixpanel/Amplitude, tracking code locations, GDPR consent management, dan QA checklist. Disimpan ke **`docs/analytics/ANALYTICS_IMPLEMENTATION_PLAN.md`**.
- `templates/09-product-growth/DASHBOARD_SPEC_TEMPLATE.md`: Template spesifikasi dashboard North Star Metric, AARRR funnel, cohort analysis, error monitoring, dan alert thresholds. Disimpan ke **`docs/analytics/DASHBOARD_SPEC.md`**.

### Modul 07 (Aktif)
- `templates/archive/qa/TEST_PLAN_SIT_TEMPLATE.md`: Template rencana pengujian integrasi sistem (SIT) terhadap layanan pihak ketiga di Staging.
- `templates/06-qa-uat/SECURITY_AUDIT_TEMPLATE.md`: Template laporan audit celah keamanan OWASP Top 10 dan kepatuhan data pribadi UU PDP.
- `templates/archive/qa/SIT_REPORT_TEMPLATE.md`: Laporan resmi bukti kelulusan pengujian integrasi sistem (SIT Pass) prasyarat pembukaan sesi UAT Klien.

### Modul 08 (Aktif)
- `templates/05-data-migration/DATA_MIGRATION_PLAN_TEMPLATE.md`: Template pemetaan kolom sumber ke database SQL, batas tanggung jawab data hygiene, dan aturan transformasi.
- `templates/05-data-migration/RECONCILIATION_REPORT_TEMPLATE.md`: Template laporan kuantitatif rekonsiliasi baris data terimpor vs ditolak dan lembar Data Sign-Off Klien.

### Modul 09 (Aktif)
- `templates/archive/uat/UAT_SCENARIOS_TEMPLATE.md`: Template panduan pengujian langkah demi langkah bagi pengguna awam di server Staging.
- `templates/archive/uat/UAT_DEFECT_LOG_TEMPLATE.md`: Template lembar kerja pelacakan temuan kendala UAT, matriks triase severity, dan status resolusi.
- `templates/06-qa-uat/UAT_SIGNOFF_TEMPLATE.md`: Dokumen resmi Berita Acara Hasil Uji Terima Pengguna (UAT Sign-Off Report) bertandatangan Single PIC Klien.

### Modul 10 (Aktif)
- `templates/archive/deploy/DEPLOYMENT_RUNBOOK_TEMPLATE.md`: Template panduan teknis langkah rilis produksi, DNS/SSL check, dan kunci rahasia live.
- `templates/07-release-handover/ROLLBACK_PLAN_TEMPLATE.md`: Template prosedur darurat 15 menit pemulihan rollback jika terjadi kegagalan fatal go-live.
- `templates/archive/deploy/GO_LIVE_REPORT_TEMPLATE.md`: Dokumen resmi Laporan Verifikasi Peluncuran Sistem (Go-Live Report) dengan bukti operasional stabil.

### Modul 11 (Aktif)
- `templates/07-release-handover/USER_MANUAL_TEMPLATE.md`: Template panduan operasional pengguna bagi staf dan admin sistem.
- `templates/07-release-handover/HANDOVER_PROTOCOL_TEMPLATE.md`: Template berita acara pengalihan kepemilikan repositori Git dan penyerahan kredensial terenkripsi.
- `templates/07-release-handover/BAST_TEMPLATE.md`: Dokumen resmi Berita Acara Serah Terima Pekerjaan (BAST) bermeterai Rp 10.000,- pemicu resmi berjalannya masa garansi.

### Modul 12 (Aktif)
- `templates/08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md`: Template kebijakan resmi batas garansi, jam kerja layanan, dan definisi galat yang dilindungi.
- `templates/08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md`: Perjanjian kerja sama pemeliharaan bulanan berulang (Monthly Retainer SLA) pemicu pendapatan rutin.
- `templates/08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md`: Prosedur standar operasional (SOP) penanganan insiden darurat produksi dan analisis akar masalah (RCA).

### Modul 13 (Aktif)
- `templates/09-product-growth/METRICS_BASELINE_REPORT_TEMPLATE.md`: Disimpan ke **`docs/analytics/METRICS_BASELINE_REPORT.md`** (Laporan baseline metrik 30 hari pertama pasca-peluncuran).
- `templates/09-product-growth/GROWTH_EXPERIMENTS_BACKLOG_TEMPLATE.md`: Disimpan ke **`docs/pm/GROWTH_EXPERIMENTS_BACKLOG.md`** (Daftar eksperimen pertumbuhan dengan RICE score dan tracking hasil).
- `templates/09-product-growth/PRODUCT_HEALTH_DASHBOARD_TEMPLATE.md`: Disimpan ke **`docs/pm/PRODUCT_HEALTH_DASHBOARD.md`** (Dashboard kesehatan produk untuk review berkala).

---

## 6. Referensi & Pengetahuan Taktis

> ⚠️ **MANDATORY REFERENCE LOADING PROTOCOL**:
> 
> **BEFORE executing ANY modul, agent WAJIB load reference files relevant untuk modul tersebut.**
> 
> **Modul 00 → LOAD:**
> - `references/improvements/MODUL_00_IMPROVEMENTS.md` (Timeline 3-4 minggu, Budget Rp1.5-11 juta, Respondent Recruitment, Competitive Moat, Skip Decision Tree)
> 
> **Modul 01 → LOAD:**
> - `references/improvements/MODUL_01_IMPROVEMENTS.md` (Timeline 1-5 hari, Scoring Rubric 5/4/3/2/1, Gate FAIL Protocol, Pre-Checklist, Risk Appetite)
> - `references/checklists/MODUL_01_ACTION_ITEMS_CHECKLIST.md` (Post-feasibility: Market validation, Formula verification, Security baseline)
> - `references/checklists/FEASIBILITY_CRITERIA.md` (Rubrik uji 4 dimensi detail)
> 
> **Modul 02 → LOAD:**
> - `references/checklists/MODUL_02_EVALUATION_CHECKLIST.md` (MoSCoW quality check, User Stories INVEST, Database Schema validation, Tech Stack validation, NFR realism, Timeline buffer, Risk completeness, Scope boundaries)
> - `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md` (Bank pertanyaan elisitasi)
> 
> **Format load:**
> ```python
> skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_XX_IMPROVEMENTS.md')
> ```
> 
> **Jika reference TIDAK di-load, execution INCOMPLETE (missing practical guidance: timeline, budget, scoring rubric, checklist).**

### Modul 00 (Aktif)
- `references/improvements/MODUL_00_IMPROVEMENTS.md`: **[MANDATORY LOAD]** Timeline estimation (3-4 minggu), Budget calculation (Rp1.5-11 juta), taktik rekrutmen responden, competitive moat assessment, dan skip decision tree.
- `references/technical/DEEP_RESEARCH_METHODOLOGY.md`: Metodologi riset mendalam regulasi/kepatuhan, competitor deep-dive analysis, dan akuisisi domain knowledge fintech/healthtech/legaltech.

### Modul 01 (Aktif)
- `references/checklists/FEASIBILITY_CRITERIA.md`: Rubrik uji 4 dimensi (teknis, bandwidth solo, kepatuhan UU PDP/ITE, ekonomi) dan daftar red-flag pemicu pembatalan proyek (*Kill Switch*).
- `references/improvements/MODUL_01_IMPROVEMENTS.md`: **[MANDATORY LOAD]** Timeline estimation (1-5 hari), Scoring rubric detail (5/4/3/2/1 per dimensi), Gate FAIL protocol (PIVOT/DEFER/PARTNER/KILL), Pre-Modul 01 checklist, Risk appetite threshold.
- `references/checklists/MODUL_01_ACTION_ITEMS_CHECKLIST.md`: **[MANDATORY LOAD]** Post-feasibility action items (Market validation, Formula verification, Security baseline).

### Modul 02 (Aktif)
- `references/checklists/REQUIREMENT_ELICITATION_GUIDE.md`: Bank pertanyaan 5 pilar elisitasi, taktik membongkar kebutuhan tersembunyi, dan deteksi red-flags klien saat wawancara.

### Modul 03 (Aktif)
- `references/improvements/MODUL_03_IMPROVEMENTS.md`: Panduan taktis menolak scope creep, formula hitungan biaya Change Request, penegakan Single PIC, dan protokol penghentian kerja sementara (*Work Pause*).

### Modul 04A (Aktif)
- `references/technical/DESIGN_SYSTEM_GUIDE.md`: Panduan komprehensif design system untuk solo dev dan tim kecil — terminologi, decision trees (build vs adopt vs extend), token architecture, component patterns (composition over configuration, controlled vs uncontrolled), tooling ecosystem (Style Dictionary, Storybook, Chromatic, Figma plugins), adoption strategies (pilot team, codemods, feature flags), governance models (centralized vs federated, RFC process), measuring success (adoption metrics, ROI calculation), common pitfalls & rescue strategies, dan case studies (Shopify Polaris, Airbnb DLS, Solo Dev SaaS).

### Modul 04 (Aktif)
- `references/solo/SOLO_UIUX_GUIDE.md`: Pedoman efisiensi desain solo dev, pemilihan pustaka komponen (Shadcn/Tailwind), rasio kontras WCAG 2.1 AA, dan taktik walk-through prototipe bersama klien.

### Modul 05 (Aktif)
- `references/solo/SOLO_ARCHITECTURE_GUIDE.md`: Pedoman arsitektur Boring Tech, aturan integritas basis data SQL DDL, standar keamanan OWASP Top 10, enkripsi AES-256, dan kepatuhan UU PDP No. 27/2022.

### Modul 05B (Aktif)
- `references/solo/SOLO_ARCHITECTURE_GUIDE.md`: Pedoman arsitektur sistem, strategi caching Redis, replikasi database, dan capacity planning solo developer.
- `references/playbooks/software-design-patterns.md`: Panduan implementasi software design patterns dan prinsip clean code untuk arsitektur terukur.

### Modul 06 (Aktif)
- `references/solo/SOLO_DEVELOPMENT_PATTERNS.md`: Pola koding produksi solo dev (validasi batas Zod, streaming enkripsi file AES-256-GCM, transaksi penguncian baris pessimistik, presigned URLs, dan skrip uji mandiri tanpa framework).
- `references/solo/SOLO_ENGINEERING_STANDARDS.md`: Standar rekayasa mendalam (protokol percabangan Git, rilis produksi bersih dari dokumen internal dev, audit keamanan OWASP/UU PDP, pencegahan N+1 query, optimasi aset, dan connection pooling).

### Modul 06B (Aktif)
- `references/pm/PM_ANALYTICS_SETUP_GUIDE.md`: Panduan taktis analytics untuk solo dev dan PM — minimal viable analytics, platform selection decision tree (Mixpanel/Amplitude/PostHog/GA4), event taxonomy quickstart, 5 core metrics, AARRR dashboard design, A/B testing statistical significance, error monitoring Sentry, privacy compliance GDPR/UU PDP, cost optimization, dan monthly maintenance routine.

### Modul 07 (Aktif)
- `references/improvements/MODUL_07_IMPROVEMENTS.md`: Pedoman efisiensi pengujian solo dev (The Pragmatic Test Pyramid), verifikasi sandbox pihak ketiga (Payment/Storage/Email), audit keamanan OWASP, dan pengujian beban k6.

### Modul 08 (Aktif)
- `references/improvements/MODUL_08_IMPROVEMENTS.md`: Pedoman pemindahan data warisan (Spreadsheet Hell avoidance), skrip otomasi ETL dengan Zod dan batching, masking data sensitif UU PDP di Staging, dan pengesahan Data Sign-Off.

### Modul 09 (Aktif)
- `references/improvements/MODUL_09_IMPROVEMENTS.md`: Panduan fasilitasi UAT bersama klien, naskah menangkis penambahan fitur berkedok bug, matriks triase tingkat keparahan cacat, dan penegakan surat klausul penerimaan otomatis (*Deemed Acceptance*).

### Modul 10 (Aktif)
- `references/improvements/MODUL_10_IMPROVEMENTS.md`: Pedoman deployment produksi (aturan No Friday Deploy), migrasi database tanpa henti (Expand and Contract), penurunan TTL DNS, dan skrip backup database harian terenkripsi ke S3/R2.

### Modul 11 (Aktif)
- `references/improvements/MODUL_11_IMPROVEMENTS.md`: Pedoman penutupan proyek dan serah terima (aturan No Pay No Root), jatah batas sesi pelatihan (1–2 sesi), transmisi kredensial terenkripsi sekali pakai (Bitwarden Send), dan kekuatan hukum BAST di Indonesia.

### Modul 12 (Aktif)
- `references/improvements/MODUL_12_IMPROVEMENTS.md`: Pedoman pemeliharaan retainer bulanan (konversi proyek lepas ke MRR stabil), formula paket Bronze/Silver/Gold, penanganan kepanikan klien di WhatsApp, dan batas on-call anti-burnout.

### Modul 13 (Aktif)
- `references/improvements/MODUL_13_IMPROVEMENTS.md`: **[MANDATORY LOAD]** Timeline estimation, rekomendasi tool metrics dashboard (PostHog/Mixpanel/Metabase), dan template dokumentasi eksperimen.
- `references/pm/PM_CONTINUOUS_IMPROVEMENT_GUIDE.md`: Panduan komprehensif continuous product improvement, Build-Measure-Learn loop, cohort retention analysis, churn prevention, dan quarterly roadmap refresh.
