variable "aws_region" {
  description = "AWS region where your Connect instance lives"
  type        = string
}

variable "connect_instance_id" {
  description = "Existing Amazon Connect instance ID"
  type        = string
}

variable "project_name" {
  description = "Short name for this contact center"
  type        = string
  default     = "telehealth-of-bamenda"
}

variable "environment" {
  description = "Deployment environment (dev, test, prod)"
  type        = string
  default     = "dev"
}

# Define business hours
variable "business_hours_timezone" {
  description = "Time zone for hours of operation"
  type        = string
  default     = "America/Chicago"
}

variable "prompts_table_name" {
  description = "Name of the DynamoDB table for Tele-Health prompts"
  type        = string
  default     = null
}


variable "business_hours" {
  description = "Map of days to opening/closing hours in 24h clock"
  type = map(object({
    start_hour : number
    start_minute : number
    end_hour : number
    end_minute : number
  }))

  default = {
    MONDAY = {
      start_hour   = 8
      start_minute = 0
      end_hour     = 17
      end_minute   = 0
    }
    TUESDAY = {
      start_hour   = 8
      start_minute = 0
      end_hour     = 17
      end_minute   = 0
    }
    WEDNESDAY = {
      start_hour   = 8
      start_minute = 0
      end_hour     = 17
      end_minute   = 0
    }
    THURSDAY = {
      start_hour   = 8
      start_minute = 0
      end_hour     = 17
      end_minute   = 0
    }
    FRIDAY = {
      start_hour   = 8
      start_minute = 0
      end_hour     = 17
      end_minute   = 0
    }
  }
}

# Define queues for Tele-Health of Bamenda
variable "queues" {
  description = "List of queues for Tele-Health of Bamenda"
  type = list(object({
    name : string
    description : string
  }))

  default = [
    {
      name        = "Nurse-Line"
      description = "General nurse triage line"
    },
    {
      name        = "Doctor-Consult"
      description = "Doctor consultation queue"
    },
    {
      name        = "Pharmacy-Support"
      description = "Pharmacy and prescription questions"
    }
  ]
}

# Simple agent definitions (for demo)
variable "agents" {
  description = "List of Connect users (agents)"
  type = list(object({
    username : string
    email : string
    first : string
    last : string
  }))

  default = [
    {
      username = "nurse1"
      email    = "nurse1@example.com"
      first    = "Nurse"
      last     = "One"
    },
    {
      username = "doctor1"
      email    = "doctor1@example.com"
      first    = "Doctor"
      last     = "One"
    },

    {
      username = "pharmacist1"
      email    = "pharmacist1@example.com"
      first    = "Pharmacist"
      last     = "One"
    }
  ]
}
