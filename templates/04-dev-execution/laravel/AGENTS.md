# AI Agent Guidelines - Laravel Project

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
