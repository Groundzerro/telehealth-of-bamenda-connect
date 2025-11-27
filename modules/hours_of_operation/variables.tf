variable "instance_id" {
  description = "Amazon Connect instance ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "timezone" {
  description = "Time zone for hours of operation"
  type        = string
}

variable "business_hours" {
  description = "Map of days to opening/closing hours"
  type = map(object({
    start_hour : number
    start_minute : number
    end_hour : number
    end_minute : number
  }))
}
