# GLOSSARY.md — Bilingual Term Inventory
**Phase**: 2B Language & Style Standards  
**Date**: 2026-10-02  
**Scope**: All English/Indonesian term pairs, spelling variants, recommended forms, and file:line deviations

---

## How to Read This Table

- **Recommended**: The form to use in new or edited content.
- **Variants Found**: Alternate spellings or untranslated forms found in corpus.
- **Verdict**: `KEEP ENGLISH` (untranslatable or domain-standard), `USE INDONESIAN` (when prose context is formal Indonesian), `INCONSISTENT` (fix needed).
- **Locations**: Representative file:line citations; not exhaustive.

---

## A. Core Process Terms

| English Term | Indonesian Equivalent | Variants Found | Recommended Form | Verdict | Locations (file:line) |
|---|---|---|---|---|---|
| **Scope creep** | Penambahan lingkup berlebih | "scope creep", "Scope Creep" | `scope creep` (lowercase, untranslated) | KEEP ENGLISH | modules/02:186, modules/09:31,152 |
| **Deemed acceptance** | Penerimaan otomatis | "Deemed Acceptance", "deemed acceptance", "Penerimaan Otomatis" | `deemed acceptance` in English context; "penerimaan otomatis" in formal Indonesian prose | INCONSISTENT | modules/09:4,28,61 |
| **Single PIC** | Satu penanggung jawab tunggal | "Single PIC", "single PIC", "SINGLE PIC" | `Single PIC` (capitalized, untranslated — proper name status) | KEEP ENGLISH | modules/03:1,31,77,79; modules/09:45; modules/11:44; SKILL.md:50 |
| **BAST** | Berita Acara Serah Terima | "BAST", "Berita Acara Serah Terima (BAST)" | `BAST` (abbreviation preferred in instructions); spell out on first use per document | KEEP ABBREV | modules/11:1,8,10,42,43,48; modules/03:28; modules/12:15 |
| **Gate** | Gerbang | "Gate", "GATE", "gerbang", "Gerbang" | `[GATE]` for structural labels; "Gerbang" for inline prose | INCONSISTENT | SKILL.md:52; modules/03:1; modules/09:1; modules/11:1 |
| **Down Payment (DP)** | Uang muka | "DP", "Down Payment", "uang muka" | `DP` in tables/labels; "uang muka" in prose | INCONSISTENT | modules/03:10,26; SKILL.md:53 |
| **Change Request (CR)** | Permintaan Perubahan | "Change Request", "Change Request (CR)", "CR" | `Change Request (CR)` on first use; `CR` thereafter | KEEP ENGLISH | modules/03:39,91,92; modules/09:35,59,77; modules/12:57 |
| **Invoice** | Tagihan / Faktur | "invoice", "Invoice", "tagihan" | `invoice` in technical context; "tagihan" acceptable in formal prose | INCONSISTENT | modules/11:21; modules/06:1206 |
| **Milestone** | Tahap / Tonggak | "milestone", "Milestone" | `milestone` (domain standard) | KEEP ENGLISH | modules/03:22,26; SKILL.md:53 |
| **Retainer** | Kontrak pemeliharaan bulanan | "retainer", "Retainer", "Monthly Retainer" | `Monthly Retainer` for product name; "retainer" lowercase in prose | INCONSISTENT | modules/12:1,8; SKILL.md:41 |
| **SLA** | Perjanjian Tingkat Layanan | "SLA", "Service Level Agreement", "SLA Respon" | `SLA` (abbreviation standard) | KEEP ABBREV | modules/12:1,8,24,107; SKILL.md:51 |

---

## B. Technical Development Terms

