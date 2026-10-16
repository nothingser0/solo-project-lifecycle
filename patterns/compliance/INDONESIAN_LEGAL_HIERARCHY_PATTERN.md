# Indonesian Legal Hierarchy & Grounded AI Citation Pattern

> **Module**: M03 (Legal & Commercial Charter) & M05 (Architecture & Technical Specs)  
> **Source**: Adapted from official Indonesian legislative standards (UU No. 12/2011 jo UU No. 13/2022) and open legal data architectures (`mashanz/peraturan-perundang-undangan`, `ilhamfp/pasal`).  
> **Objective**: Prevent legal hallucinations in AI applications and ensure strict regulatory compliance across SaaS and FinTech systems operating in Indonesia.

---

## 1. The 8-Tier Statutory Hierarchy (UU No. 12 Tahun 2011)

In Indonesian jurisprudence, regulations operate under a rigid vertical hierarchy governed by the principle **"Lex Superior Derogat Legi Inferiori"** (higher-order laws automatically supersede lower-order regulations):

```text
[ 01-CONSTITUTIONAL: UUD 1945 & TAP MPR ]
                   │
                   ▼
[ 02-NATIONAL-LAWS: UU / PERPPU ]
                   │
                   ▼
[ 03-GOVERNMENT-REGULATIONS: PP & PERPRES ]
                   │
                   ▼
[ 04-MINISTERIAL: Permen (Finance / Kemenkeu, Kominfo, Kemnaker) ]
                   │
                   ▼
[ 05-REGIONAL: PERDA Provinsi & Kabupaten/Kota ]
                   │
                   ▼
[ 06-SPECIALIZED / REGULATORS: Peraturan BI, POJK, BPK, DJP ]
```

### Hierarchy Precedence Rules for Software Engineers:
1. **Never Cite a Permen Over a UU**: If an implementation rule in a Minister of Finance Regulation (PMK) appears to conflict with the primary tax law (UU HPP / UU KUP), the statutory law takes legal precedence.
2. **Track Amendment Chains**: Indonesian laws frequently undergo piecemeal amendments rather than full replacement (e.g., UU Cipta Kerja amending dozens of legacy sectoral laws). AI systems must resolve the latest amended node, never an obsolete historical clause.
3. **Status Verification**: A regulation exists in one of three definitive states:
   * `BERLAKU` (In force)
   * `DIUBAH` (Partially amended by a newer enactment)
   * `DICABUT` (Fully revoked and void)

---

## 2. Grounded AI Legal Citation Protocol

When AI agents generate compliance reports, contract clauses, or tax computations (e.g., PPh 21 / PPN / UU PDP), they must strictly adhere to the **Non-Hallucination Citation Rule**:

* ❌ **Prohibited Hallucinated Citation**:
  > *"According to Indonesian labor law, severance pay must be calculated at 2x monthly salary under Article 45."* (Vague, lacks specific enactment and year).
* ✅ **Disciplined Grounded Citation**:
  > *"Pursuant to **UU No. 6 Tahun 2023** (Penetapan Perpu Cipta Kerja) Pasal 156 Ayat (2) jo. **PP No. 35 Tahun 2021** Pasal 40, severance compensation for termination is calculated as follows: [Exact formula]. Status: IN FORCE."*

### The 4-Part Grounding Requirement:
1. **Exact Statutory Instrument**: Name + Number + Year (e.g., `UU No. 27 Tahun 2022`).
2. **Structural Coordinates**: Exact `Bab` (Chapter), `Pasal` (Article), and `Ayat` (Clause).
3. **Enactment Status**: Verified against the latest amendment chain (`In Force` vs. `Revoked`).
4. **Primary Text Quotation**: Verbatim excerpt from official state gazette (Lembaran Negara RI), never ungrounded generative paraphrase.
