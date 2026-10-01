# Modul 12: Masa Garansi & Transisi ke Monthly Retainer / SLA Support

> ⚠️ **MANDATORY: Load references BEFORE executing this module**:
> - `references/improvements/MODUL_12_IMPROVEMENTS.md` (One-off to MRR conversion, Bronze/Silver/Gold packages formula, WhatsApp panic handling, On-call anti-burnout boundaries, timeline estimation, Incident response workflow, Retainer pricing formula, Warranty expiry automation)
>
> Load via: `skill_view(name='solo-project-lifecycle', file_path='references/improvements/MODUL_12_IMPROVEMENTS.md')`

Modul ini adalah tahap kedua belas (fase pamungkas) dalam siklus hidup proyek perangkat lunak untuk solo developer. Tujuannya adalah mengelola masa garansi perbaikan galat (*warranty period*) secara terukur, menetapkan perjanjian tingkat layanan (*Service Level Agreement* / SLA), menangani insiden darurat produksi, dan mengonversi hubungan proyek satu kali (*one-off project*) menjadi sumber pendapatan berulang yang dapat diprediksi: **Kontrak Pemeliharaan Bulanan (Monthly Retainer / SLA Contract)**.

---

## 1. Siklus Eksekusi Modul 12

```text
[ INPUT: Dokumen BAST Sah Bermeterai dari Modul 11 & Sistem Live di Produksi ]
                                    │
                                    ▼
[ LANGKAH 1: Penegakan Batasan Masa Garansi Resmi (Warranty Period) ]
  • Tanggal Mulai: Tepat sejak BAST ditandatangani (Bukan sejak mulai koding)
  • Durasi: 30 Hari (Kecil/MVP) / 60 Hari (Menengah) / 90 Hari (Besar & Enterprise)
  • Cakupan Wajib: Murni perbaikan galat (bug fix) yang melanggar spesifikasi FSD/PRD
                                    │
                                    ▼
[ LANGKAH 2: Penegakan Matriks Respon SLA & Jam Layanan (Working Hours) ]
  • Jam Layanan Standar: Senin – Jumat 09.00 – 17.00 WIB (Kecuali Retainer Enterprise)
  • Respon Severity 1 (Sistem Down): Respon < 2 Jam, Resolusi < 24 Jam
  • Respon Severity 2 (Major): Respon < 8 Jam, Resolusi < 48 Jam
  • Respon Severity 3 (Minor/Pertanyaan): Hari kerja berikutnya
                                    │
                                    ▼
[ LANGKAH 3: Penanganan Insiden Darurat Produksi (Break-Glass SOP) ]
  • Triase Insiden Cepat Melalui Sentry & Uptime Monitor
  • Eksekusi Perbaikan di Branch fix/* ──► Hotfix Staging ──► Push Tag ke main
  • Dokumentasi Post-Mortem Ringkas jika Terjadi Downtime
                                    │
                                    ▼
[ LANGKAH 4: Transisi Menuju Kontrak Retainer Bulanan (Recurring Revenue) ]
  • Kirim Proposal Paket Pemeliharaan (Bronze / Silver / Gold) 14 Hari Sebelum Garansi Habis
  • Negosiasi & Penandatanganan Kontrak SLA Retainer Bulanan
  • Penyiapan Jadwal Pemeliharaan Preventif (Update OS, Patching, Audit Backup)
                                    │
                                    ▼
[ OUTPUT: Dokumen WARRANTY_POLICY.md & Kontrak SLA_RETAINER_CONTRACT.md ]
```

---

## 2. Prinsip Perlindungan Solo Developer: "Garansi vs Retainer"

Klien sering mengira bahwa setelah membeli software, pengembang berkewajiban merawat sistem secara gratis seumur hidup. Solo developer wajib membedakan dua konsep ini secara tegas:

| Parameter | Masa Garansi (Warranty) | Kontrak Pemeliharaan (Monthly Retainer) |
| :--- | :--- | :--- |
| **Status Biaya** | **GRATIS** (Sudah termasuk dalam kontrak awal). | **BERBAYAR BULANAN** (Biaya rutin di muka). |
| **Jangka Waktu** | Terbatas (30 / 60 / 90 hari kalender). | Berkelanjutan (Perjanjian 6 atau 12 bulan). |
| **Cakupan Pekerjaan**| **HANYA BUG FIX MURNI**: Perbaikan fungsi yang terbukti tidak sesuai dengan FSD/PRD. | Pemantauan server, pembaruan versi library/keamanan, verifikasi backup DB berkala, dan jatah jam pengembangan fitur minor. |
| **Fitur Baru** | **DILARANG MASUK**: Wajib lewat Change Request (CR). | Termasuk dalam jatah jam kerja bulanan (*monthly hours quota*). |
| **Penyebab Eksternal**| **GUGUR**: Jika server diubah pihak ketiga atau API pihak ketiga berubah format. | Ditangani menggunakan alokasi jam retainer bulanan. |

---

## 3. Langkah demi Langkah Eksekusi

### Langkah 1: Sosialisasi Kebijakan Garansi (`WARRANTY_POLICY.md`)
1. Bersamaan dengan penyerahan BAST (Modul 11), serahkan dokumen **`WARRANTY_POLICY.md`** kepada Single PIC Klien.
2. Tegaskan saluran komunikasi resmi:
   - Laporan bug wajib melalui email resmi atau satu grup koordinasi teknis.
   - Dilarang mengirimkan pesan bug ke nomor pribadi solo developer di luar jam kerja (kecuali server berstatus *Critical Down*).

### Langkah 2: Triase Insiden & Eksekusi Hotfix
Jika klien melaporkan adanya kendala di produksi selama masa garansi:
1. Periksa dashboard Sentry untuk melihat *stack trace* dan riwayat error.
2. Buat branch perbaikan dari `main`:
   ```bash
   git checkout main
   git checkout -b fix/issue-critical-payment
   ```
