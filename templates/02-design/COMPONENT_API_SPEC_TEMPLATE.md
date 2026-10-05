# Component API Specification

**Component Name**: [ComponentName]  
**Version**: v1.0.0  
**Status**: ✅ Stable / ⚠️ Beta / 🚧 Draft  
**Owner**: [Team/Person]  
**Last Updated**: [YYYY-MM-DD]

---

## Overview

**Purpose**: [One-line description of what problem this component solves]

**Use Cases**:
- Use case 1: [e.g., "Primary CTA buttons in forms"]
- Use case 2: [e.g., "Navigation menu items"]
- Use case 3: [e.g., "Confirmation dialogs"]

**When NOT to use**:
- [e.g., "For navigation links, use Link component instead"]
- [e.g., "For icon-only actions, use IconButton for better accessibility"]

---

## Visual Examples

### Default State
```
[Insert screenshot or ASCII mockup]
┌────────────────┐
│  Click Me      │  ← Primary button
└────────────────┘
```

### All Variants
| Variant | Screenshot | Use Case |
|---------|------------|----------|
| Primary | [Image] | Main action (save, submit, continue) |
| Secondary | [Image] | Secondary action (cancel, back) |
| Outline | [Image] | Tertiary action, lower emphasis |
| Ghost | [Image] | Minimal emphasis, inline actions |
| Danger | [Image] | Destructive actions (delete, remove) |

### States Matrix
| State | Visual | Description |
|-------|--------|-------------|
| Default | [Image] | Initial state |
| Hover | [Image] | Mouse over |
| Focus | [Image] | Keyboard focus (visible outline) |
| Active | [Image] | Pressed/clicked |
| Loading | [Image] | Async action in progress (spinner) |
| Disabled | [Image] | Non-interactive (grayed out) |

---

## API Reference

### Props (React/Vue)

```typescript
interface ButtonProps {
  /**
   * Visual style variant
   * @default 'primary'
   */
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger'
  
  /**
   * Size of the button
   * @default 'md'
   */
  size?: 'sm' | 'md' | 'lg'
  
  /**
   * Full width button (100% of container)
   * @default false
   */
  fullWidth?: boolean
  
  /**
   * Disabled state
   * @default false
   */
  disabled?: boolean
  
  /**
   * Loading state (shows spinner, disables interaction)
   * @default false
   */
  isLoading?: boolean
  
  /**
   * Icon to display before text (accepts React element)
   */
  leftIcon?: ReactNode
  
  /**
   * Icon to display after text
   */
  rightIcon?: ReactNode
  
  /**
   * Type attribute for HTML button
   * @default 'button'
   */
  type?: 'button' | 'submit' | 'reset'
  
  /**
   * Click handler
   */
  onClick?: (event: MouseEvent) => void
  
  /**
   * Text content or child elements
   */
  children: ReactNode
  
  /**
   * Additional CSS class names
   */
  className?: string
  
  /**
   * Accessibility label (for icon-only buttons)
   */
  'aria-label'?: string
}
```

### Size Specifications

| Size | Height | Padding (horizontal) | Font Size | Icon Size | Min Width |
|------|--------|---------------------|-----------|-----------|-----------|
| `sm` | 32px | 12px | 14px | 16px | 64px |
| `md` | 40px | 16px | 16px | 20px | 80px |
| `lg` | 48px | 24px | 18px | 24px | 96px |

### Color Tokens Used

| Variant | Token | Value |
|---------|-------|-------|
| Primary background | `--color-action-primary` | #3B82F6 |
| Primary hover | `--color-action-primary-hover` | #2563EB |
| Primary text | `--color-text-inverse` | #FFFFFF |
| Secondary background | `--color-gray-700` | #3F3F46 |
| Disabled background | `--color-gray-200` | #E4E4E7 |
| Disabled text | `--color-gray-400` | #A1A1AA |

---

## Usage Examples

### Basic Usage (React)

```tsx
import { Button } from '@/components/Button'

export function Example() {
  return (
    <Button variant="primary" onClick={() => alert('Clicked!')}>
      Save Changes
    </Button>
  )
}
```

### With Icons

```tsx
import { Button } from '@/components/Button'
import { SaveIcon, ChevronRightIcon } from '@/components/icons'

export function Example() {
  return (
    <div className="flex gap-4">
      {/* Left icon */}
      <Button variant="primary" leftIcon={<SaveIcon />}>
        Save
      </Button>
      
      {/* Right icon */}
      <Button variant="outline" rightIcon={<ChevronRightIcon />}>
        Next
      </Button>
    </div>
  )
}
```

