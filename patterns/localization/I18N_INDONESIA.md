# Indonesian Localization & Formatting Standards (i18n)

> **Standard**: Production patterns for Indonesian Rupiah formatting, multi-zone Indonesian timestamps (WIB/WITA/WIT), and statutory tax rounding rules.

---

## 1. Currency Formatting (Indonesian Rupiah)

Indonesian Rupiah (IDR) does not use minor currency units (cents/sen) in modern commerce. All figures are formatted without fractional decimals unless specifically requested for exchange rates.

```typescript
// Standard Indonesian Currency Formatter
export function formatRupiah(amount: number): string {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
}

// Compact Formatter for Dashboards & Mobile KPI Cards
export function formatRupiahCompact(amount: number): string {
  if (Math.abs(amount) >= 1_000_000_000) {
    return `Rp ${(amount / 1_000_000_000).toFixed(1)} M`; // Milyar
  }
  if (Math.abs(amount) >= 1_000_000) {
    return `Rp ${(amount / 1_000_000).toFixed(1)} jt`; // Juta
  }
  if (Math.abs(amount) >= 1_000) {
    return `Rp ${(amount / 1_000).toFixed(0)} rb`; // Ribu
  }
  return formatRupiah(amount);
}
```

---

## 2. Indonesian Timezones & Date Formatting

Indonesia spans 3 time zones:
- **WIB (Waktu Indonesia Barat)**: UTC+7 (Jakarta, Sumatra, Java, West/Central Kalimantan)
- **WITA (Waktu Indonesia Tengah)**: UTC+8 (Bali, Nusa Tenggara, South/East Kalimantan, Sulawesi)
- **WIT (Waktu Indonesia Timur)**: UTC+9 (Maluku, Papua)

```typescript
// Format date in Indonesian locale with explicit timezone
export function formatIndonesianDate(
  date: Date | string,
  timeZone: 'Asia/Jakarta' | 'Asia/Makassar' | 'Asia/Jayapura' = 'Asia/Jakarta'
): string {
  const d = typeof date === 'string' ? new Date(date) : date;
  return new Intl.DateTimeFormat('id-ID', {
    dateStyle: 'long',
    timeStyle: 'short',
    timeZone,
  }).format(d);
}
// Output: "7 Oktober 2026 14.30 WIB"
```

---

## 3. Statutory Tax Calculation & Rounding (PPN & PPh)

1. **PPN (Pajak Pertambahan Nilai) — the statutory rate is 12%, the *effective* rate on ordinary goods is 11%**:
   - Statutory rate: **12%** (UU HPP, in force since 1 Jan 2025).
   - For ordinary goods the 12% is applied to a **DPP Nilai Lain** of `11/12 × harga jual`, so the customer pays `0.11 × harga jual` — an effective 11% of the selling price (PMK 131/2024).
   - For luxury goods (PPnBM objects) the 12% applies to the full price.
   - **Implement the mechanism, not the number**: store the rate and the DPP factor separately, so a future rate change is one constant. Writing `× 0.11` as "the PPN rate" is a two-year-stale reading that happens to produce the right total for ordinary goods and the wrong one for luxury.
   - Rounding: standard mathematical rounding to the nearest integer Rupiah.
   - **This is the single source for the rate in this repository.** Cite this section rather than repeating a percentage elsewhere.
2. **PPh Final 0.5% (PP 55/2022 jo. PP 20/2026)**:
   - Permanent facility for qualifying Wajib Pajak Orang Pribadi (WP OP), PT Perorangan, and Koperasi with annual turnover ≤ Rp 4.8B (no longer eligible for CV, Firma, PT non-perorangan).
   - Non-taxable turnover threshold of Rp 500.000.000/year applies strictly to individual taxpayers (WP OP).
   - Invoices must clearly separate DPP (Dasar Pengenaan Pajak), PPN, and Total Tagihan — and state the rate applied.
3. **Bea Meterai (UU No. 10/2020)**:
   - Dokumen perdata (termasuk tagihan/invoice dan kwitansi penerimaan uang) dengan nominal **di atas Rp 5.000.000** wajib dibubuhi Meterai Rp 10.000 (Meterai tempel fisik atau e-Meterai resmi Peruri).
   - Tagihan ≤ Rp 5.000.000 tidak dikenakan bea meterai.

---

## 4. 16-Digit NIK & NPWP Formatting & Validation (Coretax / PMK 112/2022 jo. PMK 136/2023)

Under the unified Indonesian tax administration system (*Coretax* DJP):
1. **Wajib Pajak Orang Pribadi (WNI)**: Menggunakan **16 digit NIK (Nomor Induk Kependudukan)** sebagai NPWP.
2. **Wajib Pajak Badan, Instansi Pemerintah, dan WNA**: Menggunakan **NPWP 16 digit** (ditambahkan angka `0` di depan 15 digit lama).
3. **Format Lama (15 Digit)**: Format transisi `99.999.999.9-999.000` tetap didukung via konversi padding `0` di depan.

```typescript
/**
 * Normalizes NPWP input by stripping punctuation, dots, hyphens, and whitespace.
 */
export function normalizeNPWP(input: string): string {
  return input.replace(/[\s.-]/g, '');
}

/**
 * Validates Indonesian NPWP / NIK according to PMK 112/2022 & Coretax standards.
 */
export function validateNPWP(input: string): {
  isValid: boolean;
  format: '16_DIGIT' | '15_DIGIT_LEGACY' | 'INVALID';
  normalized: string;
  error?: string;
} {
  const digits = normalizeNPWP(input);

  if (!/^\d+$/.test(digits)) {
    return { isValid: false, format: 'INVALID', normalized: digits, error: 'NPWP must contain only digits' };
  }

  if (digits.length === 16) {
    return { isValid: true, format: '16_DIGIT', normalized: digits };
  }

  if (digits.length === 15) {
    return { isValid: true, format: '15_DIGIT_LEGACY', normalized: digits };
  }

  return {
    isValid: false,
    format: 'INVALID',
    normalized: digits,
    error: `Expected 15 or 16 digits, received ${digits.length}`,
  };
}

/**
 * Formats a 15-digit or 16-digit NPWP into readable business invoice presentation.
 * - 15-digit legacy: 01.234.567.8-901.000
 * - 16-digit (NIK / Coretax): 0123.4567.8901.2345 (or 001.234.567.8-901.000 for Badan)
 */
export function formatNPWP(input: string): string {
  const digits = normalizeNPWP(input);
  if (digits.length === 15) {
    return `${digits.slice(0, 2)}.${digits.slice(2, 5)}.${digits.slice(5, 8)}.${digits.slice(8, 9)}-${digits.slice(9, 12)}.${digits.slice(12, 15)}`;
  }
  if (digits.length === 16) {
    // 16-digit block display
    return `${digits.slice(0, 4)}.${digits.slice(4, 8)}.${digits.slice(8, 12)}.${digits.slice(12, 16)}`;
  }
  return input;
}
```
