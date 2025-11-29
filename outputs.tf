output "hours_of_operation_id" {
  description = "ID of the hours of operation"
  value       = module.hours.hours_id
}

output "queue_ids" {
  description = "IDs of all created queues"
  value = {
    for name, q in module.queues.queues :
    name => q.id
  }
}

output "routing_profile_id" {
  description = "Routing profile for Tele-Health agents"
  value       = module.routing_profile.routing_profile_id
}

output "security_profile_id" {
  description = "Custom security profile for Tele-Health agents"
  value       = module.security_profile.security_profile_id
}

output "agent_ids" {
  description = "Map of agent usernames to user_ids"
  value       = module.users.user_ids
}

output "inbound_flow_id" {
  description = "ID of the basic inbound contact flow"
  value       = module.contact_flows.inbound_flow_id
}

output "quick_connect_ids" {
  description = "Map of queue logical name to quick connect ID"
  value       = module.quick_connects.quick_connect_ids
}

output "agent_hold_flow_id" {
  description = "Agent hold flow ID"
  value       = module.contact_flows.agent_hold_flow_id
}

output "agent_whisper_flow_id" {
  description = "Agent whisper flow ID"
  value       = module.contact_flows.agent_whisper_flow_id
}

output "pre_queue_flow_id" {
  description = "Pre-queue contact flow ID"
  value       = module.contact_flows.pre_queue_flow_id
}

output "customer_queue_flow_id" {
  description = "Customer queue flow ID"
  value       = module.contact_flows.customer_queue_flow_id
}

output "customer_hold_flow_id" {
  description = "Customer hold flow ID"
  value       = module.contact_flows.customer_hold_flow_id
}

output "customer_whisper_flow_id" {
  description = "Customer whisper flow ID"
  value       = module.contact_flows.customer_whisper_flow_id
}

output "helpdesk_flow_id" {
  description = "Helpdesk contact flow ID"
  value       = module.contact_flows.helpdesk_flow_id
}



# ########################################
# # Hours of Operation
# ########################################

# output "hours_of_operation_id" {
#   description = "ID of the hours of operation"
#   value       = aws_connect_hours_of_operation.telehealth_hours.hours_of_operation_id
# }

# ########################################
# # Queues
# ########################################

# output "queue_ids" {
#   description = "IDs of all created queues, keyed by logical queue name"
#   value = {
#     for name, q in aws_connect_queue.telehealth_queues :
#     name => q.queue_id
#   }
# }

# ########################################
# # Routing Profile
# ########################################

# output "routing_profile_id" {
#   description = "Routing profile for Tele-Health of Bamenda agents"
#   value       = aws_connect_routing_profile.telehealth_routing.routing_profile_id
# }

# ########################################
# # Security Profile
# ########################################

# output "security_profile_id" {
#   description = "Security profile ID for Tele-Health of Bamenda agents"
#   value       = aws_connect_security_profile.telehealth_agents.security_profile_id
# }

# ########################################
# # Users (Agents)
# ########################################

# output "agent_ids" {
#   description = "Map of agent usernames to Connect user IDs"
#   value = {
#     for username, u in aws_connect_user.telehealth_agents :
#     username => u.user_id
#   }
# }

########################################
# Contact Flow (optional – only if you add a root resource)
########################################

# If (later) you create a root-level resource like:
# resource "aws_connect_contact_flow" "inbound_basic" { ... }
# then you can uncomment this:

# output "inbound_flow_id" {
#   description = "Contact flow ID for basic inbound flow"
#   value       = aws_connect_contact_flow.inbound_basic.contact_flow_id
# }


# output "hours_of_operation_id" {
#   description = "ID of the hours of operation"
#   value       = module.hours.hours_id
# }

# output "queue_ids" {
#   description = "IDs of all created queues"
#   value = {
#     for name, q in module.queues.queues :
#     name => q.id
#   }
# }

# output "routing_profile_id" {
#   description = "Routing profile for Tele-Health agents"
#   value       = module.routing_profile.routing_profile_id
# }

# output "security_profile_id" {
#   description = "Custom security profile for Tele-Health agents"
#   value       = module.security_profile.security_profile_id
# }

# output "agent_ids" {
#   description = "Map of agent usernames to user_ids"
#   value       = module.users.user_ids
# }

# output "inbound_flow_id" {
#   description = "ID of the basic inbound contact flow"
#   value       = module.contact_flows.inbound_flow_id
# }


# output "hours_of_operation_id" {
#   description = "ID of the hours of operation"
#   value       = aws_connect_hours_of_operation.telehealth_hours.hours_of_operation_id
# }

# output "queue_ids" {
#   description = "IDs of all created queues"
#   value = {
#     for q in aws_connect_queue.telehealth_queues : q.name => q.queue_id
#   }
# }

# output "routing_profile_id" {
#   description = "Routing profile for Tele-Health agents"
#   value       = aws_connect_routing_profile.telehealth_routing.routing_profile_id
# }

# output "security_profile_id" {
#   description = "Custom security profile for Tele-Health agents"
#   value       = aws_connect_security_profile.telehealth_agents.security_profile_id
# }

# output "agent_ids" {
#   description = "Map of agent usernames to user_ids"
#   value = {
#     for username, u in aws_connect_user.telehealth_agents :
#     username => u.user_id
#   }
# }


# output "agent_ids" {
#   description = "Map of agent usernames to user_ids"
#   value = {
#     for u in aws_connect_user.telehealth_agents : u.username => u.user_id
#   }
# }
