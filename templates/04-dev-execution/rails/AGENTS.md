# AI Agent Guidelines - Ruby on Rails Project

## CRITICAL: Read Official Documentation First

**BEFORE implementing any feature, check official docs for current syntax:**

- **Rails Docs**: https://guides.rubyonrails.org/ (check version-specific guides)
- **Ruby Docs**: https://ruby-doc.org/
- **ActiveRecord**: https://guides.rubyonrails.org/active_record_basics.html
- **RSpec**: https://rspec.info/ (if using RSpec for testing)

**Why**: Rails conventions evolve between versions. This project uses:
- Rails 7.x or 8.x (check Gemfile.lock for exact version)
- Breaking changes exist between major versions (6.x vs 7.x vs 8.x)

### Version-Specific Syntax Enforcement

**MANDATORY: Check docs before using these APIs** (syntax changes frequently):

| API Category | Docs URL | Common Version Conflicts |
|:-------------|:---------|:-------------------------|
| **ActiveRecord Queries** | https://guides.rubyonrails.org/active_record_querying.html | Query methods evolve per version |
| **Migrations** | https://guides.rubyonrails.org/active_record_migrations.html | Column types, modifiers change |
| **Routes** | https://guides.rubyonrails.org/routing.html | Namespace syntax evolves |
| **Controllers** | https://guides.rubyonrails.org/action_controller_overview.html | Strong params patterns |
| **Views/Helpers** | https://guides.rubyonrails.org/action_view_overview.html | Helper methods change |
| **ActiveStorage** | https://guides.rubyonrails.org/active_storage_overview.html | Attachment API evolves |

**Red Flags (Outdated Patterns):**

❌ **Rails 5.x Patterns (DO NOT USE)**:
```ruby
# ❌ OLD: before_filter (Rails 4/5)
before_filter :authenticate_user

# ✅ NEW: before_action (Rails 6+)
before_action :authenticate_user
```

❌ **Deprecated Syntax (Verify Current Docs)**:
```ruby
# If you encounter errors with familiar patterns:
# 1. Check Rails guides for your version
# 2. Read upgrade guide: https://guides.rubyonrails.org/upgrading_ruby_on_rails.html
# 3. Verify syntax hasn't changed

# Example: ActiveRecord where syntax still works in 7.x/8.x
User.where(email: 'test@example.com') # ✅ Valid
```

**Enforcement Rules**:
1. **Before using any API**: Search Rails guides for exact method name
2. **Check version**: Run `bundle exec rails -v` to confirm installed version
3. **Run `bundle show rails`**: Confirm exact Rails gem version
4. **If syntax error**: Update code to match docs, not vice versa
5. **Read upgrade guide**: https://guides.rubyonrails.org/upgrading_ruby_on_rails.html

## CRITICAL: Read Project Design Specifications

**BEFORE implementing any UI component, read project design docs in docs/ folder:**

- **docs/specs/DESIGN_SYSTEM.md**: Design tokens, screen specifications, component styles
- **docs/specs/SITEMAP.md**: Route structure with Screen IDs (SCR-XX)
- **docs/design/prototype-output/**: Generated screen components (if using Interactive Prototype)
- **DESIGN.md** (root): Simplified tokens reference (copied from docs/)

**Why**: Generic Tailwind/Bootstrap ≠ project design. Must match brand identity.

**For each screen/component:**
1. Find screen ID in docs/specs/SITEMAP.md (e.g., SCR-09 Dashboard)
2. Read corresponding section in docs/specs/DESIGN_SYSTEM.md
3. Check docs/design/prototype-output/SCR-09/ if available
4. Extract design tokens from DESIGN.md (root):
   - Primary brand color (not generic neutral)
   - Shadow style (flat border vs heavy shadow)
   - Typography scale (specific font weights/sizes)
5. Implement exactly as specified

**Anti-Pattern:**
❌ `class="btn btn-primary"` (generic Bootstrap)
✅ `class="bg-primary-600 text-white px-4 py-2 rounded"` (brand primary from docs/specs/DESIGN_SYSTEM.md)

---

## Code Style Rules
1. **Ruby Style Guide**: Follow community conventions (snake_case for methods/variables).
2. **Rails Conventions**: RESTful routes, fat models/thin controllers, DRY principle.
3. **File Naming**: snake_case for all Ruby files (`user_profile.rb`).
4. **ActiveRecord**: Use ORM for all database queries (no raw SQL unless absolutely necessary).
5. **Strong Parameters**: Always use strong params in controllers for mass assignment protection.

## Database
- **ORM**: ActiveRecord (built-in)
- **Migrations**: `rails generate migration AddColumnToTable` then `rails db:migrate`
- **Seeding**: `db/seeds.rb` with `rails db:seed`
- **Foreign Keys**: Always add foreign key constraints in migrations
- **Indexes**: Add indexes on foreign keys and frequently queried columns

## Testing
- **Framework**: RSpec (preferred) or Minitest (Rails default)
- **Run**: `bundle exec rspec` or `rails test`
- **Coverage**: Use SimpleCov for test coverage reports
- **Must pass before commit**

## Security
- **Strong Parameters**: Required for all controller actions accepting params
- **SQL Injection**: ActiveRecord prevents this by default (don't use string interpolation in queries)
- **XSS Protection**: Rails escapes output by default in ERB templates
- ❌ No secrets in version control (use `credentials.yml.enc` or ENV variables)
- ❌ No raw SQL unless sanitized with `ActiveRecord::Base.sanitize_sql`

## Build Commands
- **Dev**: `rails server` or `bin/dev` (if using Procfile)
- **Console**: `rails console`
- **Migrations**: `rails db:migrate`
- **Rollback**: `rails db:rollback`
- **Seed**: `rails db:seed`
- **Routes**: `rails routes` (view all routes)

## Dependencies
- **Install**: `bundle install`
- **Add Gem**: Edit `Gemfile`, then `bundle install`
- **Update**: `bundle update gem_name`
- **Audit**: `bundle audit` (check for security vulnerabilities)
