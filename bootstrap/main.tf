locals {
  # Keep names predictable and unique-ish
  state_bucket_name = "${replace(var.project_name, "/[^a-z0-9-]/", "")}-${var.environment}-tfstate-bucket"
  lock_table_name   = "${replace(var.project_name, "/[^a-zA-Z0-9]/", "")}_${var.environment}_tf_lock"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = local.state_bucket_name

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Purpose     = "TerraformState"
  }
}

resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state_encryption" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state_block_public" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = local.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Purpose     = "TerraformLock"
  }
}

output "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.tf_state.id
}

output "lock_table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  value       = aws_dynamodb_table.tf_lock.name
}
