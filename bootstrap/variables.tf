variable "aws_region" {
  description = "Region where the state backend will live"
  type        = string
  default     = "us-west-2" # change if needed
}

variable "project_name" {
  description = "Project name used to derive bucket/table names"
  type        = string
  default     = "telehealth-of-bamenda"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
