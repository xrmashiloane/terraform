terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.45.0"
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
