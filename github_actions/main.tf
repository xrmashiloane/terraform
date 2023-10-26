
provider "aws" {
  region = "af-south-1"
  profile = "default" #Update with credential profile name more information here: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
}

#Create Open ID trust between AWS and GitHub
module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
}

#Create GitHub repository. 
#Requires github token. More information on obtaining one here https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens
#Token must have full access to repo | workflow | delete_repo 
resource "github_repository" "main" {
  name        = var.repository_name
  description = "Terraform Weather Client Project"
  visibility  = "public"
  auto_init   = true
  gitignore_template = "Terraform"
}

resource "github_branch" "main" {
  repository = github_repository.main.name
  branch     = "main"
}

resource "github_branch_default" "default" {
  repository = github_repository.main.name
  branch     = github_branch.main.branch
}