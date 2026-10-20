# Responsive Design Priority Pattern: Mobile-First vs. Desktop-First

> **Module**: M04 (UI/UX Prototyping) & M06 (Development Execution)  
> **Scope**: Authoritative engineering rules determining viewport design and implementation precedence to prevent layout reflow regressions, inverted CSS overrides, and mobile ergonomics failures.

---

## 1. The Core Architectural Decision Rule

Selecting whether to design and implement **Mobile-First** or **Desktop-First** depends strictly on **User Input Density & Primary Task Context**, never developer convenience.

```text
[ Project Archetype Evaluation ]
               │
   ┌───────────┴───────────┐
   ▼                       ▼
High Density Canvas /   Standard Vertical Content /
Dense Data Table /      Consumer Web /
Complex Desktop Ops     SaaS Marketing / Portals
   │                       │
   ▼                       ▼
DESKTOP-FIRST           MOBILE-FIRST
(Design Precedence)     (Universal Default)
```

---

## 2. Decision Matrix by Software Archetype

| Archetype / Use Case | Design Precedence | Implementation (Code) Rule | Why This Strategy |
| :--- | :---: | :---: | :--- |
| **Consumer Apps, E-Commerce, Landing Pages, Blogs, Social** | **Mobile-First** | Tailwind Base (`w-full flex-col`) $\to$ `md:`/`lg:` expansion. | $\ge 70\%$ of end users browse on smartphones; forces ruthless content prioritization. |
| **SaaS Productivity & Management (Bookmarks, Notes, Task Lists)** | **Mobile-First** | Mobile Drawer/Bottom Nav $\to$ Persistent Desktop Sidebar (`lg:flex`). | Mobile use is frequent on-the-go; desktop expands into multi-pane layout. |
| **Accounting, Financial Ledgers, Dense ERP (TataBuku, FreePajak)** | **Desktop-First (Conceptual)** | Desktop Table $\to$ Mobile Stacked Key-Value Cards (`<table className="hidden md:table">`). | Core workflow requires wide monitors (10–15 columns); mobile serves as quick status checker. |
| **Interactive Canvases & Creative Tools (Whiteboards, Diagramming)** | **Desktop-First** | Fixed Desktop Stage $\to$ Mobile Read-Only / Zoom-Pan Viewport. | Precise multi-pointer / stylus manipulation requires large viewport canvas. |

---

## 3. Implementation Rules (Tailwind & CSS Execution)

### Rule A: The Mobile-First CSS Default (Zero Min-Width Overrides)
Tailwind CSS is fundamentally designed as mobile-first:
* Unprefixed utilities target mobile viewports (`320px–639px`).
* Media query prefixes (`sm:`, `md:`, `lg:`, `xl:`) strictly apply `min-width` expansions.
* ❌ **Prohibited Antipattern**: Writing desktop CSS by default and attempting to override with `max-md:` or `max-sm:` hacks. This causes bloated stylesheets and fragile cascading bugs.

### Rule B: Desktop Table to Mobile Card Reflow
When dealing with data-dense tables on mobile screens ($<640\text{px}$):
1. **Never Allow Unconstrained Horizontal Scroll**: Horizontal scrolling hides action buttons and critical status pills off-screen.
2. **Reflow into Stacked Cards**: Use dual-layout markup or CSS subgrid to transform table rows into compact cards on mobile viewports:
   ```tsx
   {/* Mobile Card View (< md) */}
   <div className="grid grid-cols-1 gap-3 md:hidden">
     {records.map((item) => (
       <div key={item.id} className="p-4 rounded-lg border border-border bg-card">
         <div className="flex justify-between font-semibold">
           <span>{item.title}</span>
           <StatusBadge status={item.status} />
         </div>
         <p className="text-sm text-muted-foreground mt-1">{item.details}</p>
       </div>
     ))}
   </div>

   {/* Desktop Table View (>= md) */}
   <table className="hidden md:table w-full">
     {/* Full data headers and rows */}
   </table>
   ```

### Rule C: Mobile Ergonomics Guardrails (Non-Negotiable)
1. **16px Minimum Input Font**: Form inputs MUST use at least `text-base` ($16\text{px}$) on mobile to prevent iOS Safari from automatically triggering disruptive viewport zooming.
2. **44px $\times$ 44px Minimum Tap Targets**: All buttons, links, and icon toggles must have at least $44\text{px}$ physical touch boundaries (`min-h-[44px] min-w-[44px]`).
3. **Zero Mobile Parallax**: Parallax scroll effects and heavy mouse-tracking animations are strictly disabled on viewports $<768\text{px}$ to conserve GPU memory and battery life.
