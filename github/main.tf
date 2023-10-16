provider "aws" {
  region = var.aws_region
  shared_config_files      = ["~/.aws/config"] #Update with path to credentials
  shared_credentials_files = ["~/.aws/credentials"] #Update with path to credentials
  profile                  = "default" #Update with profile name
}

module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"

}