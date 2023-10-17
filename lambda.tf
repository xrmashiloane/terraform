#Zip included dummy python for deployment
data "archive_file" "zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "hello.zip"
}

#Create Lambda function and related aliases
resource "aws_lambda_function" "hello" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.zip.output_path)

  function_name = var.project_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_handler.handler"
  runtime       = "python3.11"
  timeout       = 10
  layers        = [aws_lambda_layer_version.lambda_layer.arn]
  publish       = true
}

resource "aws_lambda_alias" "alias_dev" {
  name             = "dev"
  description      = "dev"
  function_name    = aws_lambda_function.hello.arn
  function_version = "$LATEST"
}

resource "aws_lambda_alias" "alias_prod" {
  name             = "prod"
  description      = "prod"
  function_name    = aws_lambda_function.hello.arn
  function_version = "$LATEST"
}

#Add requests Lambda layer to allow API calls
resource "aws_lambda_layer_version" "lambda_layer" {
  filename              = "requests.zip"
  layer_name            = "requests_lambda_layer"
  compatible_runtimes   = ["python3.11"]
}

#Add event source from SQS queue | Allows function to be triggered by SQS message receipt
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.sqs_queue.arn
  enabled          = true
  function_name    = aws_lambda_function.hello.arn
  batch_size       = 1
}

#Create Cloudwatch log group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.hello.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

#Send function results to SNS topic for delivery to subscribers
resource "aws_lambda_function_event_invoke_config" "send_notification" {
  function_name = aws_lambda_function.hello.arn
  destination_config {
    on_failure {
      destination = aws_sns_topic.results_updates.arn
    }
    on_success {
      destination = aws_sns_topic.results_updates.arn
    }
  }
}