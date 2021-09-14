provider "aws" {
  alias = "certificate_provider"
  region = "us-east-1"
}

data "aws_route53_zone" "main" {
  name = var.hosted_zone_name
}

resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.name_prefix}-user-pool"
  admin_create_user_config {
    allow_admin_create_user_only = var.admin_create_user
  }
  password_policy {
    minimum_length                   = var.password_policy_minimum_length
    require_lowercase                = var.password_policy_require_lowercase
    require_uppercase                = var.password_policy_require_uppercase
    require_numbers                  = var.password_policy_require_numbers
    require_symbols                  = var.password_policy_require_symbols
    temporary_password_validity_days = var.password_policy_temporary_password_validity_days
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain          = "${var.custom_pool_domain_subdomain}.${var.hosted_zone_name}"
  certificate_arn = aws_acm_certificate_validation.cert_pool_domain_validation_request.certificate_arn
  user_pool_id    = aws_cognito_user_pool.user_pool.id
}

resource "aws_route53_record" "custom_pool_domain_subdomain" {
  zone_id = data.aws_route53_zone.main.id
  name    = "${var.custom_pool_domain_subdomain}.${var.hosted_zone_name}"
  type    = "A"
  alias {
    name                   = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate" "cert_pool_domain" {
  domain_name       = "${var.custom_pool_domain_subdomain}.${var.hosted_zone_name}"
  validation_method = "DNS"
  provider          = aws.certificate_provider
  tags              = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_pool_domain_validation" {
  name            = tolist(aws_acm_certificate.cert_pool_domain.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.cert_pool_domain.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.main.id
  records         = [tolist(aws_acm_certificate.cert_pool_domain.domain_validation_options)[0].resource_record_value]
  ttl             = 60
  allow_overwrite = var.allow_overwrite
  
}

resource "aws_acm_certificate_validation" "cert_pool_domain_validation_request" {
  certificate_arn         = aws_acm_certificate.cert_pool_domain.arn
  validation_record_fqdns = [aws_route53_record.cert_pool_domain_validation.fqdn]
  provider                = aws.certificate_provider
}

resource "aws_route53_record" "faux_root_a_record" {
  count   = var.create_faux_root_a_record ? 1 : 0
  name    = ""
  type    = "A"
  ttl     = "300"
  records = ["127.0.0.1"]
  zone_id = data.aws_route53_zone.main.id
}
