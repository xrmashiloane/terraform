
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "schedule_bus" # "default" bus already support schedule_expression in rules

  attach_lambda_policy = true
  lambda_target_arns   = [aws_lambda_function.hello.arn]

  schedules = {
    lambda-cron = {
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(1 day)"
      timezone            = "Africa/Johannesburg"
      arn                 = aws_lambda_function.hello.arn
      input               =  jsonencode({"query": "Durban"})
    }
  }
}