# SVG Technical & Architecture Diagram Standard Pattern

> **Module**: M04 (UI/UX Prototyping) & M05 (Architecture & Specs)  
> **Source**: Adapted from `bybit-exchange/svg-diagram` house style standards.  
> **Scope**: Authoritative engineering rules for rendering crisp, geometrically precise, zero-dependency SVG technical diagrams (architecture, sequence, flowcharts) that render reliably across GitHub dark theme, technical docs, and browser engines.

---

## 1. Core Principles & Visual Rules

1. **Lightweight & Dependency-Free**: Generate pure, semantic SVG XML. No external graphing runtimes, viewers, or JavaScript required.
2. **GitHub Dark-Theme Shield**: The very first element inside `<svg>` MUST be a solid white canvas rectangle (`<rect width="100%" height="100%" fill="#ffffff" rx="8"/>`). This guarantees that dark text and pastel boxes stay perfectly legible when viewed on GitHub dark mode.
3. **Never Overlap Elements**:
   - Maintain $\ge 25\text{–}30\text{px}$ clearance between adjacent sibling boxes.
   - Maintain $\ge 10\text{–}20\text{px}$ clearance between text and connector lines.
   - Connector lines MUST NOT cut through boxes (except terminating arrows).

---

## 2. Geometric Layout & Typography Arithmetic

SVG element coordinates do not auto-flow; they require exact mathematical placement:

### Box Dimensions & Font-Relative Height
Derive box heights directly from font size to ensure balanced internal padding:
$$\text{Box Height (1 Line)} = \text{font\_size} \times 3 \quad (\text{e.g. } 12\text{px} \times 3 = 36\text{px})$$
$$\text{Box Height (2 Lines)} = \text{font\_size} \times 3 + 1.5 \times \text{font\_size} \quad (\text{e.g. } 36\text{px} + 18\text{px} = 54\text{px})$$
* Extra lines: add $+18\text{px}$ per line for a 12px font (line-height = $1.5 \times \text{font\_size}$).

### The Optical Baseline Centering Formula
In SVG, the `y` attribute on a `<text>` element sets the **baseline of the glyph**, not its top or center. To center text vertically inside a box:
$$\text{text\_y} = \text{box\_y} + \frac{\text{box\_height}}{2} + (\text{font\_size} \times 0.35)$$
* *Top-positioned text (e.g. Titles)*: $\text{title\_y} = \text{top\_margin} + (\text{font\_size} \times 0.75)$.
* *Universal Font Stack*:
  ```css
  font-family: 'PingFang SC', 'Microsoft YaHei', 'Noto Sans CJK SC', system-ui, -apple-system, sans-serif;
  ```

---

## 3. Connector Paths & Arrowhead Standards

* **Co-Axial Straight Lines**: Use `<path d="M x1 y1 L x2 y2" .../>` only when the source and target share the exact same axis.
* **Smooth Curved Turns**: For paths that turn, use cubic Bézier (`C`) or quadratic (`Q`) curves. **Right-angle $90^\circ$ elbow joints are prohibited** because they clash with modern technical aesthetics.
* **Arrowhead Clearance**:
  - Start lines $5\text{px}$ clear of the source box.
  - Terminate lines $11\text{px}$ short of the target box edge so the arrowhead marker (`userSpaceOnUse`) docks flush without overlapping the border.
  - For horizontal arrowheads, align the curve's second control point level with the end point ($y_{c2} = y_{end}$) so the marker enters perfectly perpendicular.

---

## 3.1 Block Spacing, Text Width & Paint Order

Three rules that prevent the defects geometry alone does not catch.

**Block spacing — one standard: ≥25px, 25–30px recommended.** The breakdown is 5px start clearance + 11px end clearance and arrowhead + **≥6px of visible line** + safety margin. Under 6px the arrowhead degenerates into a dot. Do not exceed ~30px: wider spacing reads as loose and stretches every connector.

**Estimate text width before placing it.** Overflow is silent at 100% zoom and collides at print size:

