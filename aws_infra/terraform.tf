#Required variables for Terraform Cloud. 
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  #Only required for Terraform Cloud runs
  #Create organisation and workspace, more details here: https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/organizations
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

#Declare API key as secret variable to prevent leakage
variable "api_access_key_value" {
  type = string
  sensitive = true
}
