# Data Assets Management: Regulations, Calculations, Reference Data & Seed Data

Panduan untuk mengelola data non-visual: regulasi, rumus bisnis, referensi statis, seed data, dan content data dengan fokus pada maintainability, versioning, dan source of truth.

---

## 1. Data Asset Categories

| Category | Format | Storage | Update Frequency | Examples |
|----------|--------|---------|------------------|----------|
| **Regulations** | JSON, YAML, MD | `/data/regulations/` | Quarterly/Annual | Tax rates, PTKP values, legal thresholds |
| **Business Rules** | TS/JS functions | `/lib/calculations/` | Per feature | Tax calculation formulas, validation rules |
| **Reference Data** | JSON, CSV | `/data/reference/` | Rarely | City list, bank list, industry codes |
| **Seed Data** | SQL, JSON | `/prisma/seed/` | Once (dev/staging) | Test users, sample documents |
| **Content Data** | MD, MDX | `/content/` | Weekly/Daily | Blog posts, help docs, FAQs |
| **Localization** | JSON | `/locales/` | Per translation | i18n strings (id, en) |

---

## 2. Regulations & Legal Data (Versioned, Auditable)

### 2.1 Problem: Hardcoded Values Everywhere

**Bad Practice** ❌:
```typescript
// Scattered across codebase — nightmare to update
function calculatePPh21(income: number) {
  if (income <= 60_000_000) return income * 0.05;
  if (income <= 250_000_000) return income * 0.15;
  // ... hardcoded tax brackets
}

// Another file
const PTKP_TK0 = 54_000_000; // Stale data
```

**Problems**:
- Regulation changes (e.g., PTKP 54jt → 58.5jt) require finding all hardcoded values
- No audit trail ("when did this rate change?")
- No source citation ("dari mana angka ini?")

---

### 2.2 Solution: Centralized Regulation Data

**File Structure** (FreePajak example):
```
/data/
├── regulations/
│   ├── pph21-rates.json           // Income tax brackets
│   ├── ptkp-values.json           // Tax-free allowance
│   ├── pph23-rates.json           // Withholding tax rates
│   ├── pp20-2026.json             // PP 20/2026 influencer rules
│   └── metadata.json              // Version, effective dates
├── reference/
│   ├── cities.json                // Indonesian cities (for address)
│   ├── banks.json                 // Bank list (for payment)
│   └── industries.json            // Industry codes (KBLI)
└── seed/
    ├── users.json                 // Test users (dev/staging only)
    └── sample-calculations.json   // Test scenarios
```

---

### 2.3 Regulation JSON Schema (Versioned)

**`data/regulations/pph21-rates.json`**:
```json
{
  "version": "2026.1",
  "effective_date": "2026-01-01",
  "source": "UU No. 7 Tahun 2021 (UU HPP)",
  "url": "https://peraturan.bpk.go.id/Details/195158/uu-no-7-tahun-2021",
  "last_updated": "2026-09-29",
  "brackets": [
    {
      "min": 0,
      "max": 60000000,
      "rate": 0.05,
      "description": "Penghasilan hingga Rp60 juta"
    },
    {
      "min": 60000000,
      "max": 250000000,
      "rate": 0.15,
      "description": "Penghasilan Rp60 juta - Rp250 juta"
    },
    {
      "min": 250000000,
      "max": 500000000,
      "rate": 0.25,
      "description": "Penghasilan Rp250 juta - Rp500 juta"
    },
    {
      "min": 500000000,
      "max": 5000000000,
      "rate": 0.30,
      "description": "Penghasilan Rp500 juta - Rp5 miliar"
    },
    {
      "min": 5000000000,
      "max": null,
      "rate": 0.35,
      "description": "Penghasilan di atas Rp5 miliar"
    }
  ],
  "notes": [
    "Berlaku untuk Wajib Pajak Orang Pribadi",
    "Tarif progresif sesuai Pasal 17 ayat (1) huruf a UU HPP"
  ]
}
```

