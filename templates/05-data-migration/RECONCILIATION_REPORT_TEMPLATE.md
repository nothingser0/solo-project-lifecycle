# Data Migration Reconciliation Report

> Official document verifying legacy data transfer results, row count reconciliation, rejected rows list, and client data validity sign-off.

---

## 1. Migration Execution Metadata
- **System Name**: [Application Name]
- **Target Database**: PostgreSQL Staging (`staging.domainklien.com`)
- **Migration Executor**: [Your Name]
- **Execution Completion Date**: [YYYY-MM-DD]
- **Processed Source Files**: `[Source_File_Name_1.xlsx]`, `[Source_File_Name_2.csv]`

---

## 2. Quantitative Data Reconciliation Table

| Data Entity / Table | Total Source Rows (N_{src}) | Successfully Imported (N_{imp}) | Failed / Rejected (N_{rej}) | Duplicates Ignored | Success Rate |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Users (`users`)** | 450 | 442 | 8 | 0 | **98.2%** |
| **Documents (`documents`)**| 1,200 | 1,185 | 15 | 0 | **98.8%** |
| **Region Master** | 100 | 100 | 0 | 0 | **100.0%** |
| **TOTAL** | **1,750** | **1,727** | **23** | **0** | **98.7%** |

---

## 3. Rejected Rows Breakdown & Remediation

All rows that failed to import have been automatically separated into the attachment file **`rejected-rows.csv`**.

### Failure Reason Categories:
1. **Malformed Email Format (8 Rows)**: Email address missing the `@` symbol or having an invalid domain (e.g., `"budi.santoso.gmail"`).
2. **Missing Foreign Key Dependency (15 Rows)**: Legacy document references an owner name not registered in any user list.

> **Follow-up Action**: The `rejected-rows.csv` file has been handed over to the Client operational team. Corrected data can be manually inputted via application forms after system go-live.

---

## 4. Data Integrity Spot-Check

The Developer and Client PIC conducted random spot-checks on 10 data entries in the Staging interface:
- [x] Full name, identification number, and document status match original data.
- [x] Transaction dates and nominal values converted precisely without numeric distortion.
- [x] Sample account login permissions function according to roles defined in the PRD.

---

## 5. Data Validity Sign-Off Sheet

By signing this document, the Client states that they have reviewed the data reconciliation results above and agree that:
1. Successfully imported data is accurate and valid for use in **User Acceptance Testing (UAT)** sessions.
2. Rejected rows remain the Client's responsibility to correct or complete independently.

| Authorized by Client Single PIC | Reported by Solo Developer |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title / Role**: _________________ | **Title / Role**: Independent Lead Engineer |
| **Date**: _________________________ | **Date**: _________________________ |
| **Signature**: | **Signature**: |

---

## 6. Recurring Controls (only if the pipeline keeps running)

This report reconciles **once**. A live billing, stock, or reporting pipeline needs the numbers to keep matching after the sign-off — and that is where the failures happen, because nobody is watching.

| Field | Value |
| :--- | :--- |
| **Control objective** | <the one measure that must stay true, e.g. "daily invoice total = payment gateway settlement total"> |
| **Acceptable variance** | <absolute or % — stated **before** the first run> |
| **Exception owner** | <named person, and where an exception is routed> |
| **Cadence** | <daily / weekly / monthly, and at what time> |
| **Evidence per period** | <the query or report that reproduces the check, and where it is stored> |

**The variance must be chosen before the first run.** A threshold set after a miss is not a control — it is a rationalisation with a number attached.

**Three shortcuts to reject**, quoted as they are usually said:

| Rationalisation | Why it fails |
| :--- | :--- |
| *"The logic is simple enough to trust"* | Simple logic with one wrong join silently doubles a total; simplicity is not evidence |
| *"A small variance is probably fine"* | "Small" was not defined before the run, so it cannot be distinguished from a real drift |
| *"The total matched once, so we're done"* | One match proves the pipeline worked once; it says nothing about tomorrow's data |

**Per-period evidence must be reproducible.** A screenshot proves a number was seen; a saved query with a run date proves the number can be re-checked. Store the query, not the picture.
