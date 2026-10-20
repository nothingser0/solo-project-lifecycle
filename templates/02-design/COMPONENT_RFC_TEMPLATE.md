# Component RFC: [Component Name]

**RFC Number:** [RFC-YYYY-NNN]  
**Author:** [Your Name]  
**Date:** [YYYY-MM-DD]  
**Status:** [Proposal / Under Review / Approved / Rejected / Implemented]  
**Figma Link:** [URL to design file]  
**Storybook Preview:** [URL to live preview (if available)]

---

## Summary

<!-- One-paragraph elevator pitch -->

[Brief description of the component, its purpose, and why it's needed. Example: "A versatile Button component that handles primary/secondary/tertiary actions with built-in loading states, icon support, and accessibility compliance. Replaces 7 inconsistent button implementations across the codebase."]

---

## 1. Problem Statement

### Current Situation

<!-- What pain point does this solve? -->

**What's broken/missing today:**
- [Current limitation or inconsistency]
- [Pain point experienced by designers/developers]
- [Cost of not having this component]

**Example:**
- We have 12 different button styles scattered across 8 files
- No consistent hover/focus states, breaking keyboard navigation
- Each engineer implements loading states differently (spinners, disabled text, opacity changes)
- Design QA finds button inconsistencies in 60% of PRs

### User Impact

**Who is affected:**
- [Designer / Developer / End User]
- [Specific use cases or workflows]

**Example:**
- Developers waste 2-3 hours per feature implementing one-off button variants
- End users experience inconsistent interaction patterns (some buttons show loading, others just disable)
- Designers can't enforce brand consistency without per-PR review

---

## 2. Proposed Solution

### Component API

#### Props

```typescript
interface ButtonProps {
  /** Button text or child content */
  children: React.ReactNode;
  
  /** Visual style variant */
  variant?: 'primary' | 'secondary' | 'tertiary' | 'danger' | 'ghost';
  
  /** Size preset */
  size?: 'sm' | 'md' | 'lg';
  
  /** Shows spinner and disables interaction */
  loading?: boolean;
  
  /** Disables button (overridden by loading) */
  disabled?: boolean;
  
  /** Icon before text */
  iconLeft?: React.ReactNode;
  
  /** Icon after text */
  iconRight?: React.ReactNode;
  
  /** Full width (block display) */
  fullWidth?: boolean;
  
  /** Click handler */
  onClick?: (event: React.MouseEvent<HTMLButtonElement>) => void;
  
  /** Button type (for forms) */
  type?: 'button' | 'submit' | 'reset';
  
  /** ARIA label (required if no text children) */
  'aria-label'?: string;
  
  /** Additional CSS class */
  className?: string;
  
  /** Test ID for E2E tests */
  'data-testid'?: string;
}
```

#### Usage Examples

```tsx
// Primary action
<Button variant="primary" onClick={handleSave}>
  Save Changes
</Button>

// Loading state
<Button variant="primary" loading>
  Saving...
</Button>

// With icons
<Button variant="secondary" iconLeft={<PlusIcon />}>
  Add Item
</Button>

// Danger action
<Button variant="danger" iconLeft={<TrashIcon />}>
  Delete Account
</Button>

// Icon-only button (requires aria-label)
<Button variant="ghost" aria-label="Close modal">
  <XIcon />
</Button>

// Full width (mobile CTAs)
<Button variant="primary" fullWidth size="lg">
  Continue to Payment
</Button>
```

### Variants & States

#### Visual Variants

| Variant | Use Case | Colors (Light/Dark) | Example |
|---------|----------|---------------------|---------|
| `primary` | Main CTA, high emphasis | Blue 600 / Blue 500 | "Sign Up", "Save", "Submit" |
| `secondary` | Secondary actions | Gray 200 / Gray 700 | "Cancel", "Go Back" |
| `tertiary` | Low emphasis, inline | Transparent + Blue text | "Learn More", "Skip" |
| `danger` | Destructive actions | Red 600 / Red 500 | "Delete", "Remove" |
| `ghost` | Icon-only, minimal | Transparent hover | Close buttons, icon actions |

#### Interactive States

| State | Behavior |
|-------|----------|
| **Default** | Base colors, pointer cursor |
| **Hover** | Darken by 10%, scale 1.02 |
| **Active/Pressed** | Darken by 20%, scale 0.98 |
| **Focus** | 2px outline with 4px offset (WCAG 2.2 compliance) |
| **Loading** | Show spinner, disable interaction, 60% opacity |
| **Disabled** | 40% opacity, not-allowed cursor, no hover |

#### Size Variations

| Size | Height | Padding | Font Size | Use Case |
|------|--------|---------|-----------|----------|
| `sm` | 32px | 8px 12px | 14px | Compact UI, tables, mobile |
| `md` | 40px | 10px 16px | 16px | Default, most use cases |
| `lg` | 48px | 12px 24px | 18px | Hero CTAs, mobile primary actions |

---

## 3. Accessibility Considerations

### WCAG 2.2 Compliance

**Color Contrast:**
- ✅ All variants meet WCAG AA (4.5:1 for text, 3:1 for components)
- ✅ Focus outline has 3:1 contrast against background

**Keyboard Navigation:**
- ✅ Focusable via `Tab`
- ✅ Activated via `Enter` or `Space`
- ✅ Clear focus indicator (2px outline with offset)

**Screen Reader Support:**
- ✅ Role `button` (native `<button>` element)
- ✅ Loading state announced via `aria-live="polite"`
- ✅ Disabled state communicated via `aria-disabled="true"`
- ✅ Icon-only buttons require `aria-label`

**Motion & Animation:**
- ✅ Scale transitions respect `prefers-reduced-motion`
- ✅ Loading spinner has `aria-label="Loading"`

### Accessibility Testing Checklist

- [ ] Keyboard: Can focus and activate via keyboard
- [ ] Screen Reader: VoiceOver/NVDA announces role and state correctly
- [ ] Color Contrast: Passes WebAIM contrast checker
- [ ] Focus Visible: Focus ring visible on all backgrounds
- [ ] Reduced Motion: Animations disabled when `prefers-reduced-motion: reduce`

---

## 4. Implementation Plan

### Phase 1: Core Component (Week 1)

**Tasks:**
1. Implement base `<Button>` with `variant` and `size` props
2. Add `loading` and `disabled` states
3. Write Storybook stories for all variants
4. Unit tests (Jest + React Testing Library)

**Deliverables:**
- `Button.tsx` component
- `Button.stories.tsx` (Storybook)
- `Button.test.tsx` (90%+ coverage)
- Design tokens in `button.tokens.css`

### Phase 2: Icon & Advanced Features (Week 2)

**Tasks:**
1. Add `iconLeft` and `iconRight` props
2. Implement `fullWidth` layout
3. Add `type` prop for form integration
4. Accessibility audit (keyboard, screen reader)

**Deliverables:**
- Icon integration
- Accessibility report (WCAG checklist)
- Updated Storybook stories

### Phase 3: Migration & Rollout (Week 3-4)

**Tasks:**
1. Create codemod to migrate old `<button>` elements (optional)
2. Update component library docs
3. Migrate 3 pilot components to use new Button
4. Design QA review

**Deliverables:**
- Migration guide (old → new mapping)
- 3 PRs migrating existing code
- Design approval sign-off

---

## 5. Breaking Changes

### Does this introduce breaking changes?

**[YES / NO]**

**If YES, describe impact:**

| What Breaks | Affected Code | Migration Path |
|-------------|---------------|----------------|
| [Old prop removed] | [Which components] | [How to fix] |
| [API change] | [Which components] | [How to fix] |

**Example:**

| What Breaks | Affected Code | Migration Path |
|-------------|---------------|----------------|
| Old `Button` prop `theme` removed | 12 files using `theme="primary"` | Replace with `variant="primary"` |
| `isLoading` renamed to `loading` | 8 files using `isLoading` | Rename prop to `loading` |

### Deprecation Timeline

**If breaking changes exist:**

- **Now → Month 1**: Old component marked `@deprecated`, console warnings added
- **Month 1 → Month 3**: Parallel support for old + new API
- **Month 3**: Old API removed, migration required

---

## 6. Adoption Timeline

### Rollout Strategy

**Week 1-2: Alpha (Internal Testing)**
- Available in Storybook, not yet in production
- Collect feedback from 2-3 engineers

**Week 3-4: Beta (Pilot Features)**
- Use in 3 new features
- Monitor for bugs, gather DX feedback

**Week 5+: General Availability**
- Add to official Design System docs
- Announce in #engineering Slack
- Begin migrating legacy buttons (1-2 per sprint)

### Success Metrics

**How do we know this RFC succeeded?**

- [ ] 80% of new features use `<Button>` component (not one-off styles)
- [ ] Zero design QA issues related to button inconsistency (Month 1-3 avg)
- [ ] Reduced button-related code by 500 LOC (codebase cleanup)
- [ ] Positive feedback from 5+ engineers in survey

---

## 7. Open Questions & Discussion

### Unresolved Decisions

**Question 1: Should we support `as` polymorphism?**
- **Context**: Should `<Button as="a" href="...">` render an `<a>` tag?
- **Pros**: Semantic HTML for link-styled buttons
- **Cons**: Complexity, TypeScript challenges
- **Decision**: [TBD / Decided on [Date]]

**Question 2: Icon size auto-scaling?**
- **Context**: Should icons auto-size based on button `size` prop?
- **Options**:
  - A) Icons always 16px (manual sizing required for `lg`)
  - B) Icons scale: `sm`=14px, `md`=16px, `lg`=20px
