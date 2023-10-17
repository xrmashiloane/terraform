# Create new SQS Queue
resource "aws_sqs_queue" "sqs_queue" {
    name = "${var.project_name}-sqs-queue"
}