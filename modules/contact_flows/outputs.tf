output "inbound_flow_id" {
  description = "ID of the basic inbound contact flow"
  value       = aws_connect_contact_flow.inbound_basic.contact_flow_id
}

output "queue_transfer_flow_id" {
  description = "ID of the queue transfer contact flow"
  value       = aws_connect_contact_flow.queue_transfer.contact_flow_id
}


# output "transfer_flow_id" {
#   value = aws_connect_contact_flow.transfer_to_queue.contact_flow_id
# }

output "agent_hold_flow_id" {
  description = "ID of the agent hold flow"
  value       = aws_connect_contact_flow.agent_hold.contact_flow_id
}

output "agent_whisper_flow_id" {
  description = "ID of the agent whisper flow"
  value       = aws_connect_contact_flow.agent_whisper.contact_flow_id
}

output "pre_queue_flow_id" {
  description = "ID of the pre-queue contact flow"
  value       = aws_connect_contact_flow.pre_queue.contact_flow_id
}

output "customer_queue_flow_id" {
  description = "ID of the customer queue flow"
  value       = aws_connect_contact_flow.customer_queue.contact_flow_id
}

output "customer_hold_flow_id" {
  description = "ID of the customer hold flow"
  value       = aws_connect_contact_flow.customer_hold.contact_flow_id
}

output "customer_whisper_flow_id" {
  description = "ID of the customer whisper flow"
  value       = aws_connect_contact_flow.customer_whisper.contact_flow_id
}

output "helpdesk_flow_id" {
  description = "ID of the helpdesk contact flow"
  value       = aws_connect_contact_flow.helpdesk.contact_flow_id
}
