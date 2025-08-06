# AWS IAM Terraform Module

Terraform module for AWS IAM resources - users, groups, roles, and policies. Built to handle the tedious parts of IAM management while avoiding AWS managed policy dependency hell.

## What It Does

- **Users & Groups**: Basic user management with group memberships
- **Roles**: Service roles with proper assume-role policies  
- **Custom Policies**: JSON policy documents that actually make sense
- **Access Keys**: Programmatic access for CI/CD and applications
- **Login Profiles**: Console access with sensible password defaults
- **Conditional Resources**: Skip what you don't need with boolean flags

## Quick Start

```hcl
module "iam" {
  source = "./iam"

  create_users  = true
  create_groups = true
  create_roles  = true
  create_policies = true

  # Basic developer user
  users = {
    dev_user = {
      name = "developer"
      path = "/team/"
    }
  }

  # Group for developers
  groups = {
    developers = {
      name = "developers"
      path = "/groups/"
    }
  }

  # EC2 service role
  roles = {
    ec2_role = {
      name = "EC2InstanceRole"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }]
      })
    }
  }

  # Custom policy - better than AWS managed policies
  policies = {
    s3_access = {
      name = "S3ReadOnlyAccess"
      description = "Read-only access to specific S3 bucket"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
          Effect = "Allow"
          Action = ["s3:GetObject", "s3:ListBucket"]
          Resource = [
            "arn:aws:s3:::my-app-bucket",
            "arn:aws:s3:::my-app-bucket/*"
          ]
        }]
      })
    }
  }

  # Connect user to group
  user_group_memberships = {
    dev_membership = {
      user_key = "dev_user"
      groups   = ["developers"]
    }
  }

  # Attach policy to role
  role_policy_attachments = {
    ec2_s3_access = {
      role_key   = "ec2_role"
      policy_key = "s3_access"
    }
  }
}
```

## Advanced Usage

### CI/CD User with Access Keys

```hcl
module "iam_ci" {
  source = "./iam"

  create_users       = true
  create_access_keys = true

  users = {
    github_actions = {
      name = "github-actions"
      path = "/ci/"
    }
  }

  access_keys = {
    github_key = {
      user_key = "github_actions"
      status   = "Active"
    }
  }
}

# Access the credentials
output "ci_access_key_id" {
  value = module.iam_ci.iam_access_keys["github_key"].access_key_id
}

output "ci_secret_key" {
  value     = module.iam_ci.iam_access_keys["github_key"].secret
  sensitive = true
}
```

### Human Users with Console Access

```hcl
module "iam_humans" {
  source = "./iam"

  create_users         = true
  create_login_profiles = true

  users = {
    john_doe = {
      name = "john.doe"
      path = "/humans/"
      permissions_boundary = "arn:aws:iam::123456789012:policy/DeveloperBoundary"
    }
  }

  login_profiles = {
    john_login = {
      user_key                = "john_doe"
      password_reset_required = true
      password_length         = 16
    }
  }
}
```
## Important Notes

### Boolean Flags Matter
Each resource type has a `create_*` flag that must be `true` to create resources. This prevents accidental resource creation when you only want some components.

### Key Mapping
Resources reference each other using map keys, not resource names:
- `user_key` references keys in the `users` map
- `policy_key` references keys in the `policies` map  
- `role_key` references keys in the `roles` map

### Permissions Boundaries
Always use permissions boundaries in production. They're your safety net when someone inevitably gets admin access.

### Access Key Security
Access keys are marked as sensitive outputs. Use proper secret management - don't put them in your Terraform state file or logs.

## Variables

### Control Flags

| Name | Description | Default |
|------|-------------|---------|
| create_users | Create IAM users | `false` |
| create_groups | Create IAM groups | `false` |  
| create_roles | Create IAM roles | `false` |
| create_policies | Create IAM policies | `false` |
| create_user_group_memberships | Link users to groups | `false` |
| create_role_policy_attachments | Attach policies to roles | `false` |
| create_user_policy_attachments | Attach policies to users | `false` |
| create_group_policy_attachments | Attach policies to groups | `false` |
| create_access_keys | Generate access keys | `false` |
| create_login_profiles | Create console passwords | `false` |

### Resource Definitions

| Name | Description | Type |
|------|-------------|------|
| users | User definitions with paths and boundaries | `map(object)` |
| groups | Group definitions with paths | `map(object)` |
| roles | Role definitions with assume role policies | `map(object)` |
| policies | Policy definitions with JSON documents | `map(object)` |
| user_group_memberships | User-to-group assignments | `map(object)` |
| role_policy_attachments | Role-to-policy assignments | `map(object)` |
| user_policy_attachments | User-to-policy assignments | `map(object)` |
| group_policy_attachments | Group-to-policy assignments | `map(object)` |
| access_keys | Access key definitions | `map(object)` |
| login_profiles | Console login configurations | `map(object)` |
| tags | Tags applied to all resources | `map(string)` |

## Outputs

### Resource Lists
- `iam_user_names` - List of created user names
- `iam_user_arns` - List of created user ARNs  
- `iam_group_names` - List of created group names
- `iam_role_names` - List of created role names
- `iam_policy_arns` - List of created policy ARNs

### Sensitive Data (marked sensitive)
- `iam_users` - Full user details
- `iam_access_keys` - Access key IDs and secrets
- `iam_login_profiles` - Password details

### Relationship Data
- `user_group_memberships` - User-group associations
- `role_policy_attachments` - Role-policy links

## Common Gotchas

### Policy Size Limits
IAM policies have a 6,144 character limit. Large policies need to be split or simplified.

### Name Length Restrictions  
- User names: 64 characters max
- Role names: 64 characters max
- Policy names: 128 characters max

### Path Requirements
Paths must start and end with `/`. The module defaults to `/` if you don't specify one.

### Assume Role Policy JSON
The assume role policy must be valid JSON. Use `jsonencode()` to avoid syntax errors.

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.0

## Examples

Complete examples are in the `examples/` directory:
- `examples/basic/` - Standard setup for most teams
- `examples/advanced/` - CI/CD users with access keys

## Contributing

Found a bug? Want a feature? Open an issue or submit a pull request.

## License

MIT License - see LICENSE file for details.