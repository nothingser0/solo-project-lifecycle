# Figma MCP Server Setup Guide

**Purpose**: Connect AI coding agents (Claude Code, Cursor, VS Code) to Figma files for live design sync.

**Official Docs**: https://developers.figma.com/docs/figma-mcp-server/

---

## Prerequisites

1. **Figma Account** (Professional/Enterprise plan)
2. **MCP-Compatible Client**: Claude Code, Cursor, VS Code, Codex, or Xcode
3. **MCP Config** (if not already set globally in `~/.omp`)

**Supported Clients**: https://www.figma.com/mcp-catalog/

---

## Installation

### Option 1: Using MCP Config (Global Setup)

**If MCP already configured globally** (e.g., in `~/.omp`):

Figma MCP server is already available. Skip to [Usage](#usage-in-solo-project-lifecycle).

### Option 2: Install per Client

#### Claude Code

**Recommended**: Install Figma plugin (includes MCP + skills):
```bash
claude plugin install figma@claude-plugins-official
```

**Manual setup**:
```bash
# Add Figma MCP server (project scope)
claude mcp add --transport http figma https://mcp.figma.com/mcp

# Or add globally (user scope - available in all projects)
claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp
```

**Authenticate**:
1. Start Claude Code
2. Type `/mcp` → Select **figma** → **Authenticate**
3. Browser opens → Click **Allow Access**
4. Confirmation: "Authentication successful. Connected to figma"

#### Cursor

**Recommended**: Install Figma plugin:
```
/add-plugin figma
```

Or visit: cursor://anysphere.cursor-deeplink/plugin/add?id=657

**Manual setup**:
1. Click deep link: cursor://anysphere.cursor-deeplink/mcp/install?name=Figma&config=eyJ1cmwiOiJodHRwczovL21jcC5maWdtYS5jb20vbWNwIn0%3D
2. Click **Install**
3. Click **Connect** → **Open** → **Allow access**

#### VS Code

**Quick install**: Install [Figma MCP extension](vscode:mcp/by-name/com.figma.mcp/mcp)

**Manual setup**:
1. Open Command Palette (⌘ Shift P)
2. Run: **MCP: Open User Configuration** (global) or **MCP: Open Workspace Folder MCP Configuration** (project)
3. Create/edit `mcp.json`:
```json
{
  "inputs": [],
  "servers": {
    "figma": {
      "url": "https://mcp.figma.com/mcp",
      "type": "http"
    }
  }
}
```
4. Click **Start** → **Allow Access**

#### Codex (OpenAI)

**Via Codex app**:
1. Open Codex app → **Plugins** → Click **+** next to Figma
2. Click **Install Figma** → **Allow access**

**Via CLI**:
```bash
codex mcp add figma --url https://mcp.figma.com/mcp
```

#### Xcode (macOS only)

**Recommended**: One-click setup:
```
xcode://agent-plugin-clone?repo=https%3A%2F%2Fgithub.com%2Ffigma%2Fmcp-server-guide
```

**Manual**:
1. Xcode → **Settings** → **Intelligence** → **Plug-ins**
2. **Add plug-in** → **Add from URL**
3. Enter: `https://github.com/figma/mcp-server-guide`
4. Authorize Figma account

---

## Authentication

**OAuth Flow** (not personal access tokens):

1. MCP client prompts authentication
2. Browser opens Figma OAuth page
3. Click **Allow Access**
4. Returns to MCP client
5. Confirmation message appears

**No manual token needed** - OAuth handles authorization automatically.

---

## Available Tools

**Read Tools** (Design → Code):
```
get_design_context      - Get design context for layer/frame (React+Tailwind default)
get_metadata            - XML outline of selection (sparse structure)
get_screenshot          - Screenshot of selection
download_assets         - Export assets (PNG/SVG/PDF/JPG, original source images)
get_variable_defs       - Variables and styles used in selection
get_motion_context      - Keyframe animation data
get_figjam              - FigJam diagram metadata (XML)
get_libraries           - List subscribed libraries
search_design_system    - Search libraries for components/variables/styles
whoami                  - Current user identity
```

**Write Tools** (Code → Design):
```
use_figma               - General-purpose create/edit/inspect (Design/FigJam/Slides)
generate_figma_design   - Send live UI to Figma (capture web app)
generate_diagram        - Generate FigJam diagram from Mermaid
create_new_file         - Create blank Design/FigJam/Slides file
upload_assets           - Upload images to Figma file
```

**Full tool reference**: https://developers.figma.com/docs/figma-mcp-server/tools-and-prompts/

---

## Usage in Solo Project Lifecycle

### M04: UI/UX Design (Extract Design System)

**Scenario**: Generate DESIGN_SYSTEM.md from Figma file.

```bash
# User provides Figma link
User: "Extract design system from https://figma.com/file/ABC123DEF/Design-System"

# AI calls MCP tools
AI: get_design_context(nodeId from URL)
    → Extracts colors, typography, spacing, components
    
# Auto-generates DESIGN_SYSTEM.md
docs/specs/DESIGN_SYSTEM.md:
  - Color palette (from Figma variables)
  - Typography scale (from text styles)
  - Spacing system (from layout)
  - Component inventory (buttons, inputs, cards)
```

**Prompt example**:
```
"Extract the design system from https://figma.com/file/ABC123/... 
and generate DESIGN_SYSTEM.md with colors, typography, and components"
```

### M04: Document Screens

**Scenario**: Generate DESIGN_SPEC.md from Figma screens.

```bash
User: "Document the Login screen from https://figma.com/file/ABC123/.../node-XYZ"

AI: get_design_context(file="ABC123", nodeId="node-XYZ")
    → Gets frame structure, components, layout
    
# Generates DESIGN_SPEC.md entry
## Screen: Login (SCR-06)
- Layout: Vertical stack, centered
- Components: EmailInput, PasswordInput, Button (primary)
- States: Default, Loading, Error, Success
```

### M06: Generate Code from Figma

**Scenario**: Convert Figma frame to React component.

```bash
User: "Generate Next.js component from https://figma.com/file/ABC123/.../node-XYZ"

AI: get_design_context(file="ABC123", nodeId="node-XYZ")
    → Returns React + Tailwind code
    
# Output: components/LoginForm.tsx
export function LoginForm() {
  return (
    <form className="flex flex-col gap-4 p-6 bg-white rounded-lg shadow-sm">
      <input type="email" className="px-4 py-2 border rounded-md" />
      <input type="password" className="px-4 py-2 border rounded-md" />
      <button className="px-4 py-2 bg-primary-600 text-white rounded-md">
        Login
      </button>
    </form>
  );
}
```

**Custom framework**:
```
"Generate Vue component from Figma frame using components from src/ui/"
"Generate iOS SwiftUI view from this Figma frame"
```

### M06: Sync Design Changes

**Scenario**: Designer updates colors in Figma, sync to codebase.

```bash
User: "Check if design system has changed since last commit"

AI: get_variable_defs(file="ABC123", nodeId="root")
    → Compares with DESIGN_SYSTEM.md metadata
    → Detects primary color changed: #3B82F6 → #2563EB
    
# Updates files
- DESIGN_SYSTEM.md: Update primary color
- tailwind.config.ts: Update primary-600 value
- Commit: "design: sync primary color from Figma"
```

### Code → Design (Reverse Flow)

**Scenario**: Send live UI to Figma.

```bash
User: "Capture my local app at http://localhost:3000 and send to Figma"

AI: generate_figma_design(url="http://localhost:3000")
    → Creates new Figma file with captured UI
    → Returns Figma file URL
```

---

## Prompting Patterns

### Link-Based Prompting

**How it works**: Copy Figma URL, paste in prompt.

```bash
# Figma URL format:
https://figma.com/file/{fileKey}/{fileName}?node-id={nodeId}

# AI extracts:
- fileKey: ABC123DEF
- nodeId: 1-234

# Calls: get_design_context(file="ABC123DEF", nodeId="1-234")
```

**Example prompts**:
```
"Implement this design: https://figma.com/file/ABC123/...?node-id=1-234"
"Generate code for https://figma.com/file/ABC123/.../node-XYZ in Vue"
"Extract colors from https://figma.com/file/ABC123/Design-System"
```

### Framework Control

**Default**: React + Tailwind CSS

**Change framework**:
```bash
"generate in Vue"
"generate in plain HTML + CSS"
"generate in iOS SwiftUI"
"generate in Android Jetpack Compose"
```

### Component Reuse

**Use existing components**:
```bash
"generate using components from src/components/ui"
"generate with Shadcn UI components"
"use my custom Button and Input components"
```

### Best Output Quality

**1. Set up Code Connect** (maps Figma components → your code):
- Links Figma components to codebase components
- AI reuses actual code instead of generating from scratch
- Setup: https://developers.figma.com/docs/code-connect/

**2. Add custom rules** (guide agent behavior):
- Example: "Always use semantic HTML"
- Example: "Use Tailwind classes, no inline styles"
- Docs: https://developers.figma.com/docs/figma-mcp-server/add-custom-rules/

---

## Troubleshooting

### Error: "Authentication failed"
**Cause**: OAuth not completed or expired.
**Fix**: 
1. Re-run authentication flow
2. Check MCP client has Figma server enabled
3. Restart MCP client

### Error: "MCP server not responding"
**Cause**: Server not connected.
**Fix**:
1. Check MCP config has `"url": "https://mcp.figma.com/mcp"`
2. Verify authentication completed
3. Restart MCP client
4. Check network connectivity

### Error: "File not found"
**Cause**: Invalid file key or no access.
**Fix**:
1. Verify Figma URL has correct file key
2. Check file sharing settings (need view/edit access)
3. Ensure file isn't in private drafts

---

## MCP vs Manual Export Comparison

| Aspect | Manual Export (Option D) | Figma MCP (Option E) |
|:-------|:-------------------------|:---------------------|
| **Setup** | None | 5-10 minutes (OAuth) |
| **Auth** | None | OAuth browser flow |
| **Token export** | Manual (copy colors) | Automatic (query variables) |
| **Sync frequency** | On demand (manual) | Real-time (query anytime) |
| **Code generation** | Read specs → write code | Frame → code (AI interprets) |
| **Design changes** | Re-export manually | Query latest automatically |
| **Offline work** | ✅ Yes (after export) | ❌ No (requires API) |
| **Clients** | Any | Claude Code, Cursor, VS Code, Codex, Xcode |
| **Best for** | One-time handoff | Active collaboration |

---

## References

- **Figma MCP Docs**: https://developers.figma.com/docs/figma-mcp-server/
- **Tools Reference**: https://developers.figma.com/docs/figma-mcp-server/tools-and-prompts/
- **Supported Clients**: https://www.figma.com/mcp-catalog/
- **Code Connect**: https://developers.figma.com/docs/code-connect/
- **Custom Rules**: https://developers.figma.com/docs/figma-mcp-server/add-custom-rules/

---

**Last Updated**: 2026-10-04  
**MCP Server**: https://mcp.figma.com/mcp (remote)  
**Auth**: OAuth browser flow  
**Supported Clients**: Claude Code, Cursor, VS Code, Codex, Xcode
