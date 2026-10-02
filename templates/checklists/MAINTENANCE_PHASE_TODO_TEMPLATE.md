# Maintenance, Warranty, & Operations Phase TODO Template (Modul 12 - Modul 13)

> Template daftar tugas atomik untuk fase Pasca-Rilis: Masa Garansi Cacat (Warranty Period), Penyiapan Pemantauan & Observabilitas (Monitoring & APM), Penetapan Baseline Metrik Kinerja/Produk, dan Perencanaan Iterasi Berkelanjutan (SLA Retainer / Product Growth).
> Aturan: Kawal stabilitas sistem produksi secara proaktif. Terapkan batasan tegas antara perbaikan bug garansi dan penambahan fitur baru (*scope creep control*). Pantau kesehatan sistem menggunakan telemetri otomatis, bukan menunggu komplain dari pengguna akhir.

---

## Metadata Pemeliharaan & Operasi
- **Nama Sistem**: [Nama Sistem / Aplikasi]
- **Target URL Produksi**: `https://app.domainklien.com`
- **Lead Operations / On-Call Engineer**: [Nama Anda]
- **PIC Manajerial Klien**: [Nama PIC Klien]
- **Masa Garansi**: [30 / 60 / 90 Hari Kalender] (Mulai: [YYYY-MM-DD] s/d [YYYY-MM-DD])
- **Model Kontrak Lanjutan**: [ ] Warranty Gratis (Standar) | [ ] SLA Retainer Bulanan | [ ] Handover Putus Kontrak
- **Status Operasional**: [ ] WARRANTY ACTIVE | [ ] SLA RETAINER ACTIVE | [ ] ARCHIVED / CLOSED

---

## 1. Modul 12: Manajemen Masa Garansi & Layanan Cacat (Warranty Period Tasks)

### 1.1 Inisiasi Masa Garansi & Batasan Ruang Lingkup
- [ ] `maintenance/warranty-kickoff.md`: Kirimkan surat konfirmasi resmi dimulainya masa garansi terhitung sejak tanggal penandatanganan BAST Final - expect tanggal mulai dan tanggal kadaluarsa garansi tercatat hitam di atas putih
- [ ] `maintenance/warranty-scope-policy.md`: Tegaskan dan komunikasikan Batasan Lingkup Garansi kepada seluruh pemangku kepentingan klien:
  - **DITANGGUNG (Covered)**: Bug/cacat kode yang menyimpang dari dokumen spesifikasi FSD/SOW yang telah disepakati, ketidakstabilan crash server internal, kegagalan query database
  - **TIDAK DITANGGUNG (Not Covered)**: Permintaan penambahan alur/fitur baru (*Change Request*), perubahan desain antarmuka atas selera baru, kerusakan akibat modifikasi kode mandiri oleh tim klien, perubahan drastis API pihak ketiga di luar kendali
  - expect batasan tanggung jawab dipahami dan diakui secara tertulis oleh klien
- [ ] `maintenance/support-channels.md`: Buka kanal komunikasi resmi dukungan (*Support Ticket Channel*: Portal Helpdesk / Email Support / Slack Channel terdedikasi) - expect kanal komunikasi terpusat dan tercatat, bukan via chat personal acak

### 1.2 Triase Insiden & Service Level Agreement (SLA Tiers)
- [ ] Terapkan matriks klasifikasi tiket insiden dan komitmen waktu respons (*Response Time*) serta penyelesaian (*Resolution Target*):
  - **Tingkat 1 - Critical Outage (P1)**: Seluruh sistem mati total atau data rusak. Waktu respons: < 1 jam. Target resolusi/workaround: < 4 jam.
  - **Tingkat 2 - Major Degradation (P2)**: Fitur bisnis inti terganggu untuk mayoritas pengguna. Waktu respons: < 2 jam. Target resolusi: < 12 jam.
  - **Tingkat 3 - Moderate Defect (P3)**: Bug fungsional non-kritis dengan solusi alternatif. Waktu respons: < 8 jam. Target resolusi: < 48 jam.
  - **Tingkat 4 - Minor / Cosmetic (P4)**: Typo teks atau pergeseran visual kecil. Waktu respons: < 24 jam. Target resolusi: Dimasukkan ke siklus rilis patch berkala.
  - expect alur penanganan tiket mengikuti komitmen SLA
