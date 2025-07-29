# AWS IAM Terraform Module

A comprehensive Terraform module for managing AWS Identity and Access Management (IAM) resources including users, groups, roles, policies, and their relationships.

## Features

- **IAM Users**: Create and manage IAM users with optional permissions boundaries
- **IAM Groups**: Create and manage IAM groups for organizing users
- **IAM Roles**: Create and manage IAM roles with custom assume role policies
- **IAM Policies**: Create and manage custom IAM policies
- **User Group Memberships**: Manage user-group relationships
- **Policy Attachments**: Attach policies to users, groups, and roles
- **Access Keys**: Generate access keys for programmatic access
- **Login Profiles**: Create console login profiles for users
- **Comprehensive Tagging**: Support for resource tagging
- **Conditional Creation**: Enable/disable resource creation with boolean flags

## Usage

### Basic Example

```hcl
module "iam" {
  source = "./path/to/iam"

  create_users  = true
  create_groups = true
  create_roles  = true
  create_policies = true

  users = {
    developer = {
      name = "developer"
      path = "/developers/"
      tags = {
        Department = "Engineering"
        Role       = "Developer"
      }
    }
    admin = {
      name = "admin"
      path = "/admins/"
      permissions_boundary = "arn:aws:iam::123456789012:policy/AdminBoundary"
      tags = {
        Department = "IT"
        Role       = "Administrator"
      }
    }
  }

  groups = {
    developers = {
      name = "developers"
      path = "/groups/"
    }
    admins = {
      name = "admins"
      path = "/groups/"
    }
  }

  roles = {
    ec2_role = {
      name = "EC2InstanceRole"
      path = "/roles/"
      description = "Role for EC2 instances to access S3"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
              Service = "ec2.amazonaws.com"
            }
          }
        ]
      })
      tags = {
        Service = "EC2"
        Purpose = "InstanceRole"
      }
    }
  }

  policies = {
    s3_read_only = {
      name        = "S3ReadOnlyPolicy"
      description = "Policy for read-only access to S3"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:ListBucket"
            ]
            Resource = [
              "arn:aws:s3:::my-bucket",
              "arn:aws:s3:::my-bucket/*"
            ]
          }
        ]
      })
      tags = {
        Service = "S3"
        Access  = "ReadOnly"
      }
    }
  }

  user_group_memberships = {
    developer_membership = {
      user_key = "developer"
      groups   = ["developers"]
    }
    admin_membership = {
      user_key = "admin"
      groups   = ["admins", "developers"]
    }
  }

  role_policy_attachments = {
    ec2_s3_access = {
      role_key   = "ec2_role"
      policy_key = "s3_read_only"
    }
  }

  tags = {
    Environment = "production"
    Project     = "my-project"
    ManagedBy   = "terraform"
  }
}
```

### Advanced Example with Access Keys and Login Profiles

```hcl
module "iam_advanced" {
  source = "./path/to/iam"

  create_users         = true
  create_access_keys   = true
  create_login_profiles = true

  users = {
    ci_user = {
      name = "ci-user"
      path = "/ci/"
      tags = {
        Purpose = "CI/CD"
        Environment = "production"
      }
    }
  }

  access_keys = {
    ci_access_key = {
      user_key = "ci_user"
      status   = "Active"
    }
  }

  login_profiles = {
    ci_login = {
      user_key                = "ci_user"
      password_reset_required = true
      password_length         = 32
    }
  }

  tags = {
    Environment = "production"
    Purpose     = "CI/CD"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Inputs

### Control Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_users | Whether to create IAM users | `bool` | `false` | no |
| create_groups | Whether to create IAM groups | `bool` | `false` | no |
| create_roles | Whether to create IAM roles | `bool` | `false` | no |
| create_policies | Whether to create IAM policies | `bool` | `false` | no |
| create_user_group_memberships | Whether to create IAM user group memberships | `bool` | `false` | no |
| create_role_policy_attachments | Whether to create IAM role policy attachments | `bool` | `false` | no |
| create_user_policy_attachments | Whether to create IAM user policy attachments | `bool` | `false` | no |
| create_group_policy_attachments | Whether to create IAM group policy attachments | `bool` | `false` | no |
| create_access_keys | Whether to create IAM access keys | `bool` | `false` | no |
| create_login_profiles | Whether to create IAM user login profiles | `bool` | `false` | no |

### Resource Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| users | Map of IAM users to create | `map(object)` | `{}` | no |
| groups | Map of IAM groups to create | `map(object)` | `{}` | no |
| roles | Map of IAM roles to create | `map(object)` | `{}` | no |
| policies | Map of IAM policies to create | `map(object)` | `{}` | no |
| user_group_memberships | Map of IAM user group memberships to create | `map(object)` | `{}` | no |
| role_policy_attachments | Map of IAM role policy attachments to create | `map(object)` | `{}` | no |
| user_policy_attachments | Map of IAM user policy attachments to create | `map(object)` | `{}` | no |
| group_policy_attachments | Map of IAM group policy attachments to create | `map(object)` | `{}` | no |
| access_keys | Map of IAM access keys to create | `map(object)` | `{}` | no |
| login_profiles | Map of IAM user login profiles to create | `map(object)` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam_users | Map of IAM users created |
| iam_user_names | List of IAM user names |
| iam_user_arns | List of IAM user ARNs |
| iam_groups | Map of IAM groups created |
| iam_group_names | List of IAM group names |
| iam_group_arns | List of IAM group ARNs |
| iam_roles | Map of IAM roles created |
| iam_role_names | List of IAM role names |
| iam_role_arns | List of IAM role ARNs |
| iam_policies | Map of IAM policies created |
| iam_policy_names | List of IAM policy names |
| iam_policy_arns | List of IAM policy ARNs |
| iam_access_keys | Map of IAM access keys created (sensitive) |
| iam_access_key_ids | List of IAM access key IDs |
| iam_login_profiles | Map of IAM user login profiles created (sensitive) |
| user_group_memberships | Map of IAM user group memberships created |
| role_policy_attachments | Map of IAM role policy attachments created |
| user_policy_attachments | Map of IAM user policy attachments created |
| group_policy_attachments | Map of IAM group policy attachments created |

## Best Practices

### Security

1. **Use Permissions Boundaries**: Always define permissions boundaries for users and roles to limit their maximum permissions
2. **Principle of Least Privilege**: Grant only the minimum permissions necessary for each role
3. **Regular Access Reviews**: Implement processes to regularly review and audit IAM permissions
4. **Use Roles Instead of Users**: Prefer IAM roles over IAM users for application access
5. **Enable MFA**: Require multi-factor authentication for all IAM users

### Resource Organization

1. **Use Paths**: Organize resources using IAM paths (e.g., `/developers/`, `/admins/`)
2. **Consistent Naming**: Use consistent naming conventions across all IAM resources
3. **Tagging Strategy**: Implement a comprehensive tagging strategy for cost tracking and resource management

### Policy Management

1. **Custom Policies**: Create custom policies instead of using AWS managed policies when possible
2. **Policy Versioning**: Use policy versioning to track changes
3. **Policy Testing**: Test policies in a non-production environment before applying to production

## Examples

See the `examples/` directory for complete working examples:

- `examples/basic/` - Basic IAM setup with users, groups, and policies
- `examples/advanced/` - Advanced setup with roles, access keys, and login profiles

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This module is licensed under the MIT License. See the LICENSE file for details.

## Support

For issues and questions, please open an issue in the repository or contact the maintainers.