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
  description = "Map of IAM users to create"
  type = map(object({
    name                 = string
    path                 = optional(string, "/")
    permissions_boundary = optional(string)
    force_destroy        = optional(bool, false)
    tags                 = optional(map(string), {})
  }))
  default = {}
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
  description = "Map of IAM policies to create"
  type = map(object({
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