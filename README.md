## AWS Cognito User Pool Terraform Module

Terraform module that creates an AWS Cognito User Pool with a custom
domain

#### Prerequisites
An active Route53 Zone

#### Note 
This module may not destroy on the first attempt with an error stating 
that the certificate is still in use.  A subsequent terraform destroy will
remove the certificate