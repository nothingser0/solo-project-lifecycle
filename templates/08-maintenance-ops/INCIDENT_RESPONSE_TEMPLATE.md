# Laporan Penanganan Insiden & Post-Mortem (Incident Response Report)

> Dokumen analisis akar masalah (*Root Cause Analysis* / RCA), kronologi pemulihan, dan tindakan pencegahan permanen pascaterjadinya gangguan operasional di server produksi.

---

## 1. Metadata Insiden
- **ID Insiden**: `INC-[YYYYMMDD]-001`
- **Tingkat Keparahan**: [Severity 1 (Kritis) / Severity 2 (Mayor)]
- **Komponen Terdampak**: [Contoh: Gateway Pembayaran / Render PDF Vault / Database Connection]
- **Durasi Gangguan (Downtime)**: [Contoh: 18 Menit]
- **Lead Incident Responder**: [Nama Anda]
- **Tanggal Insiden**: [YYYY-MM-DD]

---

## 2. Kronologi Pemulihan Insiden (Incident Timeline)

| Waktu (WIB) | Fase Tindakan | Deskripsi Kejadian & Eksekusi |
| :---: | :--- | :--- |
| **10:15** | **Deteksi (T0)** | Bot Uptime Kuma mengirimkan alert: endpoint `/api/health` mengembalikan error 500. |
| **10:18** | **Triase (T1)** | Membuka Sentry: terdeteksi `Database connection pool timeout` akibat koneksi menggantung. |
| **10:24** | **Mitigasi (T2)** | Merestart service pooler PgBouncer dan menaikkan batas `connection_limit` dari 10 ke 25. |
| **10:33** | **Pemulihan (T3)** | Endpoint `/api/health` kembali 200 OK, antrian request diproses normal tanpa data hilang. |

---

## 3. Analisis Akar Masalah (Root Cause Analysis - The 5 Whys)

1. **Kenapa endpoint `/api/health` mengembalikan error 500?**  
   *Karena backend gagal mendapatkan koneksi aktif ke database PostgreSQL.*
2. **Kenapa koneksi database habis?**  
   *Karena seluruh 10 slot connection pool terisi penuh dan tertahan selama lebih dari 30 detik.*
3. **Kenapa koneksi tertahan lama?**  
   *Karena ada kueri pencarian dokumen yang tidak memiliki indeks pada kolom `form_data->>'creator_name'` sehingga melakukan sequential scan pada 50.000 baris.*
4. **Kenapa kueri tersebut tidak memiliki indeks?**  
   *Karena pada saat migrasi awal, kueri tersebut diasumsikan hanya dipanggil sesekali, namun klien menjalankan filter tersebut secara bersamaan saat jam kerja sibuk.*

---

## 4. Tindakan Pencegahan Permanen (Corrective & Preventive Actions)

| No | Tindakan Korektif | Penanggung Jawab | Status Penyelesaian |
| :-: | :--- | :--- | :---: |
| 1 | Menambahkan GIN Index pada kolom JSONB terkait di PostgreSQL | Developer | [x] SELESAI |
| 2 | Memasang timeout otomatis 5.000 ms pada seluruh kueri database | Developer | [x] SELESAI |
| 3 | Menambahkan alert khusus di Sentry jika koneksi pool mencapai 80% | Developer | [x] SELESAI |

---

## 5. Lembar Pengesahan Laporan Insiden

Laporan ini telah ditinjau bersama Pihak Klien sebagai wujud transparansi operasional dan komitmen peningkatan mutu berkelanjutan.

- Disusun oleh Lead Developer: **[Nama Anda]** (Tanggal: [YYYY-MM-DD])
- Diterima oleh Single PIC Klien: **[Nama PIC Klien]** (Tanggal: [YYYY-MM-DD])
