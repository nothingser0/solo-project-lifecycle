# AI Agent Guidelines - JAMstack Project

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Astro**: https://docs.astro.build/
- **11ty (Eleventy)**: https://www.11ty.dev/docs/
- **Next.js (Static)**: https://nextjs.org/docs/pages/building-your-application/rendering/static-site-generation
- **Content APIs**: Check your CMS documentation (Contentful, Sanity, etc.)

**Why**: Static site generators evolve independently. This project uses:
- Check package.json for framework and version
- Static generation at build time (no server-side rendering)

### Version-Specific Syntax Enforcement

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Astro Components** | https://docs.astro.build/en/core-concepts/astro-components/ | Component syntax evolves |
| **11ty Data Files** | https://www.11ty.dev/docs/data/ | Data cascade changes |
| **Content Collections** | https://docs.astro.build/en/guides/content-collections/ | Schema syntax (Astro) |
| **Markdown Processing** | Framework-specific | MDX vs Markdown differences |

**Enforcement Rules**:
1. All data fetching happens at build time
2. No server-side runtime (API routes served separately)
3. Check framework version before using new features
4. Use framework-specific image optimization

## Anti-AI-Slop Directives (ENFORCED)
1. **BANNED: Redundant Explanatory Comments** — do not narrate obvious code.
   - ❌ `// Increment counter`  |  `// Import React`
   - ❌ Stub comments: `// TODO: implement this later`  |  `// Add your logic here`
   - ✅ Comment ONLY non-obvious business logic, domain formulas, or deliberate workarounds.
   - ✅ Never leave commented-out dead code — delete it (git remembers).
2. **BANNED: Silent Failures** — no empty catch/except blocks; log, rethrow, or return a typed error.
3. **BANNED: Dead Code & Unused Imports** — remove unused variables, imports, and unreachable branches.
4. **RACE CONDITIONS (MANDATORY for any shared-state mutation)** — protect every read-modify-write on inventory, balances, counters, booking slots, or status transitions:
   - Use a DB transaction + row lock (SELECT ... FOR UPDATE), or a unique constraint / idempotency key.
   - Never "check then act" across two separate queries without a lock or constraint.
   - Webhooks and payment callbacks MUST be idempotent (dedupe on provider event ID).
   - Frontend: disable the submit button while pending + use an idempotency key to prevent double-submit.
5. **BANNED: Hallucinated APIs/Packages** — verify every import exists before using it.

---

## Code Style Rules
1. **TypeScript**: Use for type safety in data fetching
2. **Components**: Framework-specific (Astro, React, Vue, etc.)
3. **File Naming**: kebab-case for routes, PascalCase for components
4. **Static Assets**: Place in public/ directory
5. **Build Output**: Optimized HTML/CSS/JS in dist/

## Content Management
- **Markdown**: Use frontmatter for metadata
- **CMS Integration**: Fetch at build time via API
- **Images**: Use framework image optimization
- **No Database**: All content from files or API at build

## Testing
- **Unit**: Vitest or Jest for component logic
- **Build**: Verify dist/ output generates correctly
- **Links**: Check for broken links in generated HTML

## Security
- **No Backend**: No server vulnerabilities
- **Static Output**: Pre-rendered at build time
- **API Keys**: Only use at build time (not exposed to client)
- **XSS**: Framework escapes by default

## Build Commands
- **Dev**: `npm run dev` (local preview server)
- **Build**: `npm run build` (generate static site)
- **Preview**: `npm run preview` (preview production build)
- **Deploy**: Upload dist/ to CDN (Vercel, Netlify, Cloudflare Pages)
