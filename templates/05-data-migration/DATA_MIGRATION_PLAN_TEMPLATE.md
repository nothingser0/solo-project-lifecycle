# Data Migration Plan

> Technical specification document for column mapping, legacy data transformation rules, and data hygiene boundaries between Client and Developer.

---

## 1. Migration Plan Metadata
- **System Name**: [Application Name]
- **Client**: [Client Company / Organization]
- **Lead Data Engineer / Developer**: [Your Name]
- **Plan Date**: [YYYY-MM-DD]
- **Execution Target**: Staging & Production Environments

---

## 2. Data Hygiene Boundary

1. **Client Responsibilities**:
   - Provide source data files in structured digital formats (CSV, Excel `.xlsx`, or SQL Dump).
   - Assume full responsibility for data content cleanliness (*Data Hygiene*): removing invalid duplicates, correcting misspelled names/numbers, and populating mandatory empty fields.
2. **Developer Responsibilities**:
   - Write automated extraction, transformation, and loading scripts (*ETL Scripts*).
   - Ensure valid data is imported while maintaining table relational integrity.
   - Provide a rejected rows report (`rejected-rows.csv`) along with validation failure reasons.
3. **Manual Cleaning Service Clause**:
   - Requests for manual data cleaning or repairing corrupted data formatting by the developer beyond automated scripts will incur additional charges via the *Change Request (CR)* procedure.

---

## 3. Data Mapping Matrix

### Entity: Users / Employees (`users` Table)
- **Source File**: `Data_Karyawan_2026.xlsx` (Sheet 1)

| No | Source Column (Excel) | Source Data Type | Target Column (SQL Database) | Target SQL Type | Transformation Rule / Default |
| :-: | :--- | :--- | :--- | :--- | :--- |
| 1 | `No_Induk` | Text | `legacy_id` | `VARCHAR(50)` | Keep as audit reference |
| 2 | `Nama Lengkap` | Text | `full_name` | `VARCHAR(150)` | Trim leading/trailing whitespace, Title Case |
| 3 | `Alamat Email` | Text | `email` | `VARCHAR(255)` | Lowercase, RFC 5322 regex validation |
| 4 | `Jabatan / Peran` | Text | `role` | `VARCHAR(30)` | Map: "Staff" $\to$ `staff`, "Head" $\to$ `manager` |
| 5 | - | - | `id` | `UUID` | Auto-generate UUIDv7 |
| 6 | - | - | `password_hash` | `VARCHAR(255)` | Temporary default password hash (Argon2id) |

---

## 4. Sensitive Data Masking Protocol in Staging (UU PDP Compliance)

To preserve personal data confidentiality in accordance with UU PDP No. 27/2022 in non-production environments:

| Sensitive Column | Original Value (Production) | Masked Value on Staging Server |
| :--- | :--- | :--- |
| **National ID (NIK)** | `3578012304900001` | `357801********01` |
| **Phone Number** | `081234567890` | `0812****7890` |
| **Email Address** | `budi.santoso@perusahaan.com` | `user_001@staging.local` |
| **Bank Account Number** | `140001829104` | `******9104` |

---

## 5. Data Mapping Plan Approval Sheet

This document serves as the authoritative reference for writing automated data migration scripts.

| Approved by Client Single PIC | Validated by Solo Developer |
| :--- | :--- |
| **Name**: _________________________ | **Name**: _________________________ |
| **Title / Role**: _________________ | **Title / Role**: Independent Lead Engineer |
| **Date**: _________________________ | **Date**: _________________________ |
| **Signature**: | **Signature**: |
