locals {
  # Simple name prefix for resources
  name_prefix = "${var.project_name}-${var.environment}"
}

############################
# 1. Hours of Operation
############################

resource "aws_connect_hours_of_operation" "telehealth_hours" {
  instance_id = var.connect_instance_id
  name        = "${local.name_prefix}-business-hours"
  description = "Business hours for Tele-Health of Bamenda"
  time_zone   = var.business_hours_timezone

  # Loop over each configured day
  dynamic "config" {
    for_each = var.business_hours
    content {
      day = config.key

      start_time {
        hours   = config.value.start_hour
        minutes = config.value.start_minute
      }

      end_time {
        hours   = config.value.end_hour
        minutes = config.value.end_minute
      }
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Type        = "HoursOfOperation"
  }
}

############################
# 2. Queues
############################

resource "aws_connect_queue" "telehealth_queues" {
  for_each = {
    for q in var.queues :
    q.name => q
  }

  instance_id           = var.connect_instance_id
  name                  = "${local.name_prefix}-${each.value.name}"
  description           = each.value.description
  hours_of_operation_id = aws_connect_hours_of_operation.telehealth_hours.hours_of_operation_id

  # You can customize this later (max_contacts, outbound caller config, etc.)
  tags = {
    Project     = var.project_name
    Environment = var.environment
    QueueRole   = each.value.name
  }
}

############################
# 3. Routing Profile
############################

# Pick a "primary" queue for default outbound
# (we'll choose Nurse-Line if present, otherwise the first in the list)

locals {
  primary_queue_name = (
    contains(keys(aws_connect_queue.telehealth_queues), "Nurse-Line")
    ? "Nurse-Line"
    : keys(aws_connect_queue.telehealth_queues)[0]
  )
}

resource "aws_connect_routing_profile" "telehealth_routing" {
  instance_id               = var.connect_instance_id
  name                      = "${local.name_prefix}-routing-profile"
  description               = "Routing profile for Tele-Health of Bamenda agents"
  default_outbound_queue_id = aws_connect_queue.telehealth_queues[local.primary_queue_name].queue_id

  # Agents handle only VOICE for now, 1 at a time
  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }

  # Associate all queues with VOICE channel
  dynamic "queue_configs" {
    for_each = aws_connect_queue.telehealth_queues
    content {
      channel  = "VOICE"
      delay    = 0
      priority = 1
      queue_id = queue_configs.value.queue_id
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Type        = "RoutingProfile"
  }
}

############################
# 4. Security Profile
############################

resource "aws_connect_security_profile" "telehealth_agents" {
  instance_id = var.connect_instance_id
  name        = "${local.name_prefix}-agent-security-profile"
  description = "Security profile for Tele-Health of Bamenda agents"

  # Minimal permissions example – adjust later as needed
  permissions = [
    "BasicAgentAccess",
    "OutboundCallAccess",
  ]

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Type        = "SecurityProfile"
  }
}

############################
# 5. Users (Agents)
############################

resource "aws_connect_user" "telehealth_agents" {
  for_each = {
    for a in var.agents :
    a.username => a
  }

  instance_id = var.connect_instance_id

  # 'name' is the Connect login name (what the user types to log in)
  # We'll use the username here
  name = each.value.username

  # DEMO password – in real life use SSO or external management
  password = "P@ssword12345!"

  routing_profile_id = aws_connect_routing_profile.telehealth_routing.routing_profile_id

  security_profile_ids = [
    aws_connect_security_profile.telehealth_agents.security_profile_id
  ]

  identity_info {
    first_name = each.value.first
    last_name  = each.value.last
    email      = each.value.email
  }

  phone_config {
    phone_type                    = "SOFT_PHONE"
    after_contact_work_time_limit = 0
    auto_accept                   = false
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Type        = "User"
  }
}

####################################################################

# locals {
#   # Simple name prefix for resources
#   name_prefix = "${var.project_name}-${var.environment}"
# }

# ############################
# # 1. Hours of Operation
# ############################

# resource "aws_connect_hours_of_operation" "telehealth_hours" {
#   instance_id = var.connect_instance_id
#   name        = "${local.name_prefix}-business-hours"
#   description = "Business hours for Tele-Health of Bamenda"
#   time_zone   = var.business_hours_timezone

#   # Loop over each configured day
#   dynamic "config" {
#     for_each = var.business_hours
#     content {
#       day = config.key

#       start_time {
#         hours   = config.value.start_hour
#         minutes = config.value.start_minute
#       }

#       end_time {
#         hours   = config.value.end_hour
#         minutes = config.value.end_minute
#       }
#     }
#   }

#   tags = {
#     Project     = var.project_name
#     Environment = var.environment
#     Type        = "HoursOfOperation"
#   }
# }

