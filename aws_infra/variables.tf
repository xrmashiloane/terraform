variable "project_name" {
  type = string
  default = "lambda-terraform-github"
}
variable "aws_region" {
  type = string
  default = "af-south-1"
}

variable "filename" {
  default = "cities.csv"
}