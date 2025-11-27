locals {
  inbound_name  = "${var.name_prefix}-inbound-basic"
  transfer_name = "${var.name_prefix}-transfer-to-queue"
}

resource "aws_connect_contact_flow" "inbound_basic" {
  instance_id = var.instance_id
  name        = local.inbound_name
  description = "Basic inbound greeting flow for Tele-Health of Bamenda"

  # Correct argument name is "type", not "contact_flow_type"
  type = "CONTACT_FLOW"

  # Render your JSON contact flow from a template
  content = templatefile("${path.module}/templates/inbound_ivr.json.tftpl", {})

  tags = {
    Project     = var.name_prefix
    Environment = var.name_prefix
    Type        = "ContactFlow"
  }
}

resource "aws_connect_contact_flow" "queue_transfer" {
  instance_id = var.instance_id
  name        = "${var.name_prefix}-queue-transfer"
  description = "Transfer-to-queue flow for Quick Connects in Tele-Health of Bamenda"
  type        = "QUEUE_TRANSFER"

  # Use the exported JSON as-is for now
  content = templatefile("${path.module}/templates/transfer_to_queue.json.tftpl", {})

  tags = {
    Project     = var.name_prefix
    Environment = var.name_prefix
    Type        = "ContactFlow"
  }
}

