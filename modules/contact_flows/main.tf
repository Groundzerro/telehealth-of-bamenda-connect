############################################
# Contact Flows for Tele-Health of Bamenda
############################################

locals {
  # Base names for all flows
  inbound_basic_name  = "${var.name_prefix}-inbound-basic"
  queue_transfer_name = "${var.name_prefix}-queue-transfer"

  agent_hold_name    = "${var.name_prefix}-agent-hold"
  agent_whisper_name = "${var.name_prefix}-agent-whisper"

  pre_queue_name        = "${var.name_prefix}-pre-queue"
  customer_queue_name   = "${var.name_prefix}-customer-queue"
  customer_hold_name    = "${var.name_prefix}-customer-hold"
  customer_whisper_name = "${var.name_prefix}-customer-whisper"

  helpdesk_name = "${var.name_prefix}-helpdesk"

  common_tags = {
    Project     = var.name_prefix
    Environment = var.name_prefix
    Type        = "ContactFlow"
  }
}

#############################
# Inbound Basic Contact Flow
#############################

resource "aws_connect_contact_flow" "inbound_basic" {
  instance_id = var.instance_id
  name        = local.inbound_basic_name
  description = "Basic inbound IVR flow for Tele-Health of Bamenda"
  type        = "CONTACT_FLOW"

  # JSON exported from the Amazon Connect console
  content = templatefile("${path.module}/templates/inbound_ivr.json.tftpl", {})

  tags = local.common_tags
}

######################################
# Queue Transfer Flow (for QuickConnects)
######################################

resource "aws_connect_contact_flow" "queue_transfer" {
  instance_id = var.instance_id
  name        = local.queue_transfer_name
  description = "Queue transfer flow (used by Quick Connects) for Tele-Health of Bamenda"
  type        = "QUEUE_TRANSFER"

  # JSON exported from the Amazon Connect console
  content = templatefile("${path.module}/templates/transfer_to_queue.json.tftpl", {})

  tags = local.common_tags
}

##########################
# Agent Hold Contact Flow
##########################

resource "aws_connect_contact_flow" "agent_hold" {
  instance_id = var.instance_id
  name        = local.agent_hold_name
  description = "Agent hold flow for Tele-Health of Bamenda"
  type        = "AGENT_HOLD"

  # JSON exported from the Amazon Connect console
  content = templatefile("${path.module}/templates/agent_hold.json.tftpl", {})

  tags = merge(local.common_tags, {
    Type = "AgentHoldFlow"
  })
}

############################
# Agent Whisper Contact Flow
############################

resource "aws_connect_contact_flow" "agent_whisper" {
  instance_id = var.instance_id
  name        = local.agent_whisper_name
  description = "Agent whisper flow for Tele-Health of Bamenda"
  type        = "AGENT_WHISPER"

  # JSON exported from the Amazon Connect console
  content = templatefile("${path.module}/templates/agent_whisper.json.tftpl", {})

  tags = merge(local.common_tags, {
    Type = "AgentWhisperFlow"
  })
}

###########################
# Pre-Queue Contact Flow
###########################

resource "aws_connect_contact_flow" "pre_queue" {
  instance_id = var.instance_id
  name        = local.pre_queue_name
  description = "Pre-queue contact flow (initial routing logic) for Tele-Health of Bamenda"
  type        = "CONTACT_FLOW"

  # JSON exported from the Amazon Connect console
  content = templatefile("${path.module}/templates/pre_queue.json.tftpl", {})

  tags = merge(local.common_tags, {
    Type = "PreQueueFlow"
  })
}

#############################
# Customer Queue Contact Flow
#############################

resource "aws_connect_contact_flow" "customer_queue" {
  instance_id = var.instance_id
  name        = local.customer_queue_name
  description = "Customer queue flow for Tele-Health of Bamenda"
  type        = "CUSTOMER_QUEUE"

  # JSON exported from the Amazon Connect console
  content = templatefile("${path.module}/templates/customer_queue.json.tftpl", {})

  tags = merge(local.common_tags, {
    Type = "CustomerQueueFlow"
  })
}

############################
# Customer Hold Contact Flow
############################

resource "aws_connect_contact_flow" "customer_hold" {
  instance_id = var.instance_id
  name        = local.customer_hold_name
  description = "Customer hold flow for Tele-Health of Bamenda"
  type        = "CUSTOMER_HOLD"

  # JSON exported from the Amazon Connect console
  content = templatefile("${path.module}/templates/customer_hold.json.tftpl", {})

  tags = merge(local.common_tags, {
    Type = "CustomerHoldFlow"
  })
}

################################
# Customer Whisper Contact Flow
################################

resource "aws_connect_contact_flow" "customer_whisper" {
  instance_id = var.instance_id
  name        = local.customer_whisper_name
  description = "Customer whisper flow for Tele-Health of Bamenda"
  type        = "CUSTOMER_WHISPER"

  # JSON exported from the Amazon Connect console
  content = templatefile("${path.module}/templates/customer_whisper.json.tftpl", {})

  tags = merge(local.common_tags, {
    Type = "CustomerWhisperFlow"
  })
}

##########################
# Helpdesk Contact Flow
##########################

resource "aws_connect_contact_flow" "helpdesk" {
  instance_id = var.instance_id
  name        = local.helpdesk_name
  description = "Helpdesk contact flow for Tele-Health of Bamenda"
  type        = "CONTACT_FLOW"

  # JSON exported from the Amazon Connect console
  content = templatefile("${path.module}/templates/helpdesk.json.tftpl", {})

  tags = merge(local.common_tags, {
    Type = "HelpdeskFlow"
  })
}




