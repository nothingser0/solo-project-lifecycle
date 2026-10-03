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


## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Laravel Docs**: https://laravel.com/docs (check version-specific pages)
- **PHP Docs**: https://www.php.net/manual/en/
- **Eloquent ORM**: https://laravel.com/docs/eloquent

**Why**: Laravel syntax changes between versions. This project uses:
- Laravel 11.x (check composer.json for exact version)
- Breaking changes exist between major versions (10.x vs 11.x)

### Version-Specific Syntax Enforcement

**MANDATORY: Check docs before using these APIs** (syntax changes frequently):

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **Routing** | https://laravel.com/docs/routing | Resource routes syntax evolves |
| **Eloquent Relationships** | https://laravel.com/docs/eloquent-relationships | Eager loading changes |
| **Validation** | https://laravel.com/docs/validation | Rule syntax changes per version |
| **Middleware** | https://laravel.com/docs/middleware | Registration method changes |
| **Blade Templates** | https://laravel.com/docs/blade | Component syntax evolves |
| **Migrations** | https://laravel.com/docs/migrations | Column types added/deprecated |

**Red Flags (Outdated Patterns):**

❌ **Laravel 8/9 Patterns (DO NOT USE)**:
```php
// ❌ OLD: Route model binding (pre-11.x)
Route::get('/user/{user}', function (User $user) { });

// ✅ NEW: Check docs for current syntax
// Syntax may have evolved in 11.x
```

**Enforcement Rules**:
1. **Before using any API**: Search Laravel docs for exact method name
2. **Check version dropdown**: Verify docs match composer.json version
3. **Run `composer show laravel/framework`**: Confirm installed version
4. **If syntax error**: Update code to match docs, not vice versa

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