- [ ] `maintenance/incident-log.md`: Catat setiap tiket insiden yang dilaporkan selama masa garansi: ID Tiket, Pelapor, Timestamp Masuk, Severity, Analisis Akar Masalah (RCA), Waktu Penanganan, Waktu Penyelesaian - expect seluruh tiket terdata secara akuntabel

### 1.3 Analisis Pasca-Insiden (Post-Mortem & Root Cause Analysis)
- [ ] `maintenance/post-mortems/YYYY-MM-DD-incident-rca.md`: Untuk setiap insiden berkategori P1 atau P2, susun dokumen Root Cause Analysis (RCA) menggunakan metode 5-Whys:
  - Kronologi peristiwa (*Incident Timeline*)
  - Dampak terhadap bisnis dan jumlah pengguna terdampak
  - Akar masalah teknis (*Root Cause*)
  - Tindakan perbaikan darurat (*Corrective Action*)
  - Tindakan pencegahan agar insiden tidak terulang (*Preventative Action*)
  - expect transparansi profesional yang membangun kepercayaan klien
- [ ] Deploy patch koreksi ke produksi dan lakukan verifikasi ulang bersama pelapor tiket - expect tiket insiden ditutup dengan status RESOLVED

### 1.4 Transisi Menuju Kontrak Pemeliharaan (SLA Retainer Proposal)
- [ ] `maintenance/sla-retainer-proposal.md`: Pada 14 hari sebelum masa garansi berakhir, susun dan kirimkan proposal Perjanjian Layanan Pemeliharaan Berkelanjutan (*SLA Retainer Contract*):
  - Paket jam kerja dukungan bulanan (misal: 10 jam, 20 jam, atau 40 jam per bulan)
  - Biaya retainer tetap bulanan (*Monthly Retainer Fee*)
  - Tarif per jam untuk pengerjaan Change Request tambahan di luar kuota (*Blended Hourly Rate*)
  - Pemeliharaan preventif rutin (update security patch OS/framework bulanan, audit database)
  - expect penawaran retainment terkirim tepat waktu sebelum ketergantungan klien terputus
- [ ] Lakukan negosiasi dan penandatanganan kontrak retainer baru atau laksanakan prosedur penutupan garansi final (*Warranty Sign-off / Closure Certificate*) jika klien memilih pemeliharaan mandiri - expect status operasional terkunci jelas

---

## 2. Modul 13: Penyiapan Sistem Pemantauan & Observabilitas (Monitoring Setup)

### 2.1 Konfigurasi Pemantauan Kinerja Aplikasi (APM & Error Tracking)
- [ ] Pasang dan inisiasi SDK pemantau crash/error di backend dan frontend (Sentry / Datadog / Highlight.io / Bugsnag):
  - Konfigurasikan pelacakan unhandled promise rejection dan fatal exceptions
  - Pasang context data pengguna (User ID tersamarkan, environment tag: `production`)
  - Konfigurasikan sanitasi data rahasia (*Data Scrubbing*): sembunyikan password, nomor kartu kredit, token JWT dari rekaman log error
  - expect error di browser pengguna dan server backend otomatis tertangkap di dashboard pemantau
- [ ] Pasang pemantauan transaksi performa (*Performance Tracing / OpenTelemetry*): lacak durasi query database lambat (*slow queries > 500ms*) dan waktu eksekusi panggilan API eksternal - expect visualisasi bottleneck terpetakan

### 2.2 Pemantauan Ketersediaan Layanan (Synthetic Uptime Monitoring)
- [ ] Daftarkan probe pemantau uptime eksternal (BetterStack / UptimeRobot / Pingdom / Cloudflare Healthchecks):
  - Pantau endpoint `/healthz` publik setiap interval 1 menit dari berbagai lokasi geografis dunia
  - Pasang asersi status HTTP 200 OK dan respon waktu respon < 1000 ms
  - Pantau validitas masa aktif sertifikat SSL/TLS (beri peringatan otomatis jika sisa masa berlaku < 30 hari)
  - expect pemberitahuan otomatis aktif saat situs mengalami downtime
- [ ] Konfigurasikan saluran darurat (*Escalation Alert Routing*): hubungkan notifikasi down ke Telegram Bot, Discord Webhook, SMS, atau PagerDuty engineer on-call - expect engineer siaga menerima alert darurat dalam waktu < 2 menit setelah server mati