- **Decision**: [TBD / Decided on [Date]]

### Feedback & Comments

**[Name] - [Date]:**
> [Comment or suggestion]

**[Name] - [Date]:**
> [Comment or suggestion]

---

## 8. Related Work

### Similar Components in Other Design Systems

- [Material UI Button](https://mui.com/material-ui/react-button/)
- [Chakra UI Button](https://chakra-ui.com/docs/components/button)
- [shadcn/ui Button](https://ui.shadcn.com/docs/components/button)

**Key differences from shadcn/ui:**
- We add `loading` prop (they use separate `LoadingButton`)
- We use `variant`, they use `variant` + `size` separately
- We support `iconLeft/Right`, they require manual icon placement

### Dependencies

**New packages required:**
- `@radix-ui/react-slot` (for polymorphic `as` prop, if approved)
- None (if using native `<button>` only)

**Design tokens updated:**
- `colors.button.*`
- `spacing.button.*`
- `typography.button.*`

---

## 9. Appendix

### Design Assets

- [Figma Component Library](https://figma.com/...)
- [Design Tokens (JSON)](https://github.com/.../tokens.json)
- [Accessibility Audit Report](https://docs.google.com/...)

### Prototypes

- [Storybook Preview (WIP)](https://storybook-preview.vercel.app/...)
- [CodeSandbox Demo](https://codesandbox.io/...)

### References

- [WCAG 2.2 Button Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/button/)
- [Inclusive Components: Buttons](https://inclusive-components.design/toggle-button/)

---

## Approval

**Design Approval:**  
- [ ] Design Lead: [Name] - [Date]

**Engineering Approval:**  
- [ ] Tech Lead: [Name] - [Date]

**Product Approval:**  
- [ ] Product Manager: [Name] - [Date]

---

**Status Updates:**

| Date | Status | Notes |
|------|--------|-------|
| [YYYY-MM-DD] | Proposal | RFC submitted for review |
| [YYYY-MM-DD] | Under Review | Collecting feedback |
| [YYYY-MM-DD] | Approved | Implementation begins Week of [Date] |
| [YYYY-MM-DD] | Implemented | Shipped in Design System v[X.Y.Z] |
