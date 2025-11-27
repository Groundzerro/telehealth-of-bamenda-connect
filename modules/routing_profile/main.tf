locals {
  primary_queue_name = (
    contains(keys(var.queues), var.primary_queue_name)
    ? var.primary_queue_name
    : keys(var.queues)[0]
  )
}

resource "aws_connect_routing_profile" "this" {
  instance_id               = var.instance_id
  name                      = "${var.name_prefix}-routing-profile"
  description               = "Routing profile for Tele-Health of Bamenda agents"
  default_outbound_queue_id = var.queues[local.primary_queue_name].id

  media_concurrencies {
    channel     = "VOICE"
    concurrency = 1
  }

  dynamic "queue_configs" {
    for_each = var.queues
    content {
      channel  = "VOICE"
      delay    = 0
      priority = 1
      queue_id = queue_configs.value.id
    }
  }

  tags = {
    Project     = var.name_prefix
    Environment = var.name_prefix
    Type        = "RoutingProfile"
  }
}
