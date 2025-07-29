output "users" {
  description = "IAM users created"
  value       = module.iam_basic.iam_users
}

output "user_names" {
  description = "Names of IAM users created"
  value       = module.iam_basic.iam_user_names
}

output "groups" {
  description = "IAM groups created"
  value       = module.iam_basic.iam_groups
}

output "group_names" {
  description = "Names of IAM groups created"
  value       = module.iam_basic.iam_group_names
}

output "roles" {
  description = "IAM roles created"
  value       = module.iam_basic.iam_roles
}

output "role_names" {
  description = "Names of IAM roles created"
  value       = module.iam_basic.iam_role_names
}

output "policies" {
  description = "IAM policies created"
  value       = module.iam_basic.iam_policies
}

output "policy_names" {
  description = "Names of IAM policies created"
  value       = module.iam_basic.iam_policy_names
}

output "user_group_memberships" {
  description = "User group memberships created"
  value       = module.iam_basic.user_group_memberships
}

output "role_policy_attachments" {
  description = "Role policy attachments created"
  value       = module.iam_basic.role_policy_attachments
} 