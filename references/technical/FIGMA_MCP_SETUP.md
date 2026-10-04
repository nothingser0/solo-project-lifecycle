# Figma MCP Server Setup Guide

**Purpose**: Enable AI agents to read Figma design files directly and generate code from frames without manual export.

**When to use**: Teams with active designer, design system with frequent updates, Figma as single source of truth.

---

## Prerequisites

1. **Figma Account** with Professional plan ($15/mo)
2. **MCP-Compatible AI Client** (Claude Desktop, or listed in [Figma MCP Catalog](https://www.figma.com/mcp-catalog/))
3. **Personal Access Token** from Figma

---

## Step 1: Generate Figma Personal Access Token

### 1.1 Navigate to Settings
```
1. Open Figma desktop app or web
2. Click profile icon (top right) → Settings
3. Scroll to "Personal access tokens" section
```

### 1.2 Create New Token
```
1. Click "Generate new token"
2. Name: "MCP Server Access"
3. Expiration: No expiration (for long-term projects)
4. Scopes (select):
   ✅ File content - Read only
   ✅ Variables - Read only
   (Optional: Write scopes if using bidirectional sync)
5. Click "Generate token"
6. Copy token (starts with figd_...)
7. Store securely (cannot view again)
```

**Security Note**: Never commit tokens to git. Use environment variables or secure vaults.

---

## Step 2: Install Figma MCP Server

### Option A: Remote Server (Recommended)

**Pros**: No Figma desktop app required, connects to Figma's hosted endpoint, broadest feature set.

**Claude Desktop Setup** (macOS/Linux):

File: `~/Library/Application Support/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "figma": {
      "command": "npx",
      "args": [
        "-y",
        "@figma/mcp-server-figma@latest"
      ],
      "env": {
        "FIGMA_PERSONAL_ACCESS_TOKEN": "figd_YOUR_TOKEN_HERE"
      }
    }
  }
}
```

**Windows**:
File: `%APPDATA%\Claude\claude_desktop_config.json`

Same JSON config as above.

**Restart Claude Desktop** after saving config.

### Option B: Local Server (Enterprise/Gov)

**Use when**: Organization requires local-only execution, Figma for Government.

**Claude Desktop Setup**:

```json
{
  "mcpServers": {
    "figma-local": {
      "command": "node",
      "args": [
        "/path/to/figma-mcp-server/build/index.js"
      ],
      "env": {
        "FIGMA_ACCESS_TOKEN": "figd_YOUR_TOKEN_HERE"
      }
    }
  }
}
```

**Requirements**: Figma desktop app must be running.

See [Local Server Installation](https://developers.figma.com/docs/figma-mcp-server/local-server-installation/) for full setup.

---

## Step 3: Verify Connection

### 3.1 Test in Claude Desktop

```
User: "Can you connect to Figma?"

Claude should respond:
✅ "Yes, I have access to Figma MCP tools."

If error:
❌ "I don't have access to Figma tools"
→ Check config file syntax, token validity, restart app
```

### 3.2 List Available Tools

```
User: "What Figma tools do you have?"

Claude should list:
- figma_get_file_info
- figma_get_variables
- figma_get_node
- figma_get_components
- (write tools if enabled)
```

### 3.3 Test File Access

```
User: "Get info for Figma file ABC123DEF"

Claude calls: figma_get_file_info("ABC123DEF")

Expected response:
{
  "name": "Design System v2",
  "lastModified": "2026-10-03T12:34:56Z",
  "version": "1.2.3"
}

If error "File not found":
→ Check file key is correct (from Figma URL)
→ Token has access to file (check sharing settings)
```

---

## Usage Patterns

### Pattern 1: Extract Design System (M04)

**Scenario**: Generate DESIGN_SYSTEM.md from Figma variables.

```
User: "Extract design system from Figma file ABC123DEF"

AI workflow:
1. figma_get_file_info("ABC123DEF") → Get file name
2. figma_get_variables("ABC123DEF") → Get color/typography tokens
3. figma_get_components("ABC123DEF") → Get component library
4. Generate DESIGN_SYSTEM.md with extracted tokens
```

**Output**: `docs/specs/DESIGN_SYSTEM.md` with:
- Color palette (from Figma color variables)
- Typography scale (from Figma text styles)
- Spacing system (from Figma number variables)
- Component inventory (from Figma components)

### Pattern 2: Generate Code from Frame (M06)

**Scenario**: Convert Figma frame to React component.

```
User: "Generate Next.js component from Figma frame node-XYZ123 in file ABC123DEF"

AI workflow:
1. figma_get_node("ABC123DEF", "node-XYZ123") → Get frame structure
2. Parse layers, styles, layout
3. Read DESIGN_SYSTEM.md for token mapping
4. Generate React component with Tailwind classes
```

**Output**: `components/LoginForm.tsx` matching Figma design exactly.

### Pattern 3: Sync Design Changes

**Scenario**: Designer updates colors in Figma, sync to codebase.

```
User: "Check if Figma design system has changed since last sync"

AI workflow:
1. figma_get_file_info("ABC123DEF") → Check lastModified
2. Compare with local DESIGN_SYSTEM.md metadata
3. If changed: figma_get_variables("ABC123DEF")
4. Update DESIGN_SYSTEM.md with new tokens
5. Report changed tokens (e.g., "Primary color updated: #3B82F6 → #2563EB")
```

### Pattern 4: Document Screens from Figma

**Scenario**: Generate DESIGN_SPEC.md from Figma screens.

```
User: "Document all screens in Figma page 'User Flows'"

AI workflow:
1. figma_get_file_info("ABC123DEF") → Get pages
2. For each frame in "User Flows" page:
   - figma_get_node("ABC123DEF", frameId)
   - Extract: screen name, components used, layout
   - Document 5-state variants (if present)
3. Generate DESIGN_SPEC.md with screen specifications
```

---

## Troubleshooting

### Error: "Invalid token"
**Cause**: Token expired or incorrect.
**Fix**: Regenerate token in Figma settings, update config.

### Error: "File not found"
**Cause**: Token doesn't have access to file.
**Fix**: 
1. Check file key is correct (from Figma URL: figma.com/file/ABC123DEF/...)
2. Ensure file is shared with token owner
3. Check file isn't in private draft

### Error: "MCP server not responding"
**Cause**: Config file syntax error or missing npx.
**Fix**:
1. Validate JSON syntax (use jsonlint.com)
2. Ensure Node.js installed: `node --version`
3. Check npx available: `npx --version`
4. Restart MCP client (Claude Desktop)

### Error: "Rate limit exceeded"
**Cause**: Too many API calls.
**Fix**: Wait 60 seconds, then retry. Batch requests when possible.

---

## Security Best Practices

### 1. Token Storage
```bash
# ❌ DON'T: Hardcode in config (committed to git)
"FIGMA_PERSONAL_ACCESS_TOKEN": "figd_abc123..."

# ✅ DO: Use environment variable
"FIGMA_PERSONAL_ACCESS_TOKEN": "${FIGMA_TOKEN}"

# Set in shell:
export FIGMA_TOKEN="figd_abc123..."
```

### 2. Scope Limitation
- Use read-only scopes unless write operations needed
- Create separate tokens per project (easier revocation)
- Rotate tokens quarterly

### 3. Access Control
- Don't share tokens (each user generates own)
- Revoke tokens when team members leave
- Use Figma Enterprise SSO for centralized control

---

## Integration with Solo Project Lifecycle

### M04 (UI/UX Design)
```
Option E: Figma MCP
├─ Designer creates in Figma
├─ AI extracts design system via MCP
├─ Auto-generates DESIGN_SYSTEM.md
└─ No manual export needed
```

### M06 (Development)
```
Step 2: Static UI
├─ AI reads Figma frames via MCP
├─ Generates components matching design
├─ Uses tokens from DESIGN_SYSTEM.md
└─ Visual parity guaranteed
```

### Design System Updates
```
Designer changes primary color in Figma
  ↓
AI detects change via figma_get_variables()
  ↓
Updates DESIGN_SYSTEM.md
  ↓
Updates affected components
  ↓
Commits: "design: sync primary color from Figma"
```

---

## Comparison: Figma MCP vs Manual Export

| Aspect | Manual Export (Option D) | Figma MCP (Option E) |
|:-------|:-------------------------|:---------------------|
| **Setup** | None | 10 minutes (config + token) |
| **Token export** | Manual (copy colors) | Automatic (query variables) |
| **Sync frequency** | On demand (manual) | Real-time (query anytime) |
| **Code generation** | Read specs → write code | Frame → code (AI interprets) |
| **Design changes** | Re-export manually | Query latest automatically |
| **Offline work** | ✅ Yes (after export) | ❌ No (requires API) |
| **Best for** | One-time designs | Active iteration |

---

## References

- **Official Docs**: https://developers.figma.com/docs/figma-mcp-server/
- **MCP Catalog**: https://www.figma.com/mcp-catalog/
- **Model Context Protocol**: https://modelcontextprotocol.io/
- **API Reference**: https://developers.figma.com/docs/api/
- **Community Forum**: https://forum.figma.com/

---

**Last Updated**: 2026-10-04  
**MCP Server Version**: @figma/mcp-server-figma@latest  
**Tested with**: Claude Desktop, MCP-compatible clients
