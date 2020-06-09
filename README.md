## AWS Cognito User Pool Terraform Module

Terraform module that creates an AWS Cognito User Pool with a custom
domain

#### Prerequisites
An active Route53 Zone

An us-east-1 AWS provider explicitly declared and passed into the module. See [example](examples/default/main.tf)

#### Note 
~~This module may not destroy on the first attempt with an error stating 
that the certificate is still in use.  A subsequent terraform destroy will
remove the certificate~~ This error apprears to have been solved by moving the certificate provider out of the module.