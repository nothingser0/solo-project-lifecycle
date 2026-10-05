# Design System Guide (Comprehensive Reference)

**Last Updated**: 2026-09-27  
**Target Audience**: Solo developers, small teams, design system practitioners  
**Skill Level**: Intermediate to Advanced

---

## Table of Contents

1. [Introduction: Why Design Systems Matter](#1-introduction)
2. [Strategic Decision Trees](#2-strategic-decision-trees)
3. [Token Architecture Deep Dive](#3-token-architecture)
4. [Component Library Patterns](#4-component-library-patterns)
5. [Tooling Ecosystem](#5-tooling-ecosystem)
6. [Adoption & Migration Strategies](#6-adoption-migration)
7. [Governance Models](#7-governance-models)
8. [Measuring Success](#8-measuring-success)
9. [Common Pitfalls & Rescue Strategies](#9-common-pitfalls)
10. [Case Studies](#10-case-studies)

---

## 1. Introduction: Why Design Systems Matter

### 1.1 The ROI of Design Systems

**Quantifiable Benefits** (Industry averages from InVision 2025 report):
- **60% reduction** in design-to-code handoff time
- **70% decrease** in visual inconsistency bugs
- **3x faster** feature development for UI-heavy features
- **50% reduction** in design review cycles

**Real Cost Example** (10-person product team):
```
Without DS:
- Designer time per screen: 8h (custom styling each time)
- Developer time per screen: 16h (implementing from scratch)
- QA time per screen: 2h (visual inconsistency bugs)
- Total: 26h per screen × $50/h = $1,300 per screen

With DS:
- Designer time: 2h (component assembly)
- Developer time: 4h (prop configuration)
- QA time: 0.5h (automated visual regression)
- Total: 6.5h per screen × $50/h = $325 per screen

Savings: $975 per screen (75% cost reduction)
```

**For 50 screens/year**: $48,750 annual savings  
**DS maintenance cost**: ~$40,000/year (0.5 FTE)  
**Net savings**: $8,750 in Year 1, $48,750 in Year 2+

### 1.2 When NOT to Build a Design System

**Skip if:**
- ❌ MVP with <5 screens (premature optimization)
- ❌ Solo freelancer with no team growth plans
- ❌ Proof-of-concept that will be thrown away
- ❌ Team <3 people with low feature velocity
- ❌ Non-GUI products (backend APIs, CLI tools)

**Build if:**
- ✅ 3+ engineers building UI features simultaneously
- ✅ Multi-platform products (Web + iOS + Android)
- ✅ White-label / multi-tenant requirements
- ✅ Scale plans: Team growth from 5 → 20+ in 12 months
- ✅ Design debt causing >5 visual bugs per sprint

---

## 2. Strategic Decision Trees

### 2.1 Build vs Adopt vs Extend

```
START: Do you need custom branding?
  │
  ├─ NO → Adopt existing DS (Material UI, Chakra, Ant Design)
  │         └─ Time to production: 1-2 weeks
  │         └─ Maintenance: Zero (community-maintained)
  │         └─ Cost: Free (MIT licensed)
  │
  └─ YES → Does your brand require radical customization?
            │
            ├─ NO → Extend headless DS (Shadcn, Radix, Headless UI)
            │        └─ Time: 4-6 weeks
            │        └─ Maintenance: Low (override tokens only)
            │        └─ Cost: $10-20k initial
            │
            └─ YES → Build custom DS (this guide)
                     └─ Time: 12-16 weeks
                     └─ Maintenance: High (0.5-1 FTE ongoing)
                     └─ Cost: $80-120k initial
```

### 2.2 Tooling Stack Decision Matrix

| Scenario | Design Tool | Token System | Component Docs | Visual Regression |
|----------|-------------|--------------|----------------|-------------------|
| **Solo Dev (MVP)** | Figma Community (free) | CSS variables only | Markdown in repo | Manual screenshots |
| **Small Team (5-10)** | Figma Pro ($12/mo) | Style Dictionary | Storybook | Chromatic free tier |
| **Scale Team (20+)** | Figma Org ($45/seat) | Theo + custom pipeline | Storybook + Zeroheight | Chromatic paid |
| **Enterprise (100+)** | Figma Enterprise | Custom build system | Custom docs site | Percy / Applitools |

### 2.3 Component Priority Framework

**P0: Foundational** (Week 1-2, cannot ship without these)
```
Button, Input, Label, Select, Checkbox, Radio, Spinner
```

**P1: Essential** (Week 3-4, needed for most features)
```
Card, Modal, Alert, Toast, Tooltip, Dropdown, Badge, Avatar
```

**P2: Common** (Week 5-6, frequent but not universal)
```
Table, Tabs, Accordion, Breadcrumb, Pagination, Progress, Skeleton
```

**P3: Specialized** (Week 7+, product-specific)
```
DatePicker, FileUpload, RichTextEditor, Charts, Calendar, Kanban
```

**Stop at P1 for MVP** (16 components in 4 weeks). P2+ driven by actual product needs.

---

## 3. Token Architecture Deep Dive

### 3.1 The Two-Layer Token System

**Primitive Layer** (Design tool source of truth):
```json
{
  "color": {
    "blue-500": "#3B82F6",  // Raw hex value from Figma
    "gray-900": "#18181B"
  }
}
```

**Semantic Layer** (Implementation intent):
```json
{
  "color": {
    "action-primary": "{color.blue-500}",      // Maps to primitive
    "text-body": "{color.gray-900}"
  }
}
```

**Why Two Layers?**
1. **Rebrand resilience**: Change "action-primary" from blue → green in one place
2. **Dark mode**: Semantic tokens flip primitive mappings
3. **Platform divergence**: iOS uses "action-primary", not "blue-500"

### 3.2 Dark Mode Token Strategy

**Bad Approach** (duplicates all primitives):
```css
:root { --bg: white; --text: black; }
@media (prefers-color-scheme: dark) { --bg: black; --text: white; }
```
Problem: 2x maintenance, no shared palette.

**Good Approach** (semantic tokens remap):
```css
/* Primitives (never change) */
:root {
  --gray-50: #FAFAFA;
  --gray-900: #18181B;
}

/* Semantics (flip in dark mode) */
:root {
  --bg-primary: var(--gray-50);
  --text-primary: var(--gray-900);
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg-primary: var(--gray-900);  /* Flipped */
    --text-primary: var(--gray-50); /* Flipped */
  }
}
```

### 3.3 Token Naming Conventions (Industry Standard)

**Format**: `[category]-[property]-[variant]-[state]`

**Examples**:
```
color-text-primary          // Base text color
color-text-primary-hover    // Hover state
color-action-secondary      // Secondary action color
space-component-padding     // Semantic spacing for components
shadow-card-elevated        // Elevated card shadow
```

**Anti-patterns**:
```
colorPrimary               // ❌ camelCase (hard to parse)
color_primary_button       // ❌ Too specific (should be semantic)
blue500                    // ❌ No category prefix
```

### 3.4 Type Scale Mathematics

**Modular Scale Formula** (Tim Brown, A List Apart):
```
font-size = base-size × ratio^n

Common ratios:
- 1.125 (Major Second) → Conservative
- 1.200 (Minor Third) → Balanced ✅ Recommended
- 1.250 (Major Third) → Aggressive
- 1.333 (Perfect Fourth) → Dramatic
```

**Example (1.200 ratio, 16px base)**:
```
12px = 16 × 1.2^-2  (xs)
14px = 16 × 1.2^-1  (sm)
16px = 16 × 1.2^0   (base)
19px = 16 × 1.2^1   (lg)
23px = 16 × 1.2^2   (xl)
28px = 16 × 1.2^3   (2xl)
33px = 16 × 1.2^4   (3xl)
```

**Tool**: Use https://type-scale.com/ for visual preview.

---

## 4. Component Library Patterns

### 4.1 Composition over Configuration

**Anti-pattern** (Prop explosion):
```tsx
<Card 
  title="Document" 
  subtitle="Draft" 
  showAvatar={true}
  avatarUrl="/user.jpg"
  showFooter={true}
  footerAction="Edit"
  onFooterClick={handleEdit}
/>
```
Problem: 15+ props, inflexible, hard to extend.

**Better** (Compound components):
```tsx
<Card>
  <Card.Header>
    <Avatar src="/user.jpg" />
    <div>
      <Card.Title>Document</Card.Title>
      <Card.Subtitle>Draft</Card.Subtitle>
    </div>
  </Card.Header>
  <Card.Body>
    Content here
  </Card.Body>
  <Card.Footer>
    <Button onClick={handleEdit}>Edit</Button>
  </Card.Footer>
</Card>
```
Benefits: Unlimited flexibility, clear hierarchy, self-documenting.

### 4.2 Controlled vs Uncontrolled Components

**Controlled** (Parent manages state):
```tsx
function Form() {
  const [value, setValue] = useState('')
  return <Input value={value} onChange={setValue} />
}
```
Use when: Form validation, dependent fields, submit handling.

**Uncontrolled** (Component manages state):
```tsx
function Form() {
  const inputRef = useRef()
  return <Input defaultValue="hello" ref={inputRef} />
}
```
Use when: Simple forms, no validation, legacy integration.

**Rule**: Provide both APIs, default to controlled for new code.

### 4.3 Accessibility First (Not Afterthought)

**Bad workflow**:
```
Build component → Ship → Audit → Retrofit accessibility → Breaking changes
```

**Good workflow**:
```
Design component with a11y checklist → Build with ARIA → Test with screen reader → Ship
```

**Checklist per component**:
- [ ] Semantic HTML (`<button>` not `<div role="button">`)
- [ ] Keyboard navigation (Tab, Enter, Esc, Arrows)
- [ ] Focus visible (2px outline, high contrast)
- [ ] ARIA attributes (`role`, `aria-label`, `aria-expanded`)
- [ ] Screen reader tested (NVDA on Windows, VoiceOver on Mac)
- [ ] Color contrast ≥4.5:1 (WCAG AA)
- [ ] Touch target ≥44×44px (mobile)

### 4.4 Variant API Design

**Bad** (Combinatorial explosion):
```tsx
<Button 
  isPrimary={true}
  isLarge={false}
  hasIcon={true}
  isLoading={false}
/>
```
Problem: 2^4 = 16 prop combinations to test.

**Good** (Enum variants):
```tsx
<Button 
  variant="primary"     // enum: primary | secondary | outline
  size="md"             // enum: sm | md | lg
  leftIcon={<Icon />}   // optional
  isLoading={false}     // boolean state
/>
```
Benefits: Clear API, fewer test cases, TypeScript autocomplete.

---

## 5. Tooling Ecosystem

### 5.1 Style Dictionary (Token Transformation)

**Installation**:
```bash
pnpm add -D style-dictionary
```

**Config** (`style-dictionary.config.js`):
```javascript
module.exports = {
  source: ['tokens/**/*.json'],
  platforms: {
    css: {
      transformGroup: 'css',
      buildPath: 'dist/css/',
      files: [{
        destination: 'variables.css',
        format: 'css/variables'
      }]
    },
    ios: {
      transformGroup: 'ios-swift',
      buildPath: 'dist/ios/',
      files: [{
        destination: 'Tokens.swift',
        format: 'ios-swift/class.swift',
        className: 'DesignTokens'
      }]
    },
    android: {
      transformGroup: 'android',
      buildPath: 'dist/android/',
      files: [{
        destination: 'tokens.xml',
        format: 'android/resources'
      }]
    }
  }
}
```

**Build**:
```bash
npx style-dictionary build
```

**Output**: Generates platform-specific files from single JSON source.

### 5.2 Storybook (Component Documentation)

**Why Storybook?**
- Living documentation (code examples always up-to-date)
- Visual regression testing (Chromatic integration)
- Isolated development (test components without full app)
- Accessible to non-developers (designers, PMs can browse)

**Basic Setup** (Next.js 15):
```bash
npx storybook@latest init
```

**Story Example** (`Button.stories.tsx`):
```tsx
import type { Meta, StoryObj } from '@storybook/react'
import { Button } from './Button'

const meta: Meta<typeof Button> = {
  title: 'Components/Button',
  component: Button,
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'outline']
    }
  }
}
export default meta

type Story = StoryObj<typeof Button>

export const Primary: Story = {
  args: {
    variant: 'primary',
    children: 'Click Me'
  }
}

export const AllVariants: Story = {
  render: () => (
    <div className="flex gap-4">
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="outline">Outline</Button>
    </div>
  )
}
```

**Deploy**:
```bash
pnpm build-storybook
# Upload dist to Vercel / Netlify / Chromatic
```

### 5.3 Chromatic (Visual Regression)

**Setup**:
```bash
pnpm add -D chromatic
npx chromatic --project-token=<token>
```

**CI Integration** (`.github/workflows/chromatic.yml`):
```yaml
name: Chromatic
on: [push]
jobs:
  chromatic:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: actions/setup-node@v4
      - run: pnpm install
      - run: pnpm chromatic --project-token=${{ secrets.CHROMATIC_TOKEN }}
```

**Workflow**:
1. Push changes → Chromatic captures screenshots
2. Compare with baseline → Flag visual diffs
3. Review diffs → Approve or fix
4. Approved changes become new baseline

**Cost**: Free tier (5,000 snapshots/month), sufficient for small teams.

### 5.4 Figma Tokens Plugin (Sync with Design)

**Plugin**: [Tokens Studio for Figma](https://tokens.studio/)

**Workflow**:
```
Design tokens JSON (Git repo)
  ↓ (sync)
Figma Tokens Plugin
  ↓ (apply)
Figma Styles (Color, Typography, Spacing)
  ↓ (design)
Components in Figma
  ↓ (export)
Style Dictionary build
  ↓ (output)
CSS variables / Swift enums / Android XML
```

**Benefits**:
- Single source of truth (JSON in Git)
- Designers update Figma styles via plugin (no manual re-entry)
- Engineers pull latest tokens from Git (no Figma handoff delay)

---

## 6. Adoption & Migration Strategies

### 6.1 The Pilot Team Approach (Recommended)

**Phase 1: Pilot (Week 1-2)**
```
Goal: Validate DX (developer experience) with 1 squad
Squad selection: Pick early adopters, not skeptics
Scope: Migrate 1 feature (e.g., Settings page, 5-10 screens)
Success metric: <2 blockers requiring DS changes
```

**Phase 2: Iterate (Week 3-4)**
```
Goal: Fix rough edges from pilot feedback
Actions:
- Add missing component variants
- Improve documentation (common use cases)
- Simplify installation (create starter template)
```

**Phase 3: Gradual Rollout (Week 5-8)**
```
Goal: Expand to 50% of team
Mandate: All NEW features use DS components
Brownfield: No forced migration of existing code (yet)
```

**Phase 4: Brownfield Migration (Week 9-16)**
```
Goal: Retire legacy components
Strategy: Page-by-page replacement during feature work
Codemod: Automate simple renames (e.g., <CustomButton> → <Button>)
Deadline: Announce EOL (end-of-life) for legacy components
```

### 6.2 Codemods (Automated Migration)

**Example**: Migrate `<LegacyButton color="blue">` → `<Button variant="primary">`

**Tool**: [jscodeshift](https://github.com/facebook/jscodeshift)

```javascript
// transform.js
module.exports = function(fileInfo, api) {
  const j = api.jscodeshift
  const root = j(fileInfo.source)
  
  root.findJSXElements('LegacyButton')
    .forEach(path => {
      j(path).replaceWith(
        j.jsxElement(
          j.jsxOpeningElement(j.jsxIdentifier('Button'), [
            j.jsxAttribute(
              j.jsxIdentifier('variant'),
              j.literal('primary')
            )
          ]),
          j.jsxClosingElement(j.jsxIdentifier('Button')),
          path.node.children
        )
      )
    })
  
  return root.toSource()
}
```

**Run**:
```bash
npx jscodeshift -t transform.js src/**/*.tsx
```

### 6.3 Feature Flags for Gradual Rollout

**Pattern**: Toggle DS components on/off per user cohort

```tsx
// Feature flag wrapper
import { useFeatureFlag } from '@/lib/flags'

export function Button(props) {
  const useNewDS = useFeatureFlag('new-design-system')
  
  return useNewDS ? (
    <NewButton {...props} />
  ) : (
    <LegacyButton {...props} />
  )
}
```

**Rollout plan**:
```
Week 1: 5% internal users
Week 2: 25% internal users
Week 3: 100% internal users
Week 4: 5% external users
Week 6: 50% external users
Week 8: 100% external users
```

---

## 7. Governance Models

### 7.1 Centralized (Small Teams <20)

**Structure**:
```
Design System Owner (50% bandwidth)
  ├─ Owns all decisions
  ├─ Reviews all contributions
  └─ Maintains documentation
```

**Pros**: Fast decisions, consistent quality  
**Cons**: Bottleneck risk, single point of failure

**Tooling**: GitHub issues → Owner triages → Owner implements

### 7.2 Federated (Scale Teams 20-100)

**Structure**:
```
Design System Council (5-7 members)
  ├─ Design Lead (chair)
  ├─ 2 Frontend Engineers
  ├─ 1 Accessibility Specialist
  ├─ 1 Product Manager
  └─ 2 Squad Representatives (rotating quarterly)
```

**Decision Process**:
1. Anyone submits RFC (Request for Comments)
2. Council reviews async (48h comment period)
3. Vote: Majority approval required
4. Approved → Assign to sprint

**Pros**: Scales, distributed ownership  
**Cons**: Slower decisions, requires coordination

### 7.3 RFC (Request for Comments) Template

**File**: `rfcs/0001-new-component-name.md`

```markdown
# RFC 0001: [Component Name]

**Author**: [Your Name]  
**Date**: 2026-09-27  
**Status**: Draft / Review / Approved / Rejected

## Problem Statement
What user need is unmet by current DS?

## Proposed Solution
Component API (props, variants, usage examples)

## Alternatives Considered
Why not extend existing component?

## Accessibility Review
Keyboard nav, ARIA roles, screen reader testing plan

## Breaking Changes
None / Migration guide attached

## Implementation Plan
- Week 1: Design in Figma
- Week 2: Implement in code
- Week 3: Document in Storybook
- Week 4: Pilot with 1 squad
```

---

## 8. Measuring Success

### 8.1 Leading Indicators (Process Metrics)

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| **DS Adoption Rate** | 80% of screens in 6 months | Automated import scanner |
| **Component Coverage** | 90% of UI patterns | Manual audit |
| **Design Review Cycle Time** | <2 days (down from 4) | Jira/Linear ticket time tracking |
| **Pull Request Size** | -30% (less custom CSS) | GitHub API analytics |

### 8.2 Lagging Indicators (Outcome Metrics)

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| **Visual Bug Rate** | -70% | Jira bug count (tagged "visual-inconsistency") |
| **Feature Velocity** | +40% UI features | Sprint burn-up chart |
| **Design Debt Score** | <20 (down from 85) | Custom audit script |
| **Bundle Size** | -15% | Webpack bundle analyzer |

### 8.3 Component Usage Analytics

**Automated tracking** (Babel plugin):

```javascript
// babel-plugin-track-ds-usage.js
module.exports = function({ types: t }) {
  return {
    visitor: {
      ImportDeclaration(path) {
        if (path.node.source.value === '@company/design-system') {
          // Log imports to analytics
          const components = path.node.specifiers.map(s => s.imported.name)
          console.log('DS components used:', components)
        }
      }
    }
  }
}
```

**Dashboard** (weekly report):
```
Top 10 DS Components (by import count):
1. Button: 347 imports across 52 files
2. Input: 298 imports
3. Card: 201 imports
...

Unused Legacy Components (candidates for removal):
1. <OldButton>: 2 imports (down from 150 last quarter)
2. <CustomCard>: 0 imports (safe to delete)
```

---

## 9. Common Pitfalls & Rescue Strategies

### 9.1 Pitfall: "Design System Theater"

**Symptom**: Beautiful Storybook, zero adoption in actual product.

**Causes**:
- No mandate from leadership
- DX (developer experience) is poor (hard to install, no TypeScript, bad docs)
- Missing critical components (developers forced to build custom)

**Rescue**:
1. **Get executive sponsor**: CTO/CPO mandates DS for all new features
2. **Improve DX**: Create `create-app-with-ds` template, add TypeScript, fix docs
3. **Build missing P0 components**: Survey teams for blockers, prioritize top 3

### 9.2 Pitfall: Premature Optimization

**Symptom**: Spent 6 months building 50 components, none used in production.

**Causes**:
- Built components before product needs were clear
- No pilot team validation
- "Field of Dreams" fallacy ("if we build it, they will come")

**Rescue**:
1. **Freeze development**: Stop building new components
2. **Run product audit**: What components are actually needed for roadmap?
3. **Deprecate unused**: Archive 30+ unused components, maintain only used 15
4. **Switch to pull model**: Build components when squads request them (2-week SLA)

### 9.3 Pitfall: Token Sprawl

**Symptom**: 47 shades of gray, 18 font sizes, developers confused which to use.

**Causes**:
- No design audit before token creation
- Tokens added incrementally without consolidation
- No semantic layer (only primitive tokens)

**Rescue**:
1. **Run consolidation audit**: Cluster similar values (Delta E < 3 for colors)
2. **Enforce semantic tokens**: Ban direct use of primitive tokens in components
3. **Document decision trees**: "Use `--color-text-secondary` for X, `--color-text-tertiary` for Y"

### 9.4 Pitfall: "Not Invented Here" Syndrome

**Symptom**: Rebuilt 20 components that Material UI already provides.

**Causes**:
- Team ego ("we can do better")
- Misunderstanding of customization capabilities (most DS are themeable)
- Underestimating maintenance burden

**Rescue**:
1. **Honest ROI calculation**: Cost of custom DS vs extending existing
2. **Pilot with existing DS**: Spend 2 weeks customizing Chakra/MUI before deciding
3. **Hybrid approach**: Use headless components (Radix) + custom styling

---

## 10. Case Studies

### 10.1 Shopify Polaris (E-commerce Scale)

**Context**: 1,000+ engineers, multiple products (Shopify admin, POS, mobile)

**Approach**:
- **Central team**: 15 dedicated DS engineers + designers
- **RFC process**: All changes require written proposal + council approval
- **Documentation**: Comprehensive guidelines (accessibility, content, UX patterns)
- **Migration**: 18-month brownfield migration, codemod + manual review

**Results**:
- 80% adoption across products (2 years post-launch)
- 60% reduction in design review time
- Open-sourced: 14K GitHub stars, community contributions

**Lesson**: Invest in docs early. Shopify's docs are why adoption succeeded.

### 10.2 Airbnb DLS (Pivot from Build to Adopt)

**Context**: Built custom DS 2018-2020, maintenance burden crushed team

**Pivotal Moment (2021)**: Realized React Native Paper (community DS) covered 90% of needs

**Pivot Strategy**:
1. Froze custom DS development
2. Migrated 80% of components to React Native Paper + custom theme
3. Kept 5 custom components (unique to Airbnb brand)
4. Reduced DS team from 8 → 2 engineers

**Results**:
- $500K annual savings (labor cost)
- Faster feature velocity (community bug fixes)
- Happier engineers (less maintenance toil)

**Lesson**: Build vs adopt is not one-time decision. Revisit yearly.

### 10.3 Solo Dev SaaS (Minimal Viable DS)

**Context**: 1 founder, B2B document management SaaS, Next.js + Tailwind

**Approach**:
- **Token system**: Tailwind config extended with brand colors (30 min setup)
- **Components**: Shadcn UI (copy-paste, not npm package) for 10 core components
- **Documentation**: README with usage examples (no Storybook)
- **Total investment**: 2 weeks (part-time)

**Results**:
- Consistent UI across 50 screens
- 70% faster feature development (no styling from scratch)
- Zero maintenance burden (Shadcn updates = copy new code)

**Lesson**: DS doesn't require enterprise tooling. Tailwind + Shadcn = 80/20.

---

## Conclusion: The 80/20 of Design Systems

**If you remember only 5 things**:

1. **Start with tokens, not components** — Color/spacing consistency = 80% of visual consistency
2. **Build what you need, when you need it** — Don't build 50 components upfront
3. **Documentation = adoption** — Undocumented components are unused components
4. **Accessibility is not optional** — Retrofitting accessibility costs 5x more than building it in
5. **Adopt before building** — Shadcn/MUI/Chakra solve 90% of needs for 10% of effort

**Recommended reading**:
- *Design Systems* by Alla Kholmatova (book)
- *Atomic Design* by Brad Frost (free online)
- Shopify Polaris docs (best-in-class documentation)
- Nathan Curtis's Medium articles (DS governance expert)

**Communities**:
- Design Systems Slack (15K members)
- r/designsystems on Reddit
- Figma Design Systems Community

---

**Last Updated**: 2026-09-27  
**Maintained by**: Solo Project Development Skill  
**Feedback**: Submit issues to skill maintainer
