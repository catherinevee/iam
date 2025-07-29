output "users" {
  description = "IAM users created"
  value       = module.iam_advanced.iam_users
}

output "user_names" {
  description = "Names of IAM users created"
  value       = module.iam_advanced.iam_user_names
}

output "groups" {
  description = "IAM groups created"
  value       = module.iam_advanced.iam_groups
}

output "group_names" {
  description = "Names of IAM groups created"
  value       = module.iam_advanced.iam_group_names
}

output "roles" {
  description = "IAM roles created"
  value       = module.iam_advanced.iam_roles
}

output "role_names" {
  description = "Names of IAM roles created"
  value       = module.iam_advanced.iam_role_names
}

output "policies" {
  description = "IAM policies created"
  value       = module.iam_advanced.iam_policies
}

output "policy_names" {
  description = "Names of IAM policies created"
  value       = module.iam_advanced.iam_policy_names
}

output "access_keys" {
  description = "IAM access keys created (sensitive)"
  value       = module.iam_advanced.iam_access_keys
  sensitive   = true
}

output "access_key_ids" {
  description = "IAM access key IDs"
  value       = module.iam_advanced.iam_access_key_ids
}

output "login_profiles" {
  description = "IAM login profiles created (sensitive)"
  value       = module.iam_advanced.iam_login_profiles
  sensitive   = true
}

output "user_group_memberships" {
  description = "User group memberships created"
  value       = module.iam_advanced.user_group_memberships
}

output "user_policy_attachments" {
  description = "User policy attachments created"
  value       = module.iam_advanced.user_policy_attachments
}

output "role_policy_attachments" {
  description = "Role policy attachments created"
  value       = module.iam_advanced.role_policy_attachments
} 