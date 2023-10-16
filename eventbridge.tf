
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "schedule_bus" # "default" bus already support schedule_expression in rules

  attach_lambda_policy = true
  lambda_target_arns   = [aws_lambda_function.hello.arn]

  schedules = {
    lambda-cron = {
      description         = "Morning trigger for Lambda"
      schedule_expression = "cron(0 9 ? * MON-FRI *)"
      timezone            = "Africa/Johannesburg"
      arn                 = aws_lambda_function.hello.arn
      input               =  jsonencode({"query": "Johannesburg"})
    }
      lambda-cron = {
      description         = "Evening trigger for Lambda"
      schedule_expression = "cron(0 16 ? * MON-FRI *)"
      timezone            = "Africa/Johannesburg"
      arn                 = aws_lambda_function.hello.arn
      input               =  jsonencode({"query": "Johannesburg"})
    }
  }
}