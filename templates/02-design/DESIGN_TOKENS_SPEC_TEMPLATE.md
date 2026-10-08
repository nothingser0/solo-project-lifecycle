# Design Tokens Specification

**Project Name**: [Your Project Name]  
**Version**: v1.0.0  
**Last Updated**: [YYYY-MM-DD]  
**Maintainer**: [Design System Team]  
**Repository**: [GitHub URL to tokens repo]

---

## Overview

This document defines the single source of truth for all design tokens used across [Product Name]. Tokens are organized in **two layers**:
1. **Primitive tokens**: Raw values (hex colors, px sizes)
2. **Semantic tokens**: Purpose-driven mappings to primitive tokens

**Token Naming Convention**: `[category]-[property]-[variant]-[state]`

**Supported Platforms**:
- ✅ Web (CSS Custom Properties)
- ✅ React Native (JavaScript module)
- ✅ iOS (Swift enums)
- ✅ Android (XML resources)
- ✅ Flutter (Dart constants)

---

## 1. Color Tokens

### 1.1 Primitive Colors (Raw Values)

#### Gray Scale
```json
{
  "color": {
    "primitive": {
      "gray": {
        "50": "#FAFAFA",
        "100": "#F4F4F5",
        "200": "#E4E4E7",
        "300": "#D4D4D8",
        "400": "#A1A1AA",
        "500": "#71717A",
        "600": "#52525B",
        "700": "#3F3F46",
        "800": "#27272A",
        "900": "#18181B"
      }
    }
  }
}
```

**CSS Output**:
```css
:root {
  --color-gray-50: #FAFAFA;
  --color-gray-100: #F4F4F5;
  --color-gray-200: #E4E4E7;
  --color-gray-300: #D4D4D8;
  --color-gray-400: #A1A1AA;
  --color-gray-500: #71717A;
  --color-gray-600: #52525B;
  --color-gray-700: #3F3F46;
  --color-gray-800: #27272A;
  --color-gray-900: #18181B;
}
```

#### Brand Colors
```json
{
  "color": {
    "primitive": {
      "blue": {
        "50": "#EFF6FF",
        "100": "#DBEAFE",
        "200": "#BFDBFE",
        "300": "#93C5FD",
        "400": "#60A5FA",
        "500": "#3B82F6",
        "600": "#2563EB",
        "700": "#1D4ED8",
        "800": "#1E40AF",
        "900": "#1E3A8A"
      }
    }
  }
}
```

#### Semantic Colors (Feedback States)
```json
{
  "color": {
    "primitive": {
      "red": {
        "50": "#FEF2F2",
        "500": "#EF4444",
        "700": "#B91C1C"
      },
      "green": {
        "50": "#F0FDF4",
        "500": "#22C55E",
        "700": "#15803D"
      },
      "yellow": {
        "50": "#FEFCE8",
        "500": "#EAB308",
        "700": "#A16207"
      }
    }
  }
}
```

### 1.2 Semantic Colors (Purpose-Driven Mappings)

```json
{
  "color": {
    "semantic": {
      "text": {
        "primary": "{color.primitive.gray.900}",
        "secondary": "{color.primitive.gray.600}",
        "tertiary": "{color.primitive.gray.500}",
        "disabled": "{color.primitive.gray.400}",
        "inverse": "{color.primitive.white}"
      },
      "background": {
        "primary": "{color.primitive.white}",
        "secondary": "{color.primitive.gray.50}",
        "tertiary": "{color.primitive.gray.100}",
        "inverse": "{color.primitive.gray.900}",
        "overlay": "rgba(0, 0, 0, 0.5)"
      },
      "border": {
        "default": "{color.primitive.gray.200}",
        "strong": "{color.primitive.gray.300}",
        "subtle": "{color.primitive.gray.100}"
      },
      "action": {
        "primary": "{color.primitive.blue.500}",
        "primary-hover": "{color.primitive.blue.600}",
        "primary-active": "{color.primitive.blue.700}",
        "secondary": "{color.primitive.gray.700}",
        "secondary-hover": "{color.primitive.gray.800}"
      },
      "feedback": {
        "error": "{color.primitive.red.500}",
        "error-bg": "{color.primitive.red.50}",
        "success": "{color.primitive.green.500}",
        "success-bg": "{color.primitive.green.50}",
        "warning": "{color.primitive.yellow.500}",
        "warning-bg": "{color.primitive.yellow.50}",
        "info": "{color.primitive.blue.500}",
        "info-bg": "{color.primitive.blue.50}"
      }
    }
  }
}
```

