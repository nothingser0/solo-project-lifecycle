# Ruby on Rails Coding Conventions

## Naming Conventions

### Files & Directories
- **snake_case** for all files: `user_profile.rb`, `document_controller.rb`
- **Models**: Singular, CamelCase class (`User`), snake_case file (`user.rb`)
- **Controllers**: Plural, CamelCase class (`UsersController`), snake_case file (`users_controller.rb`)
- **Migrations**: Timestamped, descriptive (`20261003120000_create_users.rb`)

### Ruby Code
- **Classes/Modules**: PascalCase (`UserProfile`, `Api::V1`)
- **Methods/Variables**: snake_case (`find_user`, `user_email`)
- **Constants**: SCREAMING_SNAKE_CASE (`MAX_LOGIN_ATTEMPTS`, `DEFAULT_ROLE`)
- **Booleans**: Prefix with `is_`, `has_`, or `can_` (`is_active?`, `has_permission?`)

## Code Structure

### Controllers
```ruby
# RESTful actions order
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  
  def index; end
  def show; end
  def new; end
  def create; end
  def edit; end
  def update; end
  def destroy; end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:email, :role)
  end
end
```

### Models
```ruby
# Order: constants, associations, validations, scopes, callbacks, methods
class User < ApplicationRecord
  # Constants
  ROLES = %w[admin manager staff].freeze
  
  # Associations
  has_many :documents, dependent: :destroy
  
  # Validations
  validates :email, presence: true, uniqueness: true
  
  # Scopes
  scope :active, -> { where(active: true) }
  
  # Callbacks
  before_create :set_default_role
  
  # Class methods
  def self.find_by_email(email)
    where(email: email).first
  end
  
  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end
  
  private
  
  def set_default_role
    self.role ||= 'staff'
  end
end
```

## Database Conventions

### Foreign Keys
```ruby
# Always add foreign key constraints
add_reference :documents, :user, foreign_key: true, type: :uuid
```

### Indexes
```ruby
# Add indexes for:
# - Foreign keys (if not added automatically)
# - Columns used in WHERE clauses
# - Unique constraints
add_index :users, :email, unique: true
add_index :documents, :status
add_index :documents, [:user_id, :created_at]
```

### Column Types
- **Primary keys**: UUID (configure in `config/application.rb`)
- **Timestamps**: Always include `t.timestamps` in migrations
- **Enums**: Use integers, define in model (`enum role: { admin: 0, manager: 1 }`)
- **Boolean**: Default to `false`, not null (`t.boolean :active, default: false, null: false`)

## Testing Conventions

### RSpec Structure
```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
  end
  
  describe 'associations' do
    it { should have_many(:documents) }
  end
  
  describe '#full_name' do
    it 'returns first and last name' do
      user = create(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end
end
```

### Factories (FactoryBot)
```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    role { 'staff' }
    
    trait :admin do
      role { 'admin' }
    end
  end
end
```

## API Response Format

### Success Response
```ruby
# Single resource
render json: { user: user.as_json(only: [:id, :email, :role]) }, status: :ok

# Collection
render json: { users: users.as_json(only: [:id, :email]), meta: { total: users.count } }, status: :ok
```

### Error Response
```ruby
# Validation errors
render json: { errors: user.errors.full_messages }, status: :unprocessable_entity

# Not found
render json: { error: 'User not found' }, status: :not_found

# Unauthorized
render json: { error: 'Invalid credentials' }, status: :unauthorized
```

## Security Best Practices

### Strong Parameters
```ruby
# Always use strong parameters
def user_params
  params.require(:user).permit(:email, :password, :role)
end
```

### Authentication
```ruby
# Use has_secure_password
class User < ApplicationRecord
  has_secure_password
end

# Session-based authentication
session[:user_id] = user.id
```

### Authorization
```ruby
# Check ownership before actions
def set_document
  @document = current_user.documents.find(params[:id])
end
```

