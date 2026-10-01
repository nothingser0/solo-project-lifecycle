# Panduan Elisitasi Kebutuhan (Requirement Elicitation Guide)

Panduan wawancara praktis dan bank pertanyaan terarah untuk solo developer dalam menggali kebutuhan riil klien, membedah kompleksitas tersembunyi, dan mengamankan batasan lingkup sejak hari pertama.

---

## 1. Bank Pertanyaan 5 Pilar Elisitasi (The 5-Pillar Question Bank)

### Pilar 1: Motivasi Bisnis & Metrik Keberhasilan (Business Drivers & KPIs)
*Tujuan: Memahami alasan sebenarnya di balik pembuatan perangkat lunak.*

- *"Masalah operasional apa yang paling memakan waktu atau biaya perusahaan dalam 6 bulan terakhir?"*
- *"Jika aplikasi ini sukses besar saat go-live, angka apa yang ingin Bapak/Ibu lihat berubah (contoh: biaya operasional turun 30%, waktu pemrosesan order turun dari 2 jam ke 5 menit)?"*
- *"Apa dampak buruk terbesar bagi bisnis jika proyek ini gagal selesai tepat waktu?"*

### Pilar 2: Alur Kerja Harian & Kasus Pengecualian (Daily Workflow & Edge Cases)
*Tujuan: Memetakan proses nyata, bukan sekadar teori.*

- *"Coba ceritakan skenario dari saat staf membuka sistem di pagi hari sampai pekerjaan selesai (End-to-End Happy Path)?"*
- *"Apa skenario terburuk yang sering terjadi di lapangan (contoh: pelanggan membatalkan pesanan setelah bayar, jaringan internet mati saat kasir input transaksi, barang hilang saat kirim)?"*
- *"Bagaimana staf saat ini menyelesaikan situasi darurat tersebut secara manual?"*

### Pilar 3: Volume Operasional & Skalabilitas (Operational Volume & Concurrency)
*Tujuan: Menentukan batas arsitektur dan kapasitas infrastruktur.*

- *"Berapa perkiraan jumlah transaksi, dokumen, atau pesanan yang diproses dalam sehari pada bulan pertama?"*
- *"Kapan biasanya terjadi lonjakan transaksi paling padat (peak hours: jam makan siang, tanggal gajian, atau promo akhir bulan)?"*
- *"Berapa jumlah staf yang akan membuka aplikasi ini secara bersamaan di waktu yang sama?"*

### Pilar 4: Ekosistem Sistem & Integrasi Pihak Ketiga (System Ecology)
*Tujuan: Mendeteksi dependensi teknis berisiko tinggi.*

- *"Apakah sistem ini harus bertukar data dengan software lain yang sudah dipakai kantor (contoh: SAP, Accurate, Zahir, CRM Salesforce, atau database MySQL lama)?"*
- *"Apakah sistem tersebut memiliki dokumentasi API resmi (REST/GraphQL/SOAP) dan siapa tim teknis yang bisa dihubungi jika API mereka bermasalah?"*
- *Catatan Solo Dev: Jika klien tidak memiliki tim teknis untuk sistem integrasi lama, jangan tawarkan integrasi dua arah otomatis.*

### Pilar 5: Kepatuhan Hukum, Keamanan, & Retensi Data (Compliance & Governance)
*Tujuan: Menjaga developer dari risiko pidana dan denda regulasi.*

- *"Apakah ada data pribadi sensitif pelanggan yang disimpan (contoh: foto KTP, rekam medis, nomor rekening perbankan)?"*
- *"Sesuai UU PDP No. 27/2022, data sensitif wajib dienkripsi dan memiliki jejak audit. Apakah ada kebijakan perusahaan mengenai batas waktu penyimpanan data (data retention policy) sebelum dihapus permanen?"*

---

## 2. Trik Taktis Solo Dev Menghadapi Klien (Tactical Probes)

### Teknik 1: Menghadapi "Cuma Bikin Fitur Simpel Kok"
Klien sering mengira tombol di layar itu mudah dibuat.
- **Pola Respons**:
  > *"Tampilan tombolnya memang sederhana, Pak/Bu. Namun di belakang tombol tersebut, sistem harus memproses: (1) validasi stok secara bersamaan, (2) memotong saldo payment gateway, (3) mengirim webhook verifikasi, dan (4) mencatat jurnal audit ke basis data. Supaya aman dan tidak ada uang hilang, pengerjaannya butuh waktu pengujian khusus."*

### Teknik 2: Permainan Barter Fitur (The Feature Trade-Off)
Jika klien mendadak meminta tambahan fitur baru saat sesi wawancara namun tidak ingin jadwal mundur.
- **Pola Respons**:
  > *"Fitur [A] yang baru Bapak/Ibu usulkan sangat bagus. Namun dengan kapasitas waktu rilis 6 minggu yang kita kunci, jika kita memasukkan fitur [A], kita harus memilih apakah menunda fitur [B] atau fitur [C] ke rilis berikutnya. Mana yang paling prioritas untuk operasional awal?"*

### Teknik 3: Deteksi Masalah Akar dengan "5 Whys"
Klien sering meminta solusi yang keliru untuk masalah mereka (contoh: *"Kami butuh aplikasi mobile native iOS dan Android"*).
- *Tanya*: *"Kenapa butuh aplikasi mobile?"* $\to$ *"Supaya kurir bisa update status di jalan."*
- *Tanya*: *"Kenapa kurir butuh app store?"* $\to$ *"Supaya bisa buka di HP Android murah."*
- *Kesimpulan Solo Dev*: Kebutuhan sebenarnya adalah **Web Responsif / PWA** yang ringan diakses browser ponsel, bukan dua aplikasi native terpisah yang butuh biaya maintenance ganda.

---

## 3. Indikator Bahaya (Red Flags) Saat Discovery

| Perilaku Klien Saat Discovery | Risiko Nyata Bagi Solo Developer | Tindakan Mitigasi |
| :--- | :--- | :--- |
| **Klien tidak tahu proses bisnisnya sendiri** | Pengerjaan akan macet di tengah jalan karena klien terus mengubah alur. | Wajibkan klien memetakan flowchart manual sebelum developer menulis kode. |
| **Menolak membagi prioritas (Semua fitur dibilang P0/Urgent)** | Beban kerja membengkak tidak masuk akal (*burnout*). | Terapkan batasan: Maksimal hanya 5 fitur utama yang berstatus *Must-Have*. Sisanya otomatis masuk *Should/Could*. |
| **Menyembunyikan sistem lama yang rusak** | Klien berharap developer memperbaiki database lama mereka yang berantakan secara gratis. | Nyatakan secara tertulis: *Data cleaning & database recovery* dari sistem warisan dikenakan tarif terpisah per hari kerja. |
| **PIC selalu berhalangan hadir saat wawancara** | Keputusan ditunda-tunda dan proyek molor berbulan-bulan. | Aktifkan klausul *Dependency SLA*: Tiap 3 hari tanpa respons rapat/feedback, jadwal rilis resmi digeser. |
