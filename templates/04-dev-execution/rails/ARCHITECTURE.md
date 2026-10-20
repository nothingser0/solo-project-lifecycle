# Rails Project Architecture

**Framework**: Ruby on Rails 7.x/8.x
**Last Updated**: Check `Gemfile.lock` for exact versions

---

## Folder Structure

```
app/
├── assets/
│   ├── images/          # Static images
│   ├── stylesheets/     # CSS/SCSS files
│   └── javascript/      # JS files (if using import maps)
├── channels/            # ActionCable channels (WebSocket)
├── controllers/
│   ├── application_controller.rb
│   ├── api/
│   │   └── v1/          # API versioning
│   └── concerns/        # Controller mixins
├── helpers/             # View helpers
├── jobs/                # ActiveJob background jobs
├── mailers/             # ActionMailer email templates
├── models/
│   ├── application_record.rb
│   └── concerns/        # Model mixins
├── views/
│   ├── layouts/
│   │   └── application.html.erb
│   ├── api/
│   │   └── v1/          # JSON views (if using Jbuilder)
│   └── shared/          # Partial templates

config/
├── application.rb       # Application configuration
├── database.yml         # Database connection settings
├── routes.rb            # Route definitions
├── environments/
│   ├── development.rb
│   ├── test.rb
│   └── production.rb
└── initializers/        # Framework initializers

db/
├── migrate/             # Database migrations
├── schema.rb            # Current database schema (auto-generated)
└── seeds.rb             # Seed data

lib/
├── tasks/               # Custom Rake tasks
└── services/            # Business logic services

spec/ (or test/)
├── models/
├── controllers/
├── requests/            # Integration tests
└── rails_helper.rb
```

---

## Database Schema (ActiveRecord)

**Complete schema in `docs/specs/FSD.md`**

Models, migrations, and relationships generated from FSD table definitions.

### Model Pattern

```ruby
# app/models/{model_name}.rb
class {ModelName} < ApplicationRecord
  # Associations (from FSD foreign keys)
  has_many :{related_models}, dependent: :destroy
  belongs_to :{parent_model}
  
  # Validations (from FSD constraints)
  validates :{column}, presence: true
  validates :{column}, uniqueness: true
  
  # Enums (from FSD enum types)
  enum {status_column}: { draft: 0, published: 1 }
  
  # Scopes (common queries)
  scope :recent, -> { order(created_at: :desc) }
end
```

### Migration Pattern

```ruby
# db/migrate/{timestamp}_create_{table_name}.rb
class Create{TableName} < ActiveRecord::Migration[7.0]
  def change
    create_table :{table_name}, id: :uuid do |t|
      # Columns from FSD DDL
      t.string :{column_name}, null: false
      t.references :{foreign_key}, foreign_key: true, type: :uuid, index: true
      
      t.timestamps
    end
    
    # Indexes from FSD
    add_index :{table_name}, :{indexed_column}
  end
end
```

**Generate models from FSD.md schema definitions**

---

## Routing (RESTful API)

**Complete API contract in `docs/specs/FSD.md`**

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Resources from FSD endpoints
      resources :{resource_name}, only: [:index, :show, :create, :update, :destroy]
      
      # Custom actions from FSD
      post '{resource}/:id/{action}', to: '{resource}#{action}'
    end
  end
  
  # Health check
  get 'health', to: 'health#show'
end
```

**Generate routes from FSD.md API endpoint specifications**

---

## Controllers (RESTful Actions)

```ruby
# app/controllers/api/v1/{resource}_controller.rb
module Api
  module V1
    class {Resource}Controller < ApplicationController
      before_action :set_{resource}, only: [:show, :update, :destroy]
      
      def index
        @{resources} = current_user.{resources}
        render json: @{resources}
      end
      
      def show
        render json: @{resource}
      end
      
      def create
        @{resource} = current_user.{resources}.build({resource}_params)
        
        if @{resource}.save
          render json: @{resource}, status: :created
        else
          render json: { errors: @{resource}.errors }, status: :unprocessable_entity
        end
      end
      
      def update
        if @{resource}.update({resource}_params)
          render json: @{resource}
        else
          render json: { errors: @{resource}.errors }, status: :unprocessable_entity
        end
      end
      
      def destroy
        @{resource}.destroy
        head :no_content
      end
      
      private
      
      def set_{resource}
        @{resource} = current_user.{resources}.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: '{Resource} not found' }, status: :not_found
      end
      
      def {resource}_params
        params.require(:{resource}).permit({permitted_attributes})
      end
    end
  end
end
```

**Generate controllers from FSD.md endpoint specifications**

---

## Background Jobs (ActiveJob)

```ruby
# app/jobs/{job_name}_job.rb
class {JobName}Job < ApplicationJob
  queue_as :default
  
  def perform({arguments})
    # Background task logic
  end
end

# Usage:
{JobName}Job.perform_later({arguments})
```

---

## Services (Business Logic)

```ruby
# lib/services/{service_name}_service.rb
module Services
  class {ServiceName}Service
    def initialize({dependencies})
      @{dependency} = {dependency}
    end
    
    def call
      # Business logic implementation
    end
  end
end

# Usage:
Services::{ServiceName}Service.new({args}).call
```

---

## Environment Variables

**See `.env.example` for complete list**

Required configuration:
- `DATABASE_URL`: PostgreSQL connection string
- `SECRET_KEY_BASE`: Rails secret (generate with `rails secret`)
- `REDIS_URL`: Redis for ActionCable/Sidekiq (if applicable)
- External service credentials (AWS, SMTP, etc.)

---

## Testing Structure

```ruby
# spec/models/{model}_spec.rb
require 'rails_helper'

RSpec.describe {Model}, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:{attribute}) }
  end
  
  describe 'associations' do
    it { should have_many(:{related_models}) }
  end
end

# spec/requests/api/v1/{resource}_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::{Resource}', type: :request do
  describe 'POST /api/v1/{resources}' do
    context 'with valid params' do
      it 'creates {resource}' do
        post '/api/v1/{resources}', params: { {resource}: valid_attributes }
        
        expect(response).to have_http_status(:created)
      end
    end
  end
end
```

**Generate tests from FSD.md API contracts**

---

## Deployment Checklist

- [ ] Precompile assets: `rails assets:precompile`
- [ ] Run migrations: `rails db:migrate RAILS_ENV=production`
- [ ] Set `SECRET_KEY_BASE` in production
- [ ] Configure database connection in `database.yml`
- [ ] Set up Redis for ActionCable/caching (if used)
- [ ] Configure CORS if frontend is separate domain
- [ ] Set up SSL/TLS certificates
- [ ] Configure environment variables in hosting platform

---

**For complete schema**: See `docs/specs/FSD.md`  
**For API contracts**: See `docs/specs/FSD.md` endpoint specifications  
**For security requirements**: See `docs/specs/FSD.md` security specifications
