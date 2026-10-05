# Interactive Prototype Input Prompts

> **Purpose**: Pre-written prompts for each screen to generate UI via Interactive Prototype MCP tools.

## Usage

1. Fill out sitemap in `DESIGN_SPEC.md` (list all screens with Screen IDs)
2. For each screen, create a prompt file: `SCR-01-landing.txt`, `SCR-02-dashboard.txt`, etc.
3. Use MCP tool `prototype_generate_screen_from_text` with prompt content

## Prompt Template Structure

Each prompt file should follow this format:

```
Generate [Screen Name] (Screen ID: SCR-XX) for [Project Name]:

CONTENT:
- [Section 1]: [Content description]
- [Section 2]: [Content description]
- [Section 3]: [Content description]

DATA CONTEXT:
- [Domain/industry description]
- [Currency/locale]
- [User persona]

DESIGN CONSTRAINTS (ANTI-SLOP):
- Colors: [from DESIGN.md token palette]
- Typography: [font family, sizes]
- Components: [button style, card style, input style]
- Layout: [grid/flex, spacing scale]
- No: [banned patterns - heavy shadows, gradients, etc.]

STRICT RULES:
- Use exact color codes from DESIGN.md
- Follow [Component Library] patterns
- Maintain [spacing scale]
- [Accessibility requirements]
```

## Example Files

Create one file per screen:

```
prompt-input/
├── SCR-01-landing.txt          # Landing page
├── SCR-02-login.txt            # Login screen
├── SCR-03-dashboard.txt        # Main dashboard
├── SCR-04-settings.txt         # Settings page
└── ...
```

## Anti-Slop Guidelines

Always include these constraints to prevent generic AI output:

- **Color Palette**: Specify exact hex codes from design tokens
- **Typography**: Specify font family, weights, sizes
- **Component Style**: Describe button radius, border width, shadow depth
- **Layout Grid**: Specify column count, gap sizes
- **Banned Patterns**: List what NOT to use (e.g., "No purple gradients, no floating cards, no heavy drop-shadows")

## MCP Tool Usage

```typescript
// Example: Generate screen from prompt file
const prompt = fs.readFileSync('prompt-input/SCR-01-landing.txt', 'utf-8');
await tool.prototype_generate_screen_from_text({
  projectId: 'projects/[PROJECT_ID]',
  screenId: 'SCR-01',
  prompt: prompt
});
```

---

**Note**: Interactive Prototype is optional. You can skip this folder and implement screens directly in code using DESIGN.md + DESIGN_SPEC.md as reference.