| Font size | Latin char | CJK char |
| :--- | :--- | :--- |
| 8px | 4.5px | 8px |
| 9px | 5.0px | 9px |
| 10px | 5.5px | 10px |
| 11px | 6.0px | 11px |
| 12px | 7.0px | 12px |

- `text-anchor="start"`: right edge ≈ `x + chars × charWidth`
- `text-anchor="middle"`: edges ≈ `x ± (chars × charWidth) / 2`
- `text-anchor="end"`: left edge ≈ `x − chars × charWidth`

**Check before committing**: text right edge + 10px < left edge of the neighbour on its right.

**SVG has no z-index — paint order is the layer order.** Elements painted later sit on top. Author in this order, always:

1. Background boxes (grouping containers, swimlanes)
2. Connectors and arrows
3. Node boxes
4. Text labels
5. Legend

An arrow that disappears behind a box is a paint-order bug, not a routing bug.

**Why `markerUnits` matters** (referenced in §3): a marker defaults to `markerUnits="strokeWidth"`, so the arrowhead scales with the line — a 3px stroke gets an arrowhead three times the one you sized for 1px, and it looks like a lollipop. `userSpaceOnUse` pins the marker to user units so one definition works at every stroke width. If you want the arrowhead to grow, keep `strokeWidth` and define a second, larger marker for thick strokes.

**Escape special characters**: `&` → `&amp;`, `<` → `&lt;`, `>` → `&gt;`. A raw `<` in a label silently truncates the element and leaves a blank region you will hunt for later.

---

## 4. The 5 Semantic Color Triples

Use these consistent presentation attribute triples `(Fill / Stroke / Text)` to communicate architectural roles:

| Role / Domain | Fill | Stroke | Text Color | Usage |
| :--- | :---: | :---: | :---: | :--- |
| **Neutral / Structure** | `#f8fafc` | `#94a3b8` | `#1e293b` | Grouping containers, client devices, generic components |
| **Primary / Compute** | `#eff6ff` | `#3b82f6` | `#1e40af` | Application servers, API routes, controller logic |
| **Success / Database** | `#f0fdf4` | `#22c55e` | `#166534` | Primary databases, caches, persistent storage |
| **Warning / Workers** | `#fffbeb` | `#f59e0b` | `#92400e` | Message queues, background workers, scheduled crons |
| **Danger / External** | `#fef2f2` | `#ef4444` | `#991b1b` | 3rd-party APIs, untrusted public network ingress |

---

## 5. Complete Lint-Clean SVG Architecture Template

