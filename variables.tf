# -----------------------------------------------------------------------------
# General
# -----------------------------------------------------------------------------

variable "environment" {
  description = "Environment name. Used as the prefix of every resource name, e.g. dev-wp-alb."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be \"dev\" or \"prod\"."
  }
}

variable "aws_region" {
  description = "AWS region of the environment. Must match the platform's region. Set in config/<env>.tfvars."
  type        = string
}

variable "project_name" {
  description = "Short project name used in resource names (<environment>-<project_name>-<resource>)."
  type        = string
  default     = "wp"
}

variable "tags" {
  description = "Additional tags applied to all AWS resources through the provider."
  type        = map(string)
  default     = {}
}

# -----------------------------------------------------------------------------
# Platform (wp-platform-infra)
# -----------------------------------------------------------------------------

variable "platform_ssm_prefix" {
  description = "Prefix of the platform's SSM exports; the environment is appended (/platform/<env>/...)."
  type        = string
  default     = "/platform"
}
