# Legal Review TODO

**Status**: Pending external lawyer review  
**Priority**: High (6 findings)  
**Owner**: Indonesian legal counsel (UU PDP, KUHPerdata expertise)

---

## F033: UU PDP Citations (High Priority)

**Issue**: 109 mentions of "UU PDP" across 46 files, rarely cite specific Pasal.

**Action Required**:
- Review all UU PDP No. 27/2022 references
- Add specific Pasal citations where compliance rules mentioned:
  - Data collection consent: Pasal 20
  - Data encryption: Pasal 40
  - Data breach notification: Pasal 67
  - Penalty provisions: Pasal 57-59

**Files to review**:
```bash
grep -l "UU PDP" modules/*.md templates/*/*.md references/*/*.md
```

**Example fix**:
- Before: "Sesuai UU PDP, data harus dienkripsi"
- After: "Sesuai UU PDP No. 27/2022 Pasal 40, data pribadi harus dienkripsi"

---

## F034: IP Ownership Citations (High Priority)

**Issue**: IP ownership default to developer without KUHPerdata citation.

**Locations**:
- `modules/03-legal-sow-charter.md:86`
- `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md:128`

**Action Required**:
- Verify commissioned work IP ownership rules under Indonesian law
- Add proper KUHPerdata citation (possibly Pasal 1601-1617 on perjanjian melakukan pekerjaan)
- Clarify default vs contracted IP ownership

**Note**: Complex area, requires IP lawyer review. May need separate IP assignment clause.

---

## F035: UU PDP Penalty Provisions (Medium Priority)

**Issue**: UU PDP compliance mentioned but no sanctions stated.

**Location**: `templates/01-discovery-commercial/SOW_CONTRACT_CONSOLIDATED_TEMPLATE.md:145`

**Action Required**:
- Add penalty reference: "Sanksi pelanggaran data pribadi: denda administratif max Rp 6 miliar (UU PDP Pasal 57-59)"
- Verify maximum penalty amounts current as of 2026

---

## F036: KUHPerdata Generic Citations (Medium Priority)

**Issue**: 3 mentions of "KUHPerdata" without Pasal numbers.

**Action Required**:
- Find all generic KUHPerdata references
- Add specific Pasal citations:
  - Contract formation: Pasal 1320 (syarat sah perjanjian)
  - Default/breach: Pasal 1243 (ganti rugi)
  - Force majeure: Pasal 1244-1245

**Files to review**:
```bash
grep -n "KUHPerdata" modules/*.md templates/*/*.md references/*/*.md | grep -v "Pasal"
```

---

## F032: Meterai Citation ✅ FIXED

**Status**: Fixed in commit `a61a269`
- Added: "per UU No. 10/2020 Pasal 3 ayat 1"

---

## F037: E-Signature Law Update ✅ FIXED

**Status**: Fixed in commit `a61a269`
- Updated from KUHPerdata 1865/1866 to UU ITE No. 19/2016 Pasal 5 jo. PP 71/2019

---

## Lawyer Engagement Checklist

- [ ] Hire Indonesian legal counsel with expertise in:
  - UU PDP No. 27/2022 (data protection)
  - KUHPerdata (civil code)
  - UU ITE No. 19/2016 (electronic transactions)
  - Intellectual property law
- [ ] Provide lawyer with:
  - This TODO document
  - All template files (templates/01-discovery-commercial/)
  - Module 03 (legal-sow-charter.md)
  - audit/findings.md (F032-F037 section)
- [ ] Review session: 2-3 hours
- [ ] Budget estimate: Rp 5-10 juta (legal consultation fee)
- [ ] Expected deliverable: Annotated corrections + legal opinion letter

---

## Post-Review Actions

After lawyer review:
1. Update all citations per lawyer recommendations
2. Add legal disclaimer to templates if required
3. Update CHANGELOG.md with legal compliance improvements
4. Tag release as v1.1.0 (legal citations complete)

---

**Created**: 2026-10-02  
**Last Updated**: 2026-10-02
