variable "instance_id" {
  description = "Amazon Connect instance ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming security profiles"
  type        = string
}

variable "description" {
  description = "Security profile description"
  type        = string
}

variable "permissions" {
  description = "List of permission strings"
  type        = list(string)
}