### Loading State

```tsx
import { Button } from '@/components/Button'
import { useState } from 'react'

export function Example() {
  const [isLoading, setIsLoading] = useState(false)
  
  const handleSubmit = async () => {
    setIsLoading(true)
    await saveData()
    setIsLoading(false)
  }
  
  return (
    <Button 
      variant="primary" 
      isLoading={isLoading}
      onClick={handleSubmit}
    >
      {isLoading ? 'Saving...' : 'Save'}
    </Button>
  )
}
```

### Full Width (Mobile-First)

```tsx
<Button variant="primary" fullWidth>
  Continue to Checkout
</Button>
```

### Composition Pattern (Advanced)

```tsx
import { Button, ButtonGroup } from '@/components/Button'

export function Example() {
  return (
    <ButtonGroup>
      <Button variant="outline">Cancel</Button>
      <Button variant="primary">Save Draft</Button>
      <Button variant="primary">Publish</Button>
    </ButtonGroup>
  )
}
```

---

## Accessibility

### WCAG 2.1 Level AA Compliance

#### Keyboard Interactions
| Key | Action |
|-----|--------|
| `Tab` | Move focus to/from button |
| `Shift + Tab` | Move focus backward |
| `Enter` or `Space` | Activate button |

#### Screen Reader Announcements
- **Default**: "Save Changes, button"
- **Loading**: "Save Changes, button, loading"
- **Disabled**: "Save Changes, button, dimmed, unavailable"

