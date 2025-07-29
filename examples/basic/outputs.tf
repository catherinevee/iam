output "iam_users" {
  description = "IAM users created"
  value       = module.iam_basic.iam_users
}

output "iam_groups" {
  description = "IAM groups created"
  value       = module.iam_basic.iam_groups
}

output "iam_policies" {
  description = "IAM policies created"
  value       = module.iam_basic.iam_policies
}

output "user_group_memberships" {
  description = "User group memberships created"
  value       = module.iam_basic.user_group_memberships
} 