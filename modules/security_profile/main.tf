resource "aws_connect_security_profile" "this" {
  instance_id = var.instance_id
  name        = "${var.name_prefix}-agent-security-profile"
  description = var.description

  permissions = var.permissions

  tags = {
    Project     = var.name_prefix
    Environment = var.name_prefix
    Type        = "SecurityProfile"
  }
}