**CSS Output (Semantic)**:
```css
:root {
  --color-text-primary: var(--color-gray-900);
  --color-text-secondary: var(--color-gray-600);
  --color-bg-primary: #FFFFFF;
  --color-border-default: var(--color-gray-200);
  --color-action-primary: var(--color-blue-500);
  --color-action-primary-hover: var(--color-blue-600);
  --color-feedback-error: var(--color-red-500);
}
```

### 1.3 Dark Mode Tokens

```json
{
  "color": {
    "semantic": {
      "dark": {
        "text-primary": "{color.primitive.gray.50}",
        "text-secondary": "{color.primitive.gray.400}",
        "bg-primary": "{color.primitive.gray.900}",
        "bg-secondary": "{color.primitive.gray.800}",
        "border-default": "{color.primitive.gray.700}"
      }
    }
  }
}
```

**CSS Output (Dark Mode)**:
```css
@media (prefers-color-scheme: dark) {
  :root {
    --color-text-primary: var(--color-gray-50);
    --color-text-secondary: var(--color-gray-400);
    --color-bg-primary: var(--color-gray-900);
    --color-bg-secondary: var(--color-gray-800);
    --color-border-default: var(--color-gray-700);
  }
}
```

---

## 2. Typography Tokens

### 2.1 Font Families

```json
{
  "font": {
    "family": {
      "sans": "Inter, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif",
      "mono": "'JetBrains Mono', 'Fira Code', Consolas, monospace",
      "serif": "'Merriweather', Georgia, serif"
    }
  }
}
```

### 2.2 Font Sizes (Type Scale)

```json
{
  "font": {
    "size": {
      "xs": "0.75rem",      /* 12px */
      "sm": "0.875rem",     /* 14px */
      "base": "1rem",       /* 16px */
      "lg": "1.125rem",     /* 18px */
      "xl": "1.25rem",      /* 20px */
      "2xl": "1.5rem",      /* 24px */
      "3xl": "1.875rem",    /* 30px */
      "4xl": "2.25rem",     /* 36px */
      "5xl": "3rem",        /* 48px */
      "6xl": "3.75rem"      /* 60px */
    }
  }
}
```

### 2.3 Font Weights

```json
{
  "font": {
    "weight": {
      "normal": "400",
      "medium": "500",
      "semibold": "600",
      "bold": "700"
    }
  }
}
```

### 2.4 Line Heights

```json
{
  "font": {
    "lineHeight": {
      "tight": "1.2",      /* Headings */
      "normal": "1.5",     /* Body text */
      "relaxed": "1.75"    /* Marketing copy */
    }
  }
}
```

### 2.5 Letter Spacing

```json
{
  "font": {
    "letterSpacing": {
      "tight": "-0.01em",
      "normal": "0",
      "wide": "0.05em"
    }
  }
}
```

### 2.6 Semantic Typography (Text Styles)

```json
{
  "text": {
    "heading-1": {
      "fontFamily": "{font.family.sans}",
      "fontSize": "{font.size.4xl}",
      "fontWeight": "{font.weight.bold}",
      "lineHeight": "{font.lineHeight.tight}",
      "letterSpacing": "{font.letterSpacing.tight}"
    },
    "heading-2": {
      "fontFamily": "{font.family.sans}",
      "fontSize": "{font.size.3xl}",
      "fontWeight": "{font.weight.bold}",
      "lineHeight": "{font.lineHeight.tight}"
    },
    "body": {
      "fontFamily": "{font.family.sans}",
      "fontSize": "{font.size.base}",
      "fontWeight": "{font.weight.normal}",
      "lineHeight": "{font.lineHeight.normal}"
    },
    "caption": {
      "fontFamily": "{font.family.sans}",
      "fontSize": "{font.size.sm}",
      "fontWeight": "{font.weight.normal}",
      "lineHeight": "{font.lineHeight.normal}",
      "color": "{color.semantic.text.secondary}"
    },
    "code": {
      "fontFamily": "{font.family.mono}",
      "fontSize": "{font.size.sm}",
      "fontWeight": "{font.weight.normal}"
    }
  }
}
```