| English Term | Indonesian Equivalent | Variants Found | Recommended Form | Verdict | Locations (file:line) |
|---|---|---|---|---|---|
| **Scaffold / scaffolding** | Kerangka awal proyek | "scaffold", "scaffolding" | `scaffold` (verb), `scaffolding` (noun) | KEEP ENGLISH | SKILL.md:12; modules/06:32 |
| **Tech stack** | Tumpukan teknologi | "tech stack", "Tech Stack", "stack" | `tech stack` lowercase | KEEP ENGLISH | modules/05:68,1; modules/06:24 |
| **Repository (repo)** | Repositori | "repo", "repository", "repositori" | `repositori` in Indonesian prose; `repo` in technical commands | INCONSISTENT | modules/11:1,38,81; modules/03:28 |
| **Branch** | Cabang | "branch", "Branch", "cabang" | `branch` in technical context (Git term); "cabang" in prose explanation | INCONSISTENT | modules/06:37,77,853,885 |
| **Staging** | Lingkungan uji coba | "Staging", "staging", "server Staging" | `staging` lowercase in technical context | KEEP ENGLISH | modules/07:9; modules/09:8,10; modules/10:8 |
| **Production** | Produksi | "production", "Production", "produksi", "Produksi" | `produksi` in Indonesian prose; `production` in code/commands | INCONSISTENT | modules/10:1,8; modules/11:8 |
| **CI/CD** | Integrasi \& Deployment Berkelanjutan | "CI/CD" only | `CI/CD` (abbreviation standard) | KEEP ABBREV | SKILL.md:39; modules/10:8 |
| **API** | Antarmuka Pemrograman Aplikasi | "API" only | `API` (universal abbreviation) | KEEP ABBREV | modules/05:1; modules/06:1,4 |
| **Database** | Basis data | "database", "Database", "basis data", "basis-data", "DB" | `basis data` in formal prose; `database` in technical context | INCONSISTENT | modules/05:1; modules/06:3,55 |
| **Frontend / Backend** | Antarmuka / Pemroses | "frontend", "Frontend", "backend", "Backend" | `frontend`/`backend` lowercase (domain standard) | KEEP ENGLISH | modules/06:1; SKILL.md:32 |
| **Deploy / Deployment** | Peluncuran / penerapan | "deploy", "Deploy", "deployment", "Deployment", "peluncuran" | `deployment` in technical; "peluncuran" in business prose | INCONSISTENT | modules/10:1,8; SKILL.md:39 |
| **Migration / Migrasi** | Migrasi | "Migration", "migration", "Migrasi", "migrasi" | `migrasi` in Indonesian prose; `migration` in code/commands | INCONSISTENT | modules/08:1; modules/06:49 |
| **Debug / Debugging** | Penelusuran kesalahan | "debug", "debugging" | `debug` / `debugging` (domain standard) | KEEP ENGLISH | modules/07:various |
| **Hardcoded** | Nilai tetap (ditanam langsung) | "hardcoded", "hard-coded" | `hardcoded` (no hyphen, domain standard) | KEEP ENGLISH | modules/00:10 |
| **Webhook** | Kait web | "webhook", "Webhook" | `webhook` lowercase | KEEP ENGLISH | modules/07:83,84; modules/10:271 |

---

## C. Project Management Terms

| English Term | Indonesian Equivalent | Variants Found | Recommended Form | Verdict | Locations (file:line) |
|---|---|---|---|---|---|
| **PRD** | Dokumen Kebutuhan Produk | "PRD", "Product Requirement Document", "PRD.md" | `PRD` with full form on first use per document | KEEP ABBREV | modules/05:1; SKILL.md:83,134 |
| **FSD** | Dokumen Spesifikasi Fungsional | "FSD", "Functional Specification Document", "FSD.md" | `FSD` with full form on first use per document | KEEP ABBREV | modules/05:1; SKILL.md:83,135 |
| **UAT** | Pengujian Penerimaan Pengguna | "UAT", "User Acceptance Testing", "pengujian penerimaan" | `UAT` (abbreviation standard); spell out on first use per document | KEEP ABBREV | modules/09:1,8,10; SKILL.md:36 |
| **SIT** | Pengujian Integrasi Sistem | "SIT", "System Integration Testing" | `SIT` (abbreviation standard) | KEEP ABBREV | modules/07:1,9; SKILL.md:34 |
| **TAM/SAM/SOM** | Pasar Total / Dapat Dilayani / Dapat Diraih | "TAM/SAM/SOM" only | `TAM/SAM/SOM` (market-sizing abbreviations; no Indonesian equivalent used) | KEEP ABBREV | modules/00:71,73,74,75 |
| **RICE** | — | "RICE" only | `RICE` (product prioritization framework — no standard Indonesian term) | KEEP ENGLISH | modules/13:various; SKILL.md:93 |
| **OKR / KPI** | — | "OKR", "KPI", "OKR/KPI" | `OKR` / `KPI` (universal abbreviations) | KEEP ABBREV | modules/01:206; modules/13:various |
| **MoSCoW** | — | "MoSCoW", "Moscow" | `MoSCoW` (correct capitalization) | KEEP ENGLISH | modules/02:58,66; SKILL.md:79 |
| **Work Breakdown Structure (WBS)** | Rincian Paket Kerja | "WBS", "Work Breakdown Structure" | `WBS` with full form on first use | KEEP ABBREV | SKILL.md:70 |
| **Backlog** | Daftar kerja tertunda | "backlog", "Backlog" | `backlog` lowercase | KEEP ENGLISH | modules/01:146 |
| **Roadmap** | Peta jalan | "roadmap", "Roadmap", "peta jalan" | `roadmap` in technical; "peta jalan" acceptable in formal prose | INCONSISTENT | modules/01:111; modules/02:various |
| **Gantt Chart** | Diagram Gantt | "Gantt Chart" | `Gantt Chart` (proper name) | KEEP ENGLISH | modules/01:various |
| **Standup** | Rapat harian | "standup", "stand-up" | `standup` (no hyphen) | KEEP ENGLISH | references/various |

