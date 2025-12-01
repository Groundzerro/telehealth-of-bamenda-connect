output "table_name" {
  description = "Name of the DynamoDB table for prompts"
  value       = aws_dynamodb_table.prompts.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table for prompts"
  value       = aws_dynamodb_table.prompts.arn
}
