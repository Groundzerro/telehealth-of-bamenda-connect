variable "instance_id" {
  description = "Amazon Connect instance ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming quick connects"
  type        = string
}

variable "queues" {
  description = "Map of queues with id and name"
  type = map(object({
    id : string
    name : string
  }))
}

variable "transfer_flow_id" {
  description = "Contact flow ID used when transferring callers via Quick Connect"
  type        = string
}