---

## D. Legal & Commercial Terms

| English Term | Indonesian Equivalent | Variants Found | Recommended Form | Verdict | Locations (file:line) |
|---|---|---|---|---|---|
| **SOW** | Pernyataan Lingkup Kerja | "SOW", "Statement of Work", "SOW_CONTRACT" | `SOW` (abbreviation preferred) | KEEP ABBREV | modules/03:10,42; SKILL.md:80 |
| **Liability cap** | Batas ganti rugi | "Liability Cap", "liability cap" | `liability cap` lowercase in prose | KEEP ENGLISH | modules/03:88,90 |
| **IP (Intellectual Property)** | Kekayaan Intelektual (KI) | "IP", "Intellectual Property / IP", "IP ownership" | `IP` in technical; "kekayaan intelektual" in formal legal prose | INCONSISTENT | modules/03:86,87 |
| **UU PDP** | Undang-Undang Perlindungan Data Pribadi | "UU PDP", "UU PDP No. 27/2022", "UU No. 27/2022" | `UU PDP No. 27/2022` on first use; `UU PDP` thereafter | INCONSISTENT | modules/05:83; modules/06:86; modules/07:87 |
| **BAST** | Berita Acara Serah Terima | [see Section A] | [see Section A] | — | [see Section A] |
| **Meterai** | Stamp duty / revenue stamp | "meterai", "Meterai", "e-Meterai" | `meterai` lowercase; `e-Meterai` for digital form | INCONSISTENT | modules/11:43,92,103,116; SKILL.md:181 |
| **Warranty / Garansi** | Garansi | "warranty", "Warranty", "garansi", "Garansi", "Masa Garansi" | `garansi` in Indonesian prose; `warranty` in English context | INCONSISTENT | modules/12:1,8,19; SKILL.md:41 |

---

## E. Personal Name & PII Violations

| Item | Location | Status | Recommended Fix |
|---|---|---|---|
| `zeenn` (personal name) | modules/00:10 | **VIOLATION** | Replace with "Solo developer" |
| `zeenn` (GitHub username in code example) | modules/13:228 | **ACCEPTABLE** (code example context, but should use placeholder) | Replace with `{username}` or `{your-github}` |
| `zeenn` (in evaluation checklist) | references/checklists/MODUL_02_EVALUATION_CHECKLIST.md:202 | **VIOLATION** | Replace with "solo developer" |
| `nothingser0` (GitHub org name) | README.md:21,25 | **ACCEPTABLE** (real repo URL — keep) | No change needed |

---

## F. Inconsistent Spelling Variants (Spelling Normalization)

| Term | Variants Found | Recommended | Rule |
|---|---|---|---|
| `repositori` / `repository` | Both used in same prose context | `repositori` in Indonesian prose; `repository` in English context/commands | Context-dependent |
| `modul` / `module` | Both used interchangeably | `modul` in Indonesian prose; `Module` only in English headings (04A, 05B, 06B) | Context-dependent |
| `basis data` / `database` | Both used interchangeably | `basis data` in formal prose; `database` in technical/code context | Context-dependent |
| `peluncuran` / `deployment` | Both used | `peluncuran` in chapter titles/formal; `deployment` in technical commands | Context-dependent |
| `gerbang` / `gate` / `GATE` / `[GATE]` | Four forms used | `[GATE]` in structural labels (bracketed); "Gerbang" in prose | Standardize immediately |
| `Langkah demi Langkah` / `Step-by-Step` | Both in section headings | `Langkah demi Langkah` (Indonesian-language modules); `Step-by-Step` only in modules written primarily in English (04, 04A, 05B, 06B) | Match module's dominant language |
| `Lolos` / `Pass` / `PASS` | Three forms | `LOLOS (PASS)` in gate criteria | Standardize immediately |
| `Klien` / `klien` / `Client` / `client` | Mixed case | `Klien` (capitalized when referring to the contractual party); `klien` in generic references | Establish convention |
| `Developer` / `developer` | Mixed case | `Developer` (capitalized when referring to the contracting party); `developer` generic | Establish convention |
| `Pak/Bu` / `Bapak/Ibu` | Both in quoted speech | `Bapak/Ibu` (formal speech) | Standardize salutation |

---

## G. Emphasis Word Variants (B4 Related)

