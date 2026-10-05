# Data Migration Plan (Lite - Small Scale)

> **Target**: Solo MVP / Small projects with existing data  
> **When**: Discovered in M02 (if client has existing data)  
> **Duration**: 2-3 days  
> **Purpose**: Move client data from old system/Excel to new app

---

## 1. Migration Scope

### Source System
- [ ] **Format**: Excel / CSV / Old database / Manual entry
- [ ] **Location**: Client provides file or database access
- [ ] **Volume**: Estimated row count: ___________

### Data Types to Migrate
- [ ] Users/accounts
- [ ] Products/inventory
- [ ] Orders/transactions
- [ ] Other: ___________

**Decision**: 
- If <100 rows → Manual entry acceptable
- If 100-1000 rows → Script migration
- If >1000 rows → Consider data migration tool

---

## 2. Column Mapping

Map old fields to new schema:

| Old Field Name | New Field Name | Transformation Needed | Notes |
|:---------------|:---------------|:----------------------|:------|
| `customer_name` | `full_name` | None | Direct copy |
| `phone` | `phone_number` | Format: +62xxx | Add country code |
| `created` | `created_at` | Parse date | Convert DD/MM/YYYY to ISO |
| | | | |

**Example transformation**:
```javascript
// Old: "081234567890" → New: "+6281234567890"
const newPhone = oldPhone.startsWith('0') 
  ? '+62' + oldPhone.slice(1) 
  : oldPhone;
```

---

## 3. Data Validation Rules

Before importing, validate:

- [ ] **Required fields**: All mandatory columns present
- [ ] **Email format**: Valid email addresses
- [ ] **Phone format**: Valid phone numbers
- [ ] **Date format**: Parseable dates
- [ ] **Duplicates**: Check for duplicate IDs/emails
- [ ] **Foreign keys**: Related records exist (e.g., user_id exists in users table)

**Validation script**:
```javascript
const errors = [];
data.forEach((row, index) => {
  if (!row.email || !row.email.includes('@')) {
    errors.push(`Row ${index}: Invalid email`);
  }
  if (!row.phone || row.phone.length < 10) {
    errors.push(`Row ${index}: Invalid phone`);
  }
});
if (errors.length > 0) {
  console.error('Validation failed:', errors);
  process.exit(1);
}
```

---

## 4. Responsibilities

### Client Responsibilities
- [ ] **Provide data**: Export from old system by [DATE]
- [ ] **Clean data**: Remove test/dummy records
- [ ] **Answer questions**: Clarify unclear fields within 24 hours
- [ ] **Verify sample**: Review 10-20 sample records after import

### Developer Responsibilities
- [ ] **Write migration script**: Convert old format → new format
- [ ] **Test on staging**: Import to staging environment first
- [ ] **Generate report**: List errors/warnings
- [ ] **Fix errors**: Correct mapping issues

---

## 5. Migration Steps

### Step 1: Export from Old System
**Client task** (by [DATE]):
- Export to CSV/Excel
- Send file via secure method (Google Drive link, not email attachment if >10MB)

### Step 2: Staging Test (Developer)
- [ ] Import to staging database
- [ ] Verify row count matches (old count = new count)
- [ ] Spot-check 10 random records
- [ ] Generate error report

### Step 3: Client Verification
**Client task**:
- [ ] Review sample of 10-20 records in staging
- [ ] Confirm data looks correct
- [ ] Sign off: "Data migration approved for production"

### Step 4: Production Import (Developer)
- [ ] Backup production database first
- [ ] Run migration script
- [ ] Verify row counts
- [ ] Notify client: "Migration complete"

---

## 6. Reconciliation

After migration, verify:

| Metric | Old System | New System | Match? |
|:-------|:-----------|:-----------|:-------|
| Total users | _________ | _________ | ☐ |
| Total products | _________ | _________ | ☐ |
| Total orders | _________ | _________ | ☐ |

**Spot-check**: Pick 5 random records, compare old vs new side-by-side.

---

## 7. Rollback Plan

If migration fails:
1. Restore production database from backup (taken in Step 4)
2. Analyze error report
3. Fix script
4. Re-test on staging
5. Re-run production import

**Backup command** (PostgreSQL):
```bash
pg_dump -h localhost -U postgres -d mydb > backup_$(date +%Y%m%d).sql
```

**Restore command**:
```bash
psql -h localhost -U postgres -d mydb < backup_20241004.sql
```

---

## 8. Timeline

| Phase | Duration | Owner | Status |
|:------|:---------|:------|:-------|
| Client exports data | 1 day | Client | ☐ |
| Dev writes script | 1 day | Dev | ☐ |
| Staging test | 0.5 day | Dev | ☐ |
| Client verifies | 0.5 day | Client | ☐ |
| Production import | 0.5 day | Dev | ☐ |

**Total**: 2-3 days

---

## 9. Sign-Off

**Data migration completed**:
- [ ] Staging test passed
- [ ] Client verified sample records
- [ ] Production import successful
- [ ] Reconciliation confirmed

**Signed by**:  
Client PIC: ___________________________ Date: ___________  
Developer: ___________________________ Date: ___________

---

## Notes

- **Keep old system running**: Don't delete old data for 30 days (in case need to reference)
- **Document transformations**: Save column mapping for future reference
- **Test queries**: After import, run common queries to verify relationships work

---

## When NOT to Use This Template

Escalate to full `DATA_MIGRATION_PLAN_TEMPLATE.md` if:
- >10,000 rows
- Complex transformations (business logic, calculations)
- Multiple related tables (>5 tables)
- Zero-downtime requirement
- Incremental sync needed
