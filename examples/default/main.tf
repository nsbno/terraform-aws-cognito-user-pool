terraform {
  required_version = ">=0.12"
}

locals {
  region      = "eu-west-1"
  name_prefix = "cognito-test"
}

provider "aws" {
  version = "~> 2.35.0"
  region  = local.region
  alias   = "default"
}

provider "aws" {
  version = "~> 2.35.0"
  region = "us-east-1"
  alias  = "certificate-provider"
}

module "cognito_user_pool" {
  providers = {
    aws = aws.default,
    aws = aws.certificate-provider
  }
  source                       = "../../"
  name_prefix                  = local.name_prefix
  custom_pool_domain_subdomain = "test-auth"
  hosted_zone_name             = "<hosted-zone-name>"
  create_faux_root_a_record    = true
}