# Interactive Prototype Output

> **Purpose**: Store generated screen outputs from Interactive Prototype for review and handoff to development.

## Folder Structure

```
prototype-output/
├── SCR-01-landing/
│   ├── screen.html            # Generated HTML
│   ├── components/            # Extracted components
│   │   ├── Hero.tsx
│   │   ├── PricingCard.tsx
│   │   └── ...
│   └── screenshot.png         # Visual reference
├── SCR-02-login/
│   ├── screen.html
│   ├── components/
│   └── screenshot.png
└── ...
```

## Workflow

1. **Generate via MCP**: Use `prototype_generate_screen_from_text` with prompts from `prompt-input/`
2. **Export HTML**: Use `prototype_get_screen` to retrieve generated HTML
3. **Save to folder**: `prototype-output/SCR-XX-[screen-name]/screen.html`
4. **Extract components**: Break HTML into reusable React/Vue components
5. **Take screenshot**: Visual reference for design review
6. **Review**: Check against DESIGN_SPEC.md requirements (5 states, responsive, accessibility)

## Quality Gates

Before moving to Module 06 (Development), verify each screen:

| Check | Status |
|:------|:------:|
| Matches DESIGN.md color tokens | ❌ / ✅ |
| Uses specified typography | ❌ / ✅ |
| Follows component patterns | ❌ / ✅ |
| Responsive (mobile/tablet/desktop) | ❌ / ✅ |
| 5 states present (ideal/loading/empty/error/success) | ❌ / ✅ |
| No AI slop (generic shadows, gradients, mismatched colors) | ❌ / ✅ |
| Accessibility (ARIA labels, keyboard nav) | ❌ / ✅ |

## Handoff to Development

After all screens approved:

1. **Component extraction**: Move components to `src/components/ui/`
2. **Page assembly**: Wire pages in `src/app/` (Next.js) or `src/pages/` (other frameworks)
3. **State management**: Connect loading/empty/error states to API
4. **API integration**: Replace mock data with real endpoints

## Example MCP Commands

```typescript
// Get generated screen
const screen = await tool.prototype_get_screen({
  projectId: 'projects/[PROJECT_ID]',
  screenId: 'SCR-01'
});

// Save HTML
fs.writeFileSync('prototype-output/SCR-01-landing/screen.html', screen.html);

// Take screenshot (use Playwright/Puppeteer)
await page.screenshot({ 
  path: 'prototype-output/SCR-01-landing/screenshot.png',
  fullPage: true 
});
```

---

**Note**: If not using Interactive Prototype, skip this folder and implement screens directly in code based on DESIGN_SPEC.md wireframes and component descriptions.
