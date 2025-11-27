resource "aws_connect_queue" "this" {
  for_each = {
    for q in var.queues :
    q.name => q
  }

  instance_id           = var.instance_id
  name                  = "${var.name_prefix}-${each.value.name}"
  description           = each.value.description
  hours_of_operation_id = var.hours_of_operation_id

  tags = {
    Project     = var.name_prefix
    Environment = var.name_prefix
    QueueRole   = each.value.name
  }
}
