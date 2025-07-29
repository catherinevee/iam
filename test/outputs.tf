output "test_user" {
  description = "Test user created"
  value       = module.iam_test.iam_users["test_user"]
}

output "test_group" {
  description = "Test group created"
  value       = module.iam_test.iam_groups["test_group"]
}

output "test_role" {
  description = "Test role created"
  value       = module.iam_test.iam_roles["test_role"]
}

output "test_policy" {
  description = "Test policy created"
  value       = module.iam_test.iam_policies["test_policy"]
}

output "test_membership" {
  description = "Test user group membership created"
  value       = module.iam_test.user_group_memberships["test_membership"]
}

output "test_attachment" {
  description = "Test role policy attachment created"
  value       = module.iam_test.role_policy_attachments["test_attachment"]
} 