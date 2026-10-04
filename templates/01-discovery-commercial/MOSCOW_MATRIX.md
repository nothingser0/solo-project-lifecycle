# MoSCoW Prioritization Matrix

> **Purpose**: Prioritize features during discovery (M02)  
> **When**: After stakeholder interviews, before scope freeze  
> **Duration**: 30-60 minutes workshop  
> **Output**: Features categorized by priority

---

## What is MoSCoW?

**MoSCoW** is a prioritization framework:
- **M** - Must Have (non-negotiable, blocks launch)
- **S** - Should Have (important, but workaround exists)
- **C** - Could Have (nice to have, low priority)
- **W** - Won't Have (out of scope for this phase)

---

## MoSCoW Matrix Template

| Feature | Description | Category | Reason | Est. Effort |
|:--------|:------------|:---------|:-------|:------------|
| [Feature name] | [1-sentence description] | M/S/C/W | [Why this category?] | [hours/days] |

---

## How to Categorize

### Must Have (Launch Blockers)
**Question**: Can we launch without this?  
**Answer**: NO → Must Have

**Examples**:
- User login/registration
- Core CRUD operations
- Payment processing (if revenue-critical)
- Legal requirements (GDPR consent, terms)

**Rule**: If removing this makes the product useless → Must Have

---

### Should Have (Important, Not Critical)
**Question**: Can we launch with a workaround?  
**Answer**: YES → Should Have

**Examples**:
- Email notifications (can manually notify)
- Export to CSV (can copy-paste)
- Search filters (can scroll/paginate)
- Password reset (can manually reset)

**Rule**: Adds value but doesn't block launch → Should Have

---

### Could Have (Nice to Have)
**Question**: Would users miss this if absent?  
**Answer**: NO → Could Have

**Examples**:
- Dark mode
- Advanced reporting
- Bulk operations
- Keyboard shortcuts

**Rule**: Improves UX but not essential → Could Have

---

### Won't Have (Explicitly Out of Scope)
**Question**: Is this requested but out of scope?  
**Answer**: YES → Won't Have

**Examples**:
- Mobile app (when building web only)
- Multi-language (when English-only agreed)
- Integrations (when standalone agreed)
- Advanced analytics (Phase 2)

**Rule**: Document to prevent scope creep → Won't Have (This Phase)

---

## Example: E-Commerce MVP

```
MUST HAVE (Launch Blockers):
| Feature | Description | Category | Reason | Effort |
| User registration | Email + password signup | M | Can't buy without account | 2 days |
| Product catalog | List products with images | M | Core functionality | 3 days |
| Shopping cart | Add/remove items | M | Core functionality | 2 days |
| Checkout | Payment with Stripe | M | Revenue-critical | 4 days |
| Order confirmation | Email receipt | M | Legal requirement | 1 day |

SHOULD HAVE (Important):
| Feature | Description | Category | Reason | Effort |
| Product search | Keyword search | S | Can browse/filter | 2 days |
| Order history | View past orders | S | Can email invoice | 1 day |
| Password reset | Self-service reset | S | Can manually reset | 1 day |
| Product reviews | User ratings | S | Social proof nice, not critical | 3 days |

COULD HAVE (Nice to Have):
| Feature | Description | Category | Reason | Effort |
| Wishlist | Save for later | C | Not essential | 2 days |
| Promo codes | Discount coupons | C | Can manually adjust | 2 days |
| Live chat | Customer support | C | Email support OK | 3 days |
| Dark mode | UI theme toggle | C | Cosmetic | 1 day |

WON'T HAVE (Out of Scope):
| Feature | Description | Category | Reason | Effort |
| Mobile app | Native iOS/Android | W | Web-only scope | 6 weeks |
| Multi-currency | USD/EUR/GBP | W | USD-only for MVP | 1 week |
| Inventory sync | ERP integration | W | Manual inventory OK | 3 weeks |
| Subscription billing | Recurring payments | W | One-time only for MVP | 2 weeks |
```

**Total Effort**:
- Must Have: 12 days (launch-critical)
- Should Have: 7 days (defer if needed)
- Could Have: 8 days (Phase 2)
- Won't Have: 12+ weeks (future roadmap)

---

## MoSCoW Workshop (60 min)

**Attendees**: Client stakeholders, PM, Tech Lead

**Agenda**:

### Part 1: List Features (15 min)
- Brainstorm all requested features
- Write each on sticky note or spreadsheet row
- Don't filter yet, just list

### Part 2: Categorize (30 min)
- Go through each feature
- Ask: "Can we launch without this?"
- Place in M/S/C/W bucket
- Debate and reach consensus

### Part 3: Validate (15 min)
- Review Must Have list (should be <10 items)
- Confirm Should Have priority
- Acknowledge Won't Have (document for Phase 2)

---

## MoSCoW Rules

### Rule 1: Must Have < 60% of Total Effort
**Why**: If everything is Must Have, nothing is prioritized

**Fix**:
- Challenge each Must Have: "Really can't launch without this?"
- Move borderline items to Should Have
- Goal: Must Have ≤ 60% of total effort

---

### Rule 2: Won't Have ≠ Never
**Why**: Won't Have means "not this phase", not "never build"

**Communication**:
❌ "We won't build mobile app"  
✅ "Mobile app is Phase 2, after web MVP validated"

---

### Rule 3: Document the "Why"
**Why**: Prevents re-debate later

**Example**:
```
Feature: Multi-language support
Category: Won't Have (This Phase)
Reason: 95% users are English-speaking (validated in research)
Future: Add if international expansion needed (Phase 3)
```

---

## MoSCoW vs Budget

**If budget tight**:
1. Build only Must Have (bare MVP)
2. Should Have → Phase 2 (post-launch)
3. Could Have → Backlog (if budget allows)
4. Won't Have → Document (roadmap)

