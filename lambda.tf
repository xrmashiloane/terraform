data "archive_file" "zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "hello.zip"
}

resource "aws_lambda_function" "hello" {
  filename         = data.archive_file.zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.zip.output_path)

  function_name = var.project_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "hello.handler"
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

resource "aws_cloudwatch_log_group" "convert_log_group" {
  name = "/aws/lambda/${aws_lambda_function.hello.function_name}"
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename              = "requests.zip"
  layer_name            = "requests_lambda_layer"
  compatible_runtimes   = ["python3.11"]
}

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