---

## 3. Spacing Tokens (8pt Grid)

```json
{
  "space": {
    "0": "0",
    "1": "0.125rem",    /* 2px */
    "2": "0.25rem",     /* 4px */
    "3": "0.5rem",      /* 8px */
    "4": "0.75rem",     /* 12px */
    "5": "1rem",        /* 16px */
    "6": "1.5rem",      /* 24px */
    "8": "2rem",        /* 32px */
    "10": "2.5rem",     /* 40px */
    "12": "3rem",       /* 48px */
    "16": "4rem",       /* 64px */
    "20": "5rem",       /* 80px */
    "24": "6rem"        /* 96px */
  }
}
```

**Usage Guidelines**:
- Use `space-3` (8px) as base increment
- Component padding: `space-5` or `space-6` (16px or 24px)
- Section gaps: `space-8` or `space-12` (32px or 48px)

---

## 4. Border Tokens

### 4.1 Border Widths

```json
{
  "border": {
    "width": {
      "none": "0",
      "thin": "1px",
      "medium": "2px",
      "thick": "4px"
    }
  }
}
```

### 4.2 Border Radius

```json
{
  "border": {
    "radius": {
      "none": "0",
      "sm": "0.125rem",    /* 2px */
      "base": "0.25rem",   /* 4px */
      "md": "0.375rem",    /* 6px */
      "lg": "0.5rem",      /* 8px */
      "xl": "0.75rem",     /* 12px */
      "2xl": "1rem",       /* 16px */
      "full": "9999px"     /* Pills/circles */
    }
  }
}
```

---

## 5. Shadow Tokens (Elevation)

```json
{
  "shadow": {
    "none": "none",
    "sm": "0 1px 2px 0 rgba(0, 0, 0, 0.05)",
    "base": "0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1)",
    "md": "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1)",
    "lg": "0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.1)",
    "xl": "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1)",
    "2xl": "0 25px 50px -12px rgba(0, 0, 0, 0.25)"
  }
}
```

**Semantic Shadows**:
```json
{
  "shadow": {
    "semantic": {
      "card": "{shadow.sm}",
      "dropdown": "{shadow.lg}",
      "modal": "{shadow.2xl}",
      "button-hover": "{shadow.md}"
    }
  }
}
```

---

## 6. Motion Tokens

### 6.1 Duration

```json
{
  "motion": {
    "duration": {
      "instant": "0ms",
      "fast": "100ms",
      "base": "200ms",
      "slow": "300ms",
      "slower": "500ms"
    }
  }
}
```

### 6.2 Easing Functions

```json
{
  "motion": {
    "easing": {
      "linear": "linear",
      "easeIn": "cubic-bezier(0.4, 0, 1, 1)",
      "easeOut": "cubic-bezier(0, 0, 0.2, 1)",
      "easeInOut": "cubic-bezier(0.4, 0, 0.2, 1)"
    }
  }
}
```

### 6.3 Semantic Motion

```json
{
  "motion": {
    "semantic": {
      "hover": {
        "duration": "{motion.duration.fast}",
        "easing": "{motion.easing.easeOut}"
      },
      "modal": {
        "duration": "{motion.duration.base}",
        "easing": "{motion.easing.easeInOut}"
      },
      "toast": {
        "duration": "{motion.duration.slow}",
        "easing": "{motion.easing.easeOut}"
      }
    }
  }
}
```

---

## 7. Responsive Breakpoints

```json
{
  "breakpoint": {
    "sm": "640px",
    "md": "768px",
    "lg": "1024px",
    "xl": "1280px",
    "2xl": "1536px"
  }
}
```

**CSS Output (Media Queries)**:
```css
:root {
  --breakpoint-sm: 640px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 1024px;
  --breakpoint-xl: 1280px;
}
```

---

## 8. Z-Index Tokens (Layering)

```json
{
  "zIndex": {
    "base": "0",
    "dropdown": "1000",
    "sticky": "1100",
    "modal": "1200",
    "popover": "1300",
    "tooltip": "1400",
    "toast": "1500"
  }
}
```

---

