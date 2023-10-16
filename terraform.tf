terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  cloud {
    organization = "xrmashiloane"

    workspaces {
      name = "terraform"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "af-south-1"
}

variable "api_access_key_value" {
  type = string
  sensitive = true
}
