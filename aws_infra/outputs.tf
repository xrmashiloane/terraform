#ARN for secret parameter
output "api_access_key_arn" {
  value = aws_ssm_parameter.api_access_key.arn
}
# Display the SQS queue URL
output "sqs_queue_url" {
  value = aws_sqs_queue.sqs_queue.id
  description = "The SQS Queue URL"
}
