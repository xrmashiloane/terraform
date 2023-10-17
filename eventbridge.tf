# Create a new EventBridge Rule
resource "aws_cloudwatch_event_rule" "event_rule" {
  event_pattern = <<PATTERN
{
  "account": ["${data.aws_caller_identity.current.account_id}"],
  "source": ["demo.sqs"]
}
PATTERN
}

# Set the SQS as a target to the EventBridge Rule
resource "aws_cloudwatch_event_target" "event_rule_target" {
  rule = aws_cloudwatch_event_rule.event_rule.name
  arn  = aws_sqs_queue.sqs_queue.arn
}




# Display the SQS queue URL
output "SQS-QUEUE" {
  value       = aws_sqs_queue.sqs_queue.id
  description = "The SQS Queue URL"
}
