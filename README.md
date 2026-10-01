# Solo Project Lifecycle

Framework SDLC lengkap untuk solo developer dan konsultan teknis. Dari ide sampai production, termasuk kontrak, design, development, testing, deployment, dan maintenance.

## Fitur Utama

- **12-stage pipeline** yang cover semua fase pengerjaan proyek
- **Fast-track mode** untuk MVP (1-4 minggu)
- **Template siap pakai** untuk setiap dokumen (PRD, FSD, kontrak, BAST, dll)
- **Protection rules** anti-scope creep dan kerja gratis
- **Legal compliance** untuk UU PDP & UU ITE (Indonesia)
- **Reference guides** dengan checklist dan best practices

## Instalasi

Clone repo ini sebagai skill untuk AI agent:

```bash
# Clone ke direktori skills
cd ~/.agents/skills/
git clone https://github.com/nothingser0/solo-project-lifecycle.git

# Atau untuk OpenCode
cd ~/.config/opencode/skills/
git clone https://github.com/nothingser0/solo-project-lifecycle.git
```

## Cara Pakai

### Untuk MVP/Proyek Kecil (Fast-Track)

```bash
# Copy template lite
cp templates/03-architecture-specs/PROJECT_LITE_TEMPLATE.md ./PROJECT_LITE.md

# Isi template, langsung coding
```

### Untuk Proyek Menengah-Besar

Ikuti 12 tahap secara berurutan:

1. **Riset & Validasi** (Modul 00-01): Market research, feasibility check
2. **Scope & Kontrak** (Modul 02-03): Define scope, bikin kontrak, ambil DP
3. **Design & Arsitektur** (Modul 04-05): UI/UX design, tech specs, database schema
4. **Development** (Modul 06): Coding backend/frontend, setup analytics
5. **Testing** (Modul 07-09): QA, security audit, UAT client
6. **Deploy & Handover** (Modul 10-11): Production release, serah terima
7. **Maintenance** (Modul 12-13): Garansi, retainer, continuous improvement

Setiap modul punya template di folder `templates/` dan panduan di `references/`.

### Load via AI Agent

```python
skill(name='solo-project-lifecycle')
```

Agent akan guide kamu step-by-step sesuai skala proyek.

## Struktur Folder

```
project-root/
├── modules/           # 13 modul SDLC lengkap
├── templates/         # Template untuk semua dokumen
├── references/        # Panduan, checklist, best practices
├── SKILL.md          # Skill definition
└── README.md
```

Setelah setup proyek:

```
your-project/
├── docs/
│   ├── pm/           # Project management docs
│   ├── specs/        # Technical specs (PRD, FSD)
│   ├── design/       # Design system & UI/UX
│   └── analytics/    # Event tracking & metrics
│
├── AGENTS.md         # AI agent instructions
├── CONTEXT.md        # Business context
├── ARCHITECTURE.md   # Tech architecture
├── DESIGN.md         # Design tokens
├── CONVENTIONS.md    # Code style guide
├── TODO.md           # Task queue
└── .env.example      # Environment variables
```

## Lisensi

MIT License - bebas dipakai untuk proyek komersial atau personal.

---

**Framework by solo devs, for solo devs.**