**`data/regulations/ptkp-values.json`**:
```json
{
  "version": "2026.1",
  "effective_date": "2022-01-01",
  "source": "PMK No. 101/PMK.010/2016 (belum berubah per 2026)",
  "url": "https://jdih.kemenkeu.go.id/fulltext/2016/101~PMK.010~2016Per.pdf",
  "last_updated": "2026-09-29",
  "categories": {
    "TK0": {
      "value": 54000000,
      "description": "Tidak Kawin, 0 tanggungan"
    },
    "TK1": {
      "value": 58500000,
      "description": "Tidak Kawin, 1 tanggungan"
    },
    "K0": {
      "value": 58500000,
      "description": "Kawin, 0 tanggungan"
    },
    "K1": {
      "value": 63000000,
      "description": "Kawin, 1 tanggungan"
    },
    "K2": {
      "value": 67500000,
      "description": "Kawin, 2 tanggungan"
    },
    "K3": {
      "value": 72000000,
      "description": "Kawin, 3 tanggungan (maksimal)"
    }
  },
  "rules": {
    "max_dependents": 3,
    "dependent_value": 4500000,
    "notes": [
      "Tanggungan maksimal 3 orang",
      "Setiap tanggungan menambah PTKP Rp4,5 juta"
    ]
  }
}
```

---

### 2.4 TypeScript Type Safety (Auto-Generated)

**Generate types from JSON** (schema validation):
```bash
npm install -g quicktype

# Generate TypeScript types
quicktype data/regulations/pph21-rates.json -o lib/types/pph21-rates.ts
quicktype data/regulations/ptkp-values.json -o lib/types/ptkp-values.ts
```

**Or manual types**:
```typescript
// lib/types/regulations.ts
export interface TaxBracket {
  min: number;
  max: number | null;
  rate: number;
  description: string;
}

export interface PPh21Rates {
  version: string;
  effective_date: string;
  source: string;
  url: string;
  last_updated: string;
  brackets: TaxBracket[];
  notes: string[];
}

export interface PTKPCategory {
  value: number;
  description: string;
}

export interface PTKPValues {
  version: string;
  effective_date: string;
  source: string;
  url: string;
  last_updated: string;
  categories: Record<string, PTKPCategory>;
  rules: {
    max_dependents: number;
    dependent_value: number;
    notes: string[];
  };
}
```

---

### 2.5 Loader Function (Single Source of Truth)

**`lib/regulations/loader.ts`**:
```typescript
import pph21Data from '@/data/regulations/pph21-rates.json';
import ptkpData from '@/data/regulations/ptkp-values.json';
import type { PPh21Rates, PTKPValues } from '@/lib/types/regulations';

// Singleton pattern — load once, cache forever
let pph21Cache: PPh21Rates | null = null;
let ptkpCache: PTKPValues | null = null;

export function getPPh21Rates(): PPh21Rates {
  if (!pph21Cache) {
    pph21Cache = pph21Data as PPh21Rates;
  }
  return pph21Cache;
}

export function getPTKPValues(): PTKPValues {
  if (!ptkpCache) {
    ptkpCache = ptkpData as PTKPValues;
  }
  return ptkpCache;
}

// Helper: Get PTKP by status
export function getPTKP(maritalStatus: 'TK' | 'K', dependents: number): number {
  const data = getPTKPValues();
  const key = `${maritalStatus}${Math.min(dependents, data.rules.max_dependents)}`;
  return data.categories[key]?.value ?? data.categories['TK0'].value;
}

// Helper: Calculate tax by bracket
export function calculatePPh21(taxableIncome: number): number {
  const rates = getPPh21Rates();
  let tax = 0;
  
  for (const bracket of rates.brackets) {
    const bracketMin = bracket.min;
    const bracketMax = bracket.max ?? Infinity;
    
    if (taxableIncome <= bracketMin) break;
    
    const taxableInBracket = Math.min(taxableIncome, bracketMax) - bracketMin;
    tax += taxableInBracket * bracket.rate;
  }
  
  return tax;
}
```

