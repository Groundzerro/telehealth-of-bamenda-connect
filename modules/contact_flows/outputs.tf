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
