data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  # Every resource name starts with this, e.g. dev-wp-alb, prod-wp-rds.
  name_prefix = "${var.environment}-${var.project_name}"

  # Where the platform publishes its VPC, subnet, certificate and KMS identifiers.
  platform_ssm_path = "${var.platform_ssm_prefix}/${var.environment}"
}
