# UAT Workbook (Small Scale)

> **Target**: Solo MVP / Small projects  
> **Test Cases**: 10-15 critical paths only  
> **Duration**: 3-5 days  
> **Purpose**: Self-testing or lightweight client acceptance

---

## Test Environment

**URL**: https://staging.yourdomain.com  
**Test Credentials**:
- Admin: `admin@test.com` / `[provided separately]`
- User: `user@test.com` / `[provided separately]`

**Test Period**: [START DATE] to [END DATE]

---

## Critical User Flows (10-15 Test Cases)

### 1. User Registration

**Priority**: Critical  
**Pre-condition**: None

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Go to `/register` | Registration form appears | | ☐ Pass ☐ Fail |
| 2 | Enter: name, email, password | Fields accept input | | ☐ Pass ☐ Fail |
| 3 | Click "Register" | Success message + redirect to dashboard | | ☐ Pass ☐ Fail |
| 4 | Check email | Welcome email received | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 2. User Login

**Priority**: Critical  
**Pre-condition**: User registered

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Go to `/login` | Login form appears | | ☐ Pass ☐ Fail |
| 2 | Enter valid email/password | Fields accept input | | ☐ Pass ☐ Fail |
| 3 | Click "Login" | Redirect to `/dashboard` | | ☐ Pass ☐ Fail |
| 4 | Verify dashboard data | User name displayed correctly | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 3. Login with Wrong Password

**Priority**: High  
**Pre-condition**: User registered

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Go to `/login` | Login form appears | | ☐ Pass ☐ Fail |
| 2 | Enter valid email, WRONG password | Error message: "Invalid credentials" | | ☐ Pass ☐ Fail |
| 3 | User NOT logged in | Stay on login page | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 4. Create New Record (Main Feature)

**Priority**: Critical  
**Pre-condition**: User logged in

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Click "Add New" button | Form modal/page opens | | ☐ Pass ☐ Fail |
| 2 | Fill required fields | Fields accept input | | ☐ Pass ☐ Fail |
| 3 | Click "Save" | Success message + new record appears in list | | ☐ Pass ☐ Fail |
| 4 | Verify record | Data saved correctly in database | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 5. Edit Existing Record

**Priority**: High  
**Pre-condition**: At least 1 record exists

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Click "Edit" on a record | Form pre-filled with existing data | | ☐ Pass ☐ Fail |
| 2 | Change one field | Field updates | | ☐ Pass ☐ Fail |
| 3 | Click "Update" | Success message + changes reflected | | ☐ Pass ☐ Fail |
| 4 | Refresh page | Changes persist | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 6. Delete Record

**Priority**: High  
**Pre-condition**: At least 1 record exists

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Click "Delete" on a record | Confirmation prompt appears | | ☐ Pass ☐ Fail |
| 2 | Click "Confirm Delete" | Success message + record removed from list | | ☐ Pass ☐ Fail |
| 3 | Refresh page | Record still deleted | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 7. Search/Filter

**Priority**: Medium  
**Pre-condition**: Multiple records exist

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Enter search term | Search box accepts input | | ☐ Pass ☐ Fail |
| 2 | Press Enter or click "Search" | Only matching records displayed | | ☐ Pass ☐ Fail |
| 3 | Clear search | All records displayed again | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 8. Pagination (if applicable)

**Priority**: Medium  
**Pre-condition**: >10 records exist

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | View list page | Max 10 records per page | | ☐ Pass ☐ Fail |
| 2 | Click "Next Page" | Next 10 records displayed | | ☐ Pass ☐ Fail |
| 3 | Click "Previous Page" | Previous 10 records displayed | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 9. Export Data (if applicable)

**Priority**: Medium  
**Pre-condition**: Records exist

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Click "Export CSV/Excel" | File downloads | | ☐ Pass ☐ Fail |
| 2 | Open downloaded file | Data matches screen | | ☐ Pass ☐ Fail |
| 3 | Check column headers | Correct headers present | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 10. Admin Panel Access Control

