# Create new SQS Queue
resource "aws_sqs_queue" "sqs_queue" {
    name = "${var.project_name}-sqs-queue"
    delay_seconds             = 90
    max_message_size          = 2048
    message_retention_seconds = 86400
    receive_wait_time_seconds = 10
}

#Create dead letter queue
resource "aws_sqs_queue" "sqs_queue_deadletter" {
  name = "${var.project_name}-deadletter-queue"

}

#Create redrive policy
resource "aws_sqs_queue_redrive_allow_policy" "sqs_queue_deadletter" {
    queue_url = aws_sqs_queue.sqs_queue.id
   redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.sqs_queue.arn]
  })
}