| Emphasis Word | Variants | Count in Modules | Recommended |
|---|---|---|---|
| `WAJIB` | "WAJIB", "wajib", "Wajib" | ~40 total (mixed case) | ALL CAPS only for critical agent-stopping instructions; bold `**wajib**` for regular emphasis |
| `DILARANG` | "DILARANG", "Dilarang", "dilarang" | ~20 total | ALL CAPS for absolute prohibitions with consequences; bold `**dilarang**` for normal emphasis |
| `MANDATORY` | "MANDATORY", "mandatory" | ~15 total | Reserve for English-language gate headers only |
| `BLOCKING` | "BLOCKING", "Blocking" | ~8 total | ALL CAPS only in gate protocol headings |
| `STOP` | "STOP", "stop" | ~10 total | ALL CAPS only in agent-halt instructions |
| `CRITICAL` | "CRITICAL", "Critical" | ~6 total | ALL CAPS only in error messages targeting agent execution |

---

## H. Format Conventions Found (B6 Related)

| Convention | Variants Found | Recommended |
|---|---|---|
| **Date format** | `YYYY-MM-DD` (code), `DD/MM/YYYY` (none found), `YYYY-MM-DD` consistent in code examples | `YYYY-MM-DD` always |
| **Currency** | `Rp 10.000,-`, `Rp 10.000`, `Rp 10.000.000`, `Rp1.200.000` (no space), `Rp 200k`, `$20-25/mo` | `Rp 10.000` (space, Indonesian period-as-thousands-separator) for IDR; `$20/mo` for USD |
| **Path notation** | `docs/pm/BAST.md` (forward slash) | Forward slash always (cross-platform) |
| **Code block labels** | `bash`, `python`, `powershell`, `sql`, `typescript`, `text` | `bash` for shell; `powershell` for PowerShell-only; `text` for ASCII diagrams |
| **LaTeX notation** | `$\ge 3$`, `$< 15\text{ menit}$`, `$N_{\text{source}}$` | Plain text equivalents preferred (see B7); LaTeX only if rendering confirmed |
| **Heading style** | Title Case for H1/H2 (consistent); Sentence case for H3+ (mostly consistent) | H1: Module title (Title Case); H2: numbered sections (Sentence case or Title Case); H3+: Sentence case |
| **Gate label style** | `[GATE KOMERSIAL]`, `[GATE VALIDASI]`, `[GATE PENYERAHAN]`, `## 🛑 PROTOKOL [GATE]` | `[GATE: TYPE]` — bracket + colon + descriptor |
| **Number formatting** | `10.000` (Indonesian), `10,000` (English) not found | Indonesian `10.000` for IDR amounts; bare numerics for technical counts |

---

## I. Register Markers Found (B3 Related)

| Register | Examples | Files | Assessment |
|---|---|---|---|
| Formal Indonesian | "Tujuannya adalah menyelenggarakan...", "Aturan mutlak:" | All modules | Dominant register — correct |
| Instructional English | "Agent WAJIB read FSD.md from Module 05 BEFORE scaffold" | modules/06:86 | Mixed-register sentence; should pick one |
| Casual Indonesian | "maunya gratis aja", "gak spesifik" | modules/00:244, modules/04:271 | 2 instances in 17 files — minor |
| Second person formal | "Anda" | modules/00:74,75,157,226-239; modules/05:75,481; modules/11:85,179 | Correct formal register |
| Second person mixed | "Pak/Bu" (formal) vs "kamu" (absent) | modules/09:59 | No "kamu" found in modules — register is consistent |
| Parenthetical English | *(unpaid work)*, *(scope creep)*, *(leverage)* | SKILL.md:49; various | Italicized English glosses for Indonesian terms — intentional and acceptable |

---

## Appendix: Terms Appearing ≥3 Times (Frequency Audit)

| Term | Approx. Count | Consistency |
|---|---|---|
| `BAST` | 28+ | Consistent abbreviation |
| `Single PIC` | 32+ | Consistent capitalization |
| `scope creep` | 4 | Consistent (2 capitalized, 2 lowercase) — minor |
| `Change Request (CR)` | 16+ | Consistent |
| `staging` | 30+ | Mostly lowercase ✓ |
| `WAJIB` (all-caps) | ~40 | Mixed case — major inconsistency |
| `DILARANG` (all-caps) | ~20 | Mixed case — major inconsistency |
| `modul` / `Modul` | 100+ | Mixed: "Modul" as proper name, "modul" generic |
| `skill_view()` | 14+ | Consistent (portability problem — separate finding F004) |
| `klien` / `Klien` | 80+ | Inconsistent capitalization |
| `developer` / `Developer` | 70+ | Inconsistent capitalization |
| `UU PDP` | 109+ | Mostly consistent; citation depth varies |
| `LaTeX ($...$ notation)` | 65 instances | Rendering risk in 13 files (see B7) |
| `gerbang` / `Gate` / `GATE` / `[GATE]` | 20+ | Four forms — standardize needed |
| `repositori` / `repository` / `repo` | 20+ | Context-appropriate, document convention needed |
