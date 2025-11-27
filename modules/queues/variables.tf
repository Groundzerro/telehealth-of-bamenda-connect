variable "instance_id" {
  description = "Amazon Connect instance ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming queues"
  type        = string
}

variable "hours_of_operation_id" {
  description = "Hours of operation ID"
  type        = string
}

variable "queues" {
  description = "List of queue definitions"
  type = list(object({
    name : string
    description : string
  }))
}
