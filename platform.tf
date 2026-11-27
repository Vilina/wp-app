# -----------------------------------------------------------------------------
# Platform exports: identifiers published by wp-platform-infra under
# /platform/<environment>/..., e.g. /platform/dev/vpc/id
#
# Each parameter is read by name, so a missing one fails the plan with
# ParameterNotFound and names it (e.g. when the platform isn't deployed).
# -----------------------------------------------------------------------------

locals {
  platform_parameters = [
    "vpc/id",
    "vpc/cidr",
    "subnets/public/ids",
    "subnets/private/ids",
    "acm/certificate-arn",
    "kms/rds/arn",
    "kms/efs/arn",
    "kms/secrets/arn",
    "dns/zone-id",
    "dns/domain-name",
  ]
}

data "aws_ssm_parameter" "platform" {
  for_each = toset(local.platform_parameters)

  name = "${local.platform_ssm_path}/${each.key}"
}

locals {
  # insecure_value: same text as value, without the sensitive flag the provider
  # always sets. Fine here: these are IDs and ARNs, not secrets.
  platform = { for key, parameter in data.aws_ssm_parameter.platform : key => parameter.insecure_value }

  vpc_id              = local.platform["vpc/id"]
  vpc_cidr            = local.platform["vpc/cidr"]
  public_subnet_ids   = split(",", local.platform["subnets/public/ids"])
  private_subnet_ids  = split(",", local.platform["subnets/private/ids"])
  certificate_arn     = local.platform["acm/certificate-arn"]
  rds_kms_key_arn     = local.platform["kms/rds/arn"]
  efs_kms_key_arn     = local.platform["kms/efs/arn"]
  secrets_kms_key_arn = local.platform["kms/secrets/arn"]
  dns_zone_id         = local.platform["dns/zone-id"]
  domain_name         = local.platform["dns/domain-name"]
}
