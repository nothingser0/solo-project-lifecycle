# Client Intake & Qualification Checklist

> **Purpose**: Filter high-risk clients and unqualified projects BEFORE investing time in Modul 00/01 discovery. Protect solo developer bandwidth from tire-kickers, budget mismatches, and red-flag clients.

---

## 1. Initial Contact Screening (5 Minutes)

### Contact Information
- [ ] Client name and role (decision maker atau intermediary?)
- [ ] Company/organization name and industry
- [ ] Contact method (email, WhatsApp, LinkedIn)
- [ ] Referral source (existing client, cold outreach, marketplace)

### Project Quick Snapshot
```
Project type: [ ] Web App [ ] Mobile App [ ] Desktop [ ] API [ ] Other: _______
Timeline expectation: [ ] <1 bulan [ ] 1-3 bulan [ ] 3-6 bulan [ ] >6 bulan
Budget indication: [ ] <Rp 10 juta [ ] Rp 10-50 juta [ ] Rp 50-100 juta [ ] >Rp 100 juta
Current status: [ ] Idea [ ] Requirements doc [ ] Design mockup [ ] Existing codebase
```

---

## 2. Red Flag Detection Matrix (STOP/PROCEED Decision)

| Red Flag | Indicator | Risk Level | Action |
|----------|-----------|------------|--------|
| **No budget transparency** | "Berapa biayanya?" tanpa scope info | 🔴 Critical | STOP: Require budget range before discovery |
| **Unrealistic timeline** | "Bisa selesai minggu depan?" untuk complex app | 🔴 Critical | STOP: Educate realistic timeline or decline |
| **Multiple decision makers** | "Harus tanya bos/tim dulu" at every step | 🟡 High | PROCEED with caution: Enforce Single PIC at M03 |
| **Scope ambiguity** | "Saya belum tahu mau apa, tapi segera butuh" | 🟡 High | STOP: Require basic requirements doc before M00 |
| **Comparison shopping** | "Developer lain kasih harga Rp X, bisa lebih murah?" | 🟡 High | PROCEED: Clarify value-based pricing vs hourly |
| **Payment hesitancy** | "Bisa dibayar setelah launch?" | 🔴 Critical | STOP: Enforce DP requirement (M03) |
| **Unrealistic feature density** | "Clone Gojek tapi budget Rp 20 juta" | 🟡 High | PROCEED: Educate MVP scope or decline |
| **Hostile tone** | Aggressive, rude, atau demanding at first contact | 🔴 Critical | STOP: Decline politely |
| **Industry compliance unknown** | Fintech/healthtech with zero regulatory awareness | 🟡 High | PROCEED: Flag legal/compliance audit in M01 |

**Decision Rule**:
- **2+ Critical (🔴) flags**: DECLINE project immediately
- **3+ High (🟡) flags**: DECLINE or require pre-paid discovery retainer
- **1-2 High (🟡) flags**: PROCEED with enforced contracts and gates

---

## 3. Budget-Timeline-Scope Triangle Validation

### Quick Qualification Formula
```
Estimated Effort (Person-Days) = [Feature Count × 2] + [Integration Count × 3] + [Compliance × 5]

Solo Dev Rate Benchmark (2026):
- Junior (1-2 tahun): Rp 500K - 800K/hari
- Mid (3-5 tahun): Rp 800K - 1.5 juta/hari  
- Senior (5+ tahun): Rp 1.5 juta - 3 juta/hari

Minimum Project Value = Effort × Rate × 1.3 (risk buffer)
```

**Example**:
- Client budget: Rp 30 juta
- Estimated effort: 25 person-days
- Minimum viable: 25 × Rp 1 juta × 1.3 = Rp 32.5 juta
- **Assessment**: Budget too low → NEGOTIATE scope reduction OR DECLINE

### Timeline Reality Check
| Project Scale | Realistic Timeline | Client Expectation | Action |
|---------------|-------------------|-------------------|--------|
| Kecil (MVP) | 3-6 minggu | <2 minggu | Educate or decline |
| Menengah | 2-4 bulan | <1 bulan | Decline |
| Besar | 4-8 bulan | <3 bulan | Decline |
| Enterprise | 6-12 bulan | <6 bulan | Decline or bring partner |

---

## 4. Client Capability Assessment

### Technical Readiness
- [ ] **Domain & Hosting**: Client memiliki domain? Akses hosting/cloud account?
- [ ] **API Keys**: Third-party API (payment, email, storage) sudah terdaftar?
- [ ] **Content/Data**: Data warisan atau konten siap? (M08 dependency)
- [ ] **Decision Authority**: Single PIC dapat membuat keputusan teknis tanpa eskalasi?

### Collaboration Readiness
- [ ] **Communication**: Client responsif (reply <24 jam)?
- [ ] **Availability**: Client dapat attend weekly sync (30 menit)?
- [ ] **Feedback Cycle**: Client dapat review deliverable dalam 3-5 hari?
- [ ] **Payment Process**: Client memiliki invoicing/payment system (<7 hari transfer)?

**Gate**: Minimum 6/8 checkboxes must be YES. If <6, flag as HIGH-DEPENDENCY CLIENT → increase project buffer 30%.

---

## 5. Intake Conversation Script

### Opening (Qualification)
> *"Terima kasih sudah menghubungi. Sebelum kita masuk ke detail, boleh saya tahu:*
> 1. *Apa masalah bisnis yang ingin diselesaikan dengan software ini?*
> 2. *Berapa budget range yang sudah dialokasikan? (Rp 10-20 juta / Rp 50-100 juta / belum ada budget)*
> 3. *Kapan target launch-nya? Apakah ada deadline bisnis yang keras (event, tender, kontrak)?*
> 4. *Siapa yang akan menjadi decision maker utama di project ini (PIC)?*"

### Budget Mismatch Response
> *"Terima kasih atas informasinya. Berdasarkan scope yang Anda ceritakan, estimasi effort sekitar [X] person-days dengan budget minimum Rp [Y]. Jika budget saat ini Rp [Z], saya bisa bantu reduce scope dengan prioritas fitur MVP. Apakah tertarik diskusi lebih lanjut tentang MVP scope, atau ingin cari developer dengan rate lebih rendah?"*

### Unrealistic Timeline Response
> *"Timeline [X minggu] untuk project scale ini cukup ketat. Berdasarkan pengalaman, aplikasi dengan [Y fitur] + [Z integrasi] biasanya butuh minimal [N bulan]. Saya bisa bantu dengan Fast-Track MVP (core features only) jika deadline tidak bisa digeser. Alternatifnya, kita extend timeline menjadi [realistic timeline]. Mana yang lebih sesuai dengan prioritas bisnis Anda?"*

### Decline Script (Polite)
> *"Terima kasih sudah sharing project-nya. Setelah saya review, saya rasa project ini tidak sesuai dengan kapasitas dan spesialisasi saya saat ini [or: timeline/budget expectation tidak aligned]. Saya bisa rekomendasikan [referral ke developer/agency lain] jika berkenan. Semoga sukses dengan project-nya!"*

---

## 6. Intake Decision Matrix

| Score | Criteria | Decision |
|-------|----------|----------|
| **PASS (Proceed to M00/M01)** | 0-1 red flags, budget-timeline aligned, client responsive | Schedule M01 Feasibility meeting |
| **CONDITIONAL PASS** | 2-3 yellow flags, budget slightly low | Require pre-paid discovery retainer (Rp 2-5 juta) to proceed to M00 |
| **DEFER** | Budget TBD, timeline flexible | Put on waitlist, revisit in 1-2 bulan |
| **DECLINE** | 2+ red flags, misaligned expectations | Politely decline with referral |

---

## 7. Intake Output Artifacts

After qualification PASS:

1. **`docs/pm/CLIENT_INTAKE_SUMMARY.md`**:
```markdown
## Client Intake Summary

**Client**: [Nama Perusahaan]  
**PIC**: [Nama + Role + Contact]  
**Project**: [Nama Project]  
**Intake Date**: [YYYY-MM-DD]

### Qualification Score
- Red Flags: 0 🟢
- Budget Alignment: MATCH ✅
- Timeline Realism: REALISTIC ✅
- Client Readiness: 7/8 ✅

### Next Steps
- [x] Intake qualification PASS
- [ ] Schedule M01 Feasibility meeting (target: [date])
- [ ] Send discovery questionnaire
- [ ] NDA signing (if needed)

### Risk Notes
- Client belum punya domain (medium risk - add 3 hari to timeline)
- PIC masih perlu approval CFO untuk DP (track closely at M03)
```

2. **Decision**: PROCEED → M00 (optional) or M01 (mandatory)

---

## 8. Integration with Module 01

**Before Modul 01 starts**:
- [ ] Client intake checklist completed
- [ ] Budget range confirmed (minimum threshold met)
- [ ] Single PIC identified
- [ ] Basic requirements document received (1-2 halaman cukup)
- [ ] Client aware of termin payment structure (DP required)

**If intake NOT completed**: STOP - do not proceed to M01 Feasibility without qualifying the client first.

---

## Appendix: Client Qualification Rubric (Scoring)

| Dimension | Score 1 (Poor) | Score 3 (Acceptable) | Score 5 (Excellent) |
|-----------|----------------|---------------------|-------------------|
| **Budget Transparency** | No budget info | Range provided | Exact budget + approved PO |
| **Timeline Realism** | Unrealistic (<50% actual) | Tight but negotiable | Realistic + buffer |
| **Decision Authority** | Multiple approvers | Single PIC + escalation | Single PIC full authority |
| **Communication** | Slow (>3 hari) | Normal (1-2 hari) | Fast (<24 jam) |
| **Technical Readiness** | No infrastructure | Partial (domain only) | Full (domain, API, data ready) |
| **Scope Clarity** | "Belum tahu" | Basic feature list | Detailed requirements doc |

**Total Score**: ___/30

- **24-30**: IDEAL CLIENT → Proceed immediately
- **18-23**: GOOD CLIENT → Proceed with standard process  
- **12-17**: RISKY CLIENT → Conditional proceed (pre-paid discovery or enforce strict gates)
- **<12**: DECLINE → Not worth the risk

---

**Created**: 2026-10-02  
**Version**: 1.0  
**Owner**: Solo Project Lifecycle Framework
