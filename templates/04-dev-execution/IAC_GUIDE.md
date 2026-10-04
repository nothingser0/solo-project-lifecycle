# Infrastructure as Code (IaC) Guide

> **Purpose**: Manage infrastructure through code for Enterprise projects  
> **When**: M05 Architecture (before infrastructure provisioning)  
> **Target**: Enterprise projects requiring reproducible, auditable infrastructure

---

## What is Infrastructure as Code?

**Definition**: Manage and provision infrastructure through machine-readable definition files, not manual processes.

**Benefits**:
- **Reproducible**: Spin up identical environments (dev, staging, prod)
- **Version Controlled**: Track infrastructure changes in Git
- **Auditable**: See who changed what and when
- **Automated**: Deploy infrastructure with CI/CD
- **Documented**: Code is documentation

---

## IaC Tools

### Terraform (Recommended for Multi-Cloud)
**Pros**:
- Cloud-agnostic (AWS, GCP, Azure)
- Large ecosystem (providers for everything)
- State management (tracks resources)

**Cons**:
- Learning curve
- State file management complexity

**Use When**: Multi-cloud or need flexibility

---

### AWS CloudFormation (AWS Only)
**Pros**:
- Native AWS integration
- Free (built into AWS)
- Drift detection

**Cons**:
- AWS-only (vendor lock-in)
- YAML/JSON verbose

**Use When**: AWS-only infrastructure

---

### Pulumi (Code-First)
**Pros**:
- Use real programming languages (TypeScript, Python, Go)
- Type safety, IDE autocomplete
- Familiar dev experience

**Cons**:
- Newer (smaller community)
- Requires programming knowledge

**Use When**: Developers want to use TypeScript/Python

---

## Terraform Quick Start

### Project Structure

```
infrastructure/
├── main.tf              # Main configuration
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values (not committed)
├── backend.tf           # State backend config
├── modules/
│   ├── networking/      # VPC, subnets, etc.
│   ├── compute/         # EC2, ECS, etc.
│   ├── database/        # RDS, DynamoDB
│   └── monitoring/      # CloudWatch, alarms
└── environments/
    ├── dev/
    ├── staging/
    └── production/
```

---

### Example: AWS Infrastructure

**main.tf**:
```hcl
# Provider configuration
provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
  
  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# RDS Database
resource "aws_db_instance" "postgres" {
  identifier        = "${var.project_name}-db"
  engine            = "postgres"
  engine_version    = "16.1"
  instance_class    = var.db_instance_class
  allocated_storage = 100
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.project_name}-final-snapshot"
  
  tags = {
    Environment = var.environment
  }
}

# Security Group for Database
resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "Allow PostgreSQL traffic"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public.id]
}
```

---

**variables.tf**:
```hcl
variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, production)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
```

---

**terraform.tfvars** (not committed):
```hcl
project_name       = "myapp"
environment        = "production"
aws_region         = "us-east-1"
db_instance_class  = "db.r5.large"
db_name            = "myapp_prod"
db_username        = "admin"
db_password        = "super-secret-password"  # Use Secrets Manager in real projects
```

---

**outputs.tf**:
```hcl
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "db_endpoint" {
  description = "Database endpoint"
  value       = aws_db_instance.postgres.endpoint
  sensitive   = true
}

output "alb_dns_name" {
  description = "Load balancer DNS name"
  value       = aws_lb.main.dns_name
}
```

---

**backend.tf** (state storage):
```hcl
terraform {
  backend "s3" {
    bucket         = "myapp-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
```

---

## Terraform Workflow

### 1. Initialize
```bash
terraform init
```
Downloads providers, sets up backend

---

### 2. Plan
```bash
terraform plan -out=tfplan
```
Preview changes before applying

**Output**:
```
Terraform will perform the following actions:

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + cidr_block = "10.0.0.0/16"
      + id         = (known after apply)
    }

Plan: 15 to add, 0 to change, 0 to destroy.
```

---

### 3. Apply
```bash
terraform apply tfplan
```
Execute changes

**Important**: Always review plan before applying

---

### 4. Destroy (Teardown)
```bash
terraform destroy
```
Remove all resources (use with caution!)

---

## Best Practices

### 1. Use Modules
**Why**: Reusability, abstraction, maintainability

**Example**:
```hcl
# Call reusable VPC module
module "vpc" {
  source = "./modules/networking"
  
  project_name = var.project_name
  cidr_block   = "10.0.0.0/16"
}

module "database" {
  source = "./modules/database"
  
  vpc_id          = module.vpc.vpc_id
  instance_class  = "db.t3.micro"
}
```

---

### 2. Separate Environments
**Why**: Avoid accidental production changes

**Structure**:
```
environments/
├── dev/
│   ├── main.tf
│   └── terraform.tfvars
├── staging/
│   ├── main.tf
│   └── terraform.tfvars
└── production/
    ├── main.tf
    └── terraform.tfvars
```

**Different backends per environment**:
```hcl
# dev/backend.tf
backend "s3" {
  key = "dev/terraform.tfstate"
}

# production/backend.tf
backend "s3" {
  key = "production/terraform.tfstate"
}
```

---

