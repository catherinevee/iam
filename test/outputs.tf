output "test_users" {
  description = "Test IAM users created"
  value       = module.iam_test.iam_users
}

output "test_groups" {
  description = "Test IAM groups created"
  value       = module.iam_test.iam_groups
}

output "test_roles" {
  description = "Test IAM roles created"
  value       = module.iam_test.iam_roles
}

output "test_policies" {
  description = "Test IAM policies created"
  value       = module.iam_test.iam_policies
}

output "test_user_group_memberships" {
  description = "Test user group memberships created"
  value       = module.iam_test.user_group_memberships
}

output "test_role_policy_attachments" {
  description = "Test role policy attachments created"
  value       = module.iam_test.role_policy_attachments
} 