# ARCHITECTURE.md - Laravel Project

> Technical architecture, directory layout, database schema, and API contracts

---

## System Topology

```text
[ Client (Browser/Mobile) ]
        │
        ▼ (HTTPS / JSON API)
    [ Laravel App ]
        │
   ┌────┴────┬────────┐
   ▼         ▼        ▼
[ MySQL ]  [ Redis ] [ S3 ]
```

---

## Directory Structure

```text
docs/
├── specs/                    # Technical specifications (from M04-M05)
│   ├── PRD.md                # Product requirements
│   ├── FSD.md                # Functional specification
│   ├── SITEMAP.md            # Screen inventory with IDs
│   └── DESIGN_SYSTEM.md      # Design tokens & component specs
├── design/                   # Design artifacts (optional)
│   ├── prototype-output/        # Generated screens from Interactive Prototype (if used)
│   │   ├── SCR-01/           # Landing page components
│   │   ├── SCR-06/           # Login screen components
│   │   └── ...               # One folder per Screen ID
│   └── references/           # Design inspiration (optional)
│       ├── competitors/      # Competitor screenshots
│       └── brand/            # Brand assets, guidelines
└── pm/                       # Project management docs

app/
├── Http/
│   ├── Controllers/         # HTTP request handlers
│   ├── Requests/           # Form request validation
│   └── Middleware/         # Request/response filters
├── Models/                 # Eloquent ORM models
├── Services/              # Business logic layer
└── Jobs/                  # Queue jobs

routes/
├── api.php                # API routes
└── web.php               # Web routes

database/
├── migrations/           # Database schema
└── seeders/             # Sample data

resources/
└── views/               # Blade templates

config/                  # Configuration files
```

---

## Database Schema

Refer to `docs/specs/FSD.md` for complete schema.

Key tables:
- **users**: Authentication, roles
- **[domain_entity]**: Core business entities

Migration naming: `YYYY_MM_DD_HHMMSS_create_[table]_table.php`

---

## API Routes

| Endpoint | Method | Middleware | Controller Method | Response |
|----------|--------|------------|-------------------|----------|
| `/api/auth/login` | POST | - | AuthController@login | 200 + token |
| `/api/[resource]` | GET | auth:api | [Resource]Controller@index | 200 + array |
| `/api/[resource]` | POST | auth:api | [Resource]Controller@store | 201 + object |
| `/api/[resource]/{id}` | GET | auth:api | [Resource]Controller@show | 200 |
| `/api/[resource]/{id}` | PUT | auth:api | [Resource]Controller@update | 200 |
| `/api/[resource]/{id}` | DELETE | auth:api | [Resource]Controller@destroy | 204 |

---

## Middleware Stack

```php
Route::middleware(['auth:sanctum'])->group(function () {
    Route::apiResource('users', UserController::class);
});
```

---

## Security Rules

1. **Eloquent ORM**: No raw SQL queries
2. **Mass Assignment Protection**: Define `$fillable` or `$guarded`
3. **API Authentication**: Laravel Sanctum tokens
4. **Input Validation**: Form Requests for all mutations
5. **CSRF Protection**: Enabled for web routes