---

### 2.6 Versioning & Migration Strategy

**Problem**: Regulation changes (e.g., PTKP 54jt → 58.5jt in 2027).

**Solution**: Version files + migration script.

**File Structure** (versioned):
```
/data/regulations/
├── pph21-rates.v2026.1.json       // Current version
├── pph21-rates.v2025.1.json       // Historical (for audit)
├── ptkp-values.v2026.1.json
└── metadata.json                  // Points to current versions
```

**`data/regulations/metadata.json`**:
```json
{
  "current_versions": {
    "pph21_rates": "2026.1",
    "ptkp_values": "2026.1",
    "pph23_rates": "2026.1"
  },
  "changelog": [
    {
      "date": "2026-01-01",
      "regulation": "pph21_rates",
      "version": "2026.1",
      "changes": "No changes from 2025 (UU HPP rates stable)"
    },
    {
      "date": "2027-01-01",
      "regulation": "ptkp_values",
      "version": "2027.1",
      "changes": "PTKP TK0 increased from Rp54jt to Rp58.5jt"
    }
  ]
}
```

**Migration Script** (when regulation changes):
```bash
# scripts/migrate-regulation.sh
#!/bin/bash

# Backup old version
cp data/regulations/ptkp-values.json data/regulations/ptkp-values.v2026.1.json

# Update new version
cat > data/regulations/ptkp-values.json <<EOF
{
  "version": "2027.1",
  "effective_date": "2027-01-01",
  ...
  "categories": {
    "TK0": { "value": 58500000, ... }  // Updated from 54000000
  }
}
EOF

# Update metadata
# (manual or scripted JSON update)

# Run test suite to verify calculations
npm run test:calculations
```

---

## 3. Business Rules & Calculations (Code as Documentation)

### 3.1 Calculation Functions (Unit Tested)

**`lib/calculations/pph21.ts`**:
```typescript
import { getPTKP, calculatePPh21 } from '@/lib/regulations/loader';

export interface PPh21Input {
  grossIncome: number;      // Penghasilan bruto
  maritalStatus: 'TK' | 'K';
  dependents: number;       // Jumlah tanggungan (0-3)
  employmentType: 'pegawai' | 'bukan_pegawai';
}

export interface PPh21Result {
  grossIncome: number;
  deductions: {
    biayaJabatan?: number;  // Only for pegawai (5%, max 6jt/year)
    pension?: number;       // Only for pegawai (5.7% of gross)
  };
  netIncome: number;        // Netto
  ptkp: number;
  taxableIncome: number;    // Penghasilan Kena Pajak (PKP)
  tax: number;              // PPh 21 terutang
  effectiveRate: number;    // %
}

export function calculatePPh21Pegawai(input: PPh21Input): PPh21Result {
  const { grossIncome, maritalStatus, dependents } = input;
  
  // 1. Biaya Jabatan (5%, max Rp6 juta/tahun)
  const biayaJabatan = Math.min(grossIncome * 0.05, 6_000_000);
  
  // 2. Iuran Pensiun (5.7% of gross)
  const pension = grossIncome * 0.057;
  
  // 3. Net Income
  const netIncome = grossIncome - biayaJabatan - pension;
  
  // 4. PTKP
  const ptkp = getPTKP(maritalStatus, dependents);
  
  // 5. Taxable Income (PKP)
  const taxableIncome = Math.max(0, netIncome - ptkp);
  
  // 6. Tax (progressive rates)
  const tax = calculatePPh21(taxableIncome);
  
  // 7. Effective rate
  const effectiveRate = grossIncome > 0 ? (tax / grossIncome) * 100 : 0;
  
  return {
    grossIncome,
    deductions: { biayaJabatan, pension },
    netIncome,
    ptkp,
    taxableIncome,
    tax,
    effectiveRate
  };
}

export function calculatePPh21BukanPegawai(input: PPh21Input): PPh21Result {
  const { grossIncome, maritalStatus, dependents } = input;
  
  // 1. Norma (50% of gross for bukan pegawai)
  const dpp = grossIncome * 0.5;
  
  // 2. No PTKP for bukan pegawai (tarif langsung)
  const ptkp = 0;
  
  // 3. Taxable Income = DPP
  const taxableIncome = dpp;
  
  // 4. Tax (progressive rates, no PTKP deduction)
  const tax = calculatePPh21(taxableIncome);
  
  const effectiveRate = grossIncome > 0 ? (tax / grossIncome) * 100 : 0;
  
  return {
    grossIncome,
    deductions: {},
    netIncome: dpp,
    ptkp,
    taxableIncome,
    tax,
    effectiveRate
  };
}
```

