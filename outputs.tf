output "environment" {
  description = "Environment this state belongs to."
  value       = var.environment
}

output "platform_vpc_id" {
  description = "VPC read from the platform's SSM exports."
  value       = local.vpc_id
}

output "platform_subnet_counts" {
  description = "Number of public and private subnets read from the platform's SSM exports."
  value = {
    public  = length(local.public_subnet_ids)
    private = length(local.private_subnet_ids)
  }
}

output "platform_certificate_arn" {
  description = "ACM certificate read from the platform's SSM exports."
  value       = local.certificate_arn
}
