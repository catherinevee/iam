variable "create_users" {
  description = "Whether to create IAM users"
  type        = bool
  default     = false
}

variable "create_groups" {
  description = "Whether to create IAM groups"
  type        = bool
  default     = false
}

variable "create_roles" {
  description = "Whether to create IAM roles"
  type        = bool
  default     = false
}

variable "create_policies" {
  description = "Whether to create IAM policies"
  type        = bool
  default     = false
}

variable "create_user_group_memberships" {
  description = "Whether to create IAM user group memberships"
  type        = bool
  default     = false
}

variable "create_role_policy_attachments" {
  description = "Whether to create IAM role policy attachments"
  type        = bool
  default     = false
}

variable "create_user_policy_attachments" {
  description = "Whether to create IAM user policy attachments"
  type        = bool
  default     = false
}

variable "create_group_policy_attachments" {
  description = "Whether to create IAM group policy attachments"
  type        = bool
  default     = false
}

variable "create_access_keys" {
  description = "Whether to create IAM access keys"
  type        = bool
  default     = false
}

variable "create_login_profiles" {
  description = "Whether to create IAM user login profiles"
  type        = bool
  default     = false
}

variable "users" {
  description = <<-EOT
    Map of IAM users to create. Each user can have the following attributes:
    - name: The name of the IAM user (required)
    - path: Path in which to create the user (default: "/")
    - permissions_boundary: ARN of the policy that is used to set the permissions boundary
    - force_destroy: Delete user even if it has non-Terraform-managed IAM access keys
    - tags: Map of tags to assign to the user
  EOT
  type = map(object({
    name                 = string
    path                 = optional(string, "/")
    permissions_boundary = optional(string)
    force_destroy        = optional(bool, false)
    tags                 = optional(map(string), {})
  }))
  default = {}

  validation {
    condition     = alltrue([for k, v in var.users : can(regex("^[\\w+=,.@-]{1,64}$", v.name))])
    error_message = "User names must consist of alphanumeric characters and/or [+=,.@-], max 64 characters."
  }
}
}

