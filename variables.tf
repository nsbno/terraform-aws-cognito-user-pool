# ------------------------------------------------------------------------------
# Mandatory Variables
# ------------------------------------------------------------------------------
variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "custom_pool_domain_subdomain" {
  description = "The first part of the domain string. Typically auth"
  type        = string
}

variable "hosted_zone_name" {
  description = "The name of the hosted zone in which to register this pool domain"
  type        = string
}

# ------------------------------------------------------------------------------
# Optional Variables
# ------------------------------------------------------------------------------
variable "admin_create_user" {
  description = "Set to true if only the administrator is allowed to create user profiles. Set to false if users can sign themselves up via an app."
  default     = true
  type        = bool
}

variable "create_faux_root_a_record" {
  description = "Set to true if you don't already have an A record at the root of the domain/subdomain. See prerequisites under https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-add-custom-domain.html#cognito-user-pools-add-custom-domain-adding"
  default     = false
  type        = bool
}

variable "password_policy_minimum_length" {
  description = "A container for information about the user pool password policy."
  default     = 12
}

variable "password_policy_require_lowercase" {
  description = "A container for information about the user pool password policy."
  default     = true
}

variable "password_policy_require_uppercase" {
  description = "A container for information about the user pool password policy."
  default     = false
}

variable "password_policy_require_numbers" {
  description = "A container for information about the user pool password policy."
  default     = false
}

variable "password_policy_require_symbols" {
  description = "A container for information about the user pool password policy."
  default     = false
}

variable "password_policy_temporary_password_validity_days" {
  description = "A container for information about the user pool password policy."
  default     = 7
}

variable "account_recovery_mechanisms" {
  description = "A list of account recovery mechanisms."
  default     = []
  type = list(object({
    name     = string
    priority = number
  }))
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "allow_overwrite" {
  description = "Allow overwrite of aws_route53_record resource."
  default     = false
}