**Unit Tests** (`lib/calculations/pph21.test.ts`):
```typescript
import { describe, it, expect } from 'vitest';
import { calculatePPh21Pegawai, calculatePPh21BukanPegawai } from './pph21';

describe('PPh21 Calculations', () => {
  it('should calculate PPh21 pegawai correctly (TK0, 100jt income)', () => {
    const result = calculatePPh21Pegawai({
      grossIncome: 100_000_000,
      maritalStatus: 'TK',
      dependents: 0,
      employmentType: 'pegawai'
    });
    
    expect(result.netIncome).toBe(88_300_000); // 100jt - 5jt biaya jabatan - 5.7jt pensiun
    expect(result.ptkp).toBe(54_000_000);
    expect(result.taxableIncome).toBe(34_300_000); // 88.3jt - 54jt
    expect(result.tax).toBeCloseTo(1_715_000, 0); // (34.3jt * 5%)
    expect(result.effectiveRate).toBeCloseTo(1.715, 2); // 1.715%
  });
  
  it('should calculate PPh21 bukan pegawai correctly (50% norma)', () => {
    const result = calculatePPh21BukanPegawai({
      grossIncome: 100_000_000,
      maritalStatus: 'TK',
      dependents: 0,
      employmentType: 'bukan_pegawai'
    });
    
    expect(result.netIncome).toBe(50_000_000); // 50% norma
    expect(result.ptkp).toBe(0); // No PTKP for bukan pegawai
    expect(result.taxableIncome).toBe(50_000_000);
    expect(result.tax).toBeCloseTo(2_500_000, 0); // 50jt * 5%
    expect(result.effectiveRate).toBeCloseTo(2.5, 2); // 2.5%
  });
  
  it('should handle PTKP K2 correctly', () => {
    const result = calculatePPh21Pegawai({
      grossIncome: 150_000_000,
      maritalStatus: 'K',
      dependents: 2,
      employmentType: 'pegawai'
    });
    
    expect(result.ptkp).toBe(67_500_000); // K2 PTKP
  });
});
```

---

## 4. Reference Data (Static Lookups)

### 4.1 City/Province Data

**`data/reference/cities.json`**:
```json
{
  "version": "2026.1",
  "source": "Kemendagri RI",
  "last_updated": "2026-09-29",
  "provinces": [
    {
      "id": "11",
      "name": "Aceh",
      "cities": [
        { "id": "1101", "name": "Kabupaten Aceh Barat" },
        { "id": "1102", "name": "Kabupaten Aceh Besar" },
        { "id": "1171", "name": "Kota Banda Aceh" }
      ]
    },
    {
      "id": "35",
      "name": "Jawa Timur",
      "cities": [
        { "id": "3578", "name": "Kota Surabaya" },
        { "id": "3579", "name": "Kota Malang" }
      ]
    }
  ]
}
```

**Loader**:
```typescript
// lib/reference/cities.ts
import citiesData from '@/data/reference/cities.json';

export function getProvinces() {
  return citiesData.provinces;
}

export function getCitiesByProvince(provinceId: string) {
  const province = citiesData.provinces.find(p => p.id === provinceId);
  return province?.cities ?? [];
}
```