# ############################
# # 2. Queues
# ############################

# resource "aws_connect_queue" "telehealth_queues" {
#   for_each = {
#     for q in var.queues :
#     q.name => q
#   }

#   instance_id           = var.connect_instance_id
#   name                  = "${local.name_prefix}-${each.value.name}"
#   description           = each.value.description
#   hours_of_operation_id = aws_connect_hours_of_operation.telehealth_hours.hours_of_operation_id

#   # You can customize this later (max_contacts, outbound caller config, etc.)
#   tags = {
#     Project     = var.project_name
#     Environment = var.environment
#     QueueRole   = each.value.name
#   }
# }

# ############################
# # 3. Routing Profile
# ############################

# # Pick a "primary" queue for default outbound
# # (we'll choose Nurse-Line if present, otherwise the first in the list)

# locals {
#   primary_queue_name = (
#     contains(keys(aws_connect_queue.telehealth_queues), "Nurse-Line")
#     ? "Nurse-Line"
#     : keys(aws_connect_queue.telehealth_queues)[0]
#   )
# }

# resource "aws_connect_routing_profile" "telehealth_routing" {
#   instance_id               = var.connect_instance_id
#   name                      = "${local.name_prefix}-routing-profile"
#   description               = "Routing profile for Tele-Health of Bamenda agents"
#   default_outbound_queue_id = aws_connect_queue.telehealth_queues[local.primary_queue_name].queue_id

#   # Agents handle only VOICE for now, 1 at a time
#   media_concurrencies {
#     channel     = "VOICE"
#     concurrency = 1
#   }

#   # Associate all queues with VOICE channel
#   dynamic "queue_configs" {
#     for_each = aws_connect_queue.telehealth_queues
#     content {
#       channel  = "VOICE"
#       delay    = 0
#       priority = 1
#       queue_id = queue_configs.value.queue_id
#     }
#   }

#   tags = {
#     Project     = var.project_name
#     Environment = var.environment
#     Type        = "RoutingProfile"
#   }
# }

# ############################
# # 4. Security Profile
# ############################

# resource "aws_connect_security_profile" "telehealth_agents" {
#   instance_id = var.connect_instance_id
#   name        = "${local.name_prefix}-agent-security-profile"
#   description = "Security profile for Tele-Health of Bamenda agents"

#   # Minimal permissions example – adjust later as needed
#   permissions = [
#     "BasicAgentAccess",
#     "OutboundCallAccess",
#   ]

#   tags = {
#     Project     = var.project_name
#     Environment = var.environment
#     Type        = "SecurityProfile"
#   }
# }

# ############################
# # 5. Users (Agents)
# ############################

# resource "aws_connect_user" "telehealth_agents" {
#   for_each = {
#     for a in var.agents :
#     a.username => a
#   }

#   instance_id = var.connect_instance_id

#   # 'name' is often the login name or email (what user types to log in)
#   name     = each.value.email
#   name = each.value.username

#   # DEMO password – in real life use SSO or external management
#   password = "P@ssword12345!"

#   routing_profile_id = aws_connect_routing_profile.telehealth_routing.routing_profile_id

#   security_profile_ids = [
#     aws_connect_security_profile.telehealth_agents.security_profile_id
#   ]

#   identity_info {
#     first_name = each.value.first
#     last_name  = each.value.last
#     email      = each.value.email
#   }

#   phone_config {
#     phone_type                    = "SOFT_PHONE"
#     after_contact_work_time_limit = 0
#     auto_accept                   = false
#   }

#   tags = {
#     Project     = var.project_name
#     Environment = var.environment
#     Type        = "User"
#   }
# }



# # resource "aws_connect_user" "telehealth_agents" {
# #   for_each = {
# #     for a in var.agents :
# #     a.username => a
# #   }

# #   instance_id        = var.connect_instance_id
# #   name               = each.value.email           # login name
# #   username           = each.value.username
# #   routing_profile_id = aws_connect_routing_profile.telehealth_routing.routing_profile_id

# #   security_profile_ids = [
# #     aws_connect_security_profile.telehealth_agents.security_profile_id
# #   ]

# #   # DEMO ONLY – in production use SSO or manage passwords outside TF
# #   password = "P@ssword12345!"

# #   identity_info {
# #     first_name = each.value.first
# #     last_name  = each.value.last
# #     email      = each.value.email
# #   }

# #   phone_config {
# #     phone_type                    = "SOFT_PHONE"
# #     after_contact_work_time_limit = 0
# #     auto_accept                   = false
# #   }

# #   tags = {
# #     Project     = var.project_name
# #     Environment = var.environment
# #     Type        = "User"
# #   }
# # }