#### Focus Management
- **Visible focus indicator**: 2px solid outline with 2px offset
- **Color**: `--color-action-primary` (blue) for contrast
- **Preserved on click**: Focus remains after activation (don't blur programmatically)

#### Color Contrast
| Element | Foreground | Background | Contrast Ratio | WCAG AA |
|---------|------------|------------|----------------|---------|
| Primary button text | #FFFFFF | #3B82F6 | 4.5:1 | ✅ Pass |
| Disabled button text | #A1A1AA | #E4E4E7 | 3.2:1 | ⚠️ Pass (UI component) |
| Outline button text | #3F3F46 | #FFFFFF | 12.6:1 | ✅ Pass |

#### ARIA Attributes

**Icon-only buttons** (MANDATORY):
```tsx
<Button variant="ghost" aria-label="Close dialog">
  <CloseIcon />
</Button>
```

**Loading state** (automatic):
```tsx
<Button isLoading aria-busy="true">
  Saving...
</Button>
```

**Disabled state**:
```tsx
<Button disabled aria-disabled="true">
  Submit
</Button>
```

### Testing Checklist

- [ ] **Keyboard navigation**: Tab reaches button, Enter/Space activates
- [ ] **Screen reader**: NVDA/VoiceOver announces role, state, label correctly
- [ ] **Contrast**: All text meets 4.5:1 ratio (WebAIM checker)
- [ ] **Focus visible**: Outline clearly visible on all backgrounds
- [ ] **Touch target**: Minimum 44x44px (iOS/Android guidelines)
- [ ] **Loading state**: Spinner visible, click disabled, screen reader announces "loading"

---

## Implementation Notes

### CSS Architecture

**File structure** (CSS Modules):
```
Button/
├── Button.tsx
├── Button.module.css
├── Button.test.tsx
└── Button.stories.tsx
```

**Base styles** (Button.module.css):
```css
.button {
  /* Reset browser defaults */
  appearance: none;
  border: none;
  background: none;
  
  /* Layout */
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: var(--space-2);
  
  /* Typography */
  font-family: var(--font-family-sans);
  font-weight: var(--font-weight-medium);
  
  /* Interaction */
  cursor: pointer;
  user-select: none;
  
  /* Transition */
  transition: all var(--motion-duration-fast) var(--motion-easing-easeOut);
  
  /* Accessibility */
  outline: none; /* Custom focus style below */
}

.button:focus-visible {
  outline: 2px solid var(--color-action-primary);
  outline-offset: 2px;
}

.button:disabled {
  cursor: not-allowed;
  opacity: 0.6;
}
```

### State Management

**Controlled vs Uncontrolled**:
- Button is **controlled** when parent manages `isLoading` state
- Button is **uncontrolled** when it handles click without state

**Loading state UX**:
```tsx
// ✅ GOOD: Preserve button width during loading
<Button isLoading style={{ minWidth: '120px' }}>
  {isLoading ? 'Saving...' : 'Save Changes'}
</Button>

// ❌ BAD: Button width jumps (layout shift)
<Button isLoading>
  {isLoading ? <Spinner /> : 'Save'}
</Button>
```

### Performance

**Bundle size**: 2.3 KB (minified + gzipped)  
**Runtime overhead**: Negligible (no complex logic)  
**Render optimization**: Memoized with `React.memo` (equality check on props)

---

## Testing

### Unit Tests (Jest + React Testing Library)

```tsx
import { render, screen, fireEvent } from '@testing-library/react'
import { Button } from './Button'

describe('Button', () => {
  test('renders with text', () => {
    render(<Button>Click Me</Button>)
    expect(screen.getByRole('button', { name: 'Click Me' })).toBeInTheDocument()
  })
  
  test('calls onClick when clicked', () => {
    const handleClick = jest.fn()
    render(<Button onClick={handleClick}>Click</Button>)
    fireEvent.click(screen.getByRole('button'))
    expect(handleClick).toHaveBeenCalledTimes(1)
  })
  
  test('does not call onClick when disabled', () => {
    const handleClick = jest.fn()
    render(<Button disabled onClick={handleClick}>Click</Button>)
    fireEvent.click(screen.getByRole('button'))
    expect(handleClick).not.toHaveBeenCalled()
  })
  
  test('shows loading spinner when isLoading=true', () => {
    render(<Button isLoading>Save</Button>)
    expect(screen.getByRole('button')).toHaveAttribute('aria-busy', 'true')
  })
})
```

### Visual Regression (Chromatic)

```tsx
// Button.stories.tsx
import type { Meta, StoryObj } from '@storybook/react'
import { Button } from './Button'

const meta: Meta<typeof Button> = {
  title: 'Components/Button',
  component: Button,
}
export default meta

type Story = StoryObj<typeof Button>

export const AllVariants: Story = {
  render: () => (
    <div className="flex flex-col gap-4">
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="outline">Outline</Button>
      <Button variant="ghost">Ghost</Button>
      <Button variant="danger">Danger</Button>
    </div>
  )
}

export const AllStates: Story = {
  render: () => (
    <div className="flex flex-col gap-4">
      <Button>Default</Button>
      <Button className="hover">Hover</Button>
      <Button isLoading>Loading</Button>
      <Button disabled>Disabled</Button>
    </div>
  )
}
```

---

## Migration Guide

### From v0.x to v1.0

**Breaking changes**:
1. `color` prop renamed to `variant`
   ```tsx
   // Before
   <Button color="blue">Save</Button>
   
   // After
   <Button variant="primary">Save</Button>
   ```

2. `loading` prop renamed to `isLoading`
   ```tsx
   // Before
   <Button loading={true}>Save</Button>
   
   // After
   <Button isLoading={true}>Save</Button>
   ```

3. `icon` prop split into `leftIcon` and `rightIcon`
   ```tsx
   // Before
   <Button icon={<SaveIcon />}>Save</Button>
   
   // After
   <Button leftIcon={<SaveIcon />}>Save</Button>
   ```

**Codemod available**: Run `npx @myds/codemod button-v0-to-v1 ./src`

---

## Related Components

- **IconButton**: For icon-only buttons with circular shape
- **Link**: For navigation actions (use `<a>` semantics)
- **ButtonGroup**: Container for related button actions
- **SplitButton**: Button with primary action + dropdown menu

---

## Changelog

### v1.0.0 (2026-09-27) - Stable Release
- ✅ All variants implemented (primary, secondary, outline, ghost, danger)
- ✅ WCAG 2.1 AA compliant
- ✅ Keyboard navigation tested
- ✅ Screen reader tested (NVDA, VoiceOver)
- ✅ Visual regression baseline captured (Chromatic)

### v0.9.0 (2026-09-20) - Beta
- Added loading state with spinner
- Added icon support (left/right)
- Fixed focus outline visibility

### v0.8.0 (2026-09-13) - Alpha
- Initial implementation
- Basic variants only

---

## Support & Feedback

**Questions**: Post in #design-system-help Slack channel  
**Bug reports**: [GitHub Issues](https://github.com/company/design-system/issues)  
**Feature requests**: Submit RFC via [RFC template](./COMPONENT_RFC_TEMPLATE.md)  
**Maintainer**: @design-system-team
