# AI Agent Guidelines - Laravel Project

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Framework Docs**: Check version-specific pages for current API
- **ORM Docs**: Database query syntax, migrations, relationships
- **Validation Docs**: Input validation, form handling

**Why**: Framework syntax changes between versions. This project uses specific versions locked in FSD.md.

**When uncertain about syntax:**
1. Read official docs for installed version
2. Check migration guides for breaking changes
3. Verify with tests before committing

## CRITICAL: Read Project Design Specifications

**BEFORE implementing any UI component, read project design docs in docs/ folder:**

- **docs/specs/DESIGN_SYSTEM.md**: Design tokens, screen specifications, component styles
- **docs/specs/SITEMAP.md**: Route structure with Screen IDs (SCR-XX)
- **docs/design/stitch-output/**: Generated screen components (if using Google Stitch)
- **DESIGN.md** (root): Simplified tokens reference (copied from docs/)

**Why**: Generic styles ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in docs/specs/SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding section in docs/specs/DESIGN_SYSTEM.md
3. Check docs/design/stitch-output/SCR-09/ if available
4. Extract design tokens from DESIGN.md (root)
5. Implement exactly as specified

---
## Code Style Rules
1. **PSR-12 Standard**: Follow PHP-FIG coding standards.
2. **Eloquent Only**: No raw SQL queries. Use Eloquent ORM.
3. **File Naming**: PascalCase for classes (`UserController.php`), kebab-case for views (`user-profile.blade.php`).
4. **Validation**: Use Form Requests (`php artisan make:request StoreUserRequest`).
5. **No Magic Numbers**: Use config files (`config/app.php`) or constants.

## Database
- ORM: Eloquent (built-in)
- Migrations: `php artisan migrate`
- Seeding: `php artisan db:seed`

## Testing
- Run: `php artisan test` (PHPUnit)
- Must pass before commit

## Build Commands
- Dev: `php artisan serve`
- Build Assets: `npm run build` (Vite)
- Queue: `php artisan queue:work`

## Commit Format
```
feat: add user profile endpoint
fix: resolve token validation bug
refactor: extract payment service
```

## Anti-Patterns (NEVER)
- ❌ No raw SQL queries (use Eloquent)
- ❌ No logic in controllers (use Services/Actions)
- ❌ No hardcoded credentials
- ❌ No dd() or var_dump() in committed code
- ❌ No mass assignment without $fillable
