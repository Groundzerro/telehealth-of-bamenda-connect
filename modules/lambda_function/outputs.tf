output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.this.arn
}
