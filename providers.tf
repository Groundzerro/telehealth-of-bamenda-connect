terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "telehealth-of-bamenda-dev-tfstate-bucket"
    key            = "envs/dev/telehealth-of-bamenda/terraform.tfstate"
    region         = "us-west-2" # same as bootstrap
    dynamodb_table = "telehealthofbamenda_dev_tf_lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# terraform {
#   required_version = ">= 1.5.0"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.aws_region
# }
