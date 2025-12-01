variable "table_name" {
  description = "Name of the DynamoDB table to store Tele-Health prompt configuration"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the DynamoDB table"
  type        = map(string)
  default     = {}
}
