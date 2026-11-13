# WordPress Application Infrastructure (Repository 2)

The application and compute layers of the WordPress deployment: load balancer, EC2 Auto Scaling, RDS database and EFS shared storage. It runs on top of the network, certificate and KMS keys created by [wp-platform-infra](https://github.com/Vilina/wp-platform-infra) (Repository 1) and reads their identifiers from SSM Parameter Store under `/platform/<env>/`.

Each environment (`dev`, `prod`) is a separate deployment of the same code with its own variables and its own state.

## Project structure

```text
wp-app/
├── config/
│   ├── dev.backend     # S3 backend settings for dev  (key app/dev/terraform.tfstate)
│   ├── dev.tfvars      # dev variables
│   ├── prod.backend    # S3 backend settings for prod (key app/prod/terraform.tfstate)
│   └── prod.tfvars     # prod variables
├── terraform.tf        # Terraform version, AWS provider, default tags, empty S3 backend
├── variables.tf        # Input variables
├── locals.tf           # Naming prefix, platform SSM path, account lookups
└── outputs.tf          # Terraform outputs
```

## Remote state

State lives in the bucket created by the platform repo's `bootstrap/`, encrypted with its KMS key. The platform uses `platform/<env>/`; this repo uses `app/<env>/`.

| Environment | Backend file | State key |
| --- | --- | --- |
| dev | `config/dev.backend` | `app/dev/terraform.tfstate` |
| prod | `config/prod.backend` | `app/prod/terraform.tfstate` |

## Running locally

Requires Terraform 1.10+ and AWS credentials for the account. The platform must already be deployed in the environment.

Dev (prod is the same with `prod` in place of `dev`):

```bash
terraform init -reconfigure -backend-config=config/dev.backend
```

```bash
terraform plan -var-file=config/dev.tfvars
```

Always run `init -reconfigure` with the matching backend file when switching environments.
