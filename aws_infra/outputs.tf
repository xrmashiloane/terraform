#ARN for secret parameter
output "api_access_key_arn" {
  value = aws_ssm_parameter.api_access_key_value.arn
  description = "ARN for Secure String"
}

# Display the SQS queue URL
output "sqs_queue_url" {
  value = aws_sqs_queue.sqs_queue.id
  description = "SQS Queue URL"
}

#SNS Topic details for subscription
output "sns_topic_arn" {
  value = aws_sns_topic.results_updates.arn
  description = "ARN for SNS Notification"
}
