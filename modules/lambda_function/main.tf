data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "base_logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "base_logs" {
  name        = "${var.function_name}-logs"
  description = "Basic CloudWatch Logs permissions for ${var.function_name}"
  policy      = data.aws_iam_policy_document.base_logs.json
}

resource "aws_iam_role_policy_attachment" "base_logs_attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.base_logs.arn
}

# Optional extra permissions (DynamoDB, Connect metrics, etc.)
data "aws_iam_policy_document" "extra" {
  dynamic "statement" {
    for_each = var.policy_statements
    content {
      actions   = statement.value.actions
      resources = statement.value.resources
      effect    = lookup(statement.value, "effect", "Allow")

      dynamic "condition" {
        for_each = lookup(statement.value, "condition", [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_policy" "extra" {
  count       = length(var.policy_statements) > 0 ? 1 : 0
  name        = "${var.function_name}-extra"
  description = "Extra permissions for ${var.function_name}"
  policy      = data.aws_iam_policy_document.extra.json
}

resource "aws_iam_role_policy_attachment" "extra_attach" {
  count      = length(var.policy_statements) > 0 ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.extra[0].arn
}

# Package code
data "archive_file" "zip" {
  type        = "zip"
  source_dir  = var.source_path
  output_path = "${path.module}/build/${var.function_name}.zip"
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  description   = var.description
  role          = aws_iam_role.this.arn
  handler       = var.handler
  runtime       = var.runtime
  filename      = data.archive_file.zip.output_path
  timeout       = var.timeout
  memory_size   = var.memory_size

  source_code_hash = data.archive_file.zip.output_base64sha256

  environment {
    variables = var.environment
  }

  tags = var.tags
}
