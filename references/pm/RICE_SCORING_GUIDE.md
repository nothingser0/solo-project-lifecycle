# Panduan RICE Scoring

RICE membantu memprioritaskan inisiatif berdasarkan nilai yang diharapkan dibandingkan biaya pengerjaan.

## Komponen RICE

- **Reach:** Jumlah pengguna yang terdampak per kuartal.
- **Impact:** Besar perbaikan untuk setiap pengguna terdampak.
  - `0.25`: minimal
  - `0.5`: rendah
  - `1`: sedang
  - `2`: tinggi
  - `3`: masif
- **Confidence:** Tingkat keyakinan terhadap estimasi.
  - `100%`: tinggi
  - `80%`: sedang
  - `50%`: rendah
- **Effort:** Person-months yang dibutuhkan untuk menyelesaikan pekerjaan.

## Formula

```text
RICE Score = (Reach × Impact × Confidence) / Effort
```

Gunakan Confidence sebagai nilai desimal dalam perhitungan, misalnya `80% = 0.8`.

## Contoh Penilaian

| Inisiatif | Reach per kuartal | Impact | Confidence | Effort (person-months) | RICE Score |
|---|---:|---:|---:|---:|---:|
| Perbaiki alur registrasi | 500 | 2 | 80% | 1 | 800 |
| Tambahkan ekspor laporan | 120 | 1 | 100% | 0.5 | 240 |
| Otomatisasi pengingat email | 300 | 0.5 | 50% | 1 | 75 |

## Cara Menggunakan

1. Daftarkan inisiatif yang bersaing dalam periode perencanaan yang sama.
2. Tentukan Reach dari data produk atau estimasi yang memiliki sumber jelas.
3. Nilai Impact berdasarkan perubahan yang dialami tiap pengguna, bukan tingkat kesulitan teknis.
4. Turunkan Confidence bila data belum memadai atau asumsi belum divalidasi.
5. Estimasikan Effort dalam person-months, termasuk implementasi, pengujian, dan peluncuran.
6. Hitung dan urutkan skor dari tertinggi ke terendah.
7. Gunakan skor sebagai bahan keputusan, lalu catat faktor strategis, risiko, dan dependensi yang dapat mengubah urutan.
