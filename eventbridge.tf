module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  attach_lambda_policy = true
  create_role = true
  lambda_target_arns   = [aws_lambda_function.hello.arn]

  rules = {
    crons = {
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(50 minutes)"
    }
  }

  targets = {
    crons = [
      {
        name  = "lambda-loves-cron"
        arn   = aws_lambda_function.hello.arn
        input = jsonencode({ "query" : "Johannesburg" })
      }
    ]
  }


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