variable "groups" {
  description = "Map of IAM groups to create"
  type = map(object({
    name = string
    path = optional(string, "/")
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "roles" {
  description = "Map of IAM roles to create"
  type = map(object({
    name                   = string
    path                   = optional(string, "/")
    description            = optional(string)
    assume_role_policy     = string
    permissions_boundary   = optional(string)
    force_detach_policies  = optional(bool, false)
    max_session_duration   = optional(number)
    tags                   = optional(map(string), {})
  }))
  default = {}
}

variable "policies" {
  description = <<-EOT
    Map of IAM policies to create. Each policy requires:
    - name: Policy name
    - description: Policy description
    - policy: Valid JSON policy document
    - path: Path for the policy (optional)
    - tags: Resource tags (optional)
  EOT
  type = map(object({
    name        = string
    description = optional(string)
    policy      = string
    path        = optional(string, "/")
    tags        = optional(map(string), {})
  }))
  default = {}

  validation {
    condition     = alltrue([for k, v in var.policies : length(v.policy) <= 6144])
    error_message = "IAM policy documents must not exceed 6,144 characters."
  }

  validation {
    condition     = alltrue([for k, v in var.policies : can(jsondecode(v.policy))])
    error_message = "All policy documents must be valid JSON."
  }
    name        = string
    path        = optional(string, "/")
    description = optional(string)
    policy      = string
    tags        = optional(map(string), {})
  }))
  default = {}
}

variable "user_group_memberships" {
  description = "Map of IAM user group memberships to create"
  type = map(object({
    user_key = string
    groups   = list(string)
  }))
  default = {}
}

variable "role_policy_attachments" {
  description = "Map of IAM role policy attachments to create"
  type = map(object({
    role_key   = string
    policy_key = string
  }))
  default = {}
}

variable "user_policy_attachments" {
  description = "Map of IAM user policy attachments to create"
  type = map(object({
    user_key   = string
    policy_key = string
  }))
  default = {}
}

variable "group_policy_attachments" {
  description = "Map of IAM group policy attachments to create"
  type = map(object({
    group_key  = string
    policy_key = string
  }))
  default = {}
}

variable "access_keys" {
  description = "Map of IAM access keys to create"
  type = map(object({
    user_key = string
    pgp_key  = optional(string)
    status   = optional(string, "Active")
  }))
  default = {}
}

variable "login_profiles" {
  description = "Map of IAM user login profiles to create"
  type = map(object({
    user_key                = string
    password_reset_required = optional(bool, true)
    password_length         = optional(number, 20)
    pgp_key                 = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
} 
# ==============================================================================
# Enhanced IAM Configuration Variables
# ==============================================================================

variable "enable_mfa" {
  description = "Whether to enable MFA for IAM users"
  type        = bool
  default     = false
}

variable "require_mfa" {
  description = "Whether to require MFA for IAM users"
  type        = bool
  default     = false
}

variable "enable_password_policy" {
  description = "Whether to enable password policy"
  type        = bool
  default     = false
}

variable "password_policy" {
  description = "Password policy configuration"
  type = object({
    minimum_password_length = optional(number, 8)
    require_symbols = optional(bool, true)
    require_numbers = optional(bool, true)
    require_uppercase_characters = optional(bool, true)
    require_lowercase_characters = optional(bool, true)
    allow_users_to_change_password = optional(bool, true)
    max_password_age = optional(number, 90)
    password_reuse_prevention = optional(number, 24)
    hard_expiry = optional(bool, false)
  })
  default = {}
}

variable "enable_account_password_policy" {
  description = "Whether to enable account password policy"
  type        = bool
  default     = false
}

variable "enable_account_alias" {
  description = "Whether to enable account alias"
  type        = bool
  default     = false
}

variable "account_alias" {
  description = "Account alias name"
  type        = string
  default     = null
}

variable "enable_saml_provider" {
  description = "Whether to enable SAML provider"
  type        = bool
  default     = false
}

variable "saml_provider" {
  description = "SAML provider configuration"
  type = object({
    name = string
    saml_metadata_document = string
  })
  default = null
}

variable "enable_oidc_provider" {
  description = "Whether to enable OIDC provider"
  type        = bool
  default     = false
}

variable "oidc_provider" {
  description = "OIDC provider configuration"
  type = object({
    url = string
    client_id_list = list(string)
    thumbprint_list = list(string)
  })
  default = null
}

variable "enable_service_linked_roles" {
  description = "Whether to enable service linked roles"
  type        = bool
  default     = false
}

variable "service_linked_roles" {
  description = "Service linked roles to create"
  type = list(object({
    aws_service_name = string
    description = optional(string, null)
    custom_suffix = optional(string, null)
  }))
  default = []
}

variable "enable_instance_profiles" {
  description = "Whether to enable instance profiles"
  type        = bool
  default     = false
}

variable "instance_profiles" {
  description = "Instance profiles to create"
  type = map(object({
    name = string
    path = optional(string, /")
    role = string
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "enable_openid_connect_providers" {
  description = "Whether to enable OpenID Connect providers"
  type        = bool
  default     = false
}

variable "openid_connect_providers" {
  description = "OpenID Connect providers to create"
  type = map(object({
    url = string
    client_id_list = list(string)
    thumbprint_list = list(string)
  }))
  default = {}
}

variable "enable_saml_providers" {
  description = "Whether to enable SAML providers"
  type        = bool
  default     = false
}

variable "saml_providers" {
  description = "SAML providers to create"
  type = map(object({
    name = string
    saml_metadata_document = string
  }))
  default = {}
}

variable "enable_managed_policies" {
  description = "Whether to enable managed policies"
  type        = bool
  default     = false
}

variable "managed_policies" {
  description = "Managed policies to attach"
  type = map(object({
    name = string
    arn = string
    description = optional(string, null)
  }))
  default = {}
}

variable "enable_inline_policies" {
  description = "Whether to enable inline policies"
  type        = bool
  default     = false
}

variable "inline_policies" {
  description = "Inline policies to create"
  type = map(object({
    name = string
    policy = string
    users = optional(list(string), [])
    groups = optional(list(string), [])
    roles = optional(list(string), [])
  }))
  default = {}
}

