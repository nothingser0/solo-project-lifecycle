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

1. **PPN (Pajak Pertambahan Nilai) 11%**:
   - Calculated as: $\text{DPP} \times 0.11$.
   - Rounding: Standard mathematical rounding (`Math.round`) to the nearest integer Rupiah.
2. **PPh Final 0.5% (PP 55/2022 jo. PP 20/2026)**:
   - Permanent facility for qualifying Wajib Pajak Orang Pribadi (WP OP), PT Perorangan, and Koperasi with annual turnover $\le$ Rp 4.8B (no longer eligible for CV, Firma, PT non-perorangan).
   - Non-taxable turnover threshold of Rp 500.000.000/year applies strictly to individual taxpayers (WP OP).
   - Invoices must clearly separate DPP (Dasar Pengenaan Pajak), PPN 11%, and Total Tagihan.
