
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus = false 

    rules = {
    crons = {
      description         = "Trigger for a Lambda"
      schedule_expression = "cron(0 9 ? * MON-FRI *)"
    }
  }

  targets = {
    crons = [
      {
        name  = "lambda-cron"
        arn   = aws_lambda_function.hello.arn
        input = jsonencode({"query": "Durban"})
      }
    ]
  }
}