Embed this ready-to-use SVG snippet directly into `docs/specs/FSD.md` or markdown documents (`docs/assets/arch.svg`):

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 760 380" width="100%" height="100%">
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="6" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
      <path d="M 0 1.5 L 8 5 L 0 8.5 z" fill="#64748b"/>
    </marker>
  </defs>
  <style>
    text { font-family: 'PingFang SC', 'Microsoft YaHei', 'Noto Sans CJK SC', system-ui, -apple-system, sans-serif; }
    .title { font-size: 16px; font-weight: 600; fill: #0f172a; }
    .group-label { font-size: 11px; font-weight: 600; fill: #64748b; }
    .box-title { font-size: 13px; font-weight: 600; }
    .box-sub { font-size: 11px; }
    .conn-label { font-size: 10px; fill: #64748b; }
  </style>

  <!-- 1. Canvas Background Shield (Dark-Theme Safe) -->
  <rect width="100%" height="100%" fill="#ffffff" rx="8"/>

  <!-- Diagram Title -->
  <text x="380" y="32" text-anchor="middle" class="title">System Architecture Topology (4-Boundary Standard)</text>

  <!-- Group 1: Client & Ingress -->
  <rect x="25" y="60" width="200" height="280" rx="10" fill="#f8fafc" stroke="#cbd5e1" stroke-dasharray="6,4"/>
  <text x="40" y="82" class="group-label">1. INGRESS &amp; CLIENT</text>
  
  <rect x="45" y="105" width="160" height="54" rx="6" fill="#eff6ff" stroke="#3b82f6" stroke-width="1.5"/>
  <text x="125" y="126" text-anchor="middle" class="box-title" fill="#1e40af">Web / Mobile Client</text>
  <text x="125" y="144" text-anchor="middle" class="box-sub" fill="#3b82f6">Next.js / React Native</text>

  <rect x="45" y="200" width="160" height="54" rx="6" fill="#eff6ff" stroke="#3b82f6" stroke-width="1.5"/>
  <text x="125" y="221" text-anchor="middle" class="box-title" fill="#1e40af">Edge Reverse Proxy</text>
  <text x="125" y="239" text-anchor="middle" class="box-sub" fill="#3b82f6">Cloudflare WAF / SSL</text>

  <!-- Group 2: Application Runtime -->
  <rect x="270" y="60" width="220" height="280" rx="10" fill="#f8fafc" stroke="#cbd5e1" stroke-dasharray="6,4"/>
  <text x="285" y="82" class="group-label">2. APPLICATION RUNTIME</text>

  <rect x="295" y="105" width="170" height="54" rx="6" fill="#eff6ff" stroke="#3b82f6" stroke-width="1.5"/>
  <text x="380" y="126" text-anchor="middle" class="box-title" fill="#1e40af">App API Gateway</text>
  <text x="380" y="144" text-anchor="middle" class="box-sub" fill="#3b82f6">Auth + Zod Validation</text>

  <rect x="295" y="200" width="170" height="54" rx="6" fill="#fffbeb" stroke="#f59e0b" stroke-width="1.5"/>
  <text x="380" y="221" text-anchor="middle" class="box-title" fill="#92400e">Background Worker</text>
  <text x="380" y="239" text-anchor="middle" class="box-sub" fill="#b45309">Postgres Queue (SKIP LOCKED)</text>

  <!-- Group 3: Persistence & External -->
  <rect x="535" y="60" width="200" height="280" rx="10" fill="#f8fafc" stroke="#cbd5e1" stroke-dasharray="6,4"/>
  <text x="550" y="82" class="group-label">3. PERSISTENCE &amp; 3RD-PARTY</text>

  <rect x="555" y="105" width="160" height="54" rx="6" fill="#f0fdf4" stroke="#22c55e" stroke-width="1.5"/>
  <text x="635" y="126" text-anchor="middle" class="box-title" fill="#166534">PostgreSQL DB</text>
  <text x="635" y="144" text-anchor="middle" class="box-sub" fill="#15803d">Supavisor / PgBouncer</text>

  <rect x="555" y="200" width="160" height="54" rx="6" fill="#fef2f2" stroke="#ef4444" stroke-width="1.5"/>
  <text x="635" y="221" text-anchor="middle" class="box-title" fill="#991b1b">External Services</text>
  <text x="635" y="239" text-anchor="middle" class="box-sub" fill="#b91c1c">Midtrans / Resend / AI</text>

  <!-- Connectors with Curves & Labels -->
  <!-- Client to Proxy -->
  <path d="M 125 159 L 125 189" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)"/>
  
  <!-- Proxy to API Gateway -->
  <path d="M 205 227 Q 250 227 250 160 T 284 132" fill="none" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)"/>
  <text x="245" y="180" class="conn-label">HTTPS (443)</text>

  <!-- Gateway to Database -->
  <path d="M 465 132 L 544 132" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)"/>
  <text x="505" y="124" text-anchor="middle" class="conn-label">Port 6543</text>

  <!-- Gateway to Worker -->
  <path d="M 380 159 L 380 189" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)"/>

  <!-- Worker to External -->
  <path d="M 465 227 L 544 227" stroke="#64748b" stroke-width="1.5" marker-end="url(#arrow)"/>
  <text x="505" y="219" text-anchor="middle" class="conn-label">REST API</text>
</svg>
```