3. Koding perbaikan, jalankan `pnpm run test:smoke` lokal.
4. Merge ke `staging` untuk verifikasi kilat, lalu merge ke `main` dan beri tag hotfix:
   ```bash
   git checkout main
   git merge --no-ff fix/issue-critical-payment
   git tag -a v1.0.1 -m "hotfix: resolve payment webhook timeout"
   git push origin main --tags
   ```

### Langkah 3: Negosiasi Transisi ke Retainer Bulanan (14 Hari Sebelum Garansi Habis)
Dua minggu sebelum masa garansi berakhir, kirimkan surat penawaran pemeliharaan rutin (*Retainer Proposal*). 

**Otomasi Pengingat**: Atur calendar reminder atau cron job untuk mengirim proposal otomatis 14 hari sebelum tanggal garansi habis:
```bash
# Contoh cron job: Kirim reminder proposal retainer
# Tambahkan ke crontab atau gunakan scheduler layanan (Hermes cron / GitHub Actions)
0 9 * * * check_warranty_expiry_and_notify.sh
```

Tawarkan 3 opsi paket:

1. **Paket Bronze (Pemeliharaan Dasar & Keamanan)**:
   - Pemantauan server 24/7 (Uptime & Sentry).
   - Pembaruan patch keamanan dependensi dan database setiap bulan.
   - Verifikasi integritas cadangan data (*daily backup restore test*).
   - Alokasi: 5 Jam kerja konsultasi teknis / bulan.
2. **Paket Silver (Pemeliharaan Standar & Optimasi)**:
   - Seluruh fasilitas Paket Bronze.
   - Alokasi **15 Jam kerja / bulan** untuk penambahan fitur minor, perbaikan antarmuka, atau perubahan format laporan.
   - SLA Respon tanggap $< 4\text{ jam}$ di hari kerja.
3. **Paket Gold (Enterprise SLA & Prioritas Penuh)**:
   - Seluruh fasilitas Paket Silver.
   - Alokasi **30 Jam kerja / bulan** untuk pengembangan berkelanjutan.
   - Dukungan siaga darurat (*On-Call Support*) di akhir pekan jika sistem mengalami kegagalan kritis (*Severity 1*).

---

## 4. Adaptasi Berdasarkan Skala Proyek

| Parameter Pasca-Proyek | Skala Kecil (MVP / Freelance) | Skala Menengah (B2B SaaS / Agensi) | Skala Besar & Enterprise |
| :--- | :--- | :--- | :--- |
| **Durasi Garansi** | 30 Hari Kalender | 60 Hari Kalender | 90 Hari Kalender |
| **SLA Respon Bug** | Respon 1x24 jam di hari kerja | Respon 4–8 jam di hari kerja | Respon 1–2 jam dengan eskalasi darurat |
| **Model Retainer** | Opsi perbaikan insidental (*Hourly T&M*) | Paket Retainer Silver (10–15 jam/bulan) | Kontrak SLA Enterprise formal (Bilingual) |
| **Penagihan Retainer**| Invoice dikirim setelah jam dipakai | Ditagih di muka setiap tanggal 1 per bulan | Kontrak tahunan dibayar per kuartal/tahun |

---

## 5. Artefak Keluaran (Deliverables)

> 📁 **ATURAN LOKASI BERKAS MUTLAK**:
> Seluruh dokumen kebijakan garansi, kontrak retainer, dan laporan insiden WAJIB disimpan di dalam folder **`docs/pm/`**.

Modul ini menghasilkan 3 dokumen tata kelola pemeliharaan:
1. **`docs/pm/WARRANTY_POLICY.md`**: Dokumen kebijakan resmi batas garansi, jam kerja layanan, dan definisi galat yang dilindungi (menggunakan `templates/08-maintenance-ops/WARRANTY_POLICY_TEMPLATE.md`).
2. **`docs/pm/SLA_RETAINER_CONTRACT.md`**: Dokumen kontrak kerja sama pemeliharaan bulanan berulang (*Monthly Retainer Agreement*) (menggunakan `templates/08-maintenance-ops/SLA_RETAINER_CONTRACT_TEMPLATE.md`).
3. **`docs/pm/INCIDENT_RESPONSE.md`**: Prosedur standar operasional (SOP) penanganan insiden darurat produksi bagi solo developer (menggunakan `templates/08-maintenance-ops/INCIDENT_RESPONSE_TEMPLATE.md`).

---

## 6. Kriteria Kelulusan [GATE] (Gate Exit Criteria)

[GATE] Modul 12 dinyatakan **BERHASIL & SIKLUS PROYEK 100% PURNA** jika:
- [x] Masa garansi 30/60/90 hari kalender telah dilewati tanpa ada sisa tiket Severity 1 & 2 yang menggantung.
- [x] Dokumen `docs/pm/WARRANTY_POLICY.md` telah diterbitkan.
- [x] Klien telah menandatangani lembar penutupan garansi atau telah resmi menandatangani Kontrak Retainer Bulanan (`docs/pm/SLA_RETAINER_CONTRACT.md`).
- [x] Sistem beroperasi stabil secara mandiri di server produksi dengan pemantauan otomatis aktif.

---

## 🛑 PROTOKOL PENUTUPAN SIKLUS HIDUP (LIFECYCLE COMPLETION)
Setelah seluruh tahapan Modul 12 selesai:
1. Tampilkan ucapan selamat dan rangkuman purna karya kepada pengguna.
2. **AKHIRI RESPON ANDA (END TURN)**. Seluruh 12 siklus rekayasa perangkat lunak solo developer telah selesai 100%.