### 2.3 Sentralisasi Log & Kebijakan Retensi (Log Management)
- [ ] Konfigurasikan agregasi log terpusat (BetterStack Logs / Datadog Logs / Grafana Loki / AWS CloudWatch) - expect seluruh log terindeks dengan metadata konteks (Level: INFO/WARN/ERROR, Timestamp UTC, Request ID, Path)
- [ ] Terapkan kebijakan retensi log (*Log Retention Policy*): simpan log operasional standar selama 30 hari dan log audit keamanan (*Security Audit Trail*) selama minimal 365 hari sesuai kepatuhan UU PDP - expect ruang penyimpanan log efisien dan patuh regulasi

### 2.4 Otomasi Pencadangan Basis Data & Uji Pemulihan (Backup & Restore Drills)
- [ ] Jadwalkan skrip pencadangan otomatis harian (*Automated Daily Database Backup / Snapshots*) dengan retensi 30 hari snapshot harian dan 12 snapshot bulanan - expect snapshot otomatis terarsip di cloud storage terisolasi
- [ ] `maintenance/drills/backup-restore-drill.md`: Lakukan simulasi uji coba pemulihan data (*Backup Restoration Drill*) ke lingkungan staging terisolasi minimal 1 kali per kuartal:
  - Unduh file backup terbaru
  - Restore ke database kosong
  - Verifikasi integritas data dan kecocokan relasi
  - Catat durasi waktu pemulihan aktual vs target RTO
  - expect bukti empiris bahwa file cadangan benar-benar dapat dipulihkan (*valid & non-corrupted backups*)

---

## 3. Modul 13: Penetapan Metrik Baseline & Dashboard Kesehatan (Metrics Baseline)

### 3.1 Pengukuran Metrik Kinerja Teknis (Technical Baseline)
- [ ] `ops/metrics/technical-baseline.md`: Ukur dan tetapkan angka garis dasar (*baseline numbers*) pada minggu ke-2 produksi beroperasi normal:
  - **Uptime / Ketersediaan**: Catat persentase uptime aktual (target minimum: 99.9% = maksimal downtime 43 menit/bulan)
  - **Latency Transaksi**: Rata-rata response time API (p50 target < 100 ms, p95 target < 500 ms, p99 target < 1500 ms)
  - **Tingkat Error (Error Rate)**: Rasio error HTTP 5xx terhadap total request (target < 0.05%)
  - **Beban Server Rata-rata**: Persentase utilisasi CPU, RAM, Disk space, dan DB connection pool peak
  - expect angka dasar terdokumentasi sebagai tolok ukur perbandingan anomali di masa depan
- [ ] `ops/metrics/core-web-vitals.md`: Catat nilai riil metrik pengalaman pengguna frontend (Real User Monitoring - RUM):
  - Largest Contentful Paint (LCP): target < 2.5 detik
  - Interaction to Next Paint (INP): target < 200 ms
  - Cumulative Layout Shift (CLS): target < 0.1
  - expect seluruh metrik berada dalam kategori "Good" (Hijau) pada Google PageSpeed Insights

### 3.2 Pengukuran Metrik Bisnis & Penggunaan Produk (Business Baseline)
- [ ] `ops/metrics/product-baseline.md`: Ukur dan catat baseline performa bisnis produk pasca peluncuran:
  - Jumlah Pengguna Aktif: Daily Active Users (DAU) & Monthly Active Users (MAU)
  - Volume Transaksi Inti: Jumlah transaksi sukses per hari/minggu
  - Rasio Konversi Alur Utama: Persentase pengguna yang menyelesaikan Core User Loop dari registrasi hingga konversi
  - Rasio Pengabaian / Churn Awal: Persentase pengguna yang drop-off di langkah onboarding
  - expect data baseline produk bersumber dari instrumen analitik (PostHog / Mixpanel / Plausible) tanpa tebak-tebakan

### 3.3 Pembuatan Dashboard Kesehatan Produk (Product Health Dashboard)
- [ ] `ops/dashboards/product-health-dashboard.md`: Bangun atau konfigurasikan dashboard visual terpadu yang menampilkan indikator kunci kesehatan teknis dan bisnis dalam satu layar - expect dashboard dapat diakses oleh tim teknis dan manajemen klien
- [ ] Susun template laporan ringkasan kesehatan bulanan (*Monthly Executive Health Digest*) untuk dikirimkan kepada Project Sponsor klien - expect pemangku kepentingan memahami performa dan ROI investasi perangkat lunak

---

## 4. Modul 13: Perencanaan Iterasi & Pertumbuhan Berkelanjutan (Iteration Planning)