## 9. Platform-Specific Outputs

### 9.1 CSS Variables

**File**: `dist/css/variables.css`

Generated by Style Dictionary from `tokens/*.json`:

```css
:root {
  /* Colors */
  --color-gray-900: #18181B;
  --color-blue-500: #3B82F6;
  --color-text-primary: var(--color-gray-900);
  
  /* Typography */
  --font-family-sans: Inter, sans-serif;
  --font-size-base: 1rem;
  
  /* Spacing */
  --space-5: 1rem;
  
  /* Shadows */
  --shadow-card: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
}
```

### 9.2 iOS Swift

**File**: `dist/ios/DesignTokens.swift`

```swift
import UIKit

public struct DesignTokens {
    public struct Color {
        public static let textPrimary = UIColor(hex: 0x18181B)
        public static let actionPrimary = UIColor(hex: 0x3B82F6)
    }
    
    public struct Font {
        public static let familySans = "Inter"
        public static let sizeBase: CGFloat = 16.0
    }
    
    public struct Spacing {
        public static let space5: CGFloat = 16.0
    }
}
```

### 9.3 Android XML

**File**: `dist/android/tokens.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="color_text_primary">#18181B</color>
    <color name="color_action_primary">#3B82F6</color>
    
    <dimen name="font_size_base">16sp</dimen>
    <dimen name="space_5">16dp</dimen>
</resources>
```

### 9.4 Flutter Dart

**File**: `dist/flutter/design_tokens.dart`

```dart
import 'package:flutter/material.dart';

class DesignTokens {
  static const Color textPrimary = Color(0xFF18181B);
  static const Color actionPrimary = Color(0xFF3B82F6);
  
  static const double fontSizeBase = 16.0;
  static const double space5 = 16.0;
}
```

---

## 10. Token Versioning & Changelog

**Current Version**: v1.0.0  
**Release Date**: 2026-09-27

### Changelog

#### v1.0.0 (2026-09-27) - Initial Release
- ✅ Color tokens: 10 gray shades, brand colors, semantic mappings
- ✅ Typography: Type scale, font families, text styles
- ✅ Spacing: 8pt grid system
- ✅ Shadows: 6 elevation levels
- ✅ Motion: Duration and easing tokens
- ✅ Platform outputs: CSS, iOS, Android, Flutter

#### Future Roadmap
- [ ] Add high-contrast mode tokens
- [ ] Add themed variants (e-commerce, dashboard, marketing)
- [ ] Future major update: Rename color-action → color-interactive

---

## 11. Usage Examples

### Example 1: Button Component (React + CSS Variables)

```tsx
// Button.tsx
export function Button({ variant = 'primary', children }) {
  return (
    <button className={`btn btn-${variant}`}>
      {children}
    </button>
  )
}
```

```css
/* Button.css */
.btn {
  font-family: var(--font-family-sans);
  font-size: var(--font-size-base);
  padding: var(--space-3) var(--space-5);
  border-radius: var(--border-radius-base);
  transition: all var(--motion-duration-fast) var(--motion-easing-easeOut);
}

.btn-primary {
  background: var(--color-action-primary);
  color: var(--color-text-inverse);
}

.btn-primary:hover {
  background: var(--color-action-primary-hover);
  box-shadow: var(--shadow-button-hover);
}
```

### Example 2: Card Component (iOS Swift)

```swift
class CardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = DesignTokens.Border.radiusBase
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = DesignTokens.Shadow.card
        
        layoutMargins = UIEdgeInsets(
            top: DesignTokens.Spacing.space6,
            left: DesignTokens.Spacing.space6,
            bottom: DesignTokens.Spacing.space6,
            right: DesignTokens.Spacing.space6
        )
    }
}
```

---

## 12. Maintenance & Governance

**Token Approval Process**:
1. Propose new token via RFC (GitHub issue)
2. Design System Council review (3 working days)
3. Approved → Add to `tokens/*.json`
4. Run `pnpm run build:tokens` (Style Dictionary)
5. Publish new version to npm
6. Update this spec document

**Deprecation Policy**:
- 3-release warning period (v1.9 → v1.10 → v2.0)
- Migration guide published with deprecation announcement
- Console warnings in code during deprecation period

**Contact**: design-system@company.com
