data "local_file" "json_data" {
  filename = "${path.module}/event.json"
}
# Create a new EventBridge Rule
resource "aws_cloudwatch_event_rule" "event_rule" {
  name = "${var.project_name}-event-rule"
  event_pattern = data.local_file.json_data.content
}

# Set the SQS as a target to the EventBridge Rule
resource "aws_cloudwatch_event_target" "event_rule_target" {
  rule = aws_cloudwatch_event_rule.event_rule.name
  arn  = aws_sqs_queue.sqs_queue.arn
}