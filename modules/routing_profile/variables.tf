variable "instance_id" {
  description = "Amazon Connect instance ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming routing profiles"
  type        = string
}

variable "queues" {
  description = "Map of queues with id and name"
  type = map(object({
    id : string
    name : string
  }))
}

variable "primary_queue_name" {
  description = "Logical name of primary queue (e.g. Nurse-Line)"
  type        = string
}
