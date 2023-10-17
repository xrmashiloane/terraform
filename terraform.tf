#Required variables for Terraform Cloud
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  #Only required for Terraform Cloud runs
  cloud {
    organization = "xrmashiloane"

    workspaces {
      name = "terraform"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.aws_region
}

#Declare API key as secret variable to prevent leakage
variable "api_access_key_value" {
  type = string
  sensitive = true
}
