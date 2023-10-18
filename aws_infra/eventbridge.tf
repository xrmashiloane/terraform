data "local_file" "json_data" {
  filename = "${path.module}/event.json"
}
# Create a new EventBridge Schedule
resource "aws_scheduler_schedule" "my_scheduler" {
  name = "${var.project_name}-schedule"

  flexible_time_window {
    mode = "OFF"
  }

  

  schedule_expression = "cron(0 9 ? * MON-FRI *)"

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:sqs:sendMessage"
    role_arn = aws_iam_role.eventbridge_scheduler_iam_role.arn

    input = jsonencode({
      MessageBody = data.local_file.json_data.content
      QueueUrl    = aws_sqs_queue.sqs_queue.id
    })
  }
}