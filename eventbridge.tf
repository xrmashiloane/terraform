module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "${var.project_name}-eventbus"

  attach_lambda_policy = true
  create_role = true
  lambda_target_arns   = [aws_lambda_function.hello.arn]

  schedules = {
    lambda-cron = {
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(1 day)"
      timezone            = "Africa/Johannesburg"
      arn                 = aws_lambda_function.hello.arn
      input               = jsonencode({ "query" : "Johannesburg" })
    }
  }
}