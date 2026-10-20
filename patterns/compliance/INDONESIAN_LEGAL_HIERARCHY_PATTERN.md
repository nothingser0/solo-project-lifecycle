# Indonesian Legal Hierarchy & Grounded AI Citation Pattern

> **Module**: M03 (Legal & Commercial Charter) & M05 (Architecture & Technical Specs)  
> **Source**: Adapted from official Indonesian legislative standards (UU No. 12/2011 jo UU No. 13/2022) and open legal data architectures (published Indonesian statute datasets).  
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

### 2.1 Where the text must come from

The four parts above describe *how* to cite. This section is about *what you are allowed to cite from* — the part that is skipped, and the reason wrong article numbers ship.

| Source | Status | Use it for |
| :--- | :--- | :--- |
| **JDIH of the issuing body** (Setneg, Kemenkeu, Komdigi, …) — the gazette PDF | ✅ **Authoritative** | Anything that reaches a contract, policy, or client deliverable |
| `peraturan.go.id` national register | ✅ Authoritative pointer, PDF-only | Finding the right JDIH document |
| Converted text archives (published statute text-conversion datasets) | ⚠️ **Convenience copy** | Reading, searching, drafting — never the citation of record |
| An LLM's recollection of an article | ❌ **Never** | Nothing |

**The conversion rule**: a markdown conversion can lose an `Ayat`, merge two `Pasal`, or drop an amendment. It is useful precisely because it is searchable — and dangerous precisely because it looks like the law. Cite the JDIH document; use the conversion to find your way there.

**Rule for deliverables**: every statutory citation carries `source URL + date accessed`. A citation you cannot retrieve is a claim, not a finding. This applies to a privacy policy just as much as to a legal memo.

---

### The 4-Part Grounding Requirement:
1. **Exact Statutory Instrument**: Name + Number + Year (e.g., `UU No. 27 Tahun 2022`).
2. **Structural Coordinates**: Exact `Bab` (Chapter), `Pasal` (Article), and `Ayat` (Clause).
3. **Enactment Status**: Verified against the latest amendment chain (`In Force` vs. `Revoked`).
4. **Primary Text Quotation**: Verbatim excerpt from official state gazette (Lembaran Negara RI), never ungrounded generative paraphrase.
