output "iam_users" {
  description = "IAM users created"
  value       = module.iam_advanced.iam_users
}

output "iam_roles" {
  description = "IAM roles created"
  value       = module.iam_advanced.iam_roles
}

output "iam_policies" {
  description = "IAM policies created"
  value       = module.iam_advanced.iam_policies
}

output "iam_access_keys" {
  description = "IAM access keys created (sensitive)"
  value       = module.iam_advanced.iam_access_keys
  sensitive   = true
}

output "iam_login_profiles" {
  description = "IAM login profiles created (sensitive)"
  value       = module.iam_advanced.iam_login_profiles
  sensitive   = true
}

output "role_policy_attachments" {
  description = "Role policy attachments created"
  value       = module.iam_advanced.role_policy_attachments
} 