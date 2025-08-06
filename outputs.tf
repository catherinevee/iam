# User outputs - sensitive due to potential password/key information
output "iam_users" {
  description = "Created users with metadata (passwords/keys redacted)"
  value = {
    for k, v in aws_iam_user.this : k => {
      name                 = v.name
      arn                  = v.arn
      unique_id            = v.unique_id
      path                 = v.path
      permissions_boundary = v.permissions_boundary
      tags                 = v.tags
    }
  }
  sensitive = true
}

output "iam_user_names" {
  description = "User names only - safe for use in other resources"
  value       = [for user in aws_iam_user.this : user.name]
}

output "iam_user_arns" {
  description = "User ARNs for policy references"
  value       = [for user in aws_iam_user.this : user.arn]
}

# Group outputs
output "iam_groups" {
  description = "Created groups with metadata"
  value = {
    for k, v in aws_iam_group.this : k => {
      name = v.name
      arn  = v.arn
      path = v.path
    }
  }
}

output "iam_group_names" {
  description = "Group names for reference"
  value       = [for group in aws_iam_group.this : group.name]
}

output "iam_group_arns" {
  description = "Group ARNs for policy attachments"
  value       = [for group in aws_iam_group.this : group.arn]
}

# Role outputs 
output "iam_roles" {
  description = "Created roles with full configuration"
  value = {
    for k, v in aws_iam_role.this : k => {
      name                   = v.name
      arn                    = v.arn
      unique_id              = v.unique_id
      path                   = v.path
      description            = v.description
      permissions_boundary   = v.permissions_boundary
      force_detach_policies  = v.force_detach_policies
      max_session_duration   = v.max_session_duration
      tags                   = v.tags
    }
  }
}

output "iam_role_names" {
  description = "Role names for service configurations"
  value       = [for role in aws_iam_role.this : role.name]
}

output "iam_role_arns" {
  description = "Role ARNs for assume role operations"
  value       = [for role in aws_iam_role.this : role.arn]
}

# Policy outputs
output "iam_policies" {
  description = "Created custom policies with metadata"
  value = {
    for k, v in aws_iam_policy.this : k => {
      name        = v.name
      arn         = v.arn
      id          = v.id
      path        = v.path
      description = v.description
      tags        = v.tags
    }
  }
}

output "iam_policy_names" {
  description = "Policy names for reference"
  value       = [for policy in aws_iam_policy.this : policy.name]
}

output "iam_policy_arns" {
  description = "Policy ARNs for attachments"
  value       = [for policy in aws_iam_policy.this : policy.arn]
}

# Access credentials - marked sensitive for security
output "iam_access_keys" {
  description = "Access key data including secrets - handle with care"
  value = {
    for k, v in aws_iam_access_key.this : k => {
      user     = v.user
      access_key_id = v.id
      status   = v.status
      secret   = v.secret
      encrypted_secret = v.encrypted_secret
    }
  }
  sensitive = true
}

output "iam_access_key_ids" {
  description = "Access key IDs only - secrets available in sensitive output"
  value       = [for key in aws_iam_access_key.this : key.id]
}

# Login profiles - passwords are sensitive
output "iam_login_profiles" {
  description = "Console login data with encrypted passwords"
  value = {
    for k, v in aws_iam_user_login_profile.this : k => {
      user                    = v.user
      password_reset_required = v.password_reset_required
      password_length         = v.password_length
      encrypted_password      = v.encrypted_password
    }
  }
  sensitive = true
}

# Relationship outputs - useful for debugging and validation
output "user_group_memberships" {
  description = "User-to-group assignments that were created"
  value = {
    for k, v in aws_iam_user_group_membership.this : k => {
      user   = v.user
      groups = v.groups
    }
  }
}

# Policy attachment tracking
output "role_policy_attachments" {
  description = "Role-to-policy links for reference"
  value = {
    for k, v in aws_iam_role_policy_attachment.this : k => {
      role       = v.role
      policy_arn = v.policy_arn
    }
  }
}

output "user_policy_attachments" {
  description = "User-to-policy direct attachments"
  value = {
    for k, v in aws_iam_user_policy_attachment.this : k => {
      user       = v.user
      policy_arn = v.policy_arn
    }
  }
}

output "group_policy_attachments" {
  description = "Group-to-policy attachments"
  value = {
    for k, v in aws_iam_group_policy_attachment.this : k => {
      group      = v.group
      policy_arn = v.policy_arn
    }
  }
} 