## Performance Guidelines

### N+1 Query Prevention
```ruby
# ❌ Bad: N+1 queries
users = User.all
users.each { |user| puts user.documents.count }

# ✅ Good: Eager loading
users = User.includes(:documents)
users.each { |user| puts user.documents.count }
```

### Database Indexes
```ruby
# Add indexes for frequently queried columns
add_index :documents, :user_id
add_index :documents, :status
add_index :documents, [:user_id, :status]
```

### Caching
```ruby
# Fragment caching in views
<% cache @user do %>
  <%= render @user %>
<% end %>

# Low-level caching
Rails.cache.fetch("user-#{user.id}", expires_in: 1.hour) do
  user.expensive_calculation
end
```

## Gem Management

### Adding Gems
```ruby
# Gemfile - group by purpose
gem 'rails', '~> 7.0'
gem 'pg', '~> 1.1'

group :development, :test do
  gem 'rspec-rails', '~> 6.0'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'rubocop-rails', require: false
end
```

### Version Pinning
```ruby
# Use pessimistic versioning for stability
gem 'devise', '~> 4.9'  # Allows 4.9.x, not 5.0

# Exact version for critical dependencies
gem 'sidekiq', '7.1.5'
```

## Code Quality

### RuboCop
```yaml
# .rubocop.yml
AllCops:
  TargetRubyVersion: 3.2
  NewCops: enable

Style/StringLiterals:
  EnforcedStyle: single_quotes

Metrics/MethodLength:
  Max: 20

Metrics/ClassLength:
  Max: 150
```

### Code Review Checklist
- [ ] No N+1 queries (check with `bullet` gem)
- [ ] All routes use strong parameters
- [ ] Tests cover happy path + edge cases
- [ ] No secrets in code (use credentials or ENV)
- [ ] Foreign keys have indexes
- [ ] No raw SQL (use ActiveRecord)

## Rails Commands Reference

```bash
# Development
rails server              # Start dev server
rails console             # Open Rails console
rails routes              # List all routes

# Database
rails db:create           # Create database
rails db:migrate          # Run pending migrations
rails db:rollback         # Rollback last migration
rails db:seed             # Load seed data
rails db:reset            # Drop, create, migrate, seed

# Generators
rails generate model User email:string
rails generate controller Users index show
rails generate migration AddRoleToUsers role:integer

# Testing
bundle exec rspec                    # Run all tests
bundle exec rspec spec/models        # Run model tests only
bundle exec rspec spec/models/user_spec.rb:10  # Run specific line

# Code Quality
bundle exec rubocop                  # Run linter
bundle exec rubocop -a               # Auto-correct offenses
bundle exec brakeman                 # Security scanner
bundle exec bundle-audit             # Check gem vulnerabilities
```

## Deployment

### Asset Compilation
```bash
RAILS_ENV=production rails assets:precompile
```

### Database Migration
```bash
RAILS_ENV=production rails db:migrate
```

### Environment Variables
- Use `rails credentials:edit` for secrets
- Or set ENV variables in hosting platform
- Never commit `.env` or `config/master.key`

## Anti-Patterns to Avoid

### ❌ Fat Controllers
```ruby
# Bad: Business logic in controller
def create
  @user = User.new(user_params)
  @user.send_welcome_email
  @user.create_default_settings
  @user.log_creation
  @user.save
end

# Good: Delegate to service or model
def create
  @user = UserCreationService.new(user_params).call
end
```

### ❌ Bypassing Validations
```ruby
# Bad: Skip validations
user.save(validate: false)
user.update_column(:email, 'invalid')

# Good: Fix validation errors
user.save  # Returns false if invalid
errors = user.errors.full_messages
```

### ❌ String Interpolation in Queries
```ruby
# Bad: SQL injection risk
User.where("email = '#{params[:email]}'")

# Good: Parameterized query
User.where(email: params[:email])
User.where("email = ?", params[:email])
```