---

### 4.2 Bank List (For Payment)

**`data/reference/banks.json`**:
```json
{
  "version": "2026.1",
  "source": "Bank Indonesia",
  "last_updated": "2026-09-29",
  "banks": [
    {
      "code": "002",
      "name": "Bank BRI",
      "full_name": "Bank Rakyat Indonesia"
    },
    {
      "code": "008",
      "name": "Bank Mandiri",
      "full_name": "Bank Mandiri (Persero) Tbk"
    },
    {
      "code": "009",
      "name": "Bank BNI",
      "full_name": "Bank Negara Indonesia (Persero) Tbk"
    }
  ]
}
```

---

## 5. Seed Data (Dev/Staging Only)

### 5.1 Test Users & Sample Data

**`prisma/seed/users.json`**:
```json
{
  "users": [
    {
      "email": "freelancer@test.com",
      "name": "Test Freelancer",
      "role": "user",
      "profile": {
        "npwp": "12.345.678.9-012.000",
        "marital_status": "TK",
        "dependents": 0
      }
    },
    {
      "email": "admin@test.com",
      "name": "Test Admin",
      "role": "admin"
    }
  ]
}
```

**Seed Script** (`prisma/seed.ts`):
```typescript
import { PrismaClient } from '@prisma/client';
import usersData from './seed/users.json';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database...');
  
  // Clear existing data (dev/staging only!)
  if (process.env.NODE_ENV !== 'production') {
    await prisma.user.deleteMany();
  }
  
  // Seed users
  for (const userData of usersData.users) {
    await prisma.user.create({
      data: {
        email: userData.email,
        name: userData.name,
        role: userData.role,
        profile: {
          create: userData.profile
        }
      }
    });
  }
  
  console.log('Seed complete!');
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect());
```

**Run**:
```bash
npx prisma db seed
```

---

## 6. Content Data (Blog, Docs, FAQs)

### 6.1 MDX Blog Posts

**File Structure**:
```
/content/
├── blog/
│   ├── 2026-09-29-cara-hitung-pph21-freelancer.mdx
│   ├── 2026-09-28-ptkp-terbaru-2026.mdx
│   └── index.json  // Auto-generated index
└── docs/
    ├── getting-started.mdx
    ├── tax-schemes-explained.mdx
    └── faq.mdx
```

**Example Post** (`content/blog/2026-09-29-cara-hitung-pph21-freelancer.mdx`):
```mdx
---
title: "Cara Hitung PPh 21 Freelancer 2026 (Panduan Lengkap)"
description: "Panduan step-by-step menghitung PPh 21 untuk freelancer dengan 3 skema berbeda."
author: "Tim FreePajak"
date: "2026-09-29"
tags: ["tutorial", "pph21", "freelancer"]
featured_image: "/blog/pph21-freelancer-cover.jpg"
---

# Cara Hitung PPh 21 Freelancer 2026

Freelancer Indonesia wajib bayar PPh 21, tapi cara hitungnya beda dari karyawan tetap...

## 3 Skema Pajak Freelancer

### 1. PPh 21 Bukan Pegawai (Norma 50%)
...

### 2. PPh Final 0,5% (PP 23/2018)
...

### 3. PPh Pasal 17 (Pembukuan)
...

## Kalkulator Otomatis

<TaxCalculator defaultScheme="bukan_pegawai" />
```

**Loader** (Next.js):
```typescript
// lib/content/blog.ts
import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';

const blogDir = path.join(process.cwd(), 'content/blog');

export function getAllPosts() {
  const files = fs.readdirSync(blogDir);
  
  return files
    .filter(file => file.endsWith('.mdx'))
    .map(file => {
      const slug = file.replace('.mdx', '');
      const fullPath = path.join(blogDir, file);
      const fileContents = fs.readFileSync(fullPath, 'utf8');
      const { data, content } = matter(fileContents);
      
      return {
        slug,
        frontmatter: data,
        content
      };
    })
    .sort((a, b) => new Date(b.frontmatter.date) - new Date(a.frontmatter.date));
}
```

