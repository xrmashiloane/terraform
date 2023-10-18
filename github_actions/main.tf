provider "aws" {
  region = var.aws_region
  profile                  = "default" #Update with credential profile name more information here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
}

module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
}