**If budget allows**:
1. Must Have + Should Have (polished MVP)
2. Could Have (if time permits)
3. Won't Have → Future phases

---

## Common Mistakes

### Mistake 1: Everything is Must Have
**Problem**: No prioritization  
**Fix**: Ask "What's the ONE feature users need to get value?"

### Mistake 2: Ignoring Effort
**Problem**: 20 Must Haves = 6 months of work  
**Fix**: Estimate effort, challenge high-effort Must Haves

### Mistake 3: No Won't Have
**Problem**: Scope creep (client keeps adding)  
**Fix**: Explicitly document Won't Have with reasoning

### Mistake 4: Client Overrules Logic
**Problem**: Client insists dark mode is Must Have  
**Fix**: Show data ("0.5% users prefer dark mode, defer to Phase 2")

---

## Integration with Workflow

**M02 Discovery**:
1. Stakeholder interviews → Feature list
2. MoSCoW workshop → Prioritization
3. Output: `docs/pm/MOSCOW_MATRIX.md`
4. Reference in `SCOPE_STATEMENT.md`

**M06 Development**:
- Sprint 1-N: Build Must Have features
- Sprint N+1: Build Should Have (if time/budget allows)
- Could Have: Backlog for future sprints

**Change Requests**:
- New feature request → Add to MoSCoW matrix
- Re-categorize: Must/Should/Could/Won't
- If Must Have → Requires budget/timeline adjustment

---

## MoSCoW Decision Tree

```
New Feature Request
│
├─ Can we launch without it?
│  ├─ NO → Must Have
│  └─ YES → Continue
│
├─ Does it add significant value?
│  ├─ YES → Should Have
│  └─ NO → Continue
│
├─ Would users notice if missing?
│  ├─ YES → Could Have
│  └─ NO → Continue
│
└─ Out of current scope?
   └─ YES → Won't Have
```

---

## Example: Filled MoSCoW Matrix

**Project**: Inventory Management System  
**Date**: October 4, 2024  
**Attendees**: John (Client), Sarah (PM), Mike (Tech Lead)

---

### MUST HAVE (7 features, 18 days)

| Feature | Description | Reason | Effort |
|:--------|:------------|:-------|:-------|
| User login | Email/password auth | Can't access system | 2 days |
| Product CRUD | Create/view/edit/delete products | Core functionality | 4 days |
| Stock tracking | Track quantity in/out | Primary use case | 3 days |
| Low stock alerts | Notify when qty < threshold | Prevents stockouts | 2 days |
| Stock report | View current inventory | Daily operations need | 2 days |
| Barcode scanning | Scan to add/remove stock | Manual entry too slow | 3 days |
| Multi-user access | 5-10 users concurrent | Team of 8 staff | 2 days |

**Total**: 18 days (60% of 30-day timeline)

---

### SHOULD HAVE (4 features, 8 days)

| Feature | Description | Reason | Effort |
|:--------|:------------|:-------|:-------|
| Stock history | View past transactions | Can manually audit | 2 days |
| CSV export | Export inventory report | Can copy-paste | 1 day |
| Category filters | Filter by product type | Can scroll/search | 2 days |
| Email notifications | Low stock emails | Can check dashboard | 3 days |

**Total**: 8 days (27% of 30-day timeline)

---

### COULD HAVE (3 features, 6 days)

| Feature | Description | Reason | Effort |
|:--------|:------------|:-------|:-------|
| Purchase orders | Create PO for suppliers | Can use Excel | 3 days |
| Stock forecasting | Predict future needs | Nice insight, not critical | 2 days |
| Mobile app | iOS/Android | Web works on mobile | 1 day |

**Total**: 6 days (deferred to Phase 2)

---

### WON'T HAVE (Out of Scope)

| Feature | Description | Reason | Future |
|:--------|:------------|:-------|:-------|
| Accounting integration | Sync with QuickBooks | Separate system, manual OK | Phase 3 |
| Multi-warehouse | Track multiple locations | Single warehouse for MVP | Phase 2 (if expand) |
| Supplier portal | Vendors view stock | Internal-only for MVP | Phase 3 (if needed) |
| AI stock prediction | ML forecasting | Overkill for 500 SKUs | Not planned |

---

## Summary

**Committed for MVP** (26 days):
- Must Have: 18 days ✓
- Should Have: 8 days ✓

**Deferred** (Phase 2):
- Could Have: 6 days

**Out of Scope**:
- Won't Have: Document for future consideration

**Budget Impact**: MVP = Rp 40M (Must + Should), Phase 2 = +Rp 10M (Could)

---

## Tools

**Workshop**:
- Miro/Mural (virtual whiteboard)
- Google Sheets (simple table)
- Trello (4 columns: M/S/C/W)
- Sticky notes (in-person workshop)

**Documentation**:
- Markdown table (this template)
- Notion database
- Airtable

---

## MoSCoW Checklist

Before workshop:
- [ ] Feature list prepared (from stakeholder interviews)
- [ ] Effort estimates rough (T-shirt sizes: S/M/L)
- [ ] Budget/timeline known

During workshop:
- [ ] Every feature categorized (M/S/C/W)
- [ ] Must Have < 60% of effort
- [ ] Won't Have documented with reasoning
- [ ] Client agrees on priorities

After workshop:
- [ ] Matrix documented in `docs/pm/MOSCOW_MATRIX.md`
- [ ] Referenced in `SCOPE_STATEMENT.md`
- [ ] Shared with team (dev knows what to build first)

---

## Notes

**MoSCoW is not permanent**: Re-prioritize after each sprint based on feedback

**Client wants to change priority**: Require written approval + timeline adjustment

**New Must Have mid-project**: Requires change request (budget/timeline impact)
