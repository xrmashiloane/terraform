variable "project_name" {
  type    = string
  default = "lambda-terraform-github"
}
variable "aws_region" {
  type    = string
  default = "af-south-1"
}

variable "filename" {
  default = "cities.csv"
}

variable "load_city_data" {
  description = "Flag: load city data from local repository"
  type        = bool
  default     = true
}