### 3. Use Remote State
**Why**: Team collaboration, state locking

**S3 + DynamoDB**:
```hcl
terraform {
  backend "s3" {
    bucket         = "myapp-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"  # Prevents concurrent applies
  }
}
```

**Create S3 bucket + DynamoDB table first**:
```bash
aws s3 mb s3://myapp-terraform-state
aws dynamodb create-table \
  --table-name terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

---

### 4. Never Commit Secrets
**Bad**:
```hcl
# ❌ Don't do this
variable "db_password" {
  default = "my-secret-password"
}
```

**Good**:
```hcl
# ✅ Use environment variables
variable "db_password" {
  type      = string
  sensitive = true
}

# Set via environment variable
export TF_VAR_db_password="secret"
terraform apply
```

**Better**:
```hcl
# ✅ Use AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "prod/db/password"
}

resource "aws_db_instance" "postgres" {
  password = data.aws_secretsmanager_secret_version.db_password.secret_string
}
```

---

### 5. Use Data Sources
**Why**: Reference existing resources

```hcl
# Reference existing VPC (not managed by Terraform)
data "aws_vpc" "existing" {
  id = "vpc-12345"
}

# Use in new resources
resource "aws_subnet" "new" {
  vpc_id = data.aws_vpc.existing.id
}
```

---

### 6. Tag Everything
**Why**: Cost tracking, automation, organization

```hcl
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CostCenter  = "Engineering"
  }
}

resource "aws_instance" "web" {
  tags = merge(local.common_tags, {
    Name = "web-server"
  })
}
```

---

### 7. Use Terraform Workspaces (Alternative to Separate Dirs)
```bash
# Create workspace
terraform workspace new production

# Switch workspace
terraform workspace select production

# List workspaces
terraform workspace list
```

**In code**:
```hcl
resource "aws_instance" "web" {
  instance_type = terraform.workspace == "production" ? "t3.large" : "t3.micro"
}
```

---

## CI/CD Integration

### GitHub Actions Example

**.github/workflows/terraform.yml**:
```yaml
name: Terraform

on:
  push:
    branches: [main]
    paths:
      - 'infrastructure/**'
  pull_request:
    paths:
      - 'infrastructure/**'

jobs:
  terraform:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.6.0
      
      - name: Terraform Init
        run: terraform init
        working-directory: ./infrastructure
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      
      - name: Terraform Plan
        run: terraform plan -no-color
        working-directory: ./infrastructure
      
      - name: Terraform Apply (main branch only)
        if: github.ref == 'refs/heads/main' && github.event_name == 'push'
        run: terraform apply -auto-approve
        working-directory: ./infrastructure
```

---

## State Management

### State File Contains Secrets
**Problem**: `terraform.tfstate` contains passwords, API keys

**Solution**:
1. **Never commit state file** (add to `.gitignore`)
2. **Encrypt state at rest** (S3 encryption)
3. **Encrypt state in transit** (HTTPS)
4. **Limit access** (IAM policies)

**.gitignore**:
```
terraform.tfstate
terraform.tfstate.backup
.terraform/
*.tfvars
```

---

### State Locking
**Problem**: Two people run `terraform apply` simultaneously → corruption

**Solution**: DynamoDB state locking

```hcl
backend "s3" {
  bucket         = "terraform-state"
  dynamodb_table = "terraform-lock"  # Prevents concurrent applies
}
```

---

## Disaster Recovery

### Backup State File
```bash
# Manual backup
aws s3 cp s3://myapp-terraform-state/production/terraform.tfstate \
  ./backups/terraform.tfstate.$(date +%Y%m%d)

# Enable versioning on S3 bucket (automatic)
aws s3api put-bucket-versioning \
  --bucket myapp-terraform-state \
  --versioning-configuration Status=Enabled
```

---

### Recover from Lost State
**If state file deleted**:
1. **Import existing resources**:
```bash
terraform import aws_vpc.main vpc-12345
terraform import aws_db_instance.postgres mydb
```

2. **Use terraform refresh** (if some state remains):
```bash
terraform refresh
```

---

## Checklist

**Before Starting**:
- [ ] Choose IaC tool (Terraform, CloudFormation, Pulumi)
- [ ] Set up remote state backend (S3 + DynamoDB)
- [ ] Create separate environments (dev, staging, prod)
- [ ] Set up CI/CD pipeline

**Writing IaC**:
- [ ] Use modules for reusability
- [ ] Tag all resources
- [ ] Never commit secrets
- [ ] Use variables for environment-specific values
- [ ] Document outputs

**Deploying**:
- [ ] Run `terraform plan` first
- [ ] Review plan before applying
- [ ] Apply to dev first, then staging, then production
- [ ] Monitor for errors

**Maintenance**:
- [ ] Keep Terraform version up-to-date
- [ ] Regularly run `terraform plan` to detect drift
- [ ] Backup state file
- [ ] Review and clean up unused resources

---

## Notes

**IaC is not just for initial provisioning**: Use it for ongoing changes too

**Terraform state is critical**: Lose state = lose track of resources

**Plan before apply**: Always review changes before executing

**Start simple**: Don't over-engineer modules initially
