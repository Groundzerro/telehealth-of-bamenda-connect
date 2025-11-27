variable "instance_id" {
  description = "Amazon Connect instance ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming users"
  type        = string
}

variable "routing_profile_id" {
  description = "Routing profile ID to assign"
  type        = string
}

variable "security_profile_ids" {
  description = "List of security profile IDs to assign"
  type        = list(string)
}

variable "agents" {
  description = "List of Connect users (agents)"
  type = list(object({
    username : string
    email : string
    first : string
    last : string
  }))
}
