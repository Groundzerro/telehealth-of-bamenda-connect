output "hours_of_operation_id" {
  description = "ID of the hours of operation"
  value       = aws_connect_hours_of_operation.telehealth_hours.hours_of_operation_id
}

output "queue_ids" {
  description = "IDs of all created queues"
  value = {
    for q in aws_connect_queue.telehealth_queues : q.name => q.queue_id
  }
}

output "routing_profile_id" {
  description = "Routing profile for Tele-Health agents"
  value       = aws_connect_routing_profile.telehealth_routing.routing_profile_id
}

output "security_profile_id" {
  description = "Custom security profile for Tele-Health agents"
  value       = aws_connect_security_profile.telehealth_agents.security_profile_id
}

output "agent_ids" {
  description = "Map of agent usernames to user_ids"
  value = {
    for u in aws_connect_user.telehealth_agents : u.username => u.user_id
  }
}
