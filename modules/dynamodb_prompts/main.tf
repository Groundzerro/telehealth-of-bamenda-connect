resource "aws_dynamodb_table" "prompts" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "PromptId"

  attribute {
    name = "PromptId"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      Purpose = "TelehealthPromptConfig"
    }
  )
}
