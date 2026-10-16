# Richard Lawrence's 9 Patterns for Epic Breakdown

> **Standard**: Adapted from Richard Lawrence & Peter Green's Humanizing Work patterns for splitting user stories and epics.
> **Context**: Applied in **M02 (Scope Definition)** and **M06 (Development Execution)** to prevent bloated, unfinishable tasks in `TODO.md`.

---

## Why Epic Breakdown Matters for Solo Developers

Solo developers fail when tasks remain large and abstract. An epic like *"Implement Authentication"* or *"Add Midtrans Payment"* creates cognitive overload, stalls momentum, and breaks git atomicity.

Applying these 9 patterns splits any monolithic feature into discrete, testable slices that can be finished in **under 2 hours each**.

---

## The 9 Splitting Patterns

### 1. Workflow Steps
* **When to use**: The feature involves a multi-step user journey.
* **How to split**: Build the end-to-end happy path first with minimal validation, then flesh out intermediate steps.
* **Example**:
  * *Slice 1*: Checkout with single hardcoded address.
  * *Slice 2*: Add shipping address selection.
  * *Slice 3*: Add address autocomplete.

### 2. Business Rule Variations
* **When to use**: The feature contains multiple domain rules or boundary constraints.
* **How to split**: Build the default/common rule first, then layer specialized constraints as separate tasks.
* **Example**:
  * *Slice 1*: Standard domestic tax calculation (PPN 12%).
  * *Slice 2*: Exempt non-taxable income brackets (PTKP).
  * *Slice 3*: Foreign income tax treaty rules.

### 3. Major Effort vs. Minor Variation
* **When to use**: The core mechanism takes 80% of the effort, and additional cases take 20%.
* **How to split**: Complete the heavy lifting for one primary case; treat variations as simple follow-ups.
* **Example**:
  * *Slice 1*: PDF invoice generation with standard layout engine.
  * *Slice 2*: Export as CSV / Excel (reusing the already-aggregated dataset).

### 4. Simple / Complex
* **When to use**: The desired feature has rich UI states, filters, or edge-case handling.
* **How to split**: Build the simplest functional version first, then add progressive enhancements.
* **Example**:
  * *Slice 1*: Exact keyword search on text column (`ILIKE %query%`).
  * *Slice 2*: Multi-facet filter (date range, category, status).
  * *Slice 3*: Full-text search with fuzzy ranking (`pg_trgm`).

### 5. Operations / CRUD
* **When to use**: The feature manages an entity lifecycle.
* **How to split**: Never build full CRUD in a single task. Split into: Create $\to$ Read $\to$ Update $\to$ Delete.
* **Example**:
  * *Slice 1*: Create and view client profile.
  * *Slice 2*: Edit existing client profile.
  * *Slice 3*: Soft-delete client profile with dependent checks.

### 6. Data Variations
* **When to use**: The system accepts different payload structures or content types.
* **How to split**: Support the primary payload first, then add secondary formats.
* **Example**:
  * *Slice 1*: Upload avatar image via PNG/JPEG.
  * *Slice 2*: Support PDF documents.
  * *Slice 3*: Support multi-file bulk uploads.

### 7. Data Entry Methods
* **When to use**: Data can enter the system through multiple channels (manual, import, sync).
* **How to split**: Manual web form first, automated methods second.
* **Example**:
  * *Slice 1*: Manual expense record creation form.
  * *Slice 2*: CSV bulk transaction import.
  * *Slice 3*: Bank mutation API webhook sync.

### 8. Defer Performance Optimization
* **When to use**: An algorithmic task or heavy query might become slow at scale.
* **How to split**: Make it work correctly with small data first. Add caching, indexing, and workers later.
* **Example**:
  * *Slice 1*: Synchronous report generation directly in API route.
  * *Slice 2*: Move generation to background worker queue (e.g. pg-boss) + polling toast.

### 9. Break-out a Spike
* **When to use**: The technical implementation is unknown or documentation is ambiguous.
* **How to split**: Create a time-boxed technical spike (max 2 hours) in scratch directory before writing production code.
* **Example**:
  * *Slice 1 (Spike)*: Verify payment webhook signature verification in standalone script.
  * *Slice 2 (Prod)*: Integrate verified handler into production router.

---

## Solo Developer Checklist Before Adding to `TODO.md`

- [ ] Does this task take `< 2 hours` of active coding?
- [ ] Can this slice be verified independently with a test or manual check?
- [ ] Does this slice produce a working, runnable state without breaking the build?
- [ ] Is this free of premature optimizations or unrequested edge-cases?
