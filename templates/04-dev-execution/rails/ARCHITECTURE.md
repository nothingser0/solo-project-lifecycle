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
│   │       ├── auth_controller.rb
│   │       └── documents_controller.rb
│   └── concerns/        # Controller mixins
├── helpers/             # View helpers
├── jobs/                # ActiveJob background jobs
├── mailers/             # ActionMailer email templates
├── models/
│   ├── application_record.rb
│   ├── user.rb
│   ├── document.rb
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
├── schema.rb            # Current database schema
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

Refer to `docs/specs/FSD.md` for complete DDL.

### Example Models

```ruby
# app/models/user.rb
class User < ApplicationRecord
  has_secure_password
  
  has_many :documents, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[admin manager staff] }
  
  enum role: { admin: 0, manager: 1, staff: 2 }
end

# app/models/document.rb
class Document < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true, length: { maximum: 255 }
  validates :status, presence: true, inclusion: { in: %w[DRAFT SIGNED ARCHIVED] }
  
  enum status: { draft: 0, signed: 1, archived: 2 }
  
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
end
```

### Migrations

```ruby
# db/migrate/20261003_create_users.rb
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.integer :role, null: false, default: 2
      
      t.timestamps
    end
  end
end

# db/migrate/20261003_create_documents.rb
class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid, index: true
      t.string :title, null: false
      t.integer :status, null: false, default: 0
      
      t.timestamps
    end
    
    add_index :documents, :status
  end
end
```

---

## Routing (RESTful API)

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      post 'auth/login', to: 'auth#create'
      delete 'auth/logout', to: 'auth#destroy'
      
      # Resources
      resources :documents, only: [:index, :show, :create, :update, :destroy]
      
      # Custom routes
      post 'documents/:id/sign', to: 'documents#sign'
    end
  end
  
  # Health check
  get 'health', to: 'health#show'
end
```

---

## Controllers (RESTful Actions)

```ruby
# app/controllers/api/v1/auth_controller.rb
module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]
      
      def create
        user = User.find_by(email: auth_params[:email])
        
        if user&.authenticate(auth_params[:password])
          session[:user_id] = user.id
          render json: { user: user.as_json(only: [:id, :email, :role]) }, status: :ok
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end
      
      def destroy
        session.delete(:user_id)
        head :no_content
      end
      
      private
      
      def auth_params
        params.require(:auth).permit(:email, :password)
      end
    end
  end
end

# app/controllers/api/v1/documents_controller.rb
module Api
  module V1
    class DocumentsController < ApplicationController
      before_action :set_document, only: [:show, :update, :destroy, :sign]
      
      def index
        @documents = current_user.documents.recent
        render json: @documents
      end
      
      def show
        render json: @document
      end
      
      def create
        @document = current_user.documents.build(document_params)
        
        if @document.save
          render json: @document, status: :created
        else
          render json: { errors: @document.errors }, status: :unprocessable_entity
        end
      end
      
      def update
        if @document.update(document_params)
          render json: @document
        else
          render json: { errors: @document.errors }, status: :unprocessable_entity
        end
      end
      
      def destroy
        @document.destroy
        head :no_content
      end
      
      def sign
        if @document.update(status: :signed)
          render json: @document
        else
          render json: { errors: @document.errors }, status: :unprocessable_entity
        end
      end
      
      private
      
      def set_document
        @document = current_user.documents.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Document not found' }, status: :not_found
      end
      
      def document_params
        params.require(:document).permit(:title, :status)
      end
    end
  end
end
```

---

## Background Jobs (ActiveJob)

```ruby
# app/jobs/send_notification_job.rb
class SendNotificationJob < ApplicationJob
  queue_as :default
  
  def perform(user_id, message)
    user = User.find(user_id)
    # Send notification logic
  end
end

# Usage in controller:
SendNotificationJob.perform_later(user.id, "Document signed")
```

---

## Services (Business Logic)

```ruby
# lib/services/document_encryption_service.rb
module Services
  class DocumentEncryptionService
    def initialize(document)
      @document = document
    end
    
    def encrypt
      # AES-256-GCM encryption logic
    end
    
    def decrypt
      # Decryption logic
    end
  end
end

# Usage:
Services::DocumentEncryptionService.new(document).encrypt
```

---

## Environment Variables

```ruby
# config/initializers/environment.rb
ENV['DATABASE_URL']
ENV['SECRET_KEY_BASE']
ENV['REDIS_URL']
ENV['AWS_ACCESS_KEY_ID']
ENV['AWS_SECRET_ACCESS_KEY']
ENV['AWS_REGION']
ENV['S3_BUCKET']
```

See `.env.example` for complete list.

---

## Testing Structure

```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
  
  describe 'associations' do
    it { should have_many(:documents).dependent(:destroy) }
  end
end

# spec/requests/api/v1/auth_spec.rb
require 'rails_helper'

RSpec.describe 'Api::V1::Auth', type: :request do
  describe 'POST /api/v1/auth/login' do
    let(:user) { create(:user, email: 'test@example.com', password: 'password123') }
    
    context 'with valid credentials' do
      it 'returns user data and sets session' do
        post '/api/v1/auth/login', params: { auth: { email: user.email, password: 'password123' } }
        
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['user']['email']).to eq(user.email)
      end
    end
    
    context 'with invalid credentials' do
      it 'returns unauthorized' do
        post '/api/v1/auth/login', params: { auth: { email: user.email, password: 'wrong' } }
        
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
```

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