### 4.1 Pengumpulan Umpan Balik Pengguna (User Feedback Loop)
- [ ] `growth/user-feedback.md`: Pasang widget pengumpul feedback kontekstual di dalam aplikasi (NPS in-app survey, tombol "Laporkan Kendala / Beri Saran", micro-rating bintang pada transaksi tuntas) - expect data kualitatif mengalir langsung dari pengguna aktif
- [ ] `growth/user-feedback.md`: Lakukan kategorisasi dan klastering umpan balik pengguna setiap 2 pekan: Friction Points, Feature Requests, Bug Reports, UX Enhancements - expect pola kebutuhan pengguna yang berulang teridentifikasi

### 4.2 Manajemen Eksperimen Pertumbuhan & Backlog Ide (Growth Backlog)
- [ ] `growth/experiment-backlog.md`: Susun daftar hipotesis peningkatan produk dan eksperimen A/B testing:
  - Pernyataan Hipotesis: "Jika kita [melakukan perubahan X], maka [metrik Y akan meningkat sebesar Z%], karena [alasan riset W]"
  - Skoring Prioritas Eksperimen menggunakan framework ICE (*Impact 1-10, Confidence 1-10, Ease 1-10*)
  - expect backlog eksperimen terurut berdasarkan nilai ROI implementasi tertinggi
- [ ] Rancang eksperimen A/B test sederhana untuk elemen dengan friksi konversi tertinggi (misal: formulir registrasi yang disederhanakan, copywriting tombol CTA) - expect rencana pengujian memiliki kelompok kontrol dan varian yang terukur

### 4.3 Perencanaan Sprint Iterasi & Pembayaran Utang Teknis (Sprint Planning)
- [ ] `growth/sprint-backlog.md`: Susun rencana sprint pemeliharaan dan pengembangan lanjutan (Siklus 2 Mingguan / 1 Bulanan):
  - **50% Kapasitas**: Fitur baru prioritas tinggi hasil evaluasi roadmap dan feedback pengguna
  - **30% Kapasitas**: Pembayaran Utang Teknis (*Technical Debt*), optimasi performa query database, pembaruan versi dependensi framework/library
  - **20% Kapasitas**: Patch keamanan, penanganan bug berkategori rendah, dan perbaikan minor dokumen
  - expect alokasi kapasitas berimbang antara inovasi bisnis dan stabilitas jangka panjang sistem
- [ ] Jadwalkan sesi Quarterly Business Review (QBR) bersama stakeholder klien untuk mengevaluasi pencapaian target metrik bisnis dan merencanakan roadmap jangka panjang - expect hubungan kemitraan strategis jangka panjang terjalin erat

---

## 5. Gerbang Verifikasi Kelolosan Siklus Pemeliharaan & Operasi

| Parameter Evaluasi | Standar Minimum Kelolosan | Status Verifikasi | Catatan Bukti |
| :--- | :--- | :---: | :--- |
| **Penyelesaian Garansi** | 100% tiket bug garansi tertangani, nol tiket P1/P2 open, masa garansi berakhir sah | [ ] PASS | Dilampirkan `maintenance/incident-log.md` |
| **Sistem Observabilitas** | APM aktif, Uptime probe 1 menit aktif, notifikasi alert darurat terhubung ke Telegram/Slack | [ ] PASS | Dilampirkan bukti alert test |
| **Keamanan Cadangan Data** | Backup harian otomatis aktif, simulasi restore data ke staging terbukti berhasil | [ ] PASS | Dilampirkan log restore drill |
| **Baseline Kinerja & Bisnis** | Laporan baseline teknis (Uptime >= 99.9%, p95 < 500ms) & metrik produk terdokumentasi | [ ] PASS | Dilampirkan di `ops/metrics/` |
| **Kontrak Layanan Lanjutan** | Transisi ke SLA Retainer disepakati ATAU Berita Acara Penutupan Garansi ditandatangani | [ ] PASS | Dilampirkan kontrak SLA / Akta Penutupan |

### Status Akhir Siklus Proyek:
- [ ] **TRANSISI KE SLA RETAINER BERKELANJUTAN**: Klien berlangganan layanan maintenance dan iterasi produk bulanan secara aktif.
- [ ] **PENUTUPAN RESMI PROYEK (LIFECYCLE COMPLETED & ARCHIVED)**: Masa garansi tuntas, seluruh kewajiban selesai, sistem berjalan stabil di tangan tim mandiri klien. Repositori diarsipkan.