---

## 7. Data Validation & Schema

### 7.1 Zod Schema (Runtime Validation)

**`lib/schemas/regulations.ts`**:
```typescript
import { z } from 'zod';

export const TaxBracketSchema = z.object({
  min: z.number().min(0),
  max: z.number().nullable(),
  rate: z.number().min(0).max(1),
  description: z.string()
});

export const PPh21RatesSchema = z.object({
  version: z.string(),
  effective_date: z.string(),
  source: z.string(),
  url: z.string().url(),
  last_updated: z.string(),
  brackets: z.array(TaxBracketSchema),
  notes: z.array(z.string())
});

// Validate on load
import pph21Data from '@/data/regulations/pph21-rates.json';
PPh21RatesSchema.parse(pph21Data); // Throws if invalid
```

---

## 8. Documentation & Audit Trail

### 8.1 Data Source Documentation

**`data/regulations/README.md`**:
```markdown
# Regulation Data Sources

## PPh 21 Rates
- **Source**: UU No. 7 Tahun 2021 (UU HPP)
- **URL**: https://peraturan.bpk.go.id/Details/195158/uu-no-7-tahun-2021
- **Effective Date**: 2022-01-01
- **Last Verified**: 2026-09-29
- **Next Review**: 2027-01-01

## PTKP Values
- **Source**: PMK No. 101/PMK.010/2016
- **URL**: https://jdih.kemenkeu.go.id/fulltext/2016/101~PMK.010~2016Per.pdf
- **Effective Date**: 2016-01-01
- **Last Verified**: 2026-09-29
- **Next Review**: 2027-01-01

## Change Log
| Date | File | Change | Reason |
|------|------|--------|--------|
| 2026-09-29 | pph21-rates.json | No changes | Annual review |
| 2027-01-01 | ptkp-values.json | TK0: 54jt → 58.5jt | Government decree |
```

---

## 9. Checklist: Data Assets (FreePajak Example)

```markdown
### Regulations
- [ ] PPh 21 tax brackets (pph21-rates.json)
- [ ] PTKP values (ptkp-values.json)
- [ ] PPh 23 rates (pph23-rates.json)
- [ ] PPh Final 0.5% rules (pp23-2018.json)
- [ ] PP 20/2026 influencer rules (pp20-2026.json)
- [ ] Tax treaty rates (treaty-rates.json)

### Business Rules (Code)
- [ ] PPh 21 pegawai calculation (lib/calculations/pph21-pegawai.ts)
- [ ] PPh 21 bukan pegawai calculation
- [ ] PPh Final 0.5% calculation
- [ ] PPh Pasal 17 (pembukuan) calculation
- [ ] Tax comparison logic (3 schemes)
- [ ] Unit tests (100% coverage for calculations)

### Reference Data
- [ ] Indonesian cities (cities.json) — 514 kabupaten/kota
- [ ] Banks (banks.json) — Top 20 banks
- [ ] Industry codes (industries.json) — KBLI 2020

### Seed Data (Dev/Staging)
- [ ] Test users (5 personas: freelancer, admin, pro user, etc.)
- [ ] Sample calculations (20 scenarios covering edge cases)
- [ ] Sample documents (invoices, SPT mockups)

### Content Data
- [ ] 10 blog posts (tutorial, guide, update)
- [ ] 5 help docs (getting started, FAQ, troubleshooting)
- [ ] Legal pages (Privacy Policy, Terms, Disclaimer)

### Localization
- [ ] Indonesian strings (id.json) — 200+ keys
- [ ] English strings (en.json) — Optional for international users
```

---

**Tools**:
- **JSON Validation**: Zod, JSON Schema
- **Type Generation**: quicktype, json-schema-to-typescript
- **Testing**: Vitest (unit tests for calculations)
- **Documentation**: JSDoc, TSDoc
- **Versioning**: Git tags for regulation updates
