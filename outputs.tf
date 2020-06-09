output "arn" {
  description = "The ARN of the user pool."
  value       = aws_cognito_user_pool.user_pool.arn
}

output "id" {
  description = "The id of the user pool."
  value       = aws_cognito_user_pool.user_pool.id
}