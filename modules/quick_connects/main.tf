resource "aws_connect_quick_connect" "queue_quick_connects" {
  for_each = var.queues

  instance_id = var.instance_id
  name        = "${var.name_prefix}-QC-to-${each.key}"
  description = "Quick Connect to ${each.value.name} queue"

  quick_connect_config {
    quick_connect_type = "QUEUE"

    queue_config {
      queue_id        = each.value.id
      contact_flow_id = var.transfer_flow_id
    }
  }

  tags = {
    Project     = var.name_prefix
    Environment = var.name_prefix
    Type        = "QuickConnect"
    Queue       = each.key
  }
}
