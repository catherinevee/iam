# IAM Users
resource "aws_iam_user" "this" {
  for_each = { for k, v in var.users : k => v if var.create_users }

  name                 = each.value.name
  path                 = try(each.value.path, "/")
  permissions_boundary = try(each.value.permissions_boundary, null)
  force_destroy        = try(each.value.force_destroy, false)

  tags = merge(
    var.tags,
    try(each.value.tags, {}),
    {
      Name = each.value.name
    }
  )
}

# IAM Groups
resource "aws_iam_group" "this" {
  for_each = { for k, v in var.groups : k => v if var.create_groups }

  name = each.value.name
  path = try(each.value.path, "/")
}

# IAM Roles
resource "aws_iam_role" "this" {
  for_each = { for k, v in var.roles : k => v if var.create_roles }

  name                 = each.value.name
  path                 = try(each.value.path, "/")
  description          = try(each.value.description, null)
  assume_role_policy   = each.value.assume_role_policy
  permissions_boundary = try(each.value.permissions_boundary, null)
  force_detach_policies = try(each.value.force_detach_policies, false)
  max_session_duration = try(each.value.max_session_duration, null)

  tags = merge(
    var.tags,
    try(each.value.tags, {}),
    {
      Name = each.value.name
    }
  )
}

# IAM Policies
resource "aws_iam_policy" "this" {
  for_each = { for k, v in var.policies : k => v if var.create_policies }

  name        = each.value.name
  path        = try(each.value.path, "/")
  description = try(each.value.description, null)
  policy      = each.value.policy

  tags = merge(
    var.tags,
    try(each.value.tags, {}),
    {
      Name = each.value.name
    }
  )
}

# IAM User Group Memberships
resource "aws_iam_user_group_membership" "this" {
  for_each = { for k, v in var.user_group_memberships : k => v if var.create_user_group_memberships }

  user   = aws_iam_user.this[each.value.user_key].name
  groups = [for group_key in each.value.groups : aws_iam_group.this[group_key].name]

  depends_on = [
    aws_iam_user.this,
    aws_iam_group.this
  ]
}

# IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in var.role_policy_attachments : k => v if var.create_role_policy_attachments }

  role       = aws_iam_role.this[each.value.role_key].name
  policy_arn = aws_iam_policy.this[each.value.policy_key].arn

  depends_on = [
    aws_iam_role.this,
    aws_iam_policy.this
  ]
}

# IAM User Policy Attachments
resource "aws_iam_user_policy_attachment" "this" {
  for_each = { for k, v in var.user_policy_attachments : k => v if var.create_user_policy_attachments }

  user       = aws_iam_user.this[each.value.user_key].name
  policy_arn = aws_iam_policy.this[each.value.policy_key].arn

  depends_on = [
    aws_iam_user.this,
    aws_iam_policy.this
  ]
}

# IAM Group Policy Attachments
resource "aws_iam_group_policy_attachment" "this" {
  for_each = { for k, v in var.group_policy_attachments : k => v if var.create_group_policy_attachments }

  group      = aws_iam_group.this[each.value.group_key].name
  policy_arn = aws_iam_policy.this[each.value.policy_key].arn

  depends_on = [
    aws_iam_group.this,
    aws_iam_policy.this
  ]
}

# IAM Access Keys
resource "aws_iam_access_key" "this" {
  for_each = { for k, v in var.access_keys : k => v if var.create_access_keys }

  user    = aws_iam_user.this[each.value.user_key].name
  pgp_key = try(each.value.pgp_key, null)
  status  = try(each.value.status, "Active")

  depends_on = [
    aws_iam_user.this
  ]
}

# IAM User Login Profiles
resource "aws_iam_user_login_profile" "this" {
  for_each = { for k, v in var.login_profiles : k => v if var.create_login_profiles }

  user                    = aws_iam_user.this[each.value.user_key].name
  password_reset_required = try(each.value.password_reset_required, true)
  password_length        = try(each.value.password_length, 20)
  pgp_key                = try(each.value.pgp_key, null)

  depends_on = [
    aws_iam_user.this
  ]
} 