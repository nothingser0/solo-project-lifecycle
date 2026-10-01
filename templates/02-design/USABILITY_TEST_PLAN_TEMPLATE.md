# Usability Test Plan: [Project Name]

**Test Date**: [YYYY-MM-DD]  
**Iteration**: #[1/2/3]  
**Moderator**: [Name]  
**Observer**: [Name, optional]

---

## 1. Test Objectives

Validasi 3-5 user journey kritis:

1. **[Objective 1]**: [Contoh: "User baru dapat menyelesaikan onboarding dalam <5 menit tanpa bantuan"]
2. **[Objective 2]**: [Contoh: "User dapat menemukan dan mengekspor laporan bulanan tanpa tutorial"]
3. **[Objective 3]**: [Contoh: "User memahami status approval dokumen pada dashboard"]
4. **[Objective 4]**: [...]
5. **[Objective 5]**: [...]

---

## 2. Participant Profile

**Target Demografi**:
- Role/Job Title: [Contoh: "HR Manager di perusahaan 50-500 karyawan"]
- Tech Proficiency: [Beginner / Intermediate / Advanced]
- Domain Experience: [Contoh: "Familiar dengan Excel, pernah pakai HRIS sebelumnya"]
- Geographic: [Jika relevan: "Indonesia, terbiasa Bahasa Indonesia formal"]

**Screening Questions** (Kirim via Google Forms/Typeform):
1. Berapa jumlah karyawan yang Anda kelola? [ ] <50 [ ] 50-200 [ ] 200-500 [ ] >500
2. Tools apa yang saat ini Anda gunakan untuk [use case]? [Open text]
3. Seberapa sering Anda [relevant task]? [ ] Daily [ ] Weekly [ ] Monthly [ ] Rarely

**Recruitment Target**: Minimum **5 participants** per iteration

**Incentive**: [Contoh: "Voucher Tokopedia/Shopee Rp 150.000 per sesi (45 menit)"]

---

## 3. Test Tasks (Scenarios)

> **Aturan Penulisan**: Gunakan intent user, BUKAN petunjuk navigasi UI ("klik tombol X").

### Task 1: [Task Name — contoh: "Onboarding Pertama Kali"]
**Scenario**:  
> "Bayangkan hari pertama Anda menggunakan sistem ini. Perusahaan Anda baru saja berlangganan. Buatlah akun Anda dan tambahkan 3 karyawan baru (gunakan data fiktif)."

**Success Criteria**: User menyelesaikan task tanpa stuck >2 menit, tanpa minta bantuan moderator.

---

### Task 2: [Task Name — contoh: "Generate Monthly Report"]
**Scenario**:  
> "Akhir bulan ini. Atasan Anda meminta laporan absensi seluruh karyawan untuk bulan September dalam format Excel. Cobalah dapatkan laporan tersebut."

**Success Criteria**: User menemukan fitur export dalam <3 klik, berhasil download file.

---

### Task 3: [Task Name]
**Scenario**:  
> [Tulis skenario realistis...]

**Success Criteria**: [...]

---

### Task 4: [Task Name]
**Scenario**:  
> [...]

**Success Criteria**: [...]

---

### Task 5: [Task Name]
**Scenario**:  
> [...]

**Success Criteria**: [...]

---

## 4. Testing Protocol

### Pre-Test (5 menit)
1. Perkenalan moderator dan tujuan sesi
2. Jelaskan think-aloud protocol:  
   > "Silakan katakan apapun yang Anda pikirkan saat menggunakan aplikasi ini, seolah-olah Anda sedang berpikir keras. Tidak ada jawaban benar/salah."
3. Konfirmasi consent recording (audio/screen)
4. Background questions (opsional): Pengalaman dengan tools serupa

### During Test (30 menit)
- **Observer's Role**: Catat verbatim quotes, time on task, error, dan emotional cues (frustrasi, bingung, senang)
- **Moderator Prompts** (hanya jika user stuck >2 menit):
  - "Apa yang Anda cari saat ini?"
  - "Apa yang Anda harapkan terjadi setelah klik ini?"
  - **JANGAN** beri petunjuk navigasi ("coba klik menu sebelah kiri")

### Post-Test (10 menit)
1. Debrief: "Bagian mana yang paling mudah? Paling membingungkan?"
2. SUS Questionnaire (10 pertanyaan — lihat Section 5)
3. Open feedback: "Ada saran perbaikan?"

---

## 5. System Usability Scale (SUS) Questionnaire

**Instruksi**: Skala 1 (Sangat Tidak Setuju) sampai 5 (Sangat Setuju)

1. Saya pikir saya akan sering menggunakan sistem ini.
2. Saya merasa sistem ini terlalu rumit untuk digunakan.
3. Saya pikir sistem ini mudah digunakan.
4. Saya memerlukan bantuan orang teknis untuk dapat menggunakan sistem ini.
5. Saya merasa berbagai fungsi dalam sistem ini terintegrasi dengan baik.
6. Saya pikir terlalu banyak inkonsistensi dalam sistem ini.
7. Saya membayangkan kebanyakan orang akan belajar menggunakan sistem ini dengan sangat cepat.
8. Saya merasa sistem ini sangat merepotkan untuk digunakan.
9. Saya merasa sangat percaya diri menggunakan sistem ini.
10. Saya perlu belajar banyak hal sebelum dapat menggunakan sistem ini.

**Kalkulasi SUS Score**:
- Pertanyaan ganjil (1,3,5,7,9): Skor = (Rating - 1)
- Pertanyaan genap (2,4,6,8,10): Skor = (5 - Rating)
- Total = (Sum of all scores) × 2.5
- **Range**: 0-100 (bukan persentase!)

**Interpretation**:
- <60: Poor (F)
- 60-69: Marginal (D)
- **70-79: Acceptable (C)** ← Minimum gate M04
- 80-89: Good (B)
- ≥90: Excellent (A)

---

## 6. Observation Data Collection Template

| Participant | Task | Completion (Y/N) | Time (min:sec) | Errors | Verbatim Quote | Notes |
| :---: | :---: | :---: | :---: | :---: | :--- | :--- |
| P1 | Task 1 | Y | 4:32 | 1 (clicked wrong menu) | "Di mana tombol submit?" | Confused by icon-only button |
| P1 | Task 2 | N | 8:15 | 3 | "Kenapa gak ada Export?" | Missed dropdown in table header |
| P2 | Task 1 | Y | 3:05 | 0 | "Wah gampang ya" | — |
| ... | ... | ... | ... | ... | ... | ... |

---

## 7. Post-Test Analysis Checklist

- [ ] Calculate average SUS score across all participants
- [ ] Identify top 3 pain points (highest error rate + negative quotes)
- [ ] List features/flows with <70% task completion rate
- [ ] Prioritize fixes: P0 (blockers), P1 (major friction), P2 (polish)
- [ ] Document iteration plan for next design revision

**Output**: Summary report untuk design iteration review (share dengan designer/PM).