########################################################################

# locals {
#   inbound_name  = "${var.name_prefix}-inbound-basic"
#   transfer_name = "${var.name_prefix}-transfer-to-queue"
# }

# resource "aws_connect_contact_flow" "inbound_basic" {
#   instance_id = var.instance_id
#   name        = local.inbound_name
#   description = "Basic inbound greeting flow for Tele-Health of Bamenda"

#   # Correct argument name is "type", not "contact_flow_type"
#   type = "CONTACT_FLOW"

#   # Render your JSON contact flow from a template
#   content = templatefile("${path.module}/templates/inbound_ivr.json.tftpl", {})

#   tags = {
#     Project     = var.name_prefix
#     Environment = var.name_prefix
#     Type        = "ContactFlow"
#   }
# }

# resource "aws_connect_contact_flow" "queue_transfer" {
#   instance_id = var.instance_id
#   name        = "${var.name_prefix}-queue-transfer"
#   description = "Transfer-to-queue flow for Quick Connects in Tele-Health of Bamenda"
#   type        = "QUEUE_TRANSFER"

#   # Use the exported JSON as-is for now
#   content = templatefile("${path.module}/templates/transfer_to_queue.json.tftpl", {})

#   tags = {
#     Project     = var.name_prefix
#     Environment = var.name_prefix
#     Type        = "ContactFlow"
#   }
# }

# # Agent Hold flow
# resource "aws_connect_contact_flow" "agent_hold" {
#   instance_id = var.instance_id
#   name        = "${var.name_prefix}-agent-hold"
#   description = "Agent hold flow for Tele-Health of Bamenda"
#   type        = "AGENT_HOLD"

#   content = templatefile("${path.module}/templates/agent_hold.json.tftpl", {})

#   tags = {
#     Project     = var.name_prefix
#     Environment = var.name_prefix
#     Type        = "AgentHoldFlow"
#   }
# }


# # Agent Whisper flow
# resource "aws_connect_contact_flow" "agent_whisper" {
#   instance_id = var.instance_id
#   name        = "${var.name_prefix}-agent-whisper"
#   description = "Agent whisper flow for Tele-Health of Bamenda"
#   type        = "AGENT_WHISPER"

#   content = templatefile("${path.module}/templates/agent_whisper.json.tftpl", {})

#   tags = {
#     Project     = var.name_prefix
#     Environment = var.name_prefix
#     Type        = "AgentWhisperFlow"
#   }
# }

# # Pre-Queue flow (general contact flow)
# resource "aws_connect_contact_flow" "pre_queue" {
#   instance_id = var.instance_id
#   name        = "${var.name_prefix}-pre-queue"
#   description = "Pre-queue flow for Tele-Health of Bamenda"
#   type        = "CONTACT_FLOW"

#   content = templatefile("${path.module}/templates/pre_queue.json.tftpl", {})

#   tags = {
#     Project     = var.name_prefix
#     Environment = var.name_prefix
#     Type        = "PreQueueFlow"
#   }
# }

# # Customer Queue flow
# resource "aws_connect_contact_flow" "customer_queue" {
#   instance_id = var.instance_id
#   name        = "${var.name_prefix}-customer-queue"
#   description = "Customer queue flow for Tele-Health of Bamenda"
#   type        = "CUSTOMER_QUEUE"

#   content = templatefile("${path.module}/templates/customer_queue.json.tftpl", {})

#   tags = {
#     Project     = var.name_prefix
#     Environment = var.name_prefix
#     Type        = "CustomerQueueFlow"
#   }
# }

# # Customer Hold flow
# resource "aws_connect_contact_flow" "customer_hold" {
#   instance_id = var.instance_id
#   name        = "${var.name_prefix}-customer-hold"
#   description = "Customer hold flow for Tele-Health of Bamenda"
#   type        = "CUSTOMER_HOLD"

#   content = templatefile("${path.module}/templates/customer_hold.json.tftpl", {})

#   tags = {
#     Project     = var.name_prefix
#     Environment = var.name_prefix
#     Type        = "CustomerHoldFlow"
#   }
# }

# # Customer Whisper flow
# resource "aws_connect_contact_flow" "customer_whisper" {
#   instance_id = var.instance_id
#   name        = "${var.name_prefix}-customer-whisper"
#   description = "Customer whisper flow for Tele-Health of Bamenda"
#   type        = "CUSTOMER_WHISPER"

#   content = templatefile("${path.module}/templates/customer_whisper.json.tftpl", {})

#   tags = {
#     Project     = var.name_prefix
#     Environment = var.name_prefix
#     Type        = "CustomerWhisperFlow"
#   }
# }

# # Helpdesk flow (general inbound/helpdesk contact flow)
# resource "aws_connect_contact_flow" "helpdesk" {
#   instance_id = var.instance_id
#   name        = "${var.name_prefix}-helpdesk"
#   description = "Helpdesk flow for Tele-Health of Bamenda"
#   type        = "CONTACT_FLOW"

#   content = templatefile("${path.module}/templates/helpdesk.json.tftpl", {})

#   tags = {
#     Project     = var.name_prefix
#     Environment = var.name_prefix
#     Type        = "HelpdeskFlow"
#   }
# }

