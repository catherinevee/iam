# AWS IAM Terraform Module

A comprehensive Terraform module for managing AWS IAM resources including users, groups, roles, policies, and their relationships.

## Features

- **IAM Users**: Create and manage IAM users with optional permissions boundaries
- **IAM Groups**: Create and manage IAM groups for organizing users
- **IAM Roles**: Create and manage IAM roles with custom assume role policies
- **IAM Policies**: Create and manage custom IAM policies
- **User Group Memberships**: Manage user-group relationships
- **Policy Attachments**: Attach policies to users, groups, and roles
- **Access Keys**: Create and manage IAM access keys
- **Login Profiles**: Create and manage IAM user login profiles
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
      path = "/users/"
      tags = {
        Environment = "production"
        Role        = "developer"
      }
    }
    admin = {
      name = "admin"
      path = "/users/"
      tags = {
        Environment = "production"
        Role        = "admin"
      }
    }
  }

  groups = {
    developers = {
      name = "developers"
      path = "/groups/"
      tags = {
        Environment = "production"
        Team        = "development"
      }
    }
    admins = {
      name = "admins"
      path = "/groups/"
      tags = {
        Environment = "production"
        Team        = "operations"
      }
    }
  }

  policies = {
    s3_read_only = {
      name        = "S3ReadOnlyPolicy"
      description = "Policy for read-only access to S3"
      path        = "/policies/"
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
              "arn:aws:s3:::example-bucket",
              "arn:aws:s3:::example-bucket/*"
            ]
          }
        ]
      })
      tags = {
        Environment = "production"
        Service     = "s3"
      }
    }
  }

  roles = {
    ec2_role = {
      name        = "EC2Role"
      description = "Role for EC2 instances"
      path        = "/roles/"
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Principal = {
              Service = "ec2.amazonaws.com"
            }
            Action = "sts:AssumeRole"
          }
        ]
      })
      tags = {
        Environment = "production"
        Service     = "ec2"
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
    Project     = "terraform-iam-module"
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
    api_user = {
      name = "api-user"
      path = "/users/"
      tags = {
        Environment = "production"
        Purpose     = "api-access"
      }
    }
  }

  access_keys = {
    api_user_key = {
      user_key = "api_user"
      status   = "Active"
    }
  }

  login_profiles = {
    api_user_profile = {
      user_key                = "api_user"
      password_reset_required = true
      password_length         = 20
    }
  }

  tags = {
    Environment = "production"
    Project     = "api-service"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

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
- Always use the principle of least privilege when creating IAM policies
- Enable MFA for IAM users with console access
- Use IAM roles instead of access keys when possible
- Regularly rotate access keys
- Use permissions boundaries to limit the scope of IAM policies

### Resource Organization
- Use meaningful names for IAM resources
- Organize resources using IAM paths (e.g., `/teams/`, `/services/`)
- Apply consistent tagging across all resources
- Use separate IAM users for different purposes

### Policy Management
- Create reusable policies and attach them to multiple users/groups/roles
- Use policy conditions to restrict access based on context
- Regularly review and audit IAM policies
- Use AWS managed policies when appropriate

### Module Usage
- Enable only the resources you need using the control variables
- Use consistent naming conventions across your infrastructure
- Leverage the module outputs for integration with other modules
- Test your IAM configurations in a non-production environment first

## Examples

See the `examples/` directory for additional usage examples:

- `examples/basic/` - Basic IAM setup with users, groups, and policies
- `examples/advanced/` - Advanced setup with roles, access keys, and login profiles
- `examples/ec2/` - EC2-specific IAM configuration
- `examples/lambda/` - Lambda function IAM configuration

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This module is licensed under the MIT License. See LICENSE file for details.

## Support

For issues and questions, please open an issue in the repository or contact the maintainers.