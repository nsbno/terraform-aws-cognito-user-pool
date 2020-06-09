terraform {
  required_version = ">=0.12"
}

locals {
  region      = "eu-west-1"
  name_prefix = "cognito-test"
}

provider "aws" {
  version = "~> 2.65.0"
  region  = local.region
}

provider "aws" {
  version = "~> 2.65.0"
  region  = "us-east-1"
  alias   = "certificate_provider"
}

module "cognito_user_pool" {
  providers = {
    aws.certificate_provider = aws.certificate_provider
  }
  source                       = "../../"
  name_prefix                  = local.name_prefix
  custom_pool_domain_subdomain = "test-auth"
  hosted_zone_name             = "<hosted-zone-name>"
  create_faux_root_a_record    = true
}