variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda handler (e.g. main.handler)"
  type        = string
  default     = "main.handler"
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.12"
}

variable "source_path" {
  description = "Path to the Lambda source directory (containing main.py)"
  type        = string
}

variable "environment" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 5
}

variable "memory_size" {
  description = "Lambda memory size in MB"
  type        = number
  default     = 256
}

variable "policy_statements" {
  description = "Additional IAM policy statements to attach to the Lambda role"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "Tags to apply to Lambda and related resources"
  type        = map(string)
  default     = {}
}