**Priority**: High  
**Pre-condition**: Regular user logged in

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Try to access `/admin` | Access denied / redirect to dashboard | | ☐ Pass ☐ Fail |
| 2 | Logout, login as admin | Admin can access `/admin` | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 11. Mobile Responsive (if in scope)

**Priority**: Medium  
**Pre-condition**: Open on mobile device or browser DevTools mobile view

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Open homepage on mobile | Layout adapts to mobile screen | | ☐ Pass ☐ Fail |
| 2 | Test login on mobile | Form usable, buttons tap-able | | ☐ Pass ☐ Fail |
| 3 | Test main features | All critical features work | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 12. Password Reset (if in scope)

**Priority**: Medium  
**Pre-condition**: User registered

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Click "Forgot Password" | Form asks for email | | ☐ Pass ☐ Fail |
| 2 | Enter registered email | "Reset link sent" message | | ☐ Pass ☐ Fail |
| 3 | Check email | Reset link received | | ☐ Pass ☐ Fail |
| 4 | Click link, enter new password | Password updated | | ☐ Pass ☐ Fail |
| 5 | Login with new password | Login successful | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 13. Form Validation

**Priority**: High  
**Pre-condition**: Any form in app

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Leave required field empty | Error message: "Field required" | | ☐ Pass ☐ Fail |
| 2 | Enter invalid email format | Error message: "Invalid email" | | ☐ Pass ☐ Fail |
| 3 | Enter invalid phone format | Error message appears | | ☐ Pass ☐ Fail |
| 4 | Submit form with errors | Form NOT submitted | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 14. Logout

**Priority**: Critical  
**Pre-condition**: User logged in

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Click "Logout" | Redirect to homepage or login | | ☐ Pass ☐ Fail |
| 2 | Try to access `/dashboard` | Redirect to login (not accessible) | | ☐ Pass ☐ Fail |
| 3 | Click browser back button | Still logged out | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

### 15. Performance Check

**Priority**: Low  
**Pre-condition**: None

| Step | Action | Expected Result | Actual Result | Status |
|:-----|:-------|:----------------|:--------------|:-------|
| 1 | Load homepage | Loads in <3 seconds | | ☐ Pass ☐ Fail |
| 2 | Load dashboard | Loads in <3 seconds | | ☐ Pass ☐ Fail |
| 3 | Submit form | Response in <2 seconds | | ☐ Pass ☐ Fail |

**Notes**: _________________________________

---

## Bug Summary

| Bug ID | Severity | Test Case | Description | Status |
|:-------|:---------|:----------|:------------|:-------|
| 1 | S1 Critical | TC-2 | Login returns 500 error | ☐ Fixed ☐ Open |
| 2 | S2 High | TC-4 | Form submit doesn't save | ☐ Fixed ☐ Open |
| 3 | S3 Medium | TC-13 | Email validation too strict | ☐ Fixed ☐ Open |

**Severity Levels**:
- **S1 Critical**: Blocks major functionality, no workaround
- **S2 High**: Major feature broken, workaround exists
- **S3 Medium**: Minor bug, doesn't block usage
- **S4 Low**: Cosmetic issue

---

## UAT Sign-Off

**Test Summary**:
- Total test cases: 15
- Passed: _____ / 15
- Failed: _____ / 15
- Blocked: _____ / 15

**Critical bugs** (S1/S2): _____  
**Must be fixed before launch**: ☐ Yes ☐ No

**UAT Approved**: ☐ Yes ☐ No (re-test after fixes)

**Client PIC**: ___________________________  
**Signature**: ___________________________  
**Date**: ___________________________

**Developer**: ___________________________  
**Signature**: ___________________________  
**Date**: ___________________________

---

## Notes for Self-Testing (Solo MVP)

If you're testing your own app:
1. Test on different browsers (Chrome, Firefox, Safari)
2. Test on mobile (or browser DevTools mobile view)
3. Test with real data (not just "test test test")
4. Get 1-2 people to test (friend, co-founder)
5. Fix S1/S2 bugs before launch, defer S3/S4 to post-launch

**Don't skip testing!** Most bugs are found in these 15 test cases.
