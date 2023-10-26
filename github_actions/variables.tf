
variable "aws_region" {
  type        = string
  default     = "af-south-1"
  description = "AWS region"
}

variable "repository_name" {
  type        = string
  description = "Name of repository to create"
  default     = "terraform-project"
}
