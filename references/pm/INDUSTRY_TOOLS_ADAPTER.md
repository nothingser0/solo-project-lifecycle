# Industry Tools Adapter (Notion, Linear, Jira, & Figma)

> **Purpose**: Bridge repository-centric markdown specifications with enterprise collaboration platforms utilized by clients, design teams, and cross-functional product organizations.

---

## 1. Linear & Jira Issue Synchronization

Translate `SCOPE_STATEMENT.md` MoSCoW inventory and `TODO.md` sprints into project tracking tools.

### 1.1 Priority & State Mapping Matrix
| Lifecycle MoSCoW Priority | Linear Priority | Jira Priority | Linear Cycle / Sprint |
|:--------------------------|:----------------|:--------------|:----------------------|
| **P0 (Must-Have)** | Urgent (P1) / High (P2) | Blocker / Critical | Current Active Cycle (Phase 1.0 MVP) |
| **P1 (Should-Have)** | Medium (P3) | Major | Next Cycle (Phase 1.5 Fast-Follow) |
| **P2 (Could-Have)** | Low (P4) | Minor | Backlog (#later) |
| **P3 (Won't-Have)** | Canceled / Archive | Out of Scope | Deferred Archive |

### 1.2 CSV Import Format for Linear / Jira
Export your feature inventory table from `docs/pm/SCOPE_STATEMENT.md` to CSV for 1-click batch import:

```csv
Title,Description,Priority,Estimate,Labels
"F-01: User Authentication","As a user, I want to login with email so I can access records. Acceptance criteria: JWT HttpOnly, role checks.",High,3,auth;security;P0
"F-02: POS Barcode Checkout","Cashier scans barcode and decrements stock atomically. Acceptance criteria: IDR formatting, offline queue.",High,5,pos;inventory;P0
"F-06: Export Reports to Excel","Manager exports monthly transaction ledger. Acceptance criteria: CSV injection sanitized.",Medium,3,reporting;P1
```

### 1.3 Standar Penambahan Field Jira ke Kanban (Solo Developer Optimization)

Ketika mengintegrasikan atau memperbarui Kanban board dengan Jira untuk proyek Solo Developer:
1. **Otomatisasi Field (Eliminasi Redundansi Manual)**:
   - **Assignee**: Dikelola otomatis oleh Jira Automation ke *"Assign to me"* saat kartu ditarik ke `In Progress`. Tidak perlu ditulis manual di setiap kartu.
   - **Labels**: Hapus label `Solo` dari semua kartu (karena proyek dikerjakan mandiri). Label hanya disematkan untuk kondisi khusus seperti `blocked`.
   - **Due Date**: Gunakan aturan global (dikosongkan kecuali ada *hard deadline* eksternal); hapus baris tanggal dari kartu individual.
2. **Struktur Kartu Scannable (Punchy & Scannable)**:
   - Format kartu: `[ID] [Work Type] — Judul Singkat`.
   - Komponen wajib kartu:
     * **`Parent`**: ID parent Epic bila ada (misal `Parent: RK-001`).
     * **`Priority`**: `Highest` | `High` | `Medium` | `Low`.
     * **`Description`**: Maksimal 2 kalimat padat yang menjelaskan nilai/deliverable konkret.
     * **`Acceptance Criteria`**: Poin-poin checklist pendek (`- [ ] ...`) tanpa kalimat berbunga-bunga.
     * **`Estimate`**: Durasi jam (`X hours` / `X–Y hours`).
     * **`Dependencies`**: Prasyarat kartu lain atau `None`.
3. **Workflow & Batas WIP Solo**:
   - `Backlog` $\rightarrow$ `To Do (5)` $\rightarrow$ `In Progress (2)` $\rightarrow$ `In Review (1)` $\rightarrow$ `Done`.
   - Penjelasan transisi status maksimal 1 kalimat per status.
4. **Verifikasi Integritas**:
   - Periksa dan hitung jumlah kartu sebelum dan setelah penambahan/pembaruan.
   - Pastikan setiap kartu memiliki format scannable lengkap di atas tanpa penggandaan dokumen.

---

## 2. Notion Specification Database Adapter

When sharing PRD and Scope documents with corporate sponsors who prefer Notion:

### 2.1 Database Schema Properties in Notion
- **Title**: Feature Name (e.g., `F-01: Authentication Engine`)
- **Status**: `[Not Started | In Progress | Ready for QA | Done]`
- **Priority**: Select `[P0 - Must | P1 - Should | P2 - Could]`
- **Module**: Select `[M01 Feasibility | M02 Scope | M04 Design | M06 Dev]`
- **Root Cause Addressed**: Text
- **Assigned Role**: Multi-select `[Admin | Manager | Operator]`
- **Verification Status**: Select `[Pending Research | Verified]`

### 2.2 Markdown-to-Notion Ingestion
Copy sections from `docs/specs/PRD.md` or `docs/pm/SCOPE_STATEMENT.md` directly into Notion pages. Notion natively parses markdown headings, tables, callout blocks, and task lists without formatting loss.

---

## 3. Figma Design System & Token Synchronization

Bridge `docs/harness-root/DESIGN.md` tokens into Figma Variables and Dev Mode.

### 3.1 Figma Variable Collection Setup
1. **Primitives Collection**:
   - `colors/zinc/50` through `colors/zinc/950`
   - `colors/brand/primary` (`#0891B2`)
2. **Semantic Tokens Collection**:
   - `background/default` → binds to `colors/zinc/50` (Light) / `colors/zinc/950` (Dark)
   - `foreground/default` → binds to `colors/zinc/900` (Light) / `colors/zinc/50` (Dark)
   - `border/input` → binds to `colors/zinc/200`
   - `interactive/primary` → binds to `colors/brand/primary`

### 3.2 Figma MCP Remote Integration (2026 Standard)
In Claude Desktop / Cursor / Windsurf, configure the official remote Figma MCP:
```json
{
  "mcpServers": {
    "figma": {
      "url": "https://mcp.figma.com/mcp"
    }
  }
}
```
*Authenticate via browser OAuth; enables autonomous agents to query Figma frame node IDs, inspect layout tokens, and verify CSS class parity.*
