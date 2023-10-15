variable "project_name" {
  type = string
  default = "lambda-terraform-github-actions"
}

variable "schedule_expression" {
  type = string
  default = "rate(30 minutes)"
}

variable "rule_name" {
    type = string
    default = "event_rule"
}
variable "rule_description" {
  type = string
  default = "Eventbridge rule to envoke Lambda Function"
}