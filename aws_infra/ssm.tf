#Create Secure String
resource "aws_ssm_parameter" "api_access_key_value" {
  name        = "api_access_key_value"
  description = "Access key for API"
  type        = "SecureString"
  value       = var.api_access_key_value
}

#Create DynamoDB table Name Parameter
resource "aws_ssm_parameter" "dynamodb_table_name" {
  name        = "dynamodb_table"
  description = "Created DynamoDB table name for project"
  type        = "String"
  value       = aws_dynamodb_table.dynamodb-table.name
}

#Create SQS Queue URL
resource "aws_ssm_parameter" "sqs_queue_url_value" {
  name        = "sqs_queue_url"
  description = "Created DynamoDB table name for project"
  type        = "String"
  value       = aws_sqs_queue.sqs_queue.id
}