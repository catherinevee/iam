# IAM Users Outputs
output "iam_users" {
  description = "Map of IAM users created"
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
}

output "iam_user_names" {
  description = "List of IAM user names"
  value       = [for user in aws_iam_user.this : user.name]
}

output "iam_user_arns" {
  description = "List of IAM user ARNs"
  value       = [for user in aws_iam_user.this : user.arn]
}

# IAM Groups Outputs
output "iam_groups" {
  description = "Map of IAM groups created"
  value = {
    for k, v in aws_iam_group.this : k => {
      name = v.name
      arn  = v.arn
      path = v.path
      tags = v.tags
    }
  }
}

output "iam_group_names" {
  description = "List of IAM group names"
  value       = [for group in aws_iam_group.this : group.name]
}

output "iam_group_arns" {
  description = "List of IAM group ARNs"
  value       = [for group in aws_iam_group.this : group.arn]
}

# IAM Roles Outputs
output "iam_roles" {
  description = "Map of IAM roles created"
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
  description = "List of IAM role names"
  value       = [for role in aws_iam_role.this : role.name]
}

output "iam_role_arns" {
  description = "List of IAM role ARNs"
  value       = [for role in aws_iam_role.this : role.arn]
}

# IAM Policies Outputs
output "iam_policies" {
  description = "Map of IAM policies created"
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
  description = "List of IAM policy names"
  value       = [for policy in aws_iam_policy.this : policy.name]
}

output "iam_policy_arns" {
  description = "List of IAM policy ARNs"
  value       = [for policy in aws_iam_policy.this : policy.arn]
}

# IAM Access Keys Outputs
output "iam_access_keys" {
  description = "Map of IAM access keys created"
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
  description = "List of IAM access key IDs"
  value       = [for key in aws_iam_access_key.this : key.id]
}

# IAM User Login Profiles Outputs
output "iam_login_profiles" {
  description = "Map of IAM user login profiles created"
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

# User Group Memberships Outputs
output "user_group_memberships" {
  description = "Map of IAM user group memberships created"
  value = {
    for k, v in aws_iam_user_group_membership.this : k => {
      user   = v.user
      groups = v.groups
    }
  }
}

# Policy Attachments Outputs
output "role_policy_attachments" {
  description = "Map of IAM role policy attachments created"
  value = {
    for k, v in aws_iam_role_policy_attachment.this : k => {
      role       = v.role
      policy_arn = v.policy_arn
    }
  }
}

output "user_policy_attachments" {
  description = "Map of IAM user policy attachments created"
  value = {
    for k, v in aws_iam_user_policy_attachment.this : k => {
      user       = v.user
      policy_arn = v.policy_arn
    }
  }
}

output "group_policy_attachments" {
  description = "Map of IAM group policy attachments created"
  value = {
    for k, v in aws_iam_group_policy_attachment.this : k => {
      group      = v.group
      policy_arn = v.policy_arn
    }
  }
} 