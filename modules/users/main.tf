resource "aws_connect_user" "this" {
  # Create one Connect user per agent definition
  for_each = {
    for a in var.agents :
    a.username => a
  }

  # 🚦 SAFETY NET: never destroy a user accidentally
  lifecycle {
    prevent_destroy = true

    # Optional but recommended:
    # Don't try to rotate password from Terraform every time you tweak it in the console.
    ignore_changes = [
      password
    ]
  }


  # Core identifiers
  instance_id = var.instance_id

  # 'name' is the login name the agent uses in Amazon Connect.
  # We’ll use the username field from your agents list.
  name = each.value.username

  # DEMO ONLY – in production, avoid hardcoded passwords
  password = "P@ssword12345!"

  routing_profile_id   = var.routing_profile_id
  security_profile_ids = var.security_profile_ids

  # Identity info displayed in Connect / used for notifications
  identity_info {
    first_name = each.value.first
    last_name  = each.value.last
    email      = each.value.email
  }

  # Softphone configuration
  phone_config {
    phone_type                    = "SOFT_PHONE"
    after_contact_work_time_limit = 0
    auto_accept                   = false
  }

  tags = {
    Project     = var.name_prefix
    Environment = var.name_prefix
    Type        = "User"
  }
}
