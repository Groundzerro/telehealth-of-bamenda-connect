output "quick_connect_ids" {
  description = "Map of queue logical name to Quick Connect ID"
  value = {
    for name, qc in aws_connect_quick_connect.queue_quick_connects :
    name => qc.quick_connect_id
  }
}
