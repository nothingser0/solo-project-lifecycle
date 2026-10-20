# AI Agent System Prompt Engineering & Execution Guardrails Pattern

> **Module**: M05 (Architecture & Specs), M06 (Development Execution), & M07 (Quality Assurance)  
> **Source**: Adapted from production system prompts of Anthropic (Claude Code / Haiku 5.5 / Design Systems), OpenAI (Codex), Cursor IDE, and Google (Antigravity).  
> **Scope**: Authoritative engineering rules for governing AI coding agents, preventing context pollution, enforcing code cleanliness, eliminating AI visual tropes, and enforcing precision code references.

---

## 1. Core Agent Behavioral Invariants

When orchestrating or prompting AI coding agents (Claude Code, Cursor, Codex, OpenCode):

### A. The Anti-Comment-Scratchpad Rule
* **Prohibited**: Never allow agents to use code comments or terminal output as a thinking scratchpad (e.g. `// Import module`, `// Define function`, `// Handle error`, `// Loop through items`).
* **Enforced**: Comments are permitted **only** to document non-obvious business intent, security boundaries, or workarounds for third-party bugs that the code itself cannot convey. If the diff makes the change obvious, a comment is slop.

### B. Prefer Editing Over Creating Files (Anti-File-Sprawl)
* **Prohibited**: Creating ad-hoc utility files (`helpers/dateUtils2.ts`, `services/miscService.ts`) for small functions.
* **Enforced**: **Always prefer editing an existing file to creating a new one**. Do not create a new file unless it represents a distinct domain boundary or an explicitly planned architectural module.

### C. Read Before Edit (Zero-Guessing Invariant)
* Agents **MUST** read the target file or check the AST before attempting edits or patches. Blind find-and-replace without checking line context is prohibited.

### D. Zero-Unfixed-Lint Gate
* If an agent introduces a lint, type, or syntax error during a turn, it must resolve the error immediately within the same turn. Leaving broken builds for the next conversation turn is prohibited.

---

## 2. Anti-AI Visual Tropes (Anthropic Design Standard)

When generating frontend UI components or design tokens, coding agents must actively avoid hallmark "AI slop" styling:
1. **No Purple-Blue Gradients**: Do not default to `bg-gradient-to-r from-blue-600 to-purple-600` for hero sections, headers, or action buttons.
2. **No Emoji Feature Cards**: Do not place random emojis (🚀, 💡, ⚡) inside feature card headers. Use real SVG icons (Lucide / Radix) with semantic meaning.
3. **No Colored Left-Border Accent Cards**: Avoid generic `border-l-4 border-indigo-500` card styling on white surfaces. Use subtle borders (`border-slate-200 dark:border-slate-800`) or tonal elevations.
4. **Contrast Strictness**: All text must achieve WCAG AA contrast ($\ge 4.5:1$ for body text, $\ge 3:1$ for large text and UI controls). Differentiate status colors by lightness/saturation, not hue alone (accessible for colorblindness).

---

## 3. Precision Code Citation Standard (Cursor Format)

When citing existing repository code to the user or across agent messages, use the exact line-anchored coordinate syntax:

```text
```startLine:endLine:filepath
// actual code lines verbatim
```
```

### Rules:
* Always provide exact 1-indexed start and end lines.
* Do not attach a language tag to the code fence (e.g. use ````12:18:src/lib/auth.ts````, never ````typescript 12:18:...````).
* Reserve standard markdown code blocks (```typescript ... ```) exclusively for newly proposed code that does not yet exist